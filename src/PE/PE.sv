
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
input [DWD-1:0] i_Weight [PEROW],
output[DWD-1:0] o_Psum [PEROW]
);

    //=========================================
    //parameters
    //=========================================
	//=========================================
	//logics
	//=========================================
        // control //
    enum logic [1:0] {IDLE,WRITE,READ,DONE} s_main , s_main_nxt;
        // connection //
    `rdyack_logic(MAIN);
    `rdyack_logic(FS);
    `rdyack_logic(MS);
    `rdyack_logic(SS);
    FSctl fs_ctl_MAIN;
    MSctl ms_ctl_MAIN;
    SSctl ss_ctl_MAIN;
            // pipeline connect
    FSpipe fspipe_MAIN , fspipe_FS ;
        assign fspipe_MAIN = {ppctl_MAIN,ms_ctl_MAIN,ss_ctl_MAIN};
    SSctl  mspipe_FS , mspipe_ms;
        assign mspipe_FS = fspipe_FS.ssctl;
            //PAD
    logic [DWD-1:0] ip_out [IPADN];
    logic [DWD-1:0] wp_out [PEROW];
    logic [PSUMDWD-1:0] pp_in  [PEROW] , pp_out[PEROW];
    IPctl ipctl;
    WPctl wpctl;
    PPctl ppctl_MAIN , ppctl_SS;
            //data pipe
    FSin  fs_data_in [PEROW];
    FSout fs_data_out[PEROW];
    MSin  ms_data_in [PEROW];
    MSout ms_data_out[PEROW];
    SSin  ss_data_in [PEROW];
            // final outputs
    logic [PSUMDWD-1:0] sum_SS [PEROW];

    //=========================================
    //
    //=========================================
    genvar pe_row;
    generate
        for( pe_row=0 ; pe_row<PEROW ; ++pe_row)begin
            assign fs_data_in[pe_row] = {ip_out[pe_row],wp_out[pe_row],pp_out[pe_row]};
        end
    endgenerate
    
    
    //=========================================
    //combination
    //=========================================
        // module // 
    RF_2P #(
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
        .i_wdata(i_Input)
    );
    RF_2P #(
        .WORDWD(WPADSIZE),
        .DWD(DWD),
        .SIZE(PEROW)
    )WPAD(
        .*,
        .i_read (wpctl.read),
        .i_write(wpctl.write),
        .i_raddr(wpctl.raddr),
        .i_waddr(wpctl.waddr),
        .o_rdata(wp_out),
        .i_wdata(i_Weight)
    );
    // TODO
    // Psum pad need special arrangement
    //
    RF_2P_MSK #(
        .WORDWD(PPADSIZE/2),                 
        .DWD   (PSUMDWD),
        .SIZE  (PEROW)           
    )PPAD(                                         
        .*,             
        .i_dwd_mode(i_PEconf.Psum_mode),  
        .i_read(),      
        .i_write(),     
        .i_raddr(),     
        .i_waddr(),     
        .o_rdata(),     
        .i_wdata()      
    );                                         
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
        .o_DPstatus()        
    );
    FetchStage Fs(
        .*,                      
        `rdyack_connect(MAIN,MAIN),  
        `rdyack_connect(FS,FS),    
        .i_ctl(fs_ctl_MAIN),                
        .i_data(fs_data_in),              
        .o_data(fs_data_out),             
        .i_FSpipe_MAIN(fspipe_MAIN),        
        .o_FSpipe_FS(fspipe_FS)         
    );
    MultStage Ms(
        .*,                   
        `rdyack_connect(FS,FS), 
        `rdyack_connect(MS,MS), 
        .i_ctl(fspipe_FS.msctl),             
        .i_data(ms_data_in),            
        .o_data(ms_data_out),            
        .i_MSpipe_FS(mspipe_FS),       
        .o_MSpipe_MS(mspipe_MS)      
    );
    SumStage Ss(
        .*,                    
        `rdyack_connect(MS,MS),  
        `rdyack_connect(SS,SS),  
        .i_ctl(mspipe_MS),              
        .i_data(ss_data_in),             
        .Sum_SS(sum_SS),             
        .o_ppctl_SS(ppctl_SS)          
     );
    PathStage Ps(
             
    genvar pe_row ; 
    generate  
    endgenerate 

     
    //=========================================
    //sequential
    //=========================================
    always_ff @ (posedge i_clk or negedge i_rstn)begin
    
    end
endmodule






