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
output logic [PSUMDWD-1:0] o_Psum_POUT[PEROW],
output PSconf o_psconf_POUT
);
    //===========
    //Parameter
    //===========
    
    localparam MAXTW = $clog2(64); 
    //===========
    //state
    //===========
    enum logic [3:0] { IDLE , INIT ,  WORK , STALL  } s_main , s_main_nxt ;     
    //===========
    //logic
    //===========
    LpCtl ps_idx_ctl;
    logic [MAXTW-1:0] ps_loopSize_r, ps_loopSize_w ;
    logic ps_end;
    logic [MAXTW-1:0] ps_loopIdx  ;

    logic  read_PP_valid , read_PP_valid_r; 
    enum logic { FROMPP , FROMLPE  }last_src_r , last_src_w;
    enum logic { SSB4PS , PSB4SS } address_priority_w , address_priority_r; // before means address is larger and can't be outrun
        assign read_PP_valid = s_main == WORK && !(&ps_end) && !i_conf.ppctl_MAIN.read  && !( last_src_r==FROMPP &&  LPE_rdy) && !(address_priority_r==SSB4PS && i_conf.ppctl_SS.waddr <= (ps_loopIdx) )  && (!POUT_rdy || POUT_ack) ; 

        assign last_src_w = ( read_PP_valid_r  )? FROMPP : ( `rdyNack(LPE) )? FROMLPE : last_src_r;
        assign ps_idx_ctl = '{reset:s_main_nxt==IDLE,dval:s_main==WORK,inc:read_PP_valid};
        assign ps_loopSize_w = (i_conf.dpstatus.firstPixEnd)? i_conf.ppad_size: ps_loopSize_r;
    logic [PSUMDWD-1:0] psum_w [PEROW] ;
    PSconf psconf_w , psconf_r ;
    PSconf psconf_POUT_w ;
        assign psconf_w = (i_conf.dpstatus.firstPixEnd)? i_conf.psconf_MAIN : psconf_r;
        assign psconf_POUT_w = (read_PP_valid_r)? psconf_r : (`rdyNack(LPE))? i_psconf_LPE : o_psconf_POUT; 
    assign SS_ack = !( s_main==WORK && address_priority_r == PSB4SS && i_conf.ppctl_SS.waddr >= (ps_loopIdx)); //TODO PS surpass SS writing..
    assign LPE_ack = !(last_src_r == FROMLPE &&  read_PP_valid_r && (!POUT_rdy || POUT_ack)); 
    logic POUT_rdy_w;
        assign POUT_rdy_w = read_PP_valid_r || `rdyNack(LPE) || ( POUT_rdy && ! POUT_ack);

            //TODO connection 
    //===========
    //comb
    //===========
    assign o_ppctl_PS.psum_mode = (read_PP_valid)? psconf_r.psum_mode : i_conf.ppctl_MAIN.psum_mode; 
    assign o_ppctl_PS.waddr = i_conf.ppctl_SS.waddr; 
    assign o_ppctl_PS.raddr = (read_PP_valid)? ps_loopIdx: i_conf.ppctl_MAIN.raddr;
    assign o_ppctl_PS.read  = read_PP_valid || i_conf.ppctl_MAIN.read; 
    assign o_ppctl_PS.write = i_conf.ppctl_SS.write && `rdyNack(SS); 
    LoopCounterD1 #(
    .IDXDW(MAXTW), .STARTPOINT(1'b0)
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
            psum_w[perow] = o_Psum_POUT[perow];
            case ( {read_PP_valid_r,`rdyNack(LPE)} )
                2'b01: psum_w[perow] = i_Psum_LPE[perow];
                2'b10: psum_w[perow] = i_Psum_PP [perow];
                default: psum_w[perow] = o_Psum_POUT[perow];
            endcase
        `forend
        case (s_main) 
            IDLE: begin
                s_main_nxt = ( i_conf.dpstatus.firstPixEnd ) ? INIT: IDLE;
            end 
            INIT: begin
                s_main_nxt = ( i_conf.ppctl_SS.waddr =='0 && i_conf.ppctl_SS.write )? WORK : INIT; 
            end
            STALL:begin
                s_main_nxt = ( i_PEinst.reset )? IDLE : (!i_PEinst.stall)? WORK : STALL;
            end
            WORK: begin
                s_main_nxt = (i_PEinst.reset )? IDLE : (i_PEinst.stall)? STALL : (&ps_end && s_main==WORK)? IDLE : WORK; //TODO end condition
            end
            default:begin
                s_main_nxt = IDLE;
            end
        endcase 
        if ( s_main == IDLE )
            address_priority_w = SSB4PS;
        else if( s_main == WORK && i_conf.ppctl_SS.waddr == '0)
            address_priority_w = PSB4SS;
        else 
            address_priority_w = address_priority_r;
    end 
    //===========
    //sequential
    //===========
 
    `ff_rstn
        `forstart(perow,PEROW) 
            o_Psum_POUT[perow] <= '0; 
        `forend
        o_psconf_POUT <= '0;
        last_src_r <= FROMLPE;
    `ff_cg( read_PP_valid_r || `rdyNack(LPE))
        `forstart(perow,PEROW)
            o_Psum_POUT[perow] <= psum_w[perow]; 
        `forend
        o_psconf_POUT <= psconf_POUT_w;
        last_src_r <= last_src_w;
    `ff_end

    `ff_rstn
        s_main <= IDLE;
        read_PP_valid_r <= 0;
        ps_loopSize_r <= 1;
        address_priority_r <= SSB4PS;
        POUT_rdy <= 0;
        psconf_r <= '0;
    `ff_nocg
        s_main <= s_main_nxt;
        read_PP_valid_r <= read_PP_valid;
        ps_loopSize_r <= ps_loopSize_w;
        address_priority_r <= address_priority_w;
        POUT_rdy <= POUT_rdy_w;
        psconf_r <= psconf_w;
    `ff_end
endmodule
