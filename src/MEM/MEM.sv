`timescale 1 ns/1 ps
`define Rf2pIf_logic(logname,wordWd,DWd)\
    logic logname``_read;\
    logic logname``_write;\
    logic [$clog2(wordWd)-1:0] logname``_raddr;\
    logic [$clog2(wordWd)-1:0] logname``_waddr;\
    logic [DWd-1:0] logname``_rdata;\
    logic [DWd-1:0] logname``_wdata;
`define Rf2pIf_pc_rf(logname)\
    .i_read(logname``_read),\
    .i_write(logname``_write),\
    .i_raddr(logname``_raddr),\
    .i_waddr(logname``_waddr),\
    .o_rdata(logname``_rdata),\
    .i_wdata(logname``_wdata)
module RF_2F #(
    parameter wordWd = 12,
    parameter DWd    = 32,
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
    case ( DWd )
        8  :begin 
            if (wordWd==12) // 3x3/11x1/5x2/7x1
                RF_2P_12x8 rf0(
                .QA  (o_rdata),
                .CLKA(i_clk),
                .CENA(we_n),
                .AA  (i_raddr),
                .CLKB(i_clk),
                .CENB(re_n),
                .AB  (i_waddr),
                .DB  (i_wdata),
                .EMAA(EMA),
                .EMAB(EMA)
                );
            if(wordWd==48)  // 4x4x3 
                RF_2P_48x8 rf0(
                .QA  (o_rdata),
                .CLKA(i_clk),
                .CENA(we_n),
                .AA  (i_raddr),
                .CLKB(i_clk),
                .CENB(re_n),
                .AB  (i_waddr),
                .DB  (i_wdata),
                .EMAA(EMA),
                .EMAB(EMA)
                );   
        end
        16 :begin
            if (wordWd==12) // 3x3/11x1/5x2/7x1
                RF_2P_12x16 rf0(
                .QA  (o_rdata),
                .CLKA(i_clk),
                .CENA(we_n),
                .AA  (i_raddr),
                .CLKB(i_clk),
                .CENB(re_n),
                .AB  (i_waddr),
                .DB  (i_wdata),
                .EMAA(EMA),
                .EMAB(EMA)
                );
            if(wordWd==48)  // 4x4x3 
                RF_2P_48x16 rf0(
                .QA  (o_rdata),
                .CLKA(i_clk),
                .CENA(we_n),
                .AA  (i_raddr),
                .CLKB(i_clk),
                .CENB(re_n),
                .AB  (i_waddr),
                .DB  (i_wdata),
                .EMAA(EMA),
                .EMAB(EMA)
                ); 
        end 
        32 :begin
            if (wordWd==12) // 3x3/11x1/5x2/7x1
                RF_2P_12x32 rf0(
                .QA  (o_rdata),
                .CLKA(i_clk),
                .CENA(we_n),
                .AA  (i_raddr),
                .CLKB(i_clk),
                .CENB(re_n),
                .AB  (i_waddr),
                .DB  (i_wdata),
                .EMAA(EMA),
                .EMAB(EMA)
                );
            if(wordWd==48)  // 4x4x3 
                RF_2P_48x32 rf0(
                .QA  (o_rdata),
                .CLKA(i_clk),
                .CENA(we_n),
                .AA  (i_raddr),
                .CLKB(i_clk),
                .CENB(re_n),
                .AB  (i_waddr),
                .DB  (i_wdata),
                .EMAA(EMA),
                .EMAB(EMA)
                ); 
        end
        64 :begin
            if (wordWd==12) // 3x3/11x1/5x2/7x1
                RF_2P_12x64 rf0(
                .QA  (o_rdata),
                .CLKA(i_clk),
                .CENA(we_n),
                .AA  (i_raddr),
                .CLKB(i_clk),
                .CENB(re_n),
                .AB  (i_waddr),
                .DB  (i_wdata),
                .EMAA(EMA),
                .EMAB(EMA)
                );
            if(wordWd==48)  // 4x4x3 
                RF_2P_48x64 rf0(
                .QA  (o_rdata),
                .CLKA(i_clk),
                .CENA(we_n),
                .AA  (i_raddr),
                .CLKB(i_clk),
                .CENB(re_n),
                .AB  (i_waddr),
                .DB  (i_wdata),
                .EMAA(EMA),
                .EMAB(EMA)
                ); 
        end
        
        default:begin
        
        end
    endcase
endgenerate


endmodule
/*
interface Rf2p_if #(  // 2p rf interface,  re_nad/write when r/w wire is high 
    parameter wordWd =12,
    parameter DWd    =32,
    parameter AWd    =$clog2(wordWd)
);  

    logic read;  
    logic write;
    logic [AWd-1:0] raddr;
    logic [AWd-1:0] waddr;
    logic [DWd-1:0] rdata;    
    logic [DWd-1:0] wdata;

    modport rf(
        input read,
        input write,
        input raddr,
        input waddr,
        
        input  wdata,
        output rdata  
        
    );
    modport ma_r(
        output read,
        output raddr,
        input  rdata
    );
    modport ma_w(
        output write,
        output waddr,
        output wdata
    );

endinterface
 */
