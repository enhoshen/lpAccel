import PECfg::DWD;
import PECfg::PSUMDWD;
import PECfg::PEROW;
import PECtlCfg::*;
typedef struct packed{
    FSout fsout_FS ;
} MSin;
typedef struct packed{
    logic [PSUMDWD-1:0] Psum_MS;
    logic [DWD-1:0]   Sum_MS;
} MSout;
module MultStage(
`clk_input,
input MSctl i_ctl,
`rdyack_input(FS),
`rdyack_output(MS),
input  MSin   i_data [PEROW],
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
    Forward FD(
    .*,
    `rdyack_connect(src,FS),
    `rdyack_connect(dst,MS)
    );

    genvar pe_row;

    generate 
        for (pe_row=0 ; pe_row<PEROW ; ++i) begin:Arithmetic
            Aunit
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
            o_data[i] <= {{i_data.Psum_PP[i],i_data.Psum_MS[i]}, };
        end
    `ff_end
endmodule
