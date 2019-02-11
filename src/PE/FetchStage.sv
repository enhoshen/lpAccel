import PECfg::DWD;
import PECfg::PSUMDWD;
import PECfg::PEROW;
import PECtlCfg::*;
typedef struct packed{
    MSctl msctl;
    SSctl ssctl;
} FSpipe;
typedef struct packed{
    logic [DWD-1:0]  Input_IP ;
    logic [DWD-1:0]  Weight_WP;
    logic [PSUMDWD-1:0]  Psum_PP  ;
} FSin;
typedef struct packed{
    logic [DWD-1:0]  Input_FS ;
    logic [DWD-1:0]  Weight_FS;
    logic [PSUMDWD-1:0]  Psum_FS  ;
} FSout;
module FetchStage(
`clk_input,
input  FSctl i_ctl,
`rdyack_input(MAIN),
`rdyack_output(FS),
input  FSin   i_data[PEROW],
output FSout  o_data[PEROW],
input  FSpipe i_FSpipe_MAIN,
output FSpipe o_FSpipe_FS
);

    //===============
    //logic
    //===============

    `forward ( FD,MAIN,FS)
    `ff_rstn
        o_FSpipe_FS <= '0;
        for ( int i =0 ; i<PEROW ; ++i)begin
            o_data[i] <= '0;
        end
    `ff_cg( `rdyNack(MAIN) || `rdyNack(FS) )
        o_FSpipe_FS.ssctl <= i_FSpipe_MAIN.ssctl;
        for ( int i =0 ; i<PEROW ; ++i)begin
            o_data[i] <= {i_data[i].Input_IP,i_data[i].Weight_WP,i_data[i].Psum_PP};
        end 
    `ff_end

endmodule
