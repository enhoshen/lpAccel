// include IF.sv
// check IF/typedef.sv

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

    modport ipad(
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

//TODO
interface WPcont_if ;

    logic nxtWRow;
    modport wpad(
        input nxtWRow
    );
    modport pe(
        output nxtWRow
    );
endinterface 

interface IPflag_if ;
    logic zero  ;  // next pixel is zero, posedge

    modport ipad(
        output zero
    );

    modport wpad(
        input zero
    );

endinterface

interface PBpix_if #(  // input pad,buffer pixel interface
    parameter DWd = 16
);
    logic [DWd-1 :0 ] wdata;
    logic ready;
    logic valid; 
    logic zero ;

    modport pad(   
        input wdata,
        output ready,
        input valid,
        input zero
    );
    modport buff(
        output wdata,
        input ready,
        output valid,
        output zero
    );
endinterface


interface Pout_if #(  //  pad out pixel interface
    parameter DWd = 16
);
    logic [DWd-1:0] data;
    logic ready;
    logic valid;
    logic zero;

    modport  pad(
        output data,
        output valid,
        input ready,
        output zero
    );
    
    modport au(
        input data,
        input valid,
        output ready,
        input zero
    );

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
IPcont_if.ipad  cont,
PBpix_if.pad  ipix,              // from IFbuffer
Pout_if.pad   opix               // to XBunit  
);
typedef enum logic [3:0]{ IDLE = 0 , WAHEAD= 1 , RAHEAD = 2 , WAITR =3, WAITW = 4
                        }  PixState ;  // pix r/w address overlapping handling   
    //=========================================
    //parameters
    //=========================================
    
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
        wire opix_en = zero;
    Rf2p_if #(
        .wordWd(PadSize),
        .DWd(DWd)
    ) rfif (); 
    //=========================================
    //RF 12x16b
    //=========================================
    RF_2F #(
        .wordWd(PadSize),
        .DWd(DWd)
    ) RF0 (
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        .port(rfif)
    );
    
    //=========================================
    //combination
    //=========================================
        //control 
         
    always_comb begin
        pstate_nxt     = pstate     ;           
        waddr_w      = waddr_r      ;
        raddr_w      = raddr_r      ;
        base_addr_w  = base_addr_r  ;
        
        flag_reg_w   = flag_reg_r   ; 
        if (cont.reset == 1'b1) begin 
            case ( pstate ) 
                IDLE  :begin
                pstate_nxt = ( cont.start == 1'b1  )? WAITW : IDLE; 
                    waddr_w = 0;
                    raddr_w = 0;
                    base_addr_w = 0;
                    flag_reg_w = 0;
                end
                WAHEAD:begin
                pstate_nxt = WAHEAD;
            
                end
                WAITW :begin
                pstate_nxt = ( ipix.valid == 1'b1 && cont.pop)? WAHEAD : WAITW; 
                    ipix.ready = 1'b1;          
                    opix.valid = 1'b0;
                end
            endcase
        end
        else begin
        
        end 
        
    end 
    
    
    
    
  
    //=========================================
    //sequential
    //=========================================
    always_ff @ (posedge i_clk or negedge i_rstn)begin
        if( !i_rstn) begin
        
        end
        else if( en ) begin
        
        end
    end
    
    always_ff @ (posedge i_clk or negedge i_rstn)begin  // opix sequential
        if( !i_rstn) begin
        end
    else if ( opix_en ) begin
        end
    end

endmodule

module WPAD #(
)(
WPcont_if.wpad cont,
PBpix_if.pad ipix,
Pout_if.pad opix
);
endmodule

