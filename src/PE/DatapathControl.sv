import PECfg::*;
import PECtlCfg::*;

module DataPathController(
`clk_input,
input  PECfg::Conf i_PEconf,
output PECtlCfg::IPadAddr o_IPctl,
output PECtlCfg::WPadAddr o_WPctl,
output PECtlCfg::PPadAddr o_PPctl,

output                    o_FS_valid,

output                    o_MS_valid,
output                    o_MS_xNumT,
output                    o_MS_wNumT,

output                    o_SS_valid,
output                    o_SS_init,
output                    o_SS_fstpix,
output                    o_SS_lstpix,    
output                    o_SS_sht,


`pbpix_input ( ipix ),
`pbpix_input ( wpix )

);
    //==================
    //param
    //==================
    localparam TileConfWd = PECfg::TileConfDWd;
    localparam PConfWd    = PECfg::PConfDWd;
    //==================
    // logic
    //==================
    logic ce;
    logic [TileConfWd-1:0] width_idx_w, width_idx_r; // convolve width~width+S-1
    logic [PConfWd-1:0] tch_idx_w  , tch_idx_r;
    logic [PConfWd-1:0] pm_idx_w   , pm_idx_r;
    logic [PConfWd-1:0] xb_idx_w   , xb_idx_r;
    logic [PConfWd-1:0] s_idx_w    , s_idx_r;  
    PECfg::AuSel        Au_mde_w   , Au_mde_r;
         //fetch Stage
   
    logic [PConfWd-1:0] fs_psum_idx_w , fs_psum_idx_r; 
    logic [PConfWd-1:0] fs_in_idx_w   , fs_in_idx_r;
    logic [PConfWd-1:0] fs_w_idx_w    , fs_w_idx_r ;
         //Mult Stage
    PECfg::PsumInit     ms_SwapPix_w  , ms_SwapPix_r; // read next psum pix/reset from 0 / read and shift
    PECfg::NumT         ms_MultNumT_w , ms_MultNumT_r; // 
    logic [PConfWd-1:0] ms_SwapPix_w  , ms_SwapPix_r;
    logic [PConfWd-1:0] ms_psum_idx_w , ms_psum_idx_r;
        //Sum Stage
    logic [PConfWd-1:0] ss_SwapPix_w  , ss_SwapPix_r;
    logic [PConfWd-1:0] ss_psum_idx_w , ss_psum_idx_r;
    
        //Input
    //wtf is this section
    //logic [TileWd-1:0]  inTw_idx_w   , inTw_idx_r;
    //logic [PConfWd-1:0] inTch_idx_w  , inTch_idx_r;
    //logic [PConfWd-1:0] inPm_idx_w   , inPm_idx_r;
    //

    //==================
    // control
    //==================

    //==================
    // comb
    //==================
        




always_comb begin
    

end


   //==================
   //sequential
   //==================
`ff_rstn
`ff_cg(ce)
`ff_end

`ff_rstn
`ff_nocg
`ff_end

endmodule
