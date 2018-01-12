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
`IPcontIf_cont(ConfDWd,PConfDWd),
// from IFbuffer
`PBpixIf_in(ipix,DWd),  // ipix valid only when every PE ready 
// to AU 
`PBpixIf_out(opix,DWd)   // opix ready only when every PADs ready
);
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
        // addr
    logic [AddrWd-1:0] waddr_r ,     waddr_w;
    logic [AddrWd-1:0] raddr_r ,     raddr_w ;
    logic [AddrWd-1:0] nxtBase_addr_r,  nxtBase_addr_w;  // +1 when ipad_write , with spReuse
        // flag
    logic [PadSize-1:0] flag_w , flag_r;
        // enable
    wire ce ;
        assign ce = !i_cont_reset && !i_cont_stall;
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
    assign o_ipix_ready = ipad_write;
    
    assign o_opix_valid = ipad_read;
    assign o_opix_zero  = flag_r[raddr_r];
    
   
    
    
  
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

