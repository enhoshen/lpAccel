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
    struct packed {
        logic [3:0] ch;
        logic [5:0] width;
    } inidx_w , inidx_r;
    struct packed {
        logic [3:0] ch;
        logic [3:0] width;
        logic [3:0] filter;
    } widx_w , widx_r;
    struct packed {
        logic [3:0] ch;
        logic [5:0] width;
        logic [3:0] filter;
    } oidx_w , oidx_r;
    
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
    inidx_w = inidx_r;
    widx_w = widx_r;
    oidx_w = oidx_r;
    
    case (s_main)
        IDLE: begin
            inidx_w = inidx_r;
            widx_w = widx_r;
            oidx_w = oidx_r;
        end 
        STALL:begin
            inidx_w = inidx_r;
            widx_w = widx_r;
            oidx_w = oidx_r;
        end
        INIT: begin 
            inidx_w = '{4'd1,6'd1};
            widx_w = '0;
            oidx_w = '0;
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
