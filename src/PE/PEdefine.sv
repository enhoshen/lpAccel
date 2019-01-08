package PECfg ;   
    //`define MULT8
    parameter PCONFDWD = 6; 
    parameter TILECONFDWD=10; 
    parameter DWD  = 16;     // data bit width , fixed
    parameter PSUMDWD  = 16;
    parameter INSTDWD  = 3;   // 
    parameter PECOL =16;
    parameter IPADSIZE =12;
    parameter WPADSIZE =48; 
    parameter PPADSIZE =64;
    parameter IPADADDRWD=$clog2(IPADSIZE)+1;
    parameter WPADADDRWD=$clog2(WPADSIZE)+1;
    parameter PPADADDRWD=$clog2(PPADSIZE)+1;
    typedef enum logic [2:0] { XNOR,M1,M2,M4,M8 } AuSel;
    typedef struct packed{
        logic [3:0]             Pch;  // channel number to b   
        logic [4:0]             Pm; // filters number to be 
        AuSel                   Au; // Aunit bit used
        logic [2:0]             Tb;// batch tile
        logic [2:0]             U ;// stride spatially
        logic [3:0]             R ;// filter width
        logic [3:0]             S ;// filter height
        logic [WPADADDRWD-1:0]    wpad_size; // pch*pm*R
        logic [IPADADDRWD-1:0]    ipad_size; // pch*R
        logic [PPADADDRWD-1:0]    ppad_size; // pm*Tw
        logic [IPADADDRWD-1:0]    Upix;// stride used, U*pch
        logic                   PixReuse;// R<U or fully connected
        logic [4:0]             Xb; // *b is the bit channel        
        logic [4:0]             Wb; 
        logic [4:0]             wb_idx;
        logic [6:0]             Tw; //feature map width tile, for
    } Conf ;
    typedef struct packed{
        logic start; 
        logic stall;
        logic reset;
        logic dval ;
    } Inst ; 
    typedef struct packed{
        logic lastPix;
        logic confEnd;
    } DFStatus;

endpackage
`timescale 1ns/1ps
package PECtlCfg;
    import PECfg::*;
    `define MULT8 
    `ifdef MULT8
    parameter AuMultSize=4; 
    //====================
    //Aunit
    //==================== 
    function automatic AuMask;
        input AuSel sel;
        case (sel)
            XNOR:AuMask={ {48{1'b0}} , {16{1'b1}} }; 
            M1  :AuMask={ {48{1'b0}} , {16{1'b1}} };
            M2  :AuMask={ {32{1'b0}} , {16{1'b1}} , {16{1'b0}} };
            M4  :AuMask={ {16{1'b0}} , {16{1'b1}} , {32{1'b0}} };
            M8  :AuMask={ {16{1'b1}} , {48{1'b0}} };
            default: AuMask=64'b0;
        endcase
    endfunction
    parameter AuODWd = 16;
    `else
    parameter AuMultSize=3;
    function automatic AuMask;
        input AuSel sel;
        case (sel)
            XNOR:AuMask={ {32{1'b0}} , {16{1'b1}} }; 
            M1  :AuMask={ {32{1'b0}} , {16{1'b1}} };
            M2  :AuMask={ {16{1'b0}} , {16{1'b1}} , {16{1'b0}} };
            M4  :AuMask={ {16{1'b1}} , {32{1'b0}} };
        endcase
    endfunction
    parameter AuODWd = 11;
    `endif
    parameter AuMaskWd = AuMultSize*DWD;
    typedef enum logic { SIGNED , UNSIGNED } NumT;
    typedef struct packed{
        AuSel mode;
        logic valid;
        logic reset;
        logic work;
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
    typedef struct packed{
        logic [PECfg::PPADADDRWD-1:0] raddr;
        logic [PECfg::PPADADDRWD-1:0] waddr;
        logic                          read;
        logic                         write; 
    } PPctl ;
    typedef struct packed{
        logic valid;
    } FSctl ;
    typedef struct packed{
        AuCtl auctl;
    } MSctl ;
    typedef enum logic [1:0] { SHT1,SHT2,SHT4,SHT8 } ShtNum;
    typedef struct packed{
        logic  valid;
        logic  init;    // 
        logic  fstpix;  // first pix, psum initialize to 0
        logic  lstpix;  // last pix , 
        logic  sht;     // shift 
        ShtNum sht_num ;
     } SSctl ;
endpackage

