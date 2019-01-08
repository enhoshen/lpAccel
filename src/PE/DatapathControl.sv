module DataPathController
import PECfg::*;(
`clk_input,
input  Conf     i_PEconf,
input  Inst     i_PEinst,
`rdyack_input(Input),
`rdyack_input(Weight),
`rdyack_output(Psum),
output PECtlCfg::IPctl           o_IPctl,
output PECtlCfg::WPctl           o_WPctl,
output PECtlCfg::PPctl           o_PPctl,
output PECtlCfg::FSctl           o_FSctl,
output PECtlCfg::MSctl           o_MSctl,
output PECtlCfg::SSctl           o_SSctl
//`ifdef DEBUG
//output o_error
//`endif
);
    //==================
    //param
    //==================
    localparam INPUTDIM = 2;
    localparam WEIGHTDIM = 3;
    localparam OUTDIM = 5;
    localparam MAXPCH = $clog2(12);
    localparam MAXR = $clog2(12);
    localparam MAXPM = $clog2(16);
    localparam MAXTW = $clog2(64); 
    localparam MAXROWW = $clog2(255); //input row tile width 
    localparam MAXXB = $clog2(16);
    enum { WTPCH, WTR, WTPM } wt_dim;
    enum { INPCH, INTW } in_dim;
    enum { OUTPCH , OUTR , OUTPM , OUTTW , OUTXB} out_dim ; // psum dimension name
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
        assign in_idx_ctl = '{reset:i_PEinst.reset,dval:ce,inc:Input_rdy&&Input_ack};
        assign wt_idx_ctl = '{reset:i_PEinst.reset,dval:ce,inc:Weight_rdy&&Weight_ack};
        assign out_idx_ctl ='{reset:i_PEinst.reset,dval:ce,inc:Psum_rdy&&Psum_ack};
    logic [MAXROWW-1:0] in_loopSize [INPUTDIM] ;
    logic [MAXPM-1:0] wt_loopSize[WEIGHTDIM];
    logic [MAXTW-1:0] out_loopSize[OUTDIM]; 
        logic [MAXTW-1:0] in_row_tile;
        logic [3:0] in_real_stride;
            assign in_real_stride = (i_PEconf.PixReuse)? i_PEconf.U : i_PEconf.R;
            assign in_row_tile = i_PEconf.Tw * in_real_stride + i_PEconf.R - 1'b1;
        assign in_loopSize = {i_PEconf.Pch ,  in_row_tile};
        assign wt_loopSize = {i_PEconf.Pch , i_PEconf.R , i_PEconf.Pm} ;
        assign out_loopSize = {i_PEconf.Pch , i_PEconf.R , i_PEconf.Pm , i_PEconf.Tw, i_PEconf.Xb};
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
    logic wt_out_catchup;
        assign wt_out_catchup = out_loopIdx[OUTPM] == wt_loopIdx[WTPM] && 
                                out_loopIdx[OUTR]==wt_loopIdx[WTR] && 
                                out_loopIdx[OUTPCH] == wt_loopIdx[WTPCH] ; 
    logic in_out_catchup;
        assign in_out_catchup = curPix == in_loopIdx[INTW] &&
                                out_loopIdx[OUTPCH]==in_loopIdx[INPCH];
    logic prefetch_in_end;
    logic curfetch_in_end;
        assign prefetch_in_end = in_loopIdx[INTW]==prefetchEndPix && in_end[INPCH] && out_end[OUTPM] ;
        assign curfetch_in_end = in_end[INPCH] && in_loopIdx[INTW]==endPix && !out_end[OUTPM] ; 
    logic waitInput ;
    logic waitWeight;
        assign waitInput =  in_out_catchup && !( curfetch_in_end || prefetch_in_end);
        //;
        assign waitWeight = wt_out_catchup && !(&wt_end) ;
        assign Input_ack  =ce && !( curfetch_in_end || 
                        (out_end[OUTPM] && (in_out_catchup || prefetch_in_end) )  );
        assign Weight_ack = ce && !( (&wt_end && !(out_end[OUTXB] && out_end[OUTTW]) ) || 
                        (out_end[OUTXB] && out_end[OUTTW] && (wt_out_catchup )  ) );
        assign Psum_rdy = ce &&! (  waitInput || waitWeight );
        //TODO no PixReuse???
        //==============
        //Address
        //==============
    logic [IPADADDRWD-1:0]  in_raddra1 , in_waddra1;
    logic [WPADADDRWD-1:0]  wt_raddra1 , wt_waddra1;
    logic [PPADADDRWD-1:0]  ps_raddra1 , ps_waddra1;
    logic in_raddr_end , in_waddr_end , wt_raddr_end , wt_waddr_end , ps_waddr_end,ps_raddr_end;
    LpCtl psum_waddr_ctl , psum_raddr_ctl;
    LpSSCtl in_raddr_ctl;
        assign psum_waddr_ctl.reset =i_PEinst.reset;
        assign psum_raddr_ctl.reset =i_PEinst.reset;
        assign psum_waddr_ctl.dval  =ce; 
        assign psum_raddr_ctl.dval  =ce;
            assign psum_waddr_ctl.inc = out_end[OUTPCH] && out_end[OUTR] && out_idx_ctl.inc;
            assign psum_raddr_ctl.inc = out_loopIdx[OUTPCH]==1 && out_loopIdx[OUTR]==1 && out_idx_ctl.inc;
        assign in_raddr_ctl = '{dval:ce , reset:i_PEinst.reset, inc:out_idx_ctl.inc, strideCond: i_PEconf.PixReuse && (&out_end[OUTPM:OUTR] ) };
    assign o_IPctl.raddr = in_raddra1 -1'd1;
    assign o_IPctl.waddr = in_waddra1 -1'd1;
    assign o_WPctl.raddr = wt_raddra1 -1'd1;
    assign o_WPctl.waddr = wt_waddra1 -1'd1;
    assign o_PPctl.raddr = ps_raddra1 -1'd1;
    assign o_PPctl.waddr = ps_waddra1 -1'd1;
        assign o_IPctl.read = out_idx_ctl.inc;
        assign o_IPctl.write= in_idx_ctl.inc;
        assign o_WPctl.read = out_idx_ctl.inc;
        assign o_WPctl.write= wt_idx_ctl.inc;
        assign o_PPctl.read = psum_raddr_ctl.inc;
        assign o_PPctl.write= psum_waddr_ctl.inc;
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
    .NDEPTH(OUTDIM) , .IDXDW({MAXPCH, MAXR, MAXPM, MAXTW, MAXXB}) , .IDXMAXDW(MAXTW) 
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
        //Address conversion
        //=================== 
    LoopCounterD1 #(
    .IDXDW(IPADADDRWD), .STARTPOINT(1'b1) 
    ) IPWADDR( .*, .i_loopSize(i_PEconf.ipad_size), .i_ctl(in_idx_ctl), 
                .o_loopIdx(in_waddra1), .o_loopEnd(in_waddr_end)
    ); 
    //TODO input read address is tricky for pixel reuses, so a simple
    //loopcounter is insufficient
    LoopCounterStrideStart #(
    .IDXDW(IPADADDRWD), .STARTPOINT(1'b1) 
    ) IPRADDR( .*, .i_loopSize(i_PEconf.ipad_size), .i_ctl(in_raddr_ctl), 
                 .o_loopEnd(in_raddr_end) , .i_stride(i_PEconf.Upix) , .o_loopStrideIdx(in_raddra1)
    ); 
   
    LoopCounterD1 #(
    .IDXDW(WPADADDRWD), .STARTPOINT(1'b1) 
    ) WPWADDR( .*, .i_loopSize(i_PEconf.wpad_size), .i_ctl(wt_idx_ctl), 
                .o_loopIdx(wt_waddra1), .o_loopEnd(wt_waddr_end)
    ); 
    LoopCounterD1 #(
    .IDXDW(WPADADDRWD), .STARTPOINT(1'b1) 
    ) WPRADDR( .*, .i_loopSize(i_PEconf.wpad_size), .i_ctl(out_idx_ctl), 
                .o_loopIdx(wt_raddra1), .o_loopEnd(wt_raddr_end)
    ); 
    LoopCounterD1 #(
    .IDXDW(PPADADDRWD), .STARTPOINT(1'b1)
    ) PPWADDR( .*, .i_loopSize(i_PEconf.ppad_size), .i_ctl(psum_waddr_ctl),
                .o_loopIdx(ps_waddra1), .o_loopEnd(ps_waddr_end)
    ); 
    LoopCounterD1 #(
    .IDXDW(PPADADDRWD), .STARTPOINT(1'b1)
    ) PPRADDR( .*, .i_loopSize(i_PEconf.ppad_size), .i_ctl(psum_waddr_ctl), 
                .o_loopIdx(ps_raddra1), .o_loopEnd(ps_raddr_end)
    ); 

    always_comb begin
        s_main_nxt = s_main;
        case (s_main) 
            IDLE: begin
                s_main_nxt = ( i_PEinst.start) ? INIT : IDLE;
            end 
            STALL:begin
                s_main_nxt = ( i_PEinst.reset ) ? IDLE : (!i_PEinst.stall)? WORK : STALL;
            end
            INIT: begin
                s_main_nxt = ( i_PEinst.reset ) ? IDLE : WORK; 
            end
            WORK: begin
                s_main_nxt = ( i_PEinst.reset ) ? IDLE : (!i_PEinst.stall)? WORK : STALL;
            end
            default: begin
            end   
        endcase 
    end        
    always_comb begin
    end
    always_comb begin
        case (s_main)
            IDLE: begin
            end 
            STALL:begin
            end
            INIT: begin 
            end
            WORK: begin 
                
            end
            default: begin
            end   
        endcase 
    end
    //==================
    //sequential
    //==================
    `ff_rstn
        s_main <= IDLE;
    `ff_cg(i_PEinst.dval)
        s_main <= s_main_nxt;
    `ff_end

    `ff_rstn
    `ff_cg(ce)
    `ff_end

    `ff_rstn
    `ff_nocg
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
    `rdyack_logic(Psum);
    `default_Nico_define
DataPathController dut(
.*,
.o_IPctl(),
.o_WPctl(),
.o_PPctl(),
.o_FSctl(),
.o_MSctl(),
.o_SSctl()
//`ifdef DEBUG
//output o_error
//`endif
);
`default_Nico_init_block(DataFlowCtrl,10000)
endmodule 
`endif
