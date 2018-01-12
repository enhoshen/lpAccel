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


`define rdyack_input(name) output logic name``_ack; input name``_rdy
`define rdyack_output(name) output logic name``_rdy; input name``_ack
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
`define clk_port i_clk, i_rst
`define clk_connect .i_clk(i_clk), .i_rst(i_rst)
`define clk_input input i_clk; input i_rst
`define ff_rst always_ff @(posedge i_clk or negedge i_rst) if (!i_rst) begin
`define ff_cg(cg) end else if (cg) begin
`define ff_nocg end else begin
`define ff_end end
`define deffsm1(N,n,f1               ) typedef enum {f1,               N``_N}N;logic[N``_N-1:0]n``_r,n``_w;always_ff@(posedge i_clk or negedge i_rst)if(!i_rst)n``_r<='b1<<f1;else n``_r<=n``_w;
`define deffsm2(N,n,f1,f2            ) typedef enum {f1,f2,            N``_N}N;logic[N``_N-1:0]n``_r,n``_w;always_ff@(posedge i_clk or negedge i_rst)if(!i_rst)n``_r<='b1<<f1;else n``_r<=n``_w;
`define deffsm3(N,n,f1,f2,f3         ) typedef enum {f1,f2,f3,         N``_N}N;logic[N``_N-1:0]n``_r,n``_w;always_ff@(posedge i_clk or negedge i_rst)if(!i_rst)n``_r<='b1<<f1;else n``_r<=n``_w;
`define deffsm4(N,n,f1,f2,f3,f4      ) typedef enum {f1,f2,f3,f4,      N``_N}N;logic[N``_N-1:0]n``_r,n``_w;always_ff@(posedge i_clk or negedge i_rst)if(!i_rst)n``_r<='b1<<f1;else n``_r<=n``_w;
`define deffsm5(N,n,f1,f2,f3,f4,f5   ) typedef enum {f1,f2,f3,f4,f5,   N``_N}N;logic[N``_N-1:0]n``_r,n``_w;always_ff@(posedge i_clk or negedge i_rst)if(!i_rst)n``_r<='b1<<f1;else n``_r<=n``_w;
`define deffsm6(N,n,f1,f2,f3,f4,f5,f6) typedef enum {f1,f2,f3,f4,f5,f6,N``_N}N;logic[N``_N-1:0]n``_r,n``_w;always_ff@(posedge i_clk or negedge i_rst)if(!i_rst)n``_r<='b1<<f1;else n``_r<=n``_w;
`define fsm_to(n,f) n``_w[f] = 1'b1

package SramCfg;
	typedef enum {BEHAVIOUR} GenerateMode;
	typedef enum {UNDEF, OLD, NEW} ConcurrentRW;
	parameter GenerateMode GEN_MODE = BEHAVIOUR;
	parameter ConcurrentRW CON_RW = UNDEF;
endpackage

`ifndef DEFAULT_VSIZE
`define DEFAULT_VSIZE 32
`endif

package TauCfg;
	parameter N_ICFG = 3;
	parameter N_OCFG = 3;
	parameter N_INST = 15;
	parameter BOFS_FRAC_BW = 2;
	parameter BOFS_SHAMT_BW = 4;
	parameter AOFS_FRAC_BW = 2;
	parameter AOFS_SHAMT_BW = 8;
	parameter ISA_BW = 30;         // instruction
	parameter WORK_BW = 20;        // for block/accum idx
	parameter DATA_BW = 16;        // data
	parameter TMP_DATA_BW = 20;    // tmp data
	parameter GLOBAL_ADDR_BW = 32; // global address (DRAM)
	parameter LOCAL_ADDR_BW0 = 11;  // local address (SRAM)
	parameter LOCAL_ADDR_BW1 = 10;  // local address (SRAM)
	parameter DIM = 4;
	parameter VECTOR_SIZE = `DEFAULT_VSIZE;
	parameter CACHE_SIZE = 8;
	parameter XOR_BW = 5; // inspect at most 4b for XOR scheme
	parameter SRAM_NWORD = 64;
	parameter WARP_REG_ADDR_SPACE = 8;
	parameter MAX_WARP = 64;
	parameter CONST_LUT = 4; // Do not modify it owing to the limitataion of ISA
	parameter CONST_TEX_LUT = 4;
	parameter ALU_DELAY_BUF_SIZE = 2;
	parameter ARB_FIFO_SIZE = 63;
	parameter STENCIL_SIZE = 31;
endpackage

package Default;
`ifndef DEFAULT_N_CFG
`define DEFAULT_N_CFG 5
`endif
`ifndef DEFAULT_ABW
`define DEFAULT_ABW 32
`endif
`ifndef DEFAULT_SUM_ALL
`define DEFAULT_SUM_ALL 1
`endif
`ifndef DEFAULT_N_PENDING
`define DEFAULT_N_PENDING 1023
`endif
	parameter N_CFG = `DEFAULT_N_CFG;
	parameter ABW = `DEFAULT_ABW;
	parameter SUM_ALL = `DEFAULT_SUM_ALL;
	parameter N_PENDING = `DEFAULT_N_PENDING;
endpackage
