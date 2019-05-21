import PECfg::*;

module PathStage(
`clk_input,
`rdyack_input(PS),
`rdyack_input(PP),
`rdyack_input(Psum_in),
`rdyack_output(Psum_out),
input  [PSUMDWD-1:0] i_Psum_
input 
output [PSUMDWD-1:0] o
);

`ff_rstn

`ff_cg()
`ff_end
endmodule
