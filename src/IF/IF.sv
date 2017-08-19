interface ra_if;
	logic rdy;
	logic ack;

	modport in (
	    output ack , 
		input  rdy
	modport out(
	    input ack,
		output rdy
	);
	
endinterface