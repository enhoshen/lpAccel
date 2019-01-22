import PECfg::DWD;
import PECfg::PEROW;
import PECtlCfg::*;
typedef struct packed {
    logic [2*DWD-1:0] Psum_MS;
    logic [DWD-1:0]   Sum_MS ;
} SSdata;
module SumStage(
`clk_input,
input SSctl i_ctl,
`rdyack_input(MS),
`rdyack_output(SS),
input  SSdata i_data [PEROW],
output [2*DWD-1:0] Sum_SS [PEROW],
output PPctl o_ppctl_SS
);

    //===============
    //logic
    //===============


    `ff_rstn
    `ff_cg( `rdyNack(MS) || `rdyNack(SS))
    `ff_end
endmodule
