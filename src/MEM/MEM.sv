`timescale 1 ns/1 ps
// MEMdefine.sv
module RF_2P 
    import RFCfg::*;#(
    parameter wordWd = 12,
    parameter DWd    = 16,
    parameter AWd    = $clog2(wordWd)
)(
input i_clk,
input i_rstn,
input i_read,
input i_write,
input [AWd-1:0] i_raddr,
input [AWd-1:0] i_waddr,
output [DWd-1:0] o_rdata, 
input [DWd-1:0] i_wdata
);
    localparam EMA = 3'b000;

    wire we_n, re_n;
        assign we_n = !i_write;
        assign re_n = !i_read ;
    generate  
        if (RFCfg::gen_mode == SIM) begin: sim_mode
        end 
        else if (RFCfg::gen_mode == SYN) begin: syn_mode
            case ({wordWd,DWd}) 
                {32'd12,32'd16}: RF_2P_12x16 `RF2Pinstance(rf0)
                default: initial ErrorRF;
            endcase
        end
        else begin: syn_fail
            initial ErrorRF;
        end
    endgenerate
endmodule

