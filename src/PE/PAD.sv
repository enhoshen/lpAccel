// include IF.sv
// check IF/typedef.sv
module IFPAD #( 
    parameter DWd =16,
    parameter PadSize = 12,
    parameter ConfDWd = 4,
    parameter PConfDWd = 3, //PE configuration: Pc, Pm
    parameter InstDWd = 3
)(
input i_clk,
input i_rstn,
//from pe control,
input [ConfDWd-1:0]i_cont_IFLen,
input [ConfDWd-1:0]i_cont_PopU,
input [PConfDWd-1:0]i_cont_Pch,
input i_cont_lastPix,
input i_cont_pop,
input i_cont_nxtRow,
input i_cont_stall,
input i_cont_start,
input i_cont_reset,
input i_cont_done,

// from IFbuffer
`PBpixIf_ipix(DWd),  // ipix valid only when every PE ready 
// to AU 
`PBpixIf_opix(DWd)   // opix ready only when every PADs ready
);
typedef enum logic [3:0]{ IDLE = 0 , WAHEAD= 1 , RAHEAD = 2 , WAITR =3, WAITW = 4
                        }  PixState ;  // pix r/w address overlapping handling   
    //=========================================
    //parameters
    //=========================================
    localparam AddrWd = $clog2(PadSize);
    //=========================================
    //RF 12x16b
    //=========================================
    `Rf2pIf_logic( ipad, PadSize, DWd);
    
    RF_2F #(
        .wordWd(PadSize),
        .DWd(DWd)
    ) RF0 (
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        `Rf2pIf_pc_rf(ipad)
    );
    //=========================================
    //logics
    //=========================================
        // control
    wire en ;
    PixState pstate, pstate_nxt ; 
        // addr
    logic [AddrWd-1:0] waddr_r ,     waddr_w;
    logic [AddrWd-1:0] raddr_r ,     raddr_w ;
    logic [AddrWd-1:0] nxtbase_addr_r,  nxtBase_addr_w;  // +1 when ipad_write , with spReuse
        // flag
    logic [PadSize-1:0] flag_w , flag_r;
        // enable
    wire ce ;
        assign ce = !i_cont_reset && !i_cont_stall;
    wire re , we ;
        assign re = ce && (pstate!=WAITW || pstate!=IDLE);
        assign we = ce && (pstate!=WAITR || pstate!=IDLE);
    //=========================================
    //combination
    //=========================================
        //control 
        // rf control
    assign ipad_read = re && i_opix_ready ;
    assign ipad_write= we && i_cont_pop && i_ipix_valid ; 
    assign ipad_raddr=raddr_r;
    assign ipad_waddr=waddr_r;
    assign ipad_wdata=i_ipix_data;
    assign o_opix_data=ipad_rdata;
         // ipix opix
    assign o_ipix_ready = ;
    assign o_opix_valid = ;
    assign o_opix_zero  = ;
    
    always_comb begin
        pstate_nxt     = pstate     ;           
        waddr_w      = waddr_r      ;
        raddr_w      = raddr_r      ;
        nxtBase_addr_w  = base_addr_r  ;
        flag_w       = flag_r;
        if ( i_cont_reset ) begin
        pstate_nxt = IDLE;
            waddr_w= 0;
            raddr_w= 0;
            nxtBase_addr_w=0;
            flag_w=0;
        end
        else if ( i_cont_stall ) begin
        pstate_nxt     = pstate     ;           
            waddr_w      = waddr_r      ;
            raddr_w      = raddr_r      ;
            nxtBase_addr_w  = base_addr_r  ;
            flag_w       = flag_r; 
        end
        else begin
        case ( pstate ) 
            IDLE  :begin
            pstate_nxt = (i_cont_start) ? WAITW : IDLE ;
                flag_w = 0;
                waddr_w= 0;
                raddr_w= 0;
                nxtBase_addr_w = 0; 
            end
            WAHEAD:begin
            pstate_nxt = ( ) WAHEAD;
                
            end
            WAITW :begin
            pstate_nxt =( i_ipix_valid )? WAHEAD : WAITW; 
                ipix.ready = 1'b1;          
                opix.valid = 1'b0;
            end
            RAHEAD:begin
            end
            WAITR:begin

            end
        endcase
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
    parameter ConfDWd = 4,
    parameter PConfDWd =3, 
    parameter DWd = 16
)(
// pe control

input i_cont_swapWt, // weight in  
input i_cont_stall,
input i_cont_start,
input i_cont_reset,
input i_cont_done,


PBpix_if.pad ipix,
Pout_if.pad opix
);


endmodule

