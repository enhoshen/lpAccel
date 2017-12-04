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
//IPcont_if.ipad  cont,
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
`PBpixIf_ipix(DWd),
// to AU
`PBpixIf_opix(DWd) 
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
    logic [AddrWd-1:0] waddr_r ,     waddr_w    ;
        assign ipad_waddr = waddr_r;
    logic [AddrWd-1:0] raddr_r ,     raddr_w ;
        assign ipad_raddr = raddr_r;
    logic [AddrWd-1:0] base_addr_r,  base_addr_w;
    wire ce ;
        assign ce = !i_cont_reset && !i_cont_stall;
    wire re , we ;
        assign re = ce && pstate!=WAITW ;
        assign we = ce && pstate!=WAITR ;
    //=========================================
    //combination
    //=========================================
        //control 
        // rf control
    assign ipad_read = re &&
    assign ipad_write= we && o_opix_ready 
            //( !i_cont_reset && !i_cont_stall \
            //            && i_ipix_ready && pstate==WAHEAD && i_cont_pop );
    assign ipad_raddr=raddr_r;
    assign ipad_waddr=waddr_r;
    assign ipad_wdata=i_ipix_data;
    assign o_opix_data=ipad_rdata;
         
    always_comb begin
        pstate_nxt     = pstate     ;           
        waddr_w      = waddr_r      ;
        raddr_w      = raddr_r      ;
        base_addr_w  = base_addr_r  ;

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

