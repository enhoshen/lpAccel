
// include ../IF/IF.sv



module PE #(
    parameter PConfDWd = 4, 
    parameter TileConfDWd=10, 
	parameter DWd  = 16,     // data bit width 
	parameter PsumDWd  = 16,
    parameter InstDWd  = 3,   // 
    parameter PEcol =16
    )(
input i_clk,
input i_rstn,
input [PConfDWd-1:0] i_conf_Pch,  // channel number to be handled
input [PConfDWd-1:0] i_conf_Pm, // filters number to be handled
input [PConfDWd-1:0] i_conf_Pwb, //
input [PConfDWd-1:0] i_conf_Pxb, //
input [2:0] i_conf_Tb,
input [5:0] i_conf_wpad_size,
input [3:0] i_conf_ipad_size,

input i_conf_opath , // 1 as to buffer, 0 as to left PE
input [TileConfDWd-1:0] i_conf_Tw,

input [InstDwd-1:0] i_inst_pe,

`PBpixIf_in ( ipix , DWd),
`PBpixIf_in ( wpix , PEcol*DWd),

`PBpixIf_out ( pspix , DWd)
///////////////////////////////////

);
    typedef  logic enum {IDLE,WRITE,READ,DONE} fsm_t;
    fsm_t state;
    typedef enum logic [3:0]{ IDLE = 0 , INIT= 1 , LOOP = 2 , POP = 3 , OLAP = 4
                        }  IPadState ;  // pix r/w address overlapping handling   
    //=========================================
    //
    //parameters
    //=========================================
    localparam IPadSize = 12;
    localparam WPadSize = 48;
    localparam IAddrWd =$clog2(IPadSize);
    localparam WAddrWd =$clog2(WAddrWd );
	//=========================================
	//logics
	//=========================================
        // module // 

    genvar pe_row ; 
    generate begin : pe_row 
        for ( pe_row = 0 ; pe ; pe_row = pe_row+1)begin
         
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

        end
    endgenerate 
        // control //

    logic [7:0] cur_opix_r , cur_opix_w;     // max 64
    logic [3:0] cur_ipix_r , cur_ipix_w;
    
    logic [IAddrWd-1:0] ipad_waddr_r , ipad_waddr_w , ipad_raddr_r , ipad_raddr_w;
        logic [IAddrWd-1:0] ipad_base_r , ipad_base_w;
    logic [WAddrWd-1:0] wpad_waddr_r , wpad_waddr_w , wpad_waddr_r , wpad_waddr_w;
    //=========================================
    //combination
    //=========================================
        // IPAD
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






