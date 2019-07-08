`ifdef GATE_LEVEL

`else
import PECfg::*;
import PECtlCfg::*;
module PE #(
parameter [PEROWWD-1:0] PECOLIDX = 0
)(
`clk_input,
input Conf i_PEconf,
input Inst i_PEinst,
`rdyack_input(Input),
`rdyack_input(Weight),
`rdyack_input(LPE),
`rdyack_output(POUT),
input [DWD-1:0] i_Input[IPADN],
input [DWD-1:0] i_Weight [PEROW],
output[PSUMDWD-1:0] o_Psum [PEROW],
input [PSUMDWD-1:0] i_Psum_LPE [PEROW],
input  PSconf i_Psumconf_LPE,
output PSconf o_Psumconf,
output DPstatus o_status
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
            //PAD
    logic [DWD-1:0] ip_out [IPADN];
    logic [DWD-1:0] wp_out [PEROW];
    logic [PSUMDWD-1:0] pp_out[PEROW];
    IPctl ipctl;
    WPctl wpctl;
    PPctl ppctl_MAIN , ss_ppctl_MAIN ,ppctl_SS , ppctl_PS;
            //data pipe
    FSin  fs_data_in [PEROW];
    FSout fs_data_out[PEROW];
    MSout ms_data_out[PEROW];
            // pipeline connect
    FSctl fs_ctl_MAIN;
    MSconf ms_conf_MAIN;
    SSctl ss_ctl_MAIN;
    DPstatus dpstatus_MAIN;            
        assign o_status = dpstatus_MAIN;
    FSpipein fspipe_MAIN;
        assign fspipe_MAIN = {fs_ctl_MAIN,ms_conf_MAIN,ss_ctl_MAIN,ss_ppctl_MAIN};
    FSpipeout fspipe_FS; 
    MSpipe    mspipe_MS;
            // final outputs
    logic [PSUMDWD-1:0] sum_SS [PEROW];
    //=========================================
    //debug/test
    //=========================================
    assign Psum_out_rdy = ppctl_SS.write;
    //=========================================
    //comb
    //=========================================
    genvar pe_row;
    generate
        for( pe_row=0 ; pe_row<PEROW ; ++pe_row)begin: ipad_gen
            localparam int ip_idx = pe_row/(16/IPADN);
            assign fs_data_out[pe_row] = {ip_out[ip_idx],wp_out[pe_row],pp_out[pe_row]};
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
        .i_dwd_mode(ppctl_PS.psum_mode),  
        .i_read (ppctl_PS.read),      
        .i_write(ppctl_PS.write),     
        .i_raddr(ppctl_PS.raddr),     
        .i_waddr(ppctl_PS.waddr),     
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
        .o_SSPPctl(ss_ppctl_MAIN),
        .o_DPstatus(dpstatus_MAIN)        
    );
    FetchStage Fs(
        .*,                      
        `rdyack_connect(MAIN,MAIN),  
        `rdyack_connect(FS,FS),    
        .i_pipe(fspipe_MAIN),                
        .i_data(fs_data_in),              
        .o_data(),             
        .o_FSpipe_FS(fspipe_FS)         
    );
    MultStage Ms(
        .*,                   
        `rdyack_connect(FS,FS), 
        `rdyack_connect(MS,MS), 
        .i_pipe(fspipe_FS),             
        .i_data(fs_data_out),            
        .o_data(ms_data_out),            
        .o_MSpipe_MS(mspipe_MS)      
    );
    SumStage Ss(
        .*,                    
        `rdyack_connect(MS,MS),  
        `rdyack_connect(SS,SS),
        .i_pipe(mspipe_MS),              
        .i_data(ms_data_out),             
        .Sum_SS(sum_SS),             
        .o_ppctl_SS(ppctl_SS)          
     );
    PathStage Ps(
        .*,                          
        `rdyack_connect(LPE,LPE),       
        `rdyack_connect(SS,SS),        
        `rdyack_connect(POUT,POUT),      
        .i_PEinst(i_PEinst),                 
        .i_conf( {dpstatus_MAIN,{i_PEconf.Psum_mode,PECOLIDX,i_PEconf.Pm,i_PEconf.Tw } , ppctl_MAIN, ppctl_SS ,i_PEconf.ppad_size }  ),
        .o_ppctl_PS(ppctl_PS),               
        .i_Psum_PP(pp_out),
        //.i_Psum_LPE(i_Psum_LPE),
        .i_psconf_LPE(i_Psumconf_LPE),
        .o_Psum_POUT(o_Psum),
        .o_psconf_POUT(o_Psumconf)
    );             

     
    //=========================================
    //sequential
    //=========================================
    
endmodule
`endif

`ifdef PEtest
import PECfg::*;
import PECtlCfg::*;
module PEtest;

    Conf i_PEconf;
    Inst i_PEinst;
    logic [DWD-1:0] i_Input [IPADN] , i_Weight [PEROW];
    logic [PSUMDWD-1:0] o_Psum [PEROW] , i_Psum_LPE [PEROW];
    PSconf i_Psumconf_LPE, o_Psumconf;
    DPstatus o_status;
    `rdyack_logic(Input);
    `rdyack_logic(Weight);
    `rdyack_logic(LPE);
    `rdyack_logic(POUT);
    `default_Nico_define 
PE dut(
.*      
`ifdef GATE_LEVEL
,
.i_Input({>>{i_Input}}),
.i_Weight( {>>{i_Weight}}),
.o_Psum({>>{o_Psum}}),
.i_Psum_LPE({>>{i_Psum_LPE}})
`endif
);

`default_Nico_init_block(PEtest,1000000)
endmodule

`endif




