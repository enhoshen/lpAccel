// include IF.sv
// check IF/typedef.sv
typedef enum logic [3:0]{ IDLE = 0 , WAHEAD= 1 , RAHEAD = 2 , WAITR =3, WAITW = 4
                        }  PixState ;  // pix r/w address overlapping handling
module IFPAD #( 
    parameter DWd =16,
    parameter PadSize = 12,
    parameter ConfDWd = 4,
    parameter PConfDWd = 3, //PE configuration: Pc, Pm
    parameter InstDWd = 3,  
    parameter AddrWd  = 4
)(
input i_clk,
input i_rstn,
input [ConfDWd-1:0]  i_IFLen,   // RxPch  
input [ConfDWd-1:0]  i_PopU,    // (U-1)Pch+1 
input [PConfDWd-1:0] i_Pch,     // channel tile Pch
input i_pop,                  // finish all the filters and all input channel, pop a data point
input i_nxtRow,               // next row stage

input  i_WFlagNxt,              // zero flag from WPAD
output o_IFFlagNxt,            // zero flag to WPAD

input  i_stall,
input  i_start,
input  i_reset,
input  i_done,

sim_Dif.in   i_pix,              // from IFbuffer
sim_Dif.out  o_pix               // to XBunit  
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
    PixState pstate_r, pstate_w ; 
        // addr
    logic [AddrWd-1:0] waddr_r ,     waddr_w    ;
    logic [AddrWd-1:0] cur_addr_r ,  cur_addr_w ;
    logic [AddrWd-1:0] base_addr_r,  base_addr_w;
    
    logic [PadSize-1:0] flag_reg_r, flag_reg_w;
    logic cur_flag_r , cur_flag_w;
    //=========================================
    //RF 12x16b
    //=========================================
    
	
    //=========================================
    //combination
    //=========================================
	    //control 
	     
    always_comb begin
        pstate_w     = pstate_r     ;	
        
	waddr_w      = waddr_r      ;
        cur_addr_w   = cur_addr_r   ;
        base_addr_w  = base_addr_r  ;
        
	flag_reg_w   = flag_reg_r   ; 
        cur_flag_w   = cur_flag_r   ;	
        
	case ( pstate_r ) begin
	    IDLE  :begin
                
            end
	    WAHEAD:begin
            end
	    RAHEAD:begin
            end
	    WAITR :begin
            end
	    WAITW :begin
            end
	end
        	
    end	
	
	
	
	
  
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
