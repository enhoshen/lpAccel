module DataPathController
import PECfg::*;(
`clk_input,
input  Conf     i_PEconf,
input  Inst     i_PEinst,
`rdyack_input(Input),
`rdyack_input(Weight),
`rdyack_output(Psum),
output PECtlCfg::IPadAddr        o_IPctl,
output PECtlCfg::WPadAddr        o_WPctl,
output PECtlCfg::PPadAddr        o_PPctl,
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
    localparam OUTDIM = 4;
    localparam MAXPCH = $clog2(12);
    localparam MAXR = $clog2(12);
    localparam MAXPM = $clog2(16);
    localparam MAXTW = $clog2(64); 
    localparam MAXROWW $clog2(511); //input row tile width 
    enum { WTPCH, WTR, WTPM } wt_dim;
    enum { INPCH, INTW } in_dim;
    enum { OUTPCH , OUTR , OUTPM , OUTTW} out_dim ; // psum dimension name
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
        assign in_idx_ctl.reset = i_PEinst.reset;
        assign wt_idx_ctl.reset = i_PEinst.reset;
        assign out_idx_ctl.reset = i_PEinst.reset;
            assign in_idx_ctl.dval = ce ;
            assign wt_idx_ctl.dval = ce ;
            assign out_idx_ctl.dval = ce ; 
            assign in_idx_ctl.inc = Input_rdy && Input_ack;
            assign wt_idx_ctl.inc = Weight_rdy && Weight_ack;
            assign out_idx_ctl.inc = Psum_rdy && Psum_ack; 
    logic [MAXTW-1:0] in_loopSize [INPUTDIM] ;
        logic [MAXTW-1:0] in_row_tile;
            assign in_row_tile = i_PEconf.Tw * i_PEconf.U + i_PEconf.R - 1'b1;
    logic [MAXPM-1:0] wt_loopSize[WEIGHTDIM];
    logic [MAXTW-1:0] out_loopSize[OUTDIM]; 
        assign in_loopSize = {i_PEconf.Pch ,  in_row_tile};
        assign wt_loopSize = {i_PEconf.Pch , i_PEconf.R , i_PEconf.Pm} ;
        assign out_loopSize = {i_PEconf.Pch , i_PEconf.R , i_PEconf.Pm , i_PEconf.Tw};
    logic [MAXTW-1:0] in_loopIdx[INPUTDIM];
    logic [MAXPM-1:0] wt_loopIdx [WEIGHTDIM];
    logic [MAXTW-1:0] out_loopIdx[OUTDIM];
    logic [INPUTDIM-1:0] in_end;
    logic [WEIGHTDIM-1:0] wt_end;
    logic [OUTDIM-1:0] out_end;
    logic [MAXROWW:0] startPix , endPix , curPix, prefetchEndPix; // the current conv window of input feature map 
        assign startPix = i_PEconf.U * (out_loopIdx[OUTTW] - 1'b1) + 1'b1;
        assign endPix = startPix + i_PEconf.R - 1'b1;
        assign curPix = startPix + out_loopIdx[OUTR] - 1'b1;
        assign prefetchEndPix = endPix + i_PEconf.U;
    logic wt_out_catchup;
        assign wt_out_catchup = out_loopIdx[OUTPM] == wt_loopIdx[WTPM] && 
                                out_loopIdx[OUTR]==wt_loopIdx[WTR] && 
                                out_loopIdx[OUTPCH] == wt_loopIdx[WTPCH] ; 
    logic in_out_catchup;
        assign in_out_catchup = curPix == in_loopIdx[INTW] &&
                                out_loopIdx[OUTPCH]==in_loopIdx[INPCH];
    logic prefetch_in_end;
        assign prefetch_in_end = in_loopIdx[INTW]==prefetchEndPix && in_end[INPCH];
    logic waitInput ;
    logic waitWeight;
        assign waitInput =  in_out_catchup && !(in_end[INPCH] && in_loopIdx[INTW] == endPix);
        assign waitWeight = wt_out_catchup && !(&wt_end) ;
        assign Input_ack  =ce && !( (in_end[INPCH] && in_loopIdx[INTW]==endPix && !out_end[OUTPM]) || 
                        (out_end[OUTPM] && (in_out_catchup || prefetch_in_end) )  );
        assign Weight_ack = ce && !( (&wt_end && !out_end[OUTTW]) || 
                        (out_end[OUTTW] && wt_out_catchup) );
        assign Psum_rdy = ce &&! (  waitInput || waitWeight );
        //TODO no PixReuse???
        //==============
        //Utility
        //==============
    LoopCounter #( 
    .NDEPTH(INPUTDIM) , .IDXDW({MAXPCH, MAXROWW }) , .IDXMAXDW(MAXTW)
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
    .NDEPTH(OUTDIM) , .IDXDW({MAXPCH, MAXR, MAXPM, MAXTW}) , .IDXMAXDW(MAXTW) 
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
   
    //==================
    // comb
    //==================
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
