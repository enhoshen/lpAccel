/*
module test()
;

AND A ()
endmodule
*/
module AND #(
parameter BW=8
)(
input [BW-1:0] i_A,
input [BW-1:0] i_B,
output[BW-1:0] o_Out  
);

assign o_Out = i_A&i_B;

endmodule 


module XNOR #(
parameter BW=8
)(
input [BW-1:0] i_A,
input [BW-1:0] i_B,
output[BW-1:0] o_Out  
);

assign o_Out = i_A~^i_B;

endmodule 

module mux #(
parameter BW=8)(
input [BW-1:0] i_A,
input [BW-1:0] i_B,
input se,
output[BW-1:0] o_Out  
);
assign o_Out=(se)? i_A:i_B;
endmodule

module COMP #(
parameter BW=8)(
input [BW-1:0] i_A,
input [BW-1:0] i_B,
output o_Out  
);
assign o_Out = (i_A==i_B);
endmodule

module REG #(
parameter width = 256*8
)(
input clk,
input reset,
input se,
input [width-1:0] input_i,
output [width-1:0]output_o
);
reg [width-1:0] register_r;
assign output_o=register_r;
wire [width-1:0] register_w=(se)? input_i : register_r;
/*
assign register_w[width-1:8]=register_r[width-9:0];
assign register_w[7:0] = input_i;
*/
always@ (posedge clk or negedge reset)begin
	if(!reset) register_r<={width{1'b0}};
	else 	   register_r<=register_w;
end


endmodule

module assign_test(
input [7:0] in_i,
output [7:0] out_o
);
wire a = in_i[0]&&in_i[1];


assign out_o={a,in_i[6:0]};

endmodule

module assign_test_2(
input [7:0] in_i,
output [7:0] out_o
);
wire a = in_i[0]&&in_i[1];
wire [7:0]d1= {a,in_i[6:0]};

assign out_o=d1;

endmodule