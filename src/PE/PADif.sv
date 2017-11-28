interface IPcont_if#(              // to and from PE ,
    parameter ConfDWd = 4,
    parameter PConfDWd = 3
);
    logic [ConfDWd-1:0]  IFLen;   // RxPch  
    logic [ConfDWd-1:0]  PopU;    // (U-1)Pch+1 
    logic [PConfDWd-1:0] Pch;    // channel tile Pch

    logic pop ;                 // WPAD tell PE end of Tm, PE tell IPAD to pop
    logic nxtRow;               // PE keeps track of Tw, swap IF rows
    
    logic stall;
    logic start;
    logic reset;
    logic done;

    modport ipad(
        input IFLen,
        input PopU,
        input Pch,
        input pop,
        input nxtRow,
        input stall,
        input start,
        input reset,
        input done
    );
    modport pe(
        output IFLen,
        output PopU,
        output Pch,
        output pop,
        output nxtRow,
        output stall,
        output start,
        output reset,
        output done
    );    

endinterface 

//TODO
interface WPcont_if ;

    logic nxtWRow;
    modport wpad(
        input nxtWRow
    );
    modport pe(
        output nxtWRow
    );
endinterface 

interface IPflag_if ;
    logic zero  ;  // next pixel is zero, posedge

    modport ipad(
        output zero
    );

    modport wpad(
        input zero
    );

endinterface

interface PBpix_if #(  // input pad,buffer pixel interface
    parameter DWd = 16
);
    logic [DWd-1 :0 ] wdata;
    logic ready;
    logic valid; 
    logic zero ;

    modport pad(   
        input wdata,
        output ready,
        input valid,
        input zero
    );
    modport buff(
        output wdata,
        input ready,
        output valid,
        output zero
    );
endinterface


interface Pout_if #(  //  pad out pixel interface
    parameter DWd = 16
);
    logic [DWd-1:0] data;
    logic ready;
    logic valid;
    logic zero;

    modport  pad(
        output data,
        output valid,
        input ready,
        output zero
    );
    
    modport au(
        input data,
        input valid,
        output ready,
        input zero
    );

endinterface

