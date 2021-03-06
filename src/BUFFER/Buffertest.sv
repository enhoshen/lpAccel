import BufCfg::*;
import SRAMCfg::*;

`ifdef GATE_LEVEL
`else

module BufferTest (
`clk_input,
input [DWD-1:0] i_Input [IBUFBANK],
input [DWD-1:0] i_Weight [WBUFBANK],
input [GBUFDWD-1:0] i_GB [GBUFBANK],
`rdyack_input(r_Input),
`rdyack_input(r_Weight),
`rdyack_input(r_GB),
`rdyack_input(w_Input),
`rdyack_input(w_Weight),
`rdyack_input(w_GB),

output [DWD-1:0] o_Input [IBUFBANK],
output [DWD-1:0] o_Weight [WBUFBANK],
output [GBUFDWD-1:0] o_GB [GBUFBANK]
);
    //====================
    // parameter
    //====================
    localparam IBUFAWD = $clog2(IBUFSIZE);
    localparam WBUFAWD = $clog2(WBUFSIZE);
    localparam GBUFAWD = $clog2(GBUFSIZE);
    //====================
    // logic
    //====================
    SP_rwmode input_mode , weight_mode , gb_mode;
    assign input_mode = (`rdyNack(r_Input))? READ : WRITE;
    assign weight_mode = (`rdyNack(r_Weight))? READ: WRITE;
    assign gb_mode = (`rdyNack(r_GB))? READ: WRITE;
    logic [IBUFAWD-1:0] input_addr;
    logic [WBUFAWD-1:0] weight_addr ;
    logic [GBUFAWD-1:0] gb_addr ;

    //====================
    // comb
    //====================
    assign r_Input_ack=!`rdyNack(w_Input);
    assign r_Weight_ack=!`rdyNack(w_Weight);
    assign r_GB_ack= !`rdyNack(w_GB);
    assign w_Input_ack=1;
    assign w_Weight_ack=1;
    assign w_GB_ack= 1;

    genvar in_bank;
    generate
        for ( in_bank=0 ; in_bank < IBUFBANK ; ++in_bank)begin
            SRAM_SP #(
                .WORDWD(IBUFSIZE),
                .DWD(DWD),
                .SIZE(IBUFBANK)
            ) ibuf (
                .*,
                .i_rw(input_mode),
                .ce( `rdyNack(r_Input) || `rdyNack(w_Input) ),
                .i_addr(input_addr),
                .o_rdata(o_Input),
                .i_wdata(i_Input)
            );
        end
    endgenerate


    genvar w_bank;
    generate
        for ( w_bank=0 ; w_bank < WBUFBANK ; ++w_bank)begin
            SRAM_SP #(
                .WORDWD(WBUFSIZE),
                .DWD(DWD),
                .SIZE(WBUFBANK)
            ) wbuf (
                .*,
                .i_rw(weight_mode),
                .ce( `rdyNack(r_Weight) || `rdyNack(w_Weight) ),
                .i_addr(weight_addr),
                .o_rdata(o_Weight),
                .i_wdata(i_Weight)
            );


        end
    endgenerate

    genvar gb_bank;
    generate
        for ( gb_bank=0 ; gb_bank < GBUFBANK ; ++gb_bank)begin
            SRAM_SP #(
                .WORDWD(GBUFSIZE),
                .DWD(GBUFDWD),
                .SIZE(GBUFBANK)
            ) gbuf (
                .*,
                .i_rw(gb_mode),
                .ce( `rdyNack(r_GB) || `rdyNack(w_GB) ),
                .i_addr(gb_addr),
                .o_rdata(o_GB),
                .i_wdata(i_GB)
            );


        end
    endgenerate
    `ff_rstn
        input_addr<= '0;
        weight_addr<= '0;
        gb_addr <= '0;
    `ff_nocg
        input_addr<= (`rdyNack(r_Input)||`rdyNack(w_Input))? input_addr+1'b1 : input_addr;
        weight_addr<= (`rdyNack(r_Weight)||`rdyNack(w_Weight))? weight_addr+1'b1 : weight_addr;
        gb_addr <= (`rdyNack(r_GB)||`rdyNack(w_GB))? gb_addr+1'b1 : gb_addr;
        
    `ff_end

endmodule
`endif

`ifdef Buftest
module Buftest;
    logic [DWD-1:0] i_Input [IBUFBANK];
    logic [DWD-1:0] i_Weight [WBUFBANK];
    logic [GBUFDWD-1:0] i_GB [GBUFBANK];
    `rdyack_logic(r_Input);
    `rdyack_logic(r_Weight);
    `rdyack_logic(r_GB);
    `rdyack_logic(w_Input);
    `rdyack_logic(w_Weight);
    `rdyack_logic(w_GB);

    logic [DWD-1:0] o_Input [IBUFBANK];
    logic [DWD-1:0] o_Weight [WBUFBANK];
    logic [GBUFDWD-1:0] o_GB [GBUFBANK];

    `default_Nico_define
    BufferTest dut(
    .*,
    .i_Input({>>{i_Input}}),
    .i_Weight({>>{i_Weight}}),
    .i_GB({>>{i_GB}}),
    .o_Input({>>{o_Input}}),
    .o_Weight({>>{o_Weight}}),
    .o_GB({>>{o_GB}})
    );
    `default_Nico_init_block(Buftest,10000)
endmodule

`endif
