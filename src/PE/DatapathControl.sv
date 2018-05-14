import PECfg::*;
import CTLCfg::*;

module DataPathController(
`clk_input,
/*
input [PECfg::PConfDWd-1:0]    i_conf_Pch,  // channel number to be handled
input [PECfg::PConfDWd-1:0]    i_conf_Pm, // filters number to be handled
input [PECfg::PConfDWd-1:0]    i_conf_Ab, // Aunit bit used
input [PECfg::PConfDWd-1:0]    i_conf_Tb, // batch tile
input [PECfg::PConfDWd-1:0]    i_conf_U , // stride
input [PECfg::PConfDWd-1:0]    i_conf_R , // filter width
input [PECfg::PConfDWd-1:0]    i_conf_S , // filter height
input [PECfg::PConfDWd-1:0]    i_conf_wpad_size, // pch*pm*R
input [PECfg::PConfDWd-1:0]    i_conf_ipad_size, // pch*R
input [PECfg::PConfDWd-1:0]    i_conf_Xb, // *b is the bit channel num = tensor precision/Aunit bit
input [PECfg::PConfDWd-1:0]    i_conf_Wb,
input [PECfg::TileConfDWd-1:0] i_conf_Tw,
input                          i_conf_XNOR, // xnor multiply mode

input PECfg::PEiss    i_inst_pe,
input [PECfg::PConfDWd-1:0]    i_cont_wb,
input [PECfg::PConfDWd-1:0]    i_cont_b, 
*/
input  CTLCfg::Conf i_PEconf,
output [PECfg::IPadAddrWd-1:0] o_IPad_raddr,
output [PECfg::WPadAddrWd-1:0] o_WPad_raddr,
output [PECfg::PPadAddrWd-1:0] o_PPad_raddr,
output [PECfg::IPadAddrWd-1:0] o_IPad_waddr,
output [PECfg::WPadAddrWd-1:0] o_WPad_waddr,
output [PECfg::PPadAddrWd-1:0] o_PPad_waddr,
output                         o_IPad_read,
output                         o_WPad_read,
output                         o_PPad_read,
output                         o_IPad_write,
output                         o_WPad_write,
output                         o_PPad_write,

output                         o_forward,

output                         o_FetchStage_valid,

output                         o_MultStage_valid,

output                         o_SumStage_fstpix,
output                         o_SumStage_sht,
output                         o_SumStage_valid,


`pbpix_input ( ipix ),
`pbpix_input ( wpix )

);
    //==================
    //param
    //==================
    localparam TileConfWd = PECfg::TileConfDWd;
    localparam PconfWd    = PECfg::PConfDWd;
    //==================
    // logic
    //==================
    logic ce;
    logic [TileConfWd-1:0] width_idx_w, width_idx_r; // convolve width~width+S-1
    logic [PconfWd-1:0] tch_idx_w  , tch_idx_r;
    logic [PconfWd-1:0] pm_idx_w   , pm_idx_r;
    logic [PconfWd-1:0] xb_idx_w   , xb_idx_r;
    logic [PconfWd-1:0] s_idx_w    , s_idx_r;  
    PECfg::AuSel        Au_mde_w   , Au_mde_r;
         //fetch Stage
    PECfg::PsumInit fs_SwapPix_w  , fs_SwapPix_r; // read next psum pix/reset from 0 / read and shift
    PECfg::NumT     fs_MultNumT_w , fs_MultNumT_r; // 
    
    logic [PconfWd-1:0] fs_psum_idx_w , fs_psum_idx_r; 
        //Mult Stage
    logic [PconfWd-1:0] ms_SwapPix_w  , ms_SwapPix_r;
    logic [PconfWd-1:0] ms_psum_idx_w , ms_psum_idx_r;
        //Sum Stage
    logic [PconfWd-1:0] ss_SwapPix_w  , ss_SwapPix_r;
    logic [PconfWd-1:0] ss_psum_idx_w , ss_psum_idx_r;
    
        //Input
    //wtf is this section
    //logic [TileWd-1:0]  inTw_idx_w   , inTw_idx_r;
    //logic [PconfWd-1:0] inTch_idx_w  , inTch_idx_r;
    //logic [PconfWd-1:0] inPm_idx_w   , inPm_idx_r;
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
