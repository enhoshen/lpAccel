module XBunit#(
parameter BW_O=5,
parameter BW_I=16 
)(
input [BW_I-1:0] i_in1, 
input [BW_I-1:0] i_in2,
input i_ax_sel,        // use XNOR gate if high
output signed [BW_O-1:0] o_out 
);
//=====================//
//definition
//=====================//
logic [BW_I-1:0] AND;
logic [BW_I-1:0] XNOR;
logic [BW_I-1:0] src_sel; // select AND or XNOR
logic signed [BW_O-1:0] b_cnt;

//=====================//
//module
//=====================//
Bitcount #(
    .BW_O(BW_O),
	.BW_I(BW_I)
    )B_0(
    .i_in(src_sel),
	.o_out(b_cnt) );
//=====================//
//comb
//=====================//

assign AND = i_in1 & i_in2;
assign XNOR= i_in1 ~^i_in2;
assign src_sel = (i_ax_sel==1'b1)? XNOR : AND;
assign o_out = (i_ax_sel==1'b1)? b_cnt-16: b_cnt;

endmodule

module XBunitTer#(
parameter BW_O=3)();

endmodule

