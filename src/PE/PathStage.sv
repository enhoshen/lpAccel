import PECfg::*;

module PathStage(
`clk_input,
`rdyack_input(LPE),
`rdyack_input(SS),
`rdyack_output(POUT),
input  PPctl i_ppctl_MAIN,
input  PPctl i_ppctl_SS,
output PPctl o_ppctl_PS,
input  DPstatus i_dpstatus,
input  [PSUMDWD-1:0] i_Psum_PP [PEROW],
input  [PSUMDWD-1:0] i_Psum_LPE [PEROW], 
input  PSconf i_conf_LPE,
output [PSUMDWD-1:0] o_Psum_POUT[PEROW],
output PSconf i_conf_POUT
);
    //===========
    //Parameter
    //===========
    
    localparam MAXTW = $clog2(64); 
    //===========
    //logic
    //===========
    enum logic { FROMPP , FROMLPE  }last_src_r , last_src_w;
        assign last_src_w = ( `rdyNack(PP) )? FROMPP : ( `rdyNack(LPE) )? FROMLPE : last_src_r;
    logic [PSUMDWD-1:0] psum_w [PEROW] , psum_r [PEROW];
    PSconf pconf_w , pconf_r ;
            //TODO psconf connection
    logic [1:0] SRC_rdys , SRC_acks;
        assign SRC_rdys = {PP_rdy,LPE_rdy};
        assign SRC_acks = {PP_ack,LPE_ack};
    logic  read_PP_valid = !i_ppctl_MAIN.read && !`rdyNack(SS) &&;
            //TODO final condition where it's PP's turn
    assign SS_ack = ( i_ppctl_SS.waddr < i_ppctl_PS.waddr);

    LpCtl ps_idx_ctl;
    logic [MAXTW-1:0] ps_loopSize_r, ps_loopSize_w ;
    logic ps_end;
        assign ps_loopSize_w = (o_DPstatus.lastPix)? i_PEconf.ppad_size : ps_loopSize_r; 
    logic [MAXTW-1:0] ps_loopIdx  ;
    logic 
        assign o_ppctl_PS.waddr = '0;
        assign o_ppctl_PS.raddr = ps_loopIdx -1'd1;
            assign o_ppctl_PS.read = ps_idx_ctl.inc;
            assign o_ppctl_PS.write= '0; 
            //TODO connection 
    //===========
    //comb
    //===========
    LoopCounterD1 #(
    .IDXDW(MAXTW), .STARTPOINT(1'b1)
    ) PSLp(
        .*,
        .i_loopSize(ps_loopSize_r),
        .i_ctl(ps_idx_ctl),
        .o_loopEnd(ps_end),
        .o_loopIdx(ps_loopIdx)
    );
   localparam SRCN = 2; 
    `rrforward ( RRFD , SRC , POUT , SRCN )
    
    always_comb begin
        `forstart(perow,PEROW)
            case ( {`rdyNack(PP),`rdyNack(LPE)} )
                2'b01: psum_w[perow] = i_Psum_LPE[perow];
                2'b10: psum_w[perow] = i_Psum_PP [perow];
                default: psum_w[perow] = psum_r[perow];
            endcase
        `forend
        case( {`rdyNack(PP),`rdyNack(LPE)} )
            2'b01: pconf_w = i_conf_LPE;
            2'b10: pconf_w = i_conf_PP;
            default: pconf_w = '0;
        endcase 
    end 
    //===========
    //sequential
    //===========
 
    `ff_rstn
        `forstart(perow,PEROW) 
            psum_r[perow] <= '0; 
        `forend
        pconf_r <= '0;
    `ff_cg( !(SS_rdy && !SS_ack) || `rdyNack(LPE))
        `forstart(perow,PEROW)
            psum_r[perow] <= psum_w[perow]; 
        `forend
        pconf_r <= pconf_w;
    `ff_end
endmodule
