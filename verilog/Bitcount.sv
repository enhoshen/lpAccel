module Bitcount#(
parameter BW_O=4,
parameter BW_I=2**BW_O
)(
input [BW_I-1:0] i_in,
input [BW_O-1:0] o_out
);
logic [BW_I-1:0] _in;
logic [BW_O-1:0] _out;

// core //
ForCount F (._in(_in),._out(_out));


endmodule



module ForCount#(
parameter BW_O=4,
parameter BW_I=2**BW_O
)(
input [BW_I-1:0] _in,
input [BW_O-1:0] _out
);
integer i;
logic [BW_O-1:0] out;
always_comb begin
out = {BW_O{1'b0}};
	for(i=0 ; i<BW_I ; i=i+1)
		out=out+_in[i];
end

endmodule


module BCtest#(
parameter BW_O=4,
parameter BW_I=2**BW_O
);


    logic clk, rst;
    logic [7:0] in_mem  [0:31];
    logic [7:0] out_mem [0:31];
    logic [7:0] tempdata;
    logic [5:0] in_num, out_num;
    logic [5:0] inPtr, outPtr;
    
    logic       start, finish;
    logic  [5:0]     err;

    Bitcount B(i_in(i_in),o_out(o_out));
    `ifdef SDF
 //   initial $sdf_annotate(`SDFFILE, u_ppreg);
    `endif
    
    initial begin
    #0;
        clk      = 0;
        rst      = 1;
        tempdata = 0;
        err      = 0;
        in_num   = 0;
        out_num  = 0;
        inPtr    = 0;
        outPtr   = 0;
        start    = 0;
    end
    
    always begin #(`CYCLE/2) clk = ~clk; end
  /*  
    initial	begin
        $readmemh (`PAT, in_mem);
        $readmemh (`EXP, out_mem);
        #1 in_num  = in_mem[0];
        #1 out_num = out_mem[0];
    end
    
    initial begin
    $dumpfile("observe.vcd");
    $dumpvars;
    end
  */  
    initial begin
		#(`CYCLE/2) rst = 0;
		#`CYCLE     rst = 1;
        start = 1;
	end
   /*
    always_comb begin mport__data = tempdata; end
    always_comb begin finish = (inPtr == in_num) && (outPtr == out_num) && start; end 
    
    always@(posedge clk) begin 
        tempdata <= in_mem[inPtr+1];    
    end
    
    always@(negedge clk) begin
        if(mport__ack && inPtr < in_num && start == 1) begin
            inPtr <= inPtr + 1;
        end
    end
    
    always@(negedge clk) begin
        if(sport__ack && outPtr < out_num && start == 1) begin
            outPtr <= outPtr + 1;
        end
    end
    
    always@(negedge clk) begin
        if(sport__ack && sport__data != out_mem[outPtr+1]) begin
            err <= err + 1;
        end
    end
   */ 
    
    always@(posedge clk) begin
        if(finish) begin
            if (err == 0) begin
                $display("-----------------------------------------------------------\n");
                $display("Congratulations! All data have been generated successfully!\n");
                $display("-------------------------PASS------------------------------\n");
            end else begin
                $display("-----------------------------------------------------------\n");
                $display("            There are %d errors for result !\n", err);
                $display("-----------------------------------------------------------\n");
            end 
            $finish;
        end
    end    
    
    initial begin
        #(`CYCLE * `End_CYCLE);
        $display("---------------------WARRNING------------------------\n");
        $display("Simulation STOP! Maybe your circuit has some problem!\n");
        $display("Please check your ciruit again ...                   \n");
        $display("-----------------------------------------------------\n");
        $finish;
    end 
endmodule 