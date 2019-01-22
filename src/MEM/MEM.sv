`timescale 1 ns/1 ps
// MEMdefin
module RF_2P 
    import RFCfg::*;#(
    parameter WORDWD = 12,
    parameter DWD    = 16,
    parameter AWD    = $clog2(WORDWD)
)(
`clk_input,
input i_read,
input i_write,
input [AWD-1:0] i_raddr,
input [AWD-1:0] i_waddr,
output [DWD-1:0] o_rdata, 
input [DWD-1:0] i_wdata
);
    localparam EMA = 3'b000;

    wire we_n, re_n;
        assign we_n = !i_write;
        assign re_n = !i_read ;
    generate  
        if (gen_mode == SIM) begin: sim_mode
        end 
        else if (gen_mode == SYN) begin: syn_mode
            case ({WORDWD,DWD}) 
                {12,16}: RF_2P_12x16 `RF2Pinstance(RF12x16)
                {48,16}: RF_2P_48x16 `RF2Pinstance(RF48x16)
                {64,16}: RF_2P_64x16 `RF2Pinstance(RF64x16)
                default: initial ErrorRF;
            endcase
        end
        else if (gen_mode == FPGA) begin:fpga_mode
            //TODO
            initial ErrorRF;
        else begin: syn_fail
            initial ErrorRF;
        end
    endgenerate
endmodule

