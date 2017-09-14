import ISA1::*;
interface ra_if;
	logic rdy;
	logic ack;

	modport in (
	    output ack , 
		input  rdy
	);
	modport out(
	    input ack,
		output rdy
	);
	
endinterface 

interface sim_Dif #( 
    parameter DWd = 16
);
    logic [DWd -1:0]  data;
    logic ready;
	logic valid;
    modport in ( 
	    input data, 
	    output ready,
		input valid
	);
    modport out( 
        output data, 
        input ready,
        output valid
    );
endinterface

interface sim_Iif ;
    ISA1::INST inst;
    logic ready;
    logic valid;
	    modport in ( 
	    input inst, 
	    output ready,
		input valid
	);
    modport out( 
        output inst, 
        input ready,
        output valid
    );
endinterface
/*
interface rf_sp_mem_if #( //register file memory interface
    parameter DWd = 64, //word width
    parameter WWd = 32, //word number
    parameter AWd = 5 , //address width
);
    logic [AWd-1:0] A,
	logic [DWd-1:0] D,
    modport mas (  // master 
        output A,
	    output D,
        output 		
	);
endinterface
*/