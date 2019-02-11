package PECfg ;   
    //`define MULT8
    parameter PCONFDWD = 6; 
    parameter TILECONFDWD=10; 
    parameter DWD  = 16;     // data bit width , fixed
    parameter PSUMDWD  = 32;
    parameter INSTDWD  = 3;   // 
    parameter PECOL =16;
    parameter PEROW =16;
    parameter IPADSIZE =12;
    parameter IPADN    = 1;
    parameter WPADSIZE =48; 
    parameter PPADSIZE =64;
    parameter IPADADDRWD=$clog2(IPADSIZE);
    parameter WPADADDRWD=$clog2(WPADSIZE);
    parameter PPADADDRWD=$clog2(PPADSIZE);
    typedef enum logic { SIGNED , UNSIGNED } NumT;
    typedef enum logic [2:0] { XNOR,M1,M2,M4,M8 } AuSel;
    import RFCfg::DWD_mode;
    typedef struct packed{
        logic [3:0]             Pch;  // channel number to b   
        logic [4:0]             Pm; // filters number to be 
        AuSel                   Au; // Aunit mode
        logic [2:0]             Tb;// batch tile
        logic [2:0]             U ;// stride spatially
        logic [3:0]             R ;// filter width
        logic [3:0]             S ;// filter height
        logic [WPADADDRWD:0]    wpad_size; // pch*pm*R
        logic [IPADADDRWD:0]    ipad_size; // pch*R
        logic [PPADADDRWD:0]    ppad_size; // pm*Tw
        logic [IPADADDRWD:0]    Upix;// stride used, U*pch
        logic                   PixReuse;// R<U or fully connected
        logic [4:0]             Xb; // *b is the bit channel        
        logic [4:0]             Wb; 
        NumT                    XNumT; // signed or unsigned
        NumT                    WNumT;
        logic [4:0]             wb_idx;
        DWD_mode                Psum_mode;
        logic [6:0]             Tw; //feature map width tile, for
    } Conf ;
    typedef struct packed{
        logic start; 
        logic stall;
        logic reset;
        logic dval ;
    } Inst ; 

endpackage
`timescale 1ns/1ps
package PECtlCfg;
    import PECfg::*;
    //====================
    //Aunit
    //==================== 
    typedef enum { MUX , BOOTH , SIMPLE }AUNITTYPE;
    parameter AUNITTYPE ATYPE = MUX;
        parameter MSK = 1;
        parameter AUMULTSIZE=4; 
        parameter AUMASKWD = AUMULTSIZE*DWD;
    task ErrorAu;
        begin
            $display("Aunit Configuration error");
            $finish();
        end
    endtask
    typedef struct packed{
        logic lastPix;
        logic confEnd;
    } DPstatus;

    typedef struct packed{
        AuSel mode;
        logic [AUMASKWD-1:0] AuMask;
        logic iNumT;
        logic wNumT;       
    } AuCtl;
    //=================
    //Datapath
    //=================
    typedef enum logic [1:0]{ FSTPIX , FROMBUF , FROMBUFSHT } PsumInit;
    typedef struct packed{
        logic [PECfg::IPADADDRWD-1:0] raddr;
        logic [PECfg::IPADADDRWD-1:0] waddr;
        logic                          read;
        logic                         write; 
    } IPctl;
    typedef struct packed{
        logic [PECfg::WPADADDRWD-1:0] raddr;
        logic [PECfg::WPADADDRWD-1:0] waddr;
        logic                          read;
        logic                         write; 
    } WPctl ;
    import RFCfg::DWD_mode;
    typedef struct packed{
        DWD_mode                       mode;
        logic [PECfg::PPADADDRWD-1:0] raddr;
        logic [PECfg::PPADADDRWD-1:0] waddr;
        logic                          read;
        logic                         write; 
    } PPctl ;
    typedef struct packed{
        DWD_mode mode;
        logic psum_parity;
    } FSctl ;
    typedef struct packed{
        AuCtl auctl;
    } MSctl ;
        typedef struct packed{
            AuSel mode;
            logic iNumT;
            logic wNumT;
        }MSconf; // Compute the mask at Fetch stage to save up registers
    typedef struct packed{
        DWD_mode psum_mode;
        logic  fstrow;  // first pix, psum initialize to 0
        logic  lstrow;  // last pix , 
        logic  [3:0] sht_num ;
    } SSctl ;
endpackage

