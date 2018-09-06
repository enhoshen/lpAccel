// Copyright (C) 2017, Yu Sheng Lin, johnjohnlys@media.ee.ntu.edu.tw

// This file is part of Nicotb.

// Nicotb is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// Nicotb is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with Nicotb.  If not, see <http://www.gnu.org/licenses/>.
`timescale 1ns/1ns
interface sif;
    logic h;
    logic k;
endinterface;
module tb;
logic clk, rst;
logic [3:0] a;
logic [10:0] b [3][2][4];
logic [10:0] c [2][4];
logic [2:0] T [2] ;
typedef struct packed{
    logic [2:0] i;
    logic [2:0] j;
}mytype;
mytype t;
sif s();
assign t.i = T[0];
assign t.j = T[1];
`Pos(rst_out, rst)
`PosIf(ck_ev, clk, rst)

always #1 clk = ~clk;

initial begin
	$fsdbDumpfile("tb.fsdb");
	//$fsdbDumpvars(0, tb, "+mda");
	$fsdbDumpvars("+all");
	clk = 0;
	rst = 1;
    s.h = 1;
	a = 0;
	#1 $NicotbInit();
	#10 rst = 0;
	#10 rst = 1;
	#100
	$NicotbFinal();
	$finish;
end

initial begin
	#5
	@(posedge rst)
	for (int i = 0; i < 10; i++) begin
		@(posedge clk) a <= a+1;
	end
	for (int i = 0; i < 10; i++) begin
		@(posedge clk);
	end
	a <= 'x;
end

endmodule
