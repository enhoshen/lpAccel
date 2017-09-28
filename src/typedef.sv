package ISA1; //instruction definitions
    parameter InstDWd = 3 ;  
    typedef enum logic [InstDWd-1:0] { NONE  = 0,
                                      RESET = 1,
                                      STALL = 2,   
                                      NXTXB = 3,  //next Xb row
				      NXTFR = 4,  //next filter row
                                      NXTTC = 5   //next set of channels
									            } INST;

endpackage


package PSTATE; // pad states
    parameter PStWd = 3;    
	typedef enum logic [PStWd-1:0]{ IDLE =0,INIT =1,WORK =2,POPP =3   //pop a pixel
                                       } s_pad;
endpackage 
