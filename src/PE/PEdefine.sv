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
    `ifdef MULT8
    parameter AuMultSize=4 
    typedef enum logic [2:0] { XNOR,M1,M2,M4,M8 } AuSel; 
    function AuMask;
        input Ausel sel;
        case (sel)
            XNOR:AuMask={48{1'b0},16{1'b1}}; 
            M1  :AuMask={48{1'b0},16{1'b1}};
            M2  :AuMask={32{1'b0},16{1'b1},16{1'b0}};
            M4  :AuMask={16{1'b0},16{1'b1},32{1'b0}};
            M8  :AuMask={16{1'b1},48{1'b0}};
            default:64'b0;
        endcase
    endfunction
    parameter AuODWd = 16;
    `else
    parameter AuMultSize=3;
    typedef enum logic [1:0] { XNOR,M1,M2,M4 } AuSel;
    function AuMask;
        input Ausel sel;
        case (sel)
            XNOR:AuMask={32{1'b0},16{1'b1}}; 
            M1  :AuMask={32{1'b0},16{1'b1}};
            M2  :AuMask={16{1'b0},16{1'b1},16{1'b0}};
            M4  :AuMask={16{1'b1},32{1'b0}};
        endcase
    endfunction
    parameter AuODWd = 11;
    `endif
    parameter AuMaskWd = AuMultSize*DWd;
    typedef enum logic { SIGNED , UNSIGNED } NumT;
    typedef enum logic { FSTPIX , FROMBUF } PsumInit;
    typedef enum logic [3:0]{ IDLE  , INIT , LOOP , POP  , OLAP 
                        }  IPadState ;  // pix r/w address overlapping handling   
    typedef enum logic [InstDWd-1:0] {STALL,RESET,START,WORK} PEiss ;  
endpackage

