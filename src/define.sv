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


`define pbpix_input(name) output logic name``_ack, input name``_rdy , input name``_zero
`define pbpix_output(name) output logic name``_rdy, input name``_ack , output logic name``_zero
`define pbpix_logic(name) logic name``_rdy, name``_ack ,name``_zero
`define pbpix_port(name) name``_rdy, name``_ack , name``_zero
`define pbpix_connect(port_name, logic_name) .port_name``_rdy(logic_name``_rdy), .port_name``_ack(logic_name``_ack), .port_name``_zero(logic_name``_zero)
`define pbpix_unconnect(port_name) .port_name``_rdy(), .port_name``_ack() , .port_name``_zero()


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
`define clk_port i_clk, i_rstn
`define clk_connect .i_clk(i_clk), .i_rstn(i_rstn)
`define clk_input input i_clk , input i_rstn

`define ff_rstn always_ff @(posedge i_clk or negedge i_rstn)if (!i_rstn)begin
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

