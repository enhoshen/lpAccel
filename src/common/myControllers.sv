module overflow 
import COMM::NumT;#(
parameter DWd = 8,
parameter NumT Type = UNSIGNED 
)(
input [DWd-1:0] a,
input [DWd-1:0] b,
output 
);
localparam WIDTH = DWd;
localparam MSB   = WIDTH-1;
logic [WIDTH-1:0] a;
logic [WIDTH-1:0] b;
logic [WIDTH-1:0] result;
logic extra;
logic overflow;
logic underflow;



always @* begin
  {extra, result} = {a[MSB], a} + {b[MSB], b} ;
  overflow  = ({extra, result[MSB]} == 2’b01 );
  underflow = ({extra, result[MSB]} == 2’b10 );
end

endmodule 
