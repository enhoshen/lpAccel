`define SDFFILE   "./PPR_syn.sdf" // To simulation with sdf annotate
`define CYCLE     2      // Modify your clock period here
`define End_CYCLE 10000
`define PAT       "./in.dat"
`define EXP       "./out.dat"
`define SDF 0

module Bitcount #(
parameter BW_O=5,
parameter BW_I=2**(BW_O-1)
)(
input [BW_I-1:0] i_in,
output [BW_O-1:0] o_out
);

//================//
//core
//===============//
/*
ForCount#(
.BW_O(BW_O) 
)F(._in(i_in),._out(o_out));
*/
BC_16 b(.i_in(i_in),.o_out(o_out));

endmodule



module ForCount #(
parameter BW_O=4,
parameter BW_I=2**(BW_O-1)
)(
input [BW_I-1:0] _in,
output [BW_O-1:0] _out
);
integer i;
logic [BW_O-1:0] out;
assign _out = out;
always_comb begin
 out = {BW_O{1'b0}};
	for(i=0 ; i<BW_I ; i=i+1)
		out=out+_in[i];
end

endmodule

/*
module TreeCount16
(
input [15:0] _in,
output [4:0] _out
);
logic [2:0] l1_0 , l1_1 , l1_2, l1_3;
always_comb begin
 out = {BW_O{1'b0}};
	for(i=0 ; i<BW_I ; i=i+1)
		out=out+_in[i];
end

endmodule
*/

module HardCount#(
parameter BW_O=4,
parameter BW_I=2**BW_O)(
input [BW_I-1:0] _in,
output [BW_O-1:0] _out
);
assign _out = _in[0 ]+_in[1 ]+_in[2 ]+_in[3 ]+
       _in[4 ]+_in[5 ]+_in[6 ]+_in[7 ]+
	   _in[8 ]+_in[9 ]+_in[10]+_in[11]+
	   _in[12]+_in[13]+_in[14]+_in[15];

endmodule

module BC_16(
input [15:0] i_in,
output logic [4:0] o_out
);
logic HC , HS;
logic FC_0, FS_0 , FC_1 , FS_1 , FC_2 ,FS_2;
logic [3:0] BO_0 , BO_1;
assign o_out = {FC_2,FS_2,FS_1,FS_0,HS};
BC_8 b0(.i_in(i_in[15:8]), .o_out(BO_0));
BC_8 b1(.i_in(i_in[7:0]) , .o_out(BO_1));
HA   h ( .i_A(BO_0[0]), .i_B(BO_1[0]), .o_S(HS), .o_C(HC));
FA   f0(.i_A(BO_0[1]),.i_B(BO_1[1]),.i_Cin(HC)  ,.o_S(FS_0),.o_Cout(FC_0));
FA   f1(.i_A(BO_0[2]),.i_B(BO_1[2]),.i_Cin(FC_0),.o_S(FS_1),.o_Cout(FC_1));
FA   f2(.i_A(BO_0[3]),.i_B(BO_1[3]),.i_Cin(FC_1),.o_S(FS_2),.o_Cout(FC_2));

endmodule

module BC_8(
input [7:0] i_in,
output logic [3:0] o_out
);
logic C_0 , O_0 , S_0 , C_1, O_1, S_1;
logic HC , HS;
logic FC_0, FS_0 , FC_1 , FS_1;
assign o_out = {FC_1,FS_1,FS_0,HS};

BC_4 b1 ( .i_in(i_in[7:4]),.o_S(S_0),.o_O(O_0),.o_C(C_0));
BC_4 b2 ( .i_in(i_in[3:0]),.o_S(S_1),.o_O(O_1),.o_C(C_1));
HA   h( .i_A(S_0), .i_B(S_1), .o_S(HS), .o_C(HC));
FA   f0(.i_A(O_1),.i_B(O_0),.i_Cin(HC),.o_S(FS_0),.o_Cout(FC_0));
FA   f1(.i_A(C_0),.i_B(C_1),.i_Cin(FC_0),.o_S(FS_1),.o_Cout(FC_1));

endmodule

module BC_4(
input [3:0] i_in,
output logic o_S,
output logic o_O,
output logic o_C
);
logic S_00 , S_01 , S_10 , S_11;
logic C_00 , C_01 , C_10 , C_11;
assign o_O = C_10 | S_11;
assign o_S = S_10;
assign o_C = C_11;
HA h00( .i_A(i_in[0]), .i_B(i_in[1]), .o_S(S_00), .o_C(C_00));
HA h01( .i_A(i_in[2]), .i_B(i_in[3]), .o_S(S_01), .o_C(C_01));
HA h10( .i_A(S_00), .i_B(S_01),       .o_S(S_10), .o_C(C_10));
HA h11( .i_A(C_00), .i_B(C_01),       .o_S(S_11), .o_C(C_11));
endmodule

module HA(
input i_A,
input i_B,
output logic o_S,
output logic o_C
);

assign o_S = i_A ^ i_B;
assign o_C = i_A & i_B;

endmodule

module FA(
input i_A,
input i_B,
input i_Cin,
output logic o_S,
output logic o_Cout
);
logic xo1,xo2,and1,and2,or1;
assign xo1 = i_A ^ i_B;
assign xo2 = xo1 ^ i_Cin;
assign and1= xo1 & i_Cin;
assign and2= i_A & i_B;
assign or1 = and1 | and2;
assign o_S = xo2;
assign o_Cout = or1;

endmodule


module observe;
	logic  S , C;
	logic [15:0] test_sig;
	logic [4:0] out , gold_out;
	logic clk , rst;
	
	logic a, b, c;
	assign a = test_sig[2];
	assign b = test_sig[1];
	assign c = test_sig[0];
	/*
	FA test (
	.i_A(a),
	.i_B(b),
	.i_Cin(c),
	.o_S (S),
	.o_Cout (C)
	);
	
	HA test(
	.i_A(b),
	.i_B(c),
	.o_S(S),
	.o_C(C)
	);
	*/
	always begin #(`CYCLE/2) clk = ~clk; end
	
	BC_16 B1(
    .i_in(test_sig),
    .o_out(out)
    );
	HardCount#(
     .BW_O(5),
     .BW_I(16)) H(
     ._in(test_sig),
     ._out(gold_out)
    );
	initial begin
	    $fsdbDumpfile("observe.fsdb");
        $fsdbDumpvars(0,observe,"+mda"); //This command is for dumping 2D array
        $fsdbDumpvars;   
	end
    initial begin
	#0;

        clk=0;
        rst=1;
        //test_sig=0;
    #60 $finish;
	end
	initial begin
	    #(`CYCLE/2) rst =0;
		#`CYCLE     rst =1;
	end
	


	always_ff @(posedge clk)begin
	    //if(gold_out != out)
		    $display ("BC_8: input:%b output:%d ", test_sig,out);
	    if(!rst)
		    test_sig <= 16'hffff;
		else begin
	        test_sig <= test_sig+1;
	        //$display ("FA: %d+%d+%d=%d , carry=%d",a,b,c,S,C);
			//$display ("HA: %d+%d=%d , carry=%d" , b,c,S,C);

	    end

	end
endmodule
