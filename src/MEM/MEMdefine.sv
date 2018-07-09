`define RF2PIf_logic(logname , wordWd , DWd , AWd)\
    logic logname``_read;\
    logic logname``_write;\
    logic [AWd-1:0] logname``_raddr;\
    logic [AWd-1:0] logname``_waddr;\
    logic [DWd-1:0] logname``_rdata;\
    logic [DWd-1:0] logname``_wdata;\
    logic           logname``_rvalid;
`define RF2PIf_sharedCtl_logic( logname , wordWd , DWd , AWd)\
    logic logname``_read;\
    logic logname``_write;\
    logic [AWd-1:0] logname``_raddr;\
    logic [AWd-1:0] logname``_waddr;\
    logic           logname``_rvalid;
`define RF2PIf_pc_rf(logname)\
    .i_read(logname``_read),\
    .i_write(logname``_write),\
    .i_raddr(logname``_raddr),\
    .i_waddr(logname``_waddr),\
    .o_rdata(logname``_rdata),\
    .i_wdata(logname``_wdata)
`define RF2PIf_sharedCtl_pc_rf(logname)\
    .i_read(logname``_read),\
    .i_write(logname``_write),\
    .i_raddr(logname``_raddr),\
    .i_waddr(logname``_waddr)
`define RF2Pinstance(  name )\
                  name(\
                .QA  (o_rdata),\
                .CLKA(i_clk),\
                .CENA(we_n),\
                .AA  (i_raddr),\
                .CLKB(i_clk),\
                .CENB(re_n),\
                .AB  (i_waddr),\
                .DB  (i_wdata),\
                .EMAA(EMA),\
                .EMAB(EMA)\
                );

package RFCfg;
    typedef enum {SIM , SYN } GenMode;
    parameter GenMode gen_mode= SYN;
    task ErrorRF;
        begin
            $display("RF configuration wrong!");
            $finish();
        end
    endtask
endpackage 

