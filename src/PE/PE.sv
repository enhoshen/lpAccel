
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
output[PSUMDWD-1:0] o_Psum [PEROW]
);
    //=========================================
    //parameters
    //=========================================
	//=========================================
	//logics
	//=========================================
        // connection //
    `rdyack_logic(MAIN);
    `rdyack_logic(FS);
    `rdyack_logic(MS);
    `rdyack_logic(SS);
    FSctl fs_ctl_MAIN;
    MSconf ms_conf_MAIN;
    SSctl ss_ctl_MAIN;
            // pipeline connect
    FSpipein fspipe_MAIN;
        assign fspipe_MAIN = {ms_conf_MAIN,ss_ctl_MAIN};
    FSpipeout fspipe_FS; 
    SSctl  mspipe_FS , mspipe_MS;
        assign mspipe_FS = fspipe_FS.ssctl;
            //PAD
    logic [DWD-1:0] ip_out [IPADN];
    logic [DWD-1:0] wp_out [PEROW];
    logic [PSUMDWD-1:0] pp_out[PEROW];
    IPctl ipctl;
    WPctl wpctl;
    PPctl ppctl_MAIN , ppctl_SS;
            //data pipe
    FSin  fs_data_in [PEROW];
    FSout fs_data_out[PEROW];
    MSout ms_data_out[PEROW];
            // final outputs
    logic [PSUMDWD-1:0] sum_SS [PEROW];
        assign o_Psum = sum_SS;
    //=========================================
    //comb
    //=========================================
    genvar pe_row;
    generate
        for( pe_row=0 ; pe_row<PEROW ; ++pe_row)begin
            localparam int ip_idx = IPADN / pe_row;
            assign fs_data_in[pe_row] = {ip_out[ip_idx],wp_out[pe_row],pp_out[pe_row]};
        end
    endgenerate
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
    // ?TODO?
    // Psum pad need special arrangement
    //
    RF_2P_MSK #(
        .WORDWD(PPADSIZE/2),                 
        .DWD   (PSUMDWD),
        .SIZE  (PEROW)           
    )PPAD(                                         
        .*,             
        .i_dwd_mode(ppctl_MAIN.psum_mode),  
        .i_read (ppctl_MAIN.read),      
        .i_write(ppctl_MAIN.write),     
        .i_raddr(ppctl_MAIN.raddr),     
        .i_waddr(ppctl_MAIN.waddr),     
        .o_rdata(pp_out),     
        .i_wdata(sum_SS)      
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
        .o_MSconf(ms_conf_MAIN),   
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
        .i_data(fs_data_out),            
        .o_data(ms_data_out),            
        .i_MSpipe_FS(mspipe_FS),       
        .o_MSpipe_MS(mspipe_MS)      
    );
    SumStage Ss(
        .*,                    
        `rdyack_connect(MS,MS),  
        `rdyack_connect(SS,SS),  
        .i_ctl(mspipe_MS),              
        .i_data(ms_data_out),             
        .Sum_SS(sum_SS),             
        .o_ppctl_SS(ppctl_SS)          
     );
             

     
    //=========================================
    //sequential
    //=========================================
    
endmodule

`ifdef PEtest
module PEtest;
    import PECfg::*;
    Conf i_PEconf;
    Inst i_PEinst;
    logic [DWD-1:0] i_Input [IPADN] , i_Weight [PEROW];
    logic [PSUMDWD-1:0] o_Psum [PEROW];
    `rdyack_logic(Input);
    `rdyack_logic(Weight);
    `rdyack_logic(MAIN);
    `default_Nico_define 
    
PE dut(
.*      
);

`default_Nico_init_block(PEtest,10000)
endmodule

`endif




