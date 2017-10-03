// include IF.sv
// check IF/typedef.sv
typedef enum logic [3:0]{ IDLE = 0 , WAHEAD= 1 , RAHEAD = 2 , WAITR =3, WAITW = 4
                        }  PixState ;  // pix r/w address overlapping handling
interface IPcont_if#(              // to and from PE ,
    parameter ConfDWd = 4,
    parameter PConfDWd = 3
);
    logic [ConfDWd-1:0]  IFLen;   // RxPch  
    logic [ConfDWd-1:0]  PopU;    // (U-1)Pch+1 
    logic [PConfDWd-1:0] Pch;    // channel tile Pch

    logic pop ;                 // WPAD tell PE end of Tm, PE tell IPAD to pop
    logic nxtRow;               // PE keeps track of Tw, swap IF rows
    
    logic stall;
    logic start;
    logic reset;
    logic done;

    modport pad(
        input IFLen,
        input PopU,
        input Pch,
        input pop,
        input nxtRow,
        input stall,
        input start,
        input reset,
        input done
    );
    modport pe(
        output IFLen,
	output PopU,
	output Pch,
	output pop,
	output nxtRow,
	output stall,
	output start,
        output reset,
	output done
    );    

endinterface 

interface IPflag_if ;
    logic zero  ;  // next pixel is zero, posedge
    logic flag_n;  // negedge trigger , follow zero

    modport ipad(
        output zero,
	output flag_n
    );

    modport wpad(
        input flag_n
    );

    modport xbu(
        input zero
    );

endinterface

interface IPBpix_if #(  // input pad,buffer pixel interface
    parameter DWd = 16
);
    logic [DWd-1 :0 ] data;
    logic ready;
    logic valid; 
    logic zero ;

    modport pad(   
        input data,
	output ready,
	input valid,
	input zero
    );
    modport ibuf(
        output data,
	input ready,
	output valid,
	output zero
    );
endinterface

interface IPout_if #(  // input pad out pixel interface
    parameter DWd = 16
);
    logic [DWd-1:0] data;
    logic ready;
    logic valid;
    

    modport 
endinterface

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
IPflag_if.ipad flag,// zero flag to WPAD
IPcont_if.pad  cont,
IPBpix_if.pad  ipix,              // from IFbuffer
IPout_if.pad   opix               // to XBunit  
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
    PixState pstate, pstate_nxt ; 
        // addr
    logic [AddrWd-1:0] waddr_r ,     waddr_w    ;
    logic [AddrWd-1:0] raddr_r ,     raddr_w ;
    logic [AddrWd-1:0] base_addr_r,  base_addr_w;
    
    logic [PadSize-1:0] flag_reg_r, flag_reg_w;
    logic cur_flag_neg_r   ;   //negedge
        wire zero = flag_reg_r [waddr_r];  

    logic i_pix_ready_r , i_pix_ready_w;
    logic o_pix_valid_r , o_pix_valid_w;
    //=========================================
    //RF 12x16b
    //=========================================
    
	
    //=========================================
    //combination
    //=========================================
	    //control 
	     
    always_comb begin
        pstate_nxt     = pstate     ;	
        
	waddr_w      = waddr_r      ;
        raddr_w      = raddr_r   ;
        base_addr_w  = base_addr_r  ;
        
	flag_reg_w   = flag_reg_r   ; 
        
	case ( pstate_r ) begin
	    IDLE  :begin
	    pstate_w = ( )?
                waddr_w = 0;
		raddr_w = 0;
                base_addr_w = 0;

                flag_reg_w = 0;
                
            end
	    WAHEAD:begin
                o_pix_valid_w = 1'b1;
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
