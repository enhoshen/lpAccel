import PECfg::DWD;
import PECfg::PSUMDWD;
import PECfg::PEROW;
import PECtlCfg::*;
module SumStage(
`clk_input,
input SSctl i_ctl,
`rdyack_input(MS),
`rdyack_output(SS),
input  MSout i_data [PEROW],
output [PSUMDWD-1:0] Sum_SS [PEROW],
output PPctl o_ppctl_SS
);

    //===============
    //logic
    //===============
    logic [PSUMDWD-1:0] Sum_SS_w [PEROW];
    //===============
    //comb
    //===============
    `forward ( FD, MS, SS)

    always_comb begin
        
    end    
    //===============
    //sequential
    //===============
    `ff_rstn
        o_ppctl_SS <= '0;
        for ( int i=0 ; i<PEROW ; ++i)begin
            Sum_SS[i] <= '0;
        end
    `ff_cg( `rdyNack(MS) || `rdyNack(SS))
        //TODO o_ppctl_SS <= ;
        for ( int i=0 ; i<PEROW ; ++i)begin
            Sum_SS[i] <= Sum_SS_w[i] ;
        end
    `ff_end
endmodule
