import PECfg::*;
typedef struct packed{
    DPstatus dpstatus;
    PSconf psconf_MAIN;
    PPctl ppctl_MAIN;
    PPctl ppctl_SS;
    logic [PPADADDRWD:0] ppad_size; 
} PStageconf; 
module PathStage(
`clk_input,
`rdyack_input(LPE),
`rdyack_input(SS),
`rdyack_output(POUT),
input Inst i_PEinst,
input PStageconf i_conf,
output PPctl o_ppctl_PS,
input  [PSUMDWD-1:0] i_Psum_PP [PEROW],
input  [PSUMDWD-1:0] i_Psum_LPE [PEROW], 
input  PSconf i_psconf_LPE,
output [PSUMDWD-1:0] o_Psum_POUT[PEROW],
output PSconf o_psconf_POUT
);
    //===========
    //Parameter
    //===========
    
    localparam MAXTW = $clog2(64); 
    //===========
    //state
    //===========
    enum logic [3:0] { IDLE ,  WORK , STALL  } s_main , s_main_nxt ;     
    //===========
    //logic
    //===========
    logic  read_PP_valid ; 
    enum logic { FROMPP , FROMLPE  }last_src_r , last_src_w;
        assign read_PP_valid = s_main == WORK &&  !i_conf.ppctl_MAIN.read && !`rdyNack(SS) && !( last_src_r==FROMPP &&  LPE_rdy) && (!POUT_rdy || POUT_ack);
        assign last_src_w = ( read_PP_valid  )? FROMPP : ( `rdyNack(LPE) )? FROMLPE : last_src_r;
    LpCtl ps_idx_ctl;
        assign ps_idx_ctl = {s_main_nxt==IDLE,s_main==WORK,read_PP_valid};
    logic [MAXTW-1:0] ps_loopSize_r, ps_loopSize_w ;
    logic ps_end;
        assign ps_loopSize_w = (i_conf.dpstatus.firstPixEnd)? i_conf.ppad_size: ps_loopSize_r;
    logic [MAXTW-1:0] ps_loopIdx  ;
    logic [PSUMDWD-1:0] psum_w [PEROW] , psum_r [PEROW];
    PSconf psconf_w , psconf_r ;
    PSconf psconf_POUT_w ;
        assign psconf_w = (i_conf.dpstatus.firstPixEnd)? i_conf.psconf_MAIN : psconf_r;
        assign psconf_POUT_w = (read_PP_valid)? psconf_r : (`rdyNack(LPE))? i_psconf_LPE : o_psconf_POUT; 
    assign SS_ack = ( i_conf.ppctl_SS.waddr < (ps_loopIdx-1'b1));
    assign LPE_ack = !(last_src_r == FROMLPE &&  read_PP_valid && (!POUT_rdy || POUT_ack)); 
    logic POUT_rdy_w;
        assign POUT_rdy_w = read_PP_valid || `rdyNack(LPE) || ( POUT_rdy && ! POUT_ack);

            //TODO connection 
    //===========
    //comb
    //===========
    assign o_ppctl_PS.waddr = i_conf.ppctl_SS.waddr; 
    assign o_ppctl_PS.raddr = (read_PP_valid)? ps_loopIdx-1'b1 : i_conf.ppctl_MAIN.raddr;
    assign o_ppctl_PS.read  = read_PP_valid || i_conf.ppctl_MAIN.read; 
    assign o_ppctl_PS.write = i_conf.ppctl_SS.write && `rdyNack(SS); 
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
    
    always_comb begin
        `forstart(perow,PEROW)
            case ( {read_PP_valid,`rdyNack(LPE)} )
                2'b01: psum_w[perow] = i_Psum_LPE[perow];
                2'b10: psum_w[perow] = i_Psum_PP [perow];
                default: psum_w[perow] = psum_r[perow];
            endcase
        `forend
        case (s_main) 
            IDLE: begin
                s_main_nxt = ( i_conf.dpstatus.firstPixEnd ) ? WORK : IDLE;
            end 
            STALL:begin
                s_main_nxt = ( i_PEinst.reset )? IDLE : (!i_PEinst.stall)? WORK : STALL;
            end
            WORK: begin
                s_main_nxt = (i_PEinst.reset )? IDLE : (i_PEinst.stall)? STALL : (&ps_end && read_PP_valid && s_main==WORK)? IDLE : WORK; //TODO end condition
            end
            default: begin
            end   
        endcase 

    end 
    //===========
    //sequential
    //===========
 
    `ff_rstn
        `forstart(perow,PEROW) 
            psum_r[perow] <= '0; 
        `forend
        psconf_r <= '0;
        o_psconf_POUT <= '0;
        POUT_rdy <= 0;
    `ff_cg( !(SS_rdy && !SS_ack) || `rdyNack(LPE))
        `forstart(perow,PEROW)
            psum_r[perow] <= psum_w[perow]; 
        `forend
        psconf_r <= psconf_w;
        o_psconf_POUT <= psconf_POUT_w;
        POUT_rdy <= POUT_rdy_w;
    `ff_end
endmodule
