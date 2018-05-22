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
input i_ctl_reset,
input i_ctl_stall,
input i_ctl_valid,
input i_ctl_init,  // init 0 psum, rather than from psum pad
input i_ctl_fstpix,// first pix, receive data from psum pad/ init 0 psum
input i_ctl_lstpix,  // write out to psum pad
input i_ctl_sht,

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
 

