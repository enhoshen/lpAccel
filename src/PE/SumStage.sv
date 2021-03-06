import PECfg::DWD;
import PECfg::PSUMDWD;
import PECfg::PEROW;
import PECtlCfg::*;
module SumStage(
`clk_input,
input MSpipe i_pipe,
`rdyack_input(MS),
`rdyack_output(SS),
input  MSout i_data [PEROW],
output logic [PSUMDWD-1:0] Sum_SS [PEROW],
output PPctl o_ppctl_SS
);

    localparam [31:0] MAX16 = 32'h0000_7fff;
    localparam [31:0] MIN16 = 32'h0000_8000;
    localparam [31:0] MAX32 = 32'h7fff_ffff;
    localparam [31:0] MIN32 = 32'h8000_0000;
    localparam SHTDWD = ASUMDWD+8;
    //===============
    //logic
    //===============
    SSctl i_ctl;
        assign i_ctl = i_pipe.ssctl;
    logic signed [PSUMDWD-1:0] Sum_SS_w [PEROW] , Sum_add [PEROW] , Operand [PEROW];
    logic signed [SHTDWD-1:0] Sum_sht[PEROW];
    logic Overflow [PEROW];
    logic Underflow[PEROW];
    logic Sum_sign [PEROW];
    //===============
    //comb
    //===============
    assign MS_ack = !(SS_rdy && !SS_ack);
    assign SS_rdy = o_ppctl_SS.write;
    always_comb begin
        for (int i=0 ; i<PEROW ; ++i)begin
            //TODO
            Operand [i] = (i_ctl.resetsum)? '0 : (i_ctl.psumread)? i_data[i].Psum_MS : Sum_SS[i]; 
            Sum_sht[i] = i_data[i].Sum_MS << i_ctl.sht_num;
            Sum_add[i] = (Operand[i] + Sum_sht[i]) ; //TODO critical path with shifter?
            // overflow
            Overflow [i] = (i_ctl.psum_mode==D16) ? ( !Operand[i][15] && !Sum_sht[i][15] && (|Sum_add[i][18:15]) ) : ( !Operand[i][31] && !Sum_sht[i][SHTDWD-1] && Sum_add[i][31] ) ;
            Underflow[i] = (i_ctl.psum_mode==D16) ? ( Operand[i][15] && Sum_sht[i][15] && ! ( &Sum_add[i][18:15]) ) : ( Operand[i][31] && Sum_sht[i][SHTDWD-1] && !Sum_add[i][31] ) ; 
            case ( {Overflow[i],Underflow[i]} )
                2'b01: Sum_SS_w[i] = (i_ctl.psum_mode==D16)? MIN16 : MIN32;
                2'b10: Sum_SS_w[i] = (i_ctl.psum_mode==D16)? MAX16 : MAX32;
                default: begin
                    Sum_SS_w[i][DWD-1:0] = Sum_add[i][DWD-1:0];
                    Sum_SS_w[i][PSUMDWD-1:DWD] = (i_ctl.psum_mode==D16)? '0 : Sum_add[i][PSUMDWD-1:DWD];
                end
            endcase
        end 
    end    
    //===============
    //sequential
    //===============
    `ff_rstn
        o_ppctl_SS <= '0;
        for ( int i=0 ; i<PEROW ; ++i)begin
            Sum_SS[i] <= '0;
        end
    `ff_cg(`rdyNack(MS) )
        o_ppctl_SS <= i_pipe.ssppctl;
        for ( int i=0 ; i<PEROW ; ++i)begin
            Sum_SS[i] <= Sum_SS_w[i] ;
        end
    `ff_end
endmodule
