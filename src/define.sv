// Copyright 2016 Yu Sheng Lin

// This file is part of Ocean.

// MIMORI is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// MIMORI is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with Ocean.  If not, see <http://www.gnu.org/licenses/>.


// modified by En-ho Shen

`ifdef HCLK
    `define hclk `HCLK
`else
    `define hclk 1.25
`endif
`define INPUT_DELAY 1 
`define pbpix_input(name) output logic name``_ack, input name``_rdy , input name``_zero
`define pbpix_output(name) output logic name``_rdy, input name``_ack , output logic name``_zero
`define pbpix_logic(name) logic name``_rdy, name``_ack ,name``_zero
`define pbpix_port(name) name``_rdy, name``_ack , name``_zero
`define pbpix_connect(port_name, logic_name) .port_name``_rdy(logic_name``_rdy), .port_name``_ack(logic_name``_ack), .port_name``_zero(logic_name``_zero)
`define pbpix_unconnect(port_name) .port_name``_rdy(), .port_name``_ack() , .port_name``_zero()
`define rdyNack(name) name``_rdy && name``_ack
`define forstart(index,range)  for ( int index = 0 ; index < range ; ++index ) begin
`define forend end
//======= nico modified by enho =======
`define default_Nico_define \
    `clk_logic;\
    `Pos(rst_out , i_rstn)\
     `ifdef GATE_LEVEL\
     `PosIfDelayed(ck_ev, i_clk, i_rstn, `INPUT_DELAY)\
     `else \
     `PosIf(ck_ev, i_clk, i_rstn) \
     `endif \
    `WithFinish\
    logic dummy;\
    integer clk_cnt;
`define default_Nico_init_block(name,end_cycle) \
    always #`hclk i_clk = ~i_clk;\
    `ff_rstn clk_cnt <= 0; `ff_nocg clk_cnt <= clk_cnt+1; `ff_end\
    initial begin\
        `ifdef GATE_LEVEL\
            `ifdef COND \
                $fsdbDumpfile(`fsdb_cond_file(`GATE_LEVEL,name,`COND) );\
            `else \
                $fsdbDumpfile(`fsdb_file(`GATE_LEVEL,name) );\
            `endif \
            $sdf_annotate(`syn_file(`GATE_LEVEL,.sdf), name);\
            $display( `syn_file(`GATE_LEVEL,.sdf));\
            $fsdbDumpvars(0, name, "+all");\
        `else\
            $fsdbDumpfile(`"name.fsdb`");\
            $fsdbDumpvars( 0 , name , "+all");\
            $display( `"name`" );\
        `endif\
        $display(`hclk); \
        i_clk =0;\
        i_rstn=1;\
        #(2*`hclk) $NicotbInit();\
        #11 i_rstn = 0;\
        #10 i_rstn = 1;\
        #(2*`hclk*end_cycle) $display("timeout");\
        $NicotbFinal();\
        $finish();\
    end
//========= project =================
package GenCfg; //general config

    task automatic TODO;
        $display("This part hasn't finished yet");
        $finish();
    endtask  
    
    typedef enum { SIM , SYN ,FPGA , ERROR} GenMode;
    `ifdef SIM
        parameter GenMode GENMODE = SIM;
    `elsif DC 
        parameter GenMode GENMODE = SYN;
    `elsif FPGA
        parameter GenMode GENMODE = FPGA;
    `else
    `endif
endpackage
//========= utility  ============
`define syn_file( name , suffix) `"`HOME/syn/name``suffix`"
`define src_file( name ) `"`HOME/src/name.sv`"
`define fsdb_file( name ,test ) `"name``_``test``.fsdb`"
`define fsdb_cond_file( name ,test, condition) `"name``_``test``_``condition``.fsdb`"
// =======by JohnJohnLin ==========
`define rdyack_input(name) output logic name``_ack, input name``_rdy
`define rdyack_output(name) output logic name``_rdy, input name``_ack
`define rdyack_logic(name) logic name``_rdy, name``_ack
`define rdyack_port(name) name``_rdy, name``_ack
`define rdyack_connect(port_name, logic_name) .port_name``_rdy(logic_name``_rdy), .port_name``_ack(logic_name``_ack)
`define rdyack_unconnect(port_name) .port_name``_rdy(), .port_name``_ack()
`define dval_input(name) input name``_dval
`define dval_output(name) output logic name``_dval
`define dval_logic(name) logic name``_dval
`define dval_port(name) name``_dval
`define dval_connect(port_name, logic_name) .port_name``_dval(logic_name``_dval)
`define dval_unconnect(port_name) .port_name``_dval()
`define clk_port i_clk, i_rstn
`define clk_connect .i_clk(i_clk), .i_rstn(i_rstn)
`define clk_input input i_clk , input i_rstn
`define clk_logic logic i_clk ; logic i_rstn

`define ff_rstn always_ff @(posedge i_clk or negedge i_rstn)if (!i_rstn)begin
`define ff_cg(cg) end else if (cg) begin
`define ff_nocg end else begin
`define ff_end end
