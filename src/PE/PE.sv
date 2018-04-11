
import PECfg::*;

module PE (
`clk_input,
input [PECfg::PConfDWd-1:0] i_conf_Pch,  // channel number to be handled
input [PECfg::PConfDWd-1:0] i_conf_Pm, // filters number to be handled
input [PECfg::PConfDWd-1:0] i_conf_Ab, // Aunit bit used
input [PECfg::PConfDWd-1:0] i_conf_Tb, // batch tile
input [PECfg::PConfDWd-1:0] i_conf_U , // stride
input [PECfg::PConfDWd-1:0] i_conf_R , // filter width
input [PECfg::PConfDWd-1:0] i_conf_S , // filter height
input [PECfg::PConfDWd-1:0] i_conf_wpad_size, // pch*pm*R
input [PECfg::PConfDWd-1:0] i_conf_ipad_size, // pch*R
input [PECfg::TileConfDWd-1:0] i_conf_Tw,
input [PECfg::PConfDWd-1:0] i_conf_Xb, // *b is the bit channel num = tensor precision/Aunit bit
input [PECfg::PConfDWd-1:0] i_conf_Wb,


input [PECfg::InstDwd-1:0] i_inst_pe,
input [PECfg::PConfDWd-1:0] i_cont_curWb,
input [PECfg::PConfDWd-1:0] i_cont_curTb, 

input [PECfg::DWd-1:0] i_ipix,
`pbpix_input ( ipix ),
input [PECfg::DWd*PECfg::PEcol-1:0] i_wpix,
`pbpix_input ( wpix ),
output[PECfg::DWd*PECfg::PEcol-1:0] o_pspix
`pbpix_output ( pspix ),
//////////////////////////////////

);
    
    PECfg::IPadState s_ip_w , s_ip_r;
    //=========================================
    //parameters
    //=========================================
    localparam IPadSize = PECfg::IPadSize;
    localparam WPadSize = PECfg::WPadSize;
    localparam PPadSize= PECfg::PPadSize;
    localparam IAddrWd =$clog2(IPadSize);
    localparam WAddrWd =$clog2(WPadSize );
    localparam PAddrWd=$clog2(PPadSize);
	//=========================================
	//logics
	//=========================================
        // control //
    typedef enum logic {IDLE,WRITE,READ,DONE} s_main_w , s_main_r;

    logic [7:0] cur_opix_r , cur_opix_w;     // max 64
    logic [7:0] cur_ipix_r , cur_ipix_w;    
    logic [7:0] cur_wpix_r , cur_wpix_w;    
    logic [IPadSize-1:0] ipad_flag_w, ipad_flag_r;
    wire last_xb , last_wb ; 
    wire ; 

    wire ce ;
        wire re , we;
            //assign re = ce && ( (pstate==INIT && waddr_r!=raddr_r) || pstate!=IDLE);
            //assign we = ce && ( (pstate==POP  && waddr_r!=raddr_r) || pstate!=IDLE);
    wire cont_reset ;
    wire cont_stall ;
    wire cont_start ;
    
    logic [IAddrWd-1:0] ipad_waddr_r , ipad_waddr_w ;
    logic [IAddrWd-1:0] ipad_raddr_r , ipad_raddr_w;
        logic [IAddrWd-1:0] ipad_base_r , ipad_base_w;
    logic [WAddrWd-1:0] wpad_waddr_r , wpad_waddr_w ;
    logic [WAddrWd-1:0] wpad_raddr_r , wpad_raddr_w;
    logic [PAddrWd-1:0] ppad_waddr_r , ppad_waddr_r;
    logic [PAddrWd-1:0] ppad_raddr_r , ppad_raddr_r;
    
    //=========================================
    //combination
    //=========================================
        // module // 
    RF_2F #(
        .wordWd(IPadSize),
        .DWd(DWd)
    ) IPAD (
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        .i_read(),
        .i_write(),
        .i_raddr(),
        .i_waddr(),
        .o_rdata(),
        .i_wdata(),
    );
    DataPathController DC(
    );
           
    genvar pe_row ; 
    generate begin : pe_row 
        for ( pe_row = 0 ; pe ; pe_row = pe_row+1)begin
            FetchStage Fs(
            );
            MultStage Ms(
            );
            SumStage Ss(
            );
            PathStage Ps(
            );
            RF_2F#(
                .wordWd(WPadSize),
                .DWd(DWd)
            ) WPAD (
                .i_clk(i_clk),
                .i_rstn(i_rstn),
                .i_read(),
                .i_write(),
                .i_raddr(),
                .i_waddr(),
                .o_rdata(),
                .i_wdata(),
                
            );
            
            RF_2F#(
                .wordWd(PPADSize),
                .DWd(DWd)
            ) PPAD (
                .i_clk(i_clk),
                .i_rstn(i_rstn),
                .i_read(),
                .i_write(),
                .i_raddr(),
                .i_waddr(),
                .o_rdata(),
                .i_wdata(),
                
            );
            
        end
    endgenerate 



    always_comb begin
        pstate_nxt     = pstate     ;           
        waddr_w      = waddr_r      ;
        raddr_w      = raddr_r      ;
        nxtBase_addr_w  = nxtBase_addr_r  ;
        flag_w       = flag_r;
        if ( i_cont_reset ) begin
        pstate_nxt = IDLE;
            waddr_w= 0;
            raddr_w= 0;
            nxtBase_addr_w=0;
            flag_w=1;
        end
        else if ( i_cont_stall ) begin
        pstate_nxt     = pstate     ;           
            waddr_w      = waddr_r      ;
            raddr_w      = raddr_r      ;
            nxtBase_addr_w  = nxtBase_addr_r  ;
            flag_w       = flag_r; 
        end
        else begin
            if (pstate==IDLE) begin
                waddr_w = 0;
                nxtBase_addr_
            end
            else begin
                waddr_w = (ipad_write)? ((waddr_r==i_cont_IFLen)? 0 : waddr_r+1 ) : waddr_r;
                nxtBase_addr_w = (ipad_write || pstate == INIT)? ((nxtBase_addr_r==i_cont_IFLen)? 0 : nxtBase_addr_r+1) : nxtBase_addr_r;
                raddr_w = (ipad_read) ? ((i_cont_lastPix)? nxtBase_addr_r : (raddr_r==i_cont_IFLen)? 0 : raddr_r+1) : raddr_r;
                flag_w[waddr_r]= (ipad_write && !i_ipix_zero) ? 0 : flag_r[raddr_r];
            end 
        case ( pstate ) 
            IDLE  :begin
            pstate_nxt = (i_cont_start) ? INIT : IDLE ;
            end
            INIT:begin
                if( i_cont_noSpReuse &&  )begin

                end
                else if( i_cont_ 
                
                end
            end
            LOOP :begin
                if( i_cont_done)begin

                end 
            end
            POP:begin
            end

        endcase
        end
    end 
    
    
      
    //=========================================
    //sequential
    //=========================================
    always_ff @ (posedge i_clk or negedge i_rstn)begin
    
    end
endmodule






