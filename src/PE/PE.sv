
import PECfg::*;
import PECtlCfg::*;
module PE (
`clk_input,
input Conf i_PEconf,
input Inst i_PEinst,
`rdyack_input(Input),
`rdyack_input(Weight),
`rdyack_output(Psum),
input [DWD-1:0] i_Input[IPADN],
input [DWD-1:0] i_Weight [PECOL],
output[DWD-1:0] o_Psum [PECOL],
//////////////////////////////////


    //=========================================
    //parameters
    //=========================================
	//=========================================
	//logics
	//=========================================
        // control //
    typedef enum logic {IDLE,WRITE,READ,DONE} s_main_w , s_main_r;
        // connection //
    `rdyack_logic(MAIN);
    `rdyack_logic(FS);
    `rdyack_logic(MS);
    `rdyack_logic(SS);
    FSctl fs_ctl_MAIN;
    MSctl ms_ctl_MAIN;
    SSctl ss_ctl_MAIN;
            // pipeline connect
    FSpipe fs_pipe;
    SSctl  ms_pipe;
            //PAD
    logic [DWD-1:0] ip_out [IPADN];
    logic [DWD-1:0] wp_out [PECOL];
    logic [DWD-1:0] pp_in  [PECOL];
    IPctl ipctl;
    WPctl wpctl;
    PPctl ppctl_MAIN,ppctl_FS,ppctl_SS;
    //=========================================
    //combination
    //=========================================
        // module // 
    RF_2F #(
        .WORDWD(IPADSIZE),
        .DWD(DWD),
        .SIZE(IPADN)
    ) IPAD (
        .*,
        .i_read(ipctl.read),
        .i_write(ipctl.write),
        .i_raddr(ipctl.raddr),
        .i_waddr(ipctl.waddr),
        .o_rdata(ip_out),
        .i_wdata(i_Input),
    );
    RF_2F #(
        .WORDWD(WPADSIZE),
        .DWD(DWD),
        .SIZE(PECOL)
    )WPAD(
        .*,
        .i_read (wpctl.read),
        .i_write(wpctl.write),
        .i_raddr(wpctl.raddr),
        .i_waddr(wpctl.waddr),
        .o_rdata(wp_out),
        .i_wdata(i_Weight),
    );
    // TODO
    // Psum pad need special arrangement
    //
    DataPathController DPC(
        .*,           
        `rdyack_connect(Input,Input),
        `rdyack_connect(Weight,Weight),
        `rdyack_connect(MAIN,MAIN),
        .o_IPctl(ipctl),   
        .o_WPctl(wpctl),   
        .o_PPctl(ppctl_MAIN),   
        .o_FSctl(fs_ctl_MAIN),   
        .o_MSctl(ms_ctl_MAIN),   
        .o_SSctl(ss_ctl_MAIN),   
        .o_DPstatus(),        
    );
    FetchStage Fs(
        .*,              
    );
    MultStage Ms(
        .*,
     );
    SumStage Ss(
        .*,
     );
    PathStage Ps(
             
    genvar pe_row ; 
    generate begin : pe_row 
        for ( pe_row = 0 ; pe ; pe_row = pe_row+1)begin
           );
            RF_2F#(
                .wordWd(WPadSize),
                .DWd(DWd)
            ) WPAD (
                .*,
                .i_read(wpctl.read),
                .i_write(wpctl.write),
                .i_raddr(wpctl.raddr),
                .i_waddr(wpctl.waddr),
                .o_rdata(),
                .i_wdata(i_Weight[pe_row]),
                
            );
            
            RF_2F#(
                .wordWd(PPADSize),
                .DWd(DWd)
            ) PPAD (
                .*,
                .i_read(),
                .i_write(),
                .i_raddr(),
                .i_waddr(),
                .o_rdata(),
                .i_wdata(),
                
            );
            
        end
    endgenerate 

     
    //=========================================
    //sequential
    //=========================================
    always_ff @ (posedge i_clk or negedge i_rstn)begin
    
    end
endmodule






