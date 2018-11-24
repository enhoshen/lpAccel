module DataPathController
import PECfg::*;(
`clk_input,
input  Conf     i_PEconf,
input  Inst     i_PEinst,
`rdyack_port(Input),
`rdyack_port(Weight),
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


    //==================
    //state
    //==================
    enum logic [3:0] { IDLE , INIT , WORK , STALL , STOP  }s_main , s_main_nxt ;     

    //==================
    // logic
    //==================
    logic ce;
    LpCtl in_idx_ctl , w_idx_ctl , o_idx_ctl ;
    LoopCounter #( 
    .NDepth(2) , .IdxDW({4,6}) , .IdxMaxDW(6)
    ) InIDX( .*
    .i_loopSize(
    .i_ctl(in_idx_ctl),
    .o_loopEnd()
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
