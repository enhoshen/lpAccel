// include IF.sv
// check IF/typedef.sv

module IFPAD_controller #(
    parameter DWd =16,
    parameter PadSize = 12,
	parameter ConfDWd = 4,
    parameter PConfDWd = 3, //PE configuration: Pc, Pm
    parameter InstDWd = 3,  
	parameter AddrWd  = 4
)(
input i_clk,
input i_rstn,
input [ConfDWd-1:0]  i_conf_R,   // filter width
input [ConfDWd-1:0]  i_conf_pop, // (U-1)Tch+1
input [PConfDWd-1:0] i_conf_Pch, // channel tile Pc
input i_pop_px,                  // finish all the filters and all input channel, pop a data point
sim_Iif.in   i_Inst, 
sim_Dif.in   i_pix,              // from IFbuffer
sim_Dif.out  o_pix               // to PE column , ready signal implies next data point, every PE row needs to be ready

);
    //=========================================
    //parameters
    //=========================================
    import ISA1::*;
    
	//=========================================
	//logics
	//=========================================
         // control
	wire en ; 
    wire stall;
	     // addr
    logic [AddrWd-1:0] waddr_r ,     waddr_w    ;
    logic [AddrWd-1:0] cur_addr_r ,  cur_addr_w ;
    logic [AddrWd-1:0] base_addr_r,  base_addr_w;
	logic [ConfDWd-1:0] cur_rpix_r , cur_rpix_w ;  // read pixel index
	logic [ConfDWd-1:0] cur_wpix_r , cur_wpix_w ;  // write pixel index
    //=========================================
    //RF 12x16b
    //=========================================
    
	
    //=========================================
    //combination
    //=========================================
	    //control
    assign stall = (i_Inst.inst == ISA1::STALL) ;
    assign reset = (i_Inst.inst == ISA1::RESET) ;
	assign en = !stall ;   
	     
	always_comb begin
        waddr_w      = waddr_r      ;
		cur_addr_w   = cur_addr_r   ;
		base_addr_w  = base_addr_r  ;
		cur_rpix_w   = cur_rpix_r   ;
		cur_wpix_w   = cur_wpix_r   ;
		
		
		
	    
	end	
	
	
	
	
    //assign cur_rpix_w = ( o_raddr.ready )? 1 : cur_rpix_r ;
    //=========================================
    //sequential
    //=========================================
    always_ff @ (posedge i_clk or negedge i_rstn)begin
        if( i_rstn) begin
		
		end
		else if ( en ) begin
		
		end
    end
endmodule

module WBPAD #(
)(
);
endmodule

module WZPAD #(
)(
);
endmodule
