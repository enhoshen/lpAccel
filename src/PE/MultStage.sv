import PECfg::DWD;
import PECfg::PSUMDWD;
import PECfg::PEROW;
import PECtlCfg::*;
typedef struct packed{
    logic [PSUMDWD-1:0] Psum_MS;
    logic [DWD-1:0]   Sum_MS;
} MSout;
module MultStage(
`clk_input,
input  MSctl i_ctl,
`rdyack_input(FS),
`rdyack_output(MS),
input  FSout i_data [PEROW],
output MSout o_data [PEROW],
input  SSctl i_MSpipe_FS,
output SSctl o_MSpipe_MS
);

    //==================
    //logic
    //==================
    logic [DWD-1:0] Sum [PEROW];
    
    //==================
    //comb
    //==================
    `forward ( FD, FS, MS)
    
    Aunit Arithmetic_unit (
    .*,
    .i_ctl(i_ctl.auctl),
    .i_Input(i_data.Input_FS),
    .i_Weight(i_data.Weight_FS),
    .o_Sum(o_data.Sum_MS)     
    );

    `ff_rstn
        o_MSpipe_MS <= '0;
        for ( int i=0 ; i<PEROW ; ++i)begin
            o_data.Psum_MS[i] <= '0;
        end
    `ff_cg( `rdyNack(FS) || `rdyNack(MS) )
        o_MSpipe_MS <= i_MSpipe_FS;
        for ( int i=0 ; i<PEROW ; ++i)begin
            o_data.Psum_MS[i] <= i_data.Psum_PP[i] ;
        end
    `ff_end
endmodule
