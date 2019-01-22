import PECfg::DWD;
import PECfg::PEROW;
import PECtlCfg::*;
typedef struct packed{
    logic [DWD-1:0]  Input_FS;
    logic [DWD-1:0]  Weight_FS;
    logic [DWD-1:0]  Psum_FS;
    logic [DWD-1:0]  Psum_PP;
} MSdata;
typedef struct packed{
    logic [2*DWD-1:0] Psum_MS;
    logic [DWD-1:0]   Sum_MS;
} MSout;
module MultStage(
`clk_input,
input MSctl i_ctl,
`rdyack_input(FS),
`rdyack_output(MS),
input MSdata i_data [PEROW],
output MSout o_data [PEROW],
input  SSctl i_SSctl_FS,
output SSctl o_SSctl_MS
);

    //==================
    //logic
    //==================
    
    Forward FD(
    .*,
    `rdyack_connect(src,FS),
    `rdyack_connect(dst,MS)
    );

    genvar pe_row;

    generate 
        for (pe_row=0 ; pe_row<PEROW ; ++i) begin:Arithmetic
            
        end
    endgenerate

    `ff_rstn
        o_SSctl_MS <= '0;
        for ( int i=0 ; i<PEROW ; ++i)begin
            o_data[i] <= '0;
        end
    `ff_cg( `rdyNack(FS) || `rdyNack(MS) )
        o_SSctl_MS <= i_SSctl_FS;
        for ( int i=0 ; i<PEROW ; ++i)begin
            o_data[i] <= 
        end
    `ff_end
endmodule
