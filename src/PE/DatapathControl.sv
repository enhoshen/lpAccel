module DataPathController
import PECfg::*;
import PECtlCfg::*;(
`clk_input,
input  PECfg::Conf     i_PEconf,
input  PECfg::Inst     i_PEinst,
output IPadAddr        o_IPctl,
output WPadAddr        o_WPctl,
output PPadAddr        o_PPctl,
output FSctl           o_FSctl,
output MSctl           o_MSctl,
output SSctl           o_SSctl,
output o_error,
`pbpix_input ( ipix ),
`pbpix_input ( wpix )

);
    //==================
    //param
    //==================


    //==================
    //state
    //==================
    enum logic [3:0] { IDLE , INIT , WORK , STALL , STOP  }s_main , s_main_nxt ;     


    //==================
    // logic
    //==================
    logic ce;
    logic [TileConfWd-1:0] width_idx_w, width_idx_r; // convolve width~width+S-1
    logic [PConfWd-1:0]    tch_idx_w  , tch_idx_r;
    logic [PConfWd-1:0]    pm_idx_w   , pm_idx_r;
    logic [PConfWd-1:0]    xb_idx_w   , xb_idx_r;
    logic [PConfWd-1:0]    s_idx_w    , s_idx_r;  
    AuSel        Au_mde_w   , Au_mde_r;
    
    logic [PConfWd-1:0] 
         //init  stage : prepare fetch stage's address
    logic [PConfWd-1:0] ins_ipRaddr_w , ins_ipRaddr_r; // 
    logic [PConfWd-1:0] ins_wpRaddr_w , ins_wpRaddr_r;
    logic [PConfWd-1:0] ins_forward_w , forward_r;
         //fetch Stage : prepare psum address, output input/weight data
   
    logic [PConfWd-1:0] fs_psRaddr_w , fs_psRaddr_r; 
    logic [PConfWd-1:0] fs_in_idx_w   , fs_in_idx_r;
    logic [PConfWd-1:0] fs_w_idx_w    , fs_w_idx_r ;
    logic               fs_forward_w  , fs_forward_r;     
        //Mult Stage
    PsumInit  ms_SwapPix_w  , ms_SwapPix_r; // read next psum pix/reset from 0 / read and shift
    NumT      ms_MultNumT_w , ms_MultNumT_r; // 
    logic [PConfWd-1:0] ms_SwapPix_w  , ms_SwapPix_r;
    logic [PConfWd-1:0] ms_psum_idx_w , ms_psum_idx_r;
    logic               ms_forward_w  , ms_forward_r;
        //Sum Stage
    logic [PConfWd-1:0] ss_SwapPix_w  , ss_SwapPix_r;
    logic [PConfWd-1:0] ss_psum_idx_w , ss_psum_idx_r;
    logic               ss_forward_w  , ss_forward_r ;
    
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
    width_idx_w  =width_idx_r;   
    tch_idx_w    =tch_idx_r;
    pm_idx_w     =pm_idx_r;
    xb_idx_w     =xb_idx_r;
    s_idx_w      =s_idx_r;  
                               
                                
    fs_psum_idx_w=fs_psum_idx_r; 
    fs_in_idx_w  =fs_in_idx_r;   
    fs_w_idx_w   =fs_w_idx_r ;   
                                
    ms_SwapPix_w =ms_SwapPix_r;  
    ms_MultNumT_w=ms_MultNumT_r; 
    ms_SwapPix_w =ms_SwapPix_r;  
    ms_psum_idx_w=ms_psum_idx_r; 
                                
    ss_SwapPix_w =ss_SwapPix_r;  
    ss_psum_idx_w=ss_psum_idx_r; 

    case (s_main) begin
        IDLE: begin
        end 
        INIT: begin 
            width_idx_w = 0;
            tch_idx_w   = 0;
            pm_idx_w    = 0;
            xb_idx_w    = 0;
            s_idx_w     = 0;
        end
        WORK: begin 
        end
        STALL:begin 
        end
        STOP: begin 
        end
        default: begin
        end   
    endcase 


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
