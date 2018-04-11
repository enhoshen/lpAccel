import PECfg::*;
module FetchStage(
);
endmodule

module MultStage(
);

    //=========================
    //module
    //=========================

            Aunit Au(
                `clk_connect,
                i_cont_mask (), 
                i_cont_mode (),
                i_cont_iNumT(),  // signed/unsigned numerical type
                i_cont_wNumT(),
                i_cont_reset(),
                i_cont_stall(),
                i_smode_ipix(),  // smode indicate sign/unsigned mode
                i_ipix(),
                `pbpix_connect(ipix , ),
                i_smode_wpix(),
                i_wpix(),
                `pbpix_connect(wpix,),
                o_sum(),
                `pbpix_connect(sum,)
            );

endmodule

module SumStage(
`clk_input,
input i_cont_reset,
input i_cont_stall,
input i_cont_first_pix,
input i_cont_read_psum,
input i_cont_forward,
input i_cont_

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
 

