package PECfg ;   
    //`define MULT8
    parameter PConfDWd = 6; 
    parameter TileConfDWd=10; 
	parameter DWd  = 16;     // data bit width , fixed
	parameter PsumDWd  = 16;
    parameter InstDWd  = 3;   // 
    parameter PEcol =16;
    parameter IPadSize =12;
    parameter WPadSize =48; 
    parameter PPadSize =64;
    parameter IPadAddrWd=$clog2(IPadSize);
    parameter WPadAddrWd=$clog2(WPadSize);
    parameter PPadAddrWd=$clog2(PPadSize);
    typedef enum logic [2:0] { XNOR,M1,M2,M4,M8 } AuSel;
    typedef struct packed{
        logic [PConfDWd-1:0]    Pch;  // channel number to b   
        logic [PConfDWd-1:0]    Pm; // filters number to be 
        AuSel                   Au; // Aunit bit used
        logic [PConfDWd-1:0]    Tb;// batch tile
        logic [PConfDWd-1:0]    U ;// stride spatially
        logic [PConfDWd-1:0]    R ;// filter width
        logic [PConfDWd-1:0]    S ;// filter height
        logic [PConfDWd-1:0]    wpad_size; // pch*pm*R
        logic [PConfDWd-1:0]    ipad_size; // pch*R
        logic [PConfDWd-1:0]    Upix;// stride used, U*pch
        logic                   PixReuse;// R<U or fully connected
        logic [PConfDWd-1:0]    Xb; // *b is the bit channel        
        logic [PConfDWd-1:0]    Wb;
        logic [TileConfDWd-1:0] Tw;
    } Conf ;
    typedef struct packed{
        logic                    start; 
    } Inst ; 


endpackage

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
    parameter AuMaskWd = AuMultSize*DWd;
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
    typedef enum logic [3:0]{ IDLE  , INIT , LOOP , POP  , OLAP 
                        }  IPadState ;  // pix r/w address overlapping handling   
    typedef enum logic [InstDWd-1:0] {STALL,RESET,START,WORK} PEiss ;  
    typedef struct packed{
        logic [PECfg::IPadAddrWd-1:0] raddr;
        logic [PECfg::IPadAddrWd-1:0] waddr;
        logic                          read;
        logic                         write; 
    } IPadAddr ;
    typedef struct packed{
        logic [PECfg::WPadAddrWd-1:0] raddr;
        logic [PECfg::WPadAddrWd-1:0] waddr;
        logic                          read;
        logic                         write; 
    } WPadAddr ;
    typedef struct packed{
        logic [PECfg::PPadAddrWd-1:0] raddr;
        logic [PECfg::PPadAddrWd-1:0] waddr;
        logic                          read;
        logic                         write; 
    } PPadAddr ;
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

