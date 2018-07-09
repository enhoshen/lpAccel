// ==================================================================
// This confidential and proprietary software may be used only as 
// authorized by a licensing agreement from National Taiwan University.
// (C) COPYRIGHT 2018 Media IC & System Lab,
// Graduate Institute of Electronics Engineering,
// National Taiwan University. ALL RIGHTS RESERVED
// -------------------------------------------------------------------
// FILE NAME      : DivPipe_test.sv
// TYPE           : TESTBENCH
// DEPARTMENT     : Media IC & System Lab
// AUTHOR         : Shih-Yi, Wu
// AUTHOR'S EMAIL : sywu@media.ee.ntu.edu.tw
// --------------------------------------------------------------------

`include "define.sv"
`timescale 1ns/1ps
`ifdef GATE_LEVEL
// Files you should include at gate-level simulation stage
`include "Top_syn_include.sv"
`else
// Files you should include at RTL simulation stage
`include "../../MEM/MEM_include.sv"
`include "../FIFORAM.sv"
`endif

`define CLK 10
`define HCLK 5
`define INPUT_DELAY 2

module FIFORAM_test;

logic i_clk, i_rstn;
`Pos(rst_out, i_rstn)

// Note !!!
// Gate-level simulation should have some input delay !!!
`ifdef GATE_LEVEL
`PosIfDelayed(ck_ev, i_clk, i_rstn, `INPUT_DELAY)
`else
`PosIf(ck_ev, i_clk, i_rstn)
`endif
`WithFinish

//===============================================================================
// Parameter
//========================
`ifdef GATE_LEVEL
localparam GATE_LEVEL = 1;
`else
localparam GATE_LEVEL = 0;
`endif
//===============================================================================
// Signals connected to nicotb
//===============================================================================
logic i_dval;
logic signed [NUMBW-1:0]   num;
logic signed [DENBW-1:0]   den;

logic quot_dval;
logic signed [TBBW-1:0]   quot;

//===============================================================================
//  Register/Wire Declaration
//===============================================================================
logic signed [NUMBW-1:0]   dut_quot;

assign quot   = $signed(dut_quot);
//===============================================================================
//  Combinational Logic
//===============================================================================
// TB  ==========================================================================
always #`HCLK i_clk = ~i_clk;

initial begin
`ifdef GATE_LEVEL
	$fsdbDumpfile("DivPipe_syn_test.fsdb");
	$sdf_annotate(`SDF , dut);
	$fsdbDumpvars(0, dut, "+mda");
`else
	$fsdbDumpfile("DivPipe_test.fsdb");
	$fsdbDumpvars(0, dut, "+mda");
`endif
	i_clk = 0;
	i_rst = 1;
	#1 $NicotbInit();
	#11 i_rst = 0;
	#10 i_rst = 1;
	#(`CLK*10000) $display("Timeout");
	$NicotbFinal();
	$finish;
end

// DUT =========================================================================
/*
DivPipe #(
    .PIPESTAGE(PIPESTAGE),
    .NUMBW(NUMBW),
    .DENBW(DENBW),
    .TC_MODE(TC_MODE)
)dut(
    `clk_connect,
    .i_dval(i_dval),
    .i_num(num),
    .i_den(den),
    .o_quot_dval(quot_dval),
    .o_quot(dut_quot)
);
*/
FIFORAM dut(
`clk_input,
.i_pop,
.i_lastpix, // reset read index to start
.i_read,
.i_write,
`rdyack_port(write),
.i_dupWrite,  // data reuse, end++ but not actually write data 
.i_wdata,
.o_rdata,
.o_rvalid
);


endmodule
