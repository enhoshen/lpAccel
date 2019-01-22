
import PECfg::*;
import PECtlCfg::*;
module PE (
`clk_input,
input Conf i_PEconf,
input Inst i_PEinst,
`rdyack_input(Input),
`rdyack_input(Weight),
`rdyack_output(Psum),
input [DWD-1:0] i_Input,
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
    IPctl ipctl;
    WPctl wpctl;
    PPctl ppctl_MAIN , ppctl_FS , ppctl_SS , ppctl_PS;  // the suffix mark the output module of the port
    FSctl fsctl_MAIN;
    MSctl msctl_MAIN , msctl_FS;
    SSctl ssctl_MAIN , ssctl_FS , ssctl_MS;
    //=========================================
    //combination
    //=========================================
        // module // 
    RF_2F #(
        .wordWd(IPadSize),
        .DWd(DWd)
    ) IPAD (
        .*,
        .i_read(ipctl.read),
        .i_write(ipctl.write),
        .i_raddr(ipctl.raddr),
        .i_waddr(ipctl.waddr),
        .o_rdata(),
        .i_wdata(i_Input),
    );
    DataPathController DPC(
        .*,
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






