interface Rf2p_if #(  // 2p rf interface,  read/write when r/w wire is high
    parameter wordWd =12,
    parameter DWd    =16,
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
    modport mast(
        output read,
        output write,
        output raddr,
        output waddr,

        output wdata,
        input  rdata
    );


endinterface

module RF_2F#(
    parameter wordWd = 12,
    parameter DWd    = 16,
    parameter AWd    = $clog2(wordWd)
)(
input i_clk,
input i_rstn,
Rf2p_if.rf port
);

    wire we, re;
        assign we = port.write;
        assign re = port.read ;

generate 
    case ( DWd )
        8  :begin 
            if (wordWd==12) // 3x3/11x1/5x2/7x1
                RF_2P_12x8 rf0(
                .QA  (port.rdata),
                .CLKA(i_clk),
                .CENA(we),
                .AA  (port.waddr),
                .CLKB(i_clk),
                .CENB(re),
                .AB  (port.raddr),
                .DB  (port.wdata),
                .EMAA(),
                .EMAB()
                );
            if(wordWd==48)  // 4x4x3 
                RF_2P_48x8 rf0(
                .QA  (port.rdata),
                .CLKA(i_clk),
                .CENA(we),
                .AA  (port.waddr),
                .CLKB(i_clk),
                .CENB(re),
                .AB  (port.raddr),
                .DB  (port.wdata),
                .EMAA(),
                .EMAB()
                );   
        end
        16 :begin
        end 
        32 :begin
        end
        64 :begin
        end
        
        default:begin
        
        end
    endcase
endgenerate


endmodule
