import PECfg::*;
import RFCfg::*;
module DataPathController #(
parameter [PEROWWD-1:0] PECOLIDX =0     
)(
`clk_input,
input  Conf     i_PEconf,
input  Inst     i_PEinst,
`rdyack_input(Input),
`rdyack_input(Weight),
`rdyack_output(MAIN),
output PECtlCfg::IPctl           o_IPctl,
output PECtlCfg::WPctl           o_WPctl,
output PECtlCfg::PPctl           o_PPctl,
output PECtlCfg::FSctl           o_FSctl,
output PECtlCfg::MSconf          o_MSconf,
output PECtlCfg::SSctl           o_SSctl,
output PECtlCfg::PPctl           o_SSPPctl,
output PECtlCfg::DPstatus        o_DPstatus
//`ifdef DEBUG
//output o_error
//`endif
);
    //==================
    //param
    //==================
    localparam INPUTDIM = 2;
    localparam WEIGHTDIM = 3;
    localparam OUTDIM = 6;
    localparam MAXPCH = $clog2(12);
    localparam MAXR = $clog2(12);
    localparam MAXPM = $clog2(16);
    localparam MAXTW = $clog2(64); 
    localparam MAXROWW = $clog2(255); //input row tile width 
    localparam MAXXB = $clog2(16);
    localparam MAXS  = $clog2(11);
    enum { WTPCH, WTR, WTPM } wt_dim;
    enum { INPCH, INTW } in_dim;
    enum { OUTPCH , OUTR , OUTPM , OUTTW , OUTXB , OUTS } out_dim ; // psum dimension name
    //==================
    //state
    //==================
    enum logic [3:0] { IDLE , INIT , WORK , STALL  }s_main , s_main_nxt ;     

    //==================
    // logic
    //==================
        //==============
        //looping
        //==============
    logic ce;
        assign ce = s_main==WORK ;
    LpCtl in_idx_ctl , wt_idx_ctl , out_idx_ctl ;
        assign in_idx_ctl = '{reset:i_PEinst.reset||o_DPstatus.confEnd ,dval:ce,inc:Input_rdy&&Input_ack};
        assign wt_idx_ctl = '{reset:i_PEinst.reset||o_DPstatus.confEnd ,dval:ce,inc:Weight_rdy&&Weight_ack};
        assign out_idx_ctl ='{reset:i_PEinst.reset||o_DPstatus.confEnd ,dval:ce,inc:MAIN_rdy&&MAIN_ack};
        //--------------
        //data index loop size and index
        //--------------
    logic [MAXROWW-1:0] in_loopSize [INPUTDIM] ;
    logic [MAXPM-1:0] wt_loopSize[WEIGHTDIM];
    logic [MAXTW-1:0] out_loopSize[OUTDIM]; 
        logic [MAXTW-1:0] in_row_tile;
        logic [3:0] in_real_stride;
            assign in_real_stride = (i_PEconf.PixReuse)? i_PEconf.U : i_PEconf.R;
            assign in_row_tile = (i_PEconf.PixReuse)? i_PEconf.Tw * in_real_stride-in_real_stride + i_PEconf.R  : i_PEconf.Tw*in_real_stride ;
        assign in_loopSize = {i_PEconf.Pch ,  in_row_tile};
        assign wt_loopSize = {i_PEconf.Pch , i_PEconf.R , i_PEconf.Pm} ;
        assign out_loopSize = {i_PEconf.Pch , i_PEconf.R , i_PEconf.Pm , i_PEconf.Tw, i_PEconf.Xb , i_PEconf.S};
    logic [MAXROWW-1:0] in_loopIdx[INPUTDIM];
    logic [MAXPM-1:0] wt_loopIdx [WEIGHTDIM];
    logic [MAXTW-1:0] out_loopIdx[OUTDIM];
    logic [INPUTDIM-1:0] in_end;
    logic [WEIGHTDIM-1:0] wt_end;
    logic [OUTDIM-1:0] out_end;
    logic [MAXROWW-1:0] startPix , endPix , curPix, prefetchEndPix; // the current conv window of input feature map 
        assign startPix = in_real_stride * (out_loopIdx[OUTTW] - 1'b1) + 1'b1;
        assign endPix = startPix + i_PEconf.R - 1'b1;
        assign curPix = startPix + out_loopIdx[OUTR] - 1'b1;
        assign prefetchEndPix = endPix + in_real_stride;
    logic wt_out_catchup; // weight catch up with output, stop weight
        assign wt_out_catchup = out_loopIdx[OUTPM] == wt_loopIdx[WTPM] && 
                                out_loopIdx[OUTR]==wt_loopIdx[WTR] && 
                                out_loopIdx[OUTPCH] == wt_loopIdx[WTPCH] ; 
    logic in_out_catchup; // input catch up with output, stop input
        assign in_out_catchup = curPix == in_loopIdx[INTW] &&
                                out_loopIdx[OUTPCH]==in_loopIdx[INPCH]; // input and psum are at the same index
    logic prefetch_in_end;
    logic curfetch_in_end;
        assign prefetch_in_end = in_loopIdx[INTW]==prefetchEndPix && in_end[INPCH] && out_end[OUTPM] ; // new input pixels in place (prefetch) and psum progress to the last pm
        assign curfetch_in_end = in_end[INPCH] && in_loopIdx[INTW]==endPix && !out_end[OUTPM] ; // input pixels all in place, psum not at the last pm
    logic prefetch_wt_end;
    logic curfetch_wt_end;
        
    logic waitInput ;
    logic waitWeight;
        assign waitInput = in_out_catchup && !( curfetch_in_end || prefetch_in_end)  ;
        //;
        assign waitWeight = wt_out_catchup && !(&wt_end) && !(out_end[OUTXB] &&out_end[OUTTW]) ;

        assign Input_ack  = ce && !( curfetch_in_end ||  prefetch_in_end   ) ;
        assign Weight_ack = ce && !( (&wt_end && !(out_end[OUTXB] && out_end[OUTTW]) ) || 
                        (out_end[OUTXB] && out_end[OUTTW] && (wt_out_catchup )  ) );
        assign MAIN_rdy = ce && !(  waitInput || waitWeight ) ;//TODO one rdy left on &out_end
        //--------------
        //path stage
        //--------------
        /*
    enum logic {PSIDLE,PSWORK}  s_ps , s_ps_nxt; 
    PSconf psconf_r , psconf_w;
        assign psconf_w = (o_DPstatus.lastPix)? {i_PEconf.Psum_mode, PECOLIDX , i_PEconf.Pm , i_PEconf.Tw}: psconf_r;
    LpCtl ps_idx_ctl;
        assign ps_idx_ctl = {i_PEinst.reset, ce&&s_ps==PSWORK , `rdyNack(PSPP)};
    logic [MAXTW-1:0] ps_loopSize_r, ps_loopSize_w ;
    logic ps_end;
        assign ps_loopSize_w = (o_DPstatus.lastPix)? i_PEconf.ppad_size : ps_loopSize_r; 
    logic [MAXTW-1:0] ps_loopIdx  ;
        assign o_PSPPctl.waddr = '0;
        assign o_PSPPctl.raddr = ps_loopIdx -1'd1;
            assign o_PSPPctl.read = ps_idx_ctl.inc;
            assign o_PSPPctl.write= '0; 
        assign s_ps_nxt = (o_DPstatus.lastPix)? PSWORK : (s_ps==PSWORK && ps_end && `rdyNack(PSPP))? PSIDLE : s_ps;
        */
        //TODO rdy ack from whom?? 
        
        //==============
        //Address
        //==============
    logic [IPADADDRWD:0]  in_raddra1 , in_waddra1;
    logic [WPADADDRWD:0]  wt_raddra1 , wt_waddra1;
    logic [PPADADDRWD:0]  ps_raddra1 , ps_waddra1;
    logic in_raddr_end , in_waddr_end , wt_raddr_end , wt_waddr_end , ps_waddr_end,ps_raddr_end;
    LpCtl psum_waddr_ctl , psum_raddr_ctl;
    LpSSCtl in_raddr_ctl;
        assign psum_waddr_ctl.reset =i_PEinst.reset;
        assign psum_raddr_ctl.reset =i_PEinst.reset;
        assign psum_waddr_ctl.dval  =ce; 
        assign psum_raddr_ctl.dval  =ce;
            assign psum_raddr_ctl.inc = out_end[OUTPCH] && out_end[OUTR] && out_idx_ctl.inc;
            assign psum_waddr_ctl.inc =( i_PEconf.Pch == 4'd1 || out_loopIdx[OUTPCH]==out_loopSize[OUTPCH]-1'b1) && out_end[OUTR] && out_idx_ctl.inc;
        assign in_raddr_ctl = '{dval:ce , reset:i_PEinst.reset, inc:out_idx_ctl.inc, strideCond: i_PEconf.PixReuse && (&out_end[OUTPM:OUTR] && !out_end[OUTTW]) };
    assign o_IPctl.raddr = in_raddra1 -1'd1;
    assign o_IPctl.waddr = in_waddra1 -1'd1;
    assign o_WPctl.raddr = wt_raddra1 -1'd1;
    assign o_WPctl.waddr = wt_waddra1 -1'd1;
    assign o_PPctl.raddr = ps_raddra1 -1'd1;
    assign o_PPctl.waddr = '0;
    assign o_SSPPctl.waddr = ps_waddra1 -1'd1;
    assign o_SSPPctl.raddr = ps_raddra1 -1'd1;
        assign o_IPctl.read = out_idx_ctl.inc;
        assign o_IPctl.write= in_idx_ctl.inc;
        assign o_WPctl.read = out_idx_ctl.inc;
        assign o_WPctl.write= wt_idx_ctl.inc;
        assign o_PPctl.read = psum_raddr_ctl.inc && (!o_SSctl.fstrow || (o_SSctl.fstrow && &out_end[OUTTW:OUTPCH] ) ) && !(i_PEconf.Psum_mode==D16 && o_PPctl.raddr[0]); // address is odd and data of D16 type:don't read; first row don't read, just initialize.
        assign o_PPctl.write= '0;
        assign o_SSPPctl.write = psum_waddr_ctl.inc;
        assign o_SSPPctl.read = '0;
            assign o_PPctl.psum_mode = i_PEconf.Psum_mode;
            assign o_SSPPctl.psum_mode = i_PEconf.Psum_mode;
        //=====================
        //Misc
        //=====================
    logic [3:0] Ab ; // Aunit bit used
    //=====================
    //Status
    //=====================
    PECtlCfg::DPstatus dpstatus_w;
    assign dpstatus_w.firstPixEnd= &out_end[OUTR:OUTPCH] && &out_end[OUTS:OUTXB] && `rdyNack(MAIN);
    assign dpstatus_w.confEnd = &out_end ; 
    //==================
    // comb
    //==================
        //==================
        //data transfer control
        //==================
    LoopCounter #( 
    .NDEPTH(INPUTDIM) , .IDXDW({MAXPCH, MAXROWW }) , .IDXMAXDW(MAXROWW)
    ) INLp(
        .*,
        .i_loopSize( in_loopSize ),
        .i_ctl(in_idx_ctl),
        .o_loopEnd(in_end),
        .o_loopIdx(in_loopIdx)
    ); 
    LoopCounter #( 
    .NDEPTH(WEIGHTDIM) , .IDXDW({MAXPCH, MAXR, MAXPM}) , .IDXMAXDW(MAXPM)
    ) WLp( 
        .*,
        .i_loopSize(wt_loopSize),
        .i_ctl(wt_idx_ctl),
        .o_loopEnd(wt_end),
        .o_loopIdx(wt_loopIdx)
    );
    
    LoopCounter #( 
    .NDEPTH(OUTDIM) , .IDXDW({MAXPCH, MAXR, MAXPM, MAXTW, MAXXB,MAXS}) , .IDXMAXDW(MAXTW) 
    ) OLp( 
        .*,
        .i_loopSize( out_loopSize ),
        .i_ctl(out_idx_ctl),
        .o_loopEnd(out_end),
        .o_loopIdx(out_loopIdx)
    );
    //init  stage : prepare fetch 
    //fetch Stage : prepare psum address, output input/weight data
    //Mult Stage
    // read next psum pix/reset from 0 / read and shift
        //===================
        //Path Stage
        //===================
        /*
    LoopCounterD1 #(
    .IDXDW(MAXTW), .STARTPOINT(1'b1)
    ) PSLp(
        .*,
        .i_loopSize(ps_loopSize_r),
        .i_ctl(ps_idx_ctl),
        .o_loopEnd(ps_end),
        .o_loopIdx(ps_loopIdx)
    );
        */ 
        //===================
        //Address conversion
        //=================== 
    LoopCounterD1 #(
    .IDXDW(IPADADDRWD+1), .STARTPOINT(1'b1) 
    ) IPWADDR( .*, .i_loopSize(i_PEconf.ipad_size), .i_ctl(in_idx_ctl), 
                .o_loopIdx(in_waddra1), .o_loopEnd(in_waddr_end)
    ); 
    //input read address is tricky for pixel reuses, so a simple
    //loopcounter is insufficient
    LoopCounterStrideStart #(
    .IDXDW(IPADADDRWD+1), .STARTPOINT(1'b1) 
    ) IPRADDR( .*, .i_loopSize(i_PEconf.ipad_size), .i_ctl(in_raddr_ctl), 
                 .o_loopEnd(in_raddr_end) , .i_stride(i_PEconf.Upix) , .o_loopStrideIdx(in_raddra1) , .o_loopIdx()
    ); 
   
    LoopCounterD1 #(
    .IDXDW(WPADADDRWD+1), .STARTPOINT(1'b1) 
    ) WPWADDR( .*, .i_loopSize(i_PEconf.wpad_size), .i_ctl(wt_idx_ctl), 
                .o_loopIdx(wt_waddra1), .o_loopEnd(wt_waddr_end)
    ); 
    LoopCounterD1 #(
    .IDXDW(WPADADDRWD+1), .STARTPOINT(1'b1) 
    ) WPRADDR( .*, .i_loopSize(i_PEconf.wpad_size), .i_ctl(out_idx_ctl), 
                .o_loopIdx(wt_raddra1), .o_loopEnd(wt_raddr_end)
    ); 
    LoopCounterD1 #(
    .IDXDW(PPADADDRWD+1), .STARTPOINT(1'b1)
    ) PPWADDR( .*, .i_loopSize(i_PEconf.ppad_size), .i_ctl(psum_waddr_ctl),
                .o_loopIdx(ps_waddra1), .o_loopEnd(ps_waddr_end)
    ); 
    LoopCounterD1 #(
    .IDXDW(PPADADDRWD+1), .STARTPOINT(1'b1)
    ) PPRADDR( .*, .i_loopSize(i_PEconf.ppad_size), .i_ctl(psum_waddr_ctl), 
                .o_loopIdx(ps_raddra1), .o_loopEnd(ps_raddr_end)
    ); 

    always_comb begin
        s_main_nxt = s_main;
        if ( i_PEinst.dval)
        case (s_main) 
            IDLE: begin
                s_main_nxt = ( i_PEinst.start||i_PEinst.next) ? INIT : IDLE;
            end 
            STALL:begin
                s_main_nxt = ( i_PEinst.reset ) ? IDLE : (!i_PEinst.stall)? WORK : STALL;
            end
            INIT: begin
                s_main_nxt = ( i_PEinst.reset ) ? IDLE : WORK; 
            end
            WORK: begin
                if(i_PEinst.stall) s_main_nxt=STALL;
                else if( i_PEinst.reset) s_main_nxt =IDLE; 
                else if( o_DPstatus.confEnd && ! i_PEinst.next)  s_main_nxt=IDLE;
                else if( i_PEinst.next) s_main_nxt=INIT;
                else s_main_nxt=s_main; 
                //s_main_nxt = ( (i_PEinst.reset && i_PEinst.start) || i_PEinst.next)? INIT :(   (i_PEinst.reset && !i_PEinst.start ) || (o_DPstatus.confEnd && !i_PEinst.next)) ? IDLE : (!i_PEinst.stall)? WORK : STALL;
            end
            default: begin
            end   
        endcase 
        else
            s_main_nxt = s_main;
    end        
    //=====================
    //datapath control
    //=====================
    always_comb begin
        o_FSctl = {i_PEconf.Psum_mode,o_PPctl.raddr[0]};
        o_MSconf.mode = i_PEconf.Au;
        o_MSconf.iNumT = (i_PEconf.XNumT == UNSIGNED)? UNSIGNED : (out_end[OUTXB])? SIGNED : UNSIGNED;
        o_MSconf.wNumT = (i_PEconf.WNumT == UNSIGNED)? UNSIGNED : (i_PEconf.Wb == i_PEconf.Wb_idx)? SIGNED : UNSIGNED;
        o_SSctl.fstrow = (i_PEconf.Wb_idx ==1 && out_loopIdx[OUTXB]==1 && out_loopIdx[OUTS]== 1);
        o_SSctl.lstrow = (out_end[OUTXB] && out_end[OUTS] );
        o_SSctl.psumread  = psum_raddr_ctl.inc;
        o_SSctl.psumwrite = psum_waddr_ctl.inc;
        o_SSctl.resetsum  =  o_SSctl.fstrow && (psum_raddr_ctl.inc || ( out_loopIdx[OUTPCH]=='0 && out_idx_ctl.inc ) ); 
        o_SSctl.psum_mode   = i_PEconf.Psum_mode;
        case (i_PEconf.Au)
            XNOR: Ab=4'b1;
            M1: Ab=4'b1;
            M2: Ab=4'd2;
            M4: Ab=4'd4;
            M8: Ab=4'd8;
            default: Ab=4'b1;
        endcase
        o_SSctl.sht_num   = (out_loopIdx[OUTXB]+i_PEconf.Wb_idx-2'd2)* Ab ;
    end
    //==================
    //sequential
    //==================
    `ff_rstn
        s_main <= IDLE;
    `ff_nocg
        s_main <= s_main_nxt;
    `ff_end

    `ff_rstn
    `ff_cg(ce)
    `ff_end

    `ff_rstn
        o_DPstatus <= '0;
    `ff_nocg
        o_DPstatus <= dpstatus_w;
    `ff_end

endmodule

`ifdef DataFlowCtrl
module DataFlowCtrl 
import PECfg::*;
;
    Conf i_PEconf;
    Inst i_PEinst;
    `rdyack_logic(Input);
    `rdyack_logic(Weight);
    `rdyack_logic(MAIN);
    `default_Nico_define
DataPathController dut(
.*,
.o_IPctl(),
.o_WPctl(),
.o_PPctl(),
.o_FSctl(),
.o_MSconf(),
.o_SSctl()
//`ifdef DEBUG
//output o_error
//`endif
);
`default_Nico_init_block(DataFlowCtrl,10000)
endmodule 
`endif
