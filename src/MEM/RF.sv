`timescale 1 ns/1 ps
// MEMdefin
module RF_2P 
    import RFCfg::*;#(
    parameter WORDWD = 12,
    parameter DWD    = 16,
    parameter AWD    = $clog2(WORDWD),
    parameter SIZE   = 1
)(
`clk_input,
input i_read,
input i_write,
input [AWD-1:0] i_raddr,
input [AWD-1:0] i_waddr,
output [DWD-1:0] o_rdata[SIZE], 
input [DWD-1:0] i_wdata[SIZE]
);
    localparam EMA = 3'b000;

    wire we_n, re_n;
        assign we_n = !i_write;
        assign re_n = !i_read ;
    genvar arr;
    generate  
        if (gen_mode == SIM) begin: sim_mode
        end 
        else if (gen_mode == SYN) begin: syn_mode
            for ( arr=0 ; arr<SIZE ; ++arr)begin: rf_instance 
                case ({WORDWD,DWD}) 
                    {12,16}: RF_2P_12x16 `RF2Pinstance_arr(RF12x16,arr)
                    {48,16}: RF_2P_48x16 `RF2Pinstance_arr(RF48x16,arr)
                    {64,16}: RF_2P_64x16 `RF2Pinstance_arr(RF64x16,arr)
                    default: initial ErrorRF;
                endcase
            end
        end
        else if (gen_mode == FPGA) begin:fpga_mode
            //TODO
            initial ErrorRF;
        else begin: syn_fail
            initial ErrorRF;
        end
    endgenerate
endmodule
module RF_2P_MSK 
    import RFCfg::*;#(
    parameter WORDWD = 12,
    parameter DWD    = 16,
    parameter AWD    = $clog2(WORDWD),
    parameter SIZE   = 1
)(
`clk_input,
input DWD_mode i_dwd, 
input i_read,
input i_write,
input [AWD-1:0] i_raddr,
input [AWD-1:0] i_waddr,
output [DWD-1:0] o_rdata[SIZE], 
input [DWD-1:0] i_wdata[SIZE]
);
    localparam EMA = 3'b000;

    wire we_n, re_n;
        assign we_n = !i_write;
        assign re_n = !i_read ;
    genvar arr;
    generate  
        if (gen_mode == SIM) begin: sim_mode
        end 
        else if (gen_mode == SYN) begin: syn_mode
            for ( arr=0 ; arr<SIZE ; ++arr)begin: rf_instance 
            // TODO
            //    case ({WORDWD,DWD}) 
            //        {32,32}: RF_2P_12x16 `RF2Pinstance_arr(RF12x16,arr)
            //        default: initial ErrorRF;
            //    endcase
            end
            
        end
        else if (gen_mode == FPGA) begin:fpga_mode
            //TODO
            initial ErrorRF;
        else begin: syn_fail
            initial ErrorRF;
        end
    endgenerate
endmodule

