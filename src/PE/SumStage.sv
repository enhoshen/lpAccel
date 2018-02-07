import PECfg::*;

module SumStage(
`clk_input,
input i_cont_reset,
input i_cont_stall,
input i_cont_first_pix,
input i_cont_read_psum,
input i_cont_forward,

input signed[PECfg::AuODWd-1:0] i_sum,
`pbpix_input (sum),
input signed [PECfg::DWd-1:0]i_psum,
output signed[PECfg::DWd-1:0]o_psum,
`pbpix_input (psum),
);
    //==========================
    //parameters
    //==========================
    localparam DWd = PECfg::DWd;
    //==========================
    //logics
    //==========================
    
    logic [PECfg::DWd-1:0] psum_w , psum_r
        assign o_psum = 
    wire ce ;
        assign ce = i_cont_stall && sum_zero;

    `ff_srstn()
        psum_r <= 
    `ff_cg( ce )
        psum_r <= psum_w;
    `ff_end
endmodule
