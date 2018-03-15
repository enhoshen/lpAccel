
package PECfg ;   
    parameter PConfDWd = 6; 
    parameter TileConfDWd=10; 
	parameter DWd  = 16;     // data bit width 
	parameter PsumDWd  = 16;
    parameter InstDWd  = 3;   // 
    parameter PEcol =16;
    parameter IPadSize =12;
    parameter WPadSize =48; 
    parameter PPadSize =64;
    parameter AuODWd = 11;
    typedef enum logic [1:0] { XNOR,M1,M2,M4 } AuSel;
    typedef enum logic { SIGNED , UNSIGNED } NumT;
    typedef enum logic { FSTPIX , FROMBUF } PsumInit;
    typedef enum logic [3:0]{ IDLE  , INIT , LOOP , POP  , OLAP 
                        }  IPadState ;  // pix r/w address overlapping handling   
    typedef enum logic [InstDWd-1:0] {STALL,RESET,START,WORK} PEiss ;  
endpackage

