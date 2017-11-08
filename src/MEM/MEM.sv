interface Rf2p_if #(  // 2p rf interface,  re_nad/write when r/w wire is high 
    parameter wordWd =12,
    parameter DWd    =32,
    parameter AWd    =$clog2(wordWd)
);  

    logic re_nad;  
    logic write;
    logic [AWd-1:0] raddr;
    logic [AWd-1:0] waddr;
    logic [DWd-1:0] rdata;    
    logic [DWd-1:0] wdata;

    modport rf(
        input re_nad,
        input write,
        input raddr,
        input waddr,
        
        input  wdata,
        output rdata  
        
    );
    modport ma_r(
        output re_nad,
        output raddr,
        input  rdata
    );
    modport ma_w(
        output write,
        output waddr,
        output wdata
    );

endinterface

module RF_2F #(
    parameter wordWd = 12,
    parameter DWd    = 32,
    parameter AWd    = $clog2(wordWd)
)(
input i_clk,
input i_rstn,
Rf2p_if.rf port
);
    localparam EMA = 3'b000;

    wire we_n_n, re_n;
        assign we_n_n = !port.write;
        assign re_n_n = !port.read ;
 
generate 
    case ( DWd )
        8  :begin 
            if (wordWd==12) // 3x3/11x1/5x2/7x1
                RF_2P_12x8 rf0(
                .QA  (port.rdata),
                .CLKA(i_clk),
                .CENA(we_n),
                .AA  (port.raddr),
                .CLKB(i_clk),
                .CENB(re_n),
                .AB  (port.waddr),
                .DB  (port.wdata),
                .EMAA(EMA),
                .EMAB(EMA)
                );
            if(wordWd==48)  // 4x4x3 
                RF_2P_48x8 rf0(
                .QA  (port.rdata),
                .CLKA(i_clk),
                .CENA(we_n),
                .AA  (port.raddr),
                .CLKB(i_clk),
                .CENB(re_n),
                .AB  (port.waddr),
                .DB  (port.wdata),
                .EMAA(EMA),
                .EMAB(EMA)
                );   
        end
        16 :begin
            if (wordWd==12) // 3x3/11x1/5x2/7x1
                RF_2P_12x16 rf0(
                .QA  (port.rdata),
                .CLKA(i_clk),
                .CENA(we_n),
                .AA  (port.raddr),
                .CLKB(i_clk),
                .CENB(re_n),
                .AB  (port.waddr),
                .DB  (port.wdata),
                .EMAA(EMA),
                .EMAB(EMA)
                );
            if(wordWd==48)  // 4x4x3 
                RF_2P_48x16 rf0(
                .QA  (port.rdata),
                .CLKA(i_clk),
                .CENA(we_n),
                .AA  (port.raddr),
                .CLKB(i_clk),
                .CENB(re_n),
                .AB  (port.waddr),
                .DB  (port.wdata),
                .EMAA(EMA),
                .EMAB(EMA)
                ); 
        end 
        32 :begin
            if (wordWd==12) // 3x3/11x1/5x2/7x1
                RF_2P_12x32 rf0(
                .QA  (port.rdata),
                .CLKA(i_clk),
                .CENA(we_n),
                .AA  (port.raddr),
                .CLKB(i_clk),
                .CENB(re_n),
                .AB  (port.waddr),
                .DB  (port.wdata),
                .EMAA(EMA),
                .EMAB(EMA)
                );
            if(wordWd==48)  // 4x4x3 
                RF_2P_48x32 rf0(
                .QA  (port.rdata),
                .CLKA(i_clk),
                .CENA(we_n),
                .AA  (port.raddr),
                .CLKB(i_clk),
                .CENB(re_n),
                .AB  (port.waddr),
                .DB  (port.wdata),
                .EMAA(EMA),
                .EMAB(EMA)
                ); 
        end
        64 :begin
            if (wordWd==12) // 3x3/11x1/5x2/7x1
                RF_2P_12x64 rf0(
                .QA  (port.rdata),
                .CLKA(i_clk),
                .CENA(we_n),
                .AA  (port.raddr),
                .CLKB(i_clk),
                .CENB(re_n),
                .AB  (port.waddr),
                .DB  (port.wdata),
                .EMAA(EMA),
                .EMAB(EMA)
                );
            if(wordWd==48)  // 4x4x3 
                RF_2P_48x64 rf0(
                .QA  (port.rdata),
                .CLKA(i_clk),
                .CENA(we_n),
                .AA  (port.raddr),
                .CLKB(i_clk),
                .CENB(re_n),
                .AB  (port.waddr),
                .DB  (port.wdata),
                .EMAA(EMA),
                .EMAB(EMA)
                ); 
        end
        
        default:begin
        
        end
    endcase
endgenerate


endmodule
