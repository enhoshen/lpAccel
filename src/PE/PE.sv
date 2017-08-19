
module Convolver#(
    parameter CONF_BW = 4,
	parameter DATA_BW  = 16,
	parameter PSUM_BW  = 12
	)(
	input i_clk,
	input i_rstn,
	input [CONF_BW-1:0] i_conf_ch,  // channel number to be handled
	input [CONF_BW-1:0] i_conf_flt, // filters number to be handled
	input [CONF_BW-1:0] i_conf_wch,
	input []
);
   typedef  enum {IDLE,WRITE,READ,DONE} fsm_t;
   fsm_t state;
   //=========================================
   //parameters
   //=========================================
   
   localparam NUM_UNIT = 4;
   
   
   //=========================================
   //sequential
   //=========================================
   always_ff @ (posedge i_clk or negedge i_rstn)begin
   
   end
endmodule
