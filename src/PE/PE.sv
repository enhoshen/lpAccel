
// include ../IF/IF.sv
module Convolver#(
    parameter ConfDWd = 4, 
	parameter DWd  = 16,     // data bit width 
	parameter PsumDWd  = 16,
    parameter InstDWd  = 3,   // 
    parameter UnitNum  = 4
	)(
input i_clk,
input i_rstn,
input [ConfDWd-1:0] i_conf_ch,  // channel number to be handled
input [ConfDWd-1:0] i_conf_flt, // filters number to be handled
input [ConfDWd-1:0] i_conf_wch, // weight channels number
sim_Dif.in          i_Inst,  // global control signal
//-----I/OData------
sim_Dif.in          i_FIFO_data_in,  // data from in_FIFO: next row ifmap / psum from next channel set , from ifmap buffer or PE
sim_Dif.out         o_FIFO_data_out, // data to  out_FIFO: to neighbor PE
sim_Dif.out         o_ofmap_out     // ofmap/psum to ofamp buffer

//-----MemData------
);
    typedef  enum {IDLE,WRITE,READ,DONE} fsm_t;
    fsm_t state;
    //=========================================
    //parameters
    //=========================================
    localparam Pmw = 2 ;       // XBunit num, throughput number
    
	//=========================================
	//logics
	//=========================================
	
    //=========================================
    //combination
    //=========================================
    
    genvar  XB;
    generate 
        for (XB = 0 ; XB < Pmw ; XB++)begin: XBunit
            XBunit #(
			.BW_O(5),
			.BW_I(DWd)
			) xb (
			.i_in1(),
			.i_in2(),
			.i_x_sel(),
			.o_out()
			);
        end			
    endgenerate
    
    
    //=========================================
    //sequential
    //=========================================
    always_ff @ (posedge i_clk or negedge i_rstn)begin
    
    end
endmodule
