module DataPathController
import PECfg::*;(
`clk_input,
input  Conf     i_PEconf,
input  Inst     i_PEinst,
`rdyack_input(Input),
`rdyack_input(Weight),
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
    localparam MAXR = $clog(12);
    localparam MAXPM = $clog2(16);
    localparam MAXTW = $clog2(64);

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
            assign in_idx_ctl.inc = Input_rdy &&;
            assign wt_idx_ctl.inc = Weight_rdy &&;
            assign out_idx_ctl.inc = ;
    logic [] in_idx_cnt;
    logic [] wt_idx_cnt;
    logic [] out_idx_cnt;
    logic [MAXTW-1:0] in_loopSize [INPUTDIM] ;
    logic [MAXPM-1:0] wt_loopSize[WEIGHTDIM];
    logic [MAXTW-1:0] out_loopSize[OUTDIM]; 
        assign in_loopSize = {i_PEconf.Pch ,  i_PEconf.Tw};
        assign wt_loopSize = {i_PEconf.Pch , i_PEconf.R , i_PEconf.Pm} ;
        assign out_loopSize = {i_PEconf.Pch , i_PEconf.R , i_PEconf.Pm , i_PEconf.Tw};
    logic [INPUTDIM-1:0] in_end;
    logic [WEIGHTDIM-1:0] wt_end;
    logic [OUTDIM-1:0] out_end;
    LoopCounter #( 
    .NDepth(INPUTDIM) , .IdxDW({MAXPCH, MAXR, MAXTW }) , .IdxMaxDW(MAXTW)
    ) INLp(
    .*,
    .i_loopSize( in_loopSize ),
    .i_ctl(in_idx_ctl),
    .out_loopEnd(in_end)
    ); 
    LoopCounter #( 
    .NDepth(WEIGHTDIM) , .IdxDW({MAXPCH, MAXR, MAXPM}) , .IdxMaxDW(MAXPM)
    ) WLp( 
    .*,
    .i_loopSize(wt_loopSize),
    .i_ctl(wt_idx_ctl),
    .out_loopEnd(wt_end)
    );
    
    LoopCounter #( 
    .NDepth(OUTDIM) , .IdxDW({MAXPCH, MAXR, MAXPM, MAXTW}) , .IdxMaxDW(MAXTW)
    ) OLp( 
    .*,
    .i_loopSize( out_loopSize ),
    .i_ctl(out_idx_ctl),
    .out_loopEnd(out_end)
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
                s_main_nxt = ( !i_PEinst.reset ) ? IDLE : (!i_PEinst.stall)? WORK : STALL;
            end
            INIT: begin
                s_main_nxt = ( !i_PEinst.reset ) ? IDLE : WORK ; 
            end
            WORK: begin
                s_main_nxt = ( !i_PEinst.reset ) ? IDLE : (!i_PEinst.stall)? WORK : STALL;
            end
            default: begin
            end   
        endcase 
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
