import PECfg::DWD;
import PECfg::PEROW;
import PECtlCfg::*;

module Aunit(
`clk_input,
input AuCtl i_ctl,
input [DWD-1:0] i_Input [PEROW],
input [DWD-1:0] i_Weight [PEROW],
input [DWD-1:0] o_Sum [PEROW]
);
genvar pe_row;
generate
    for ( pe_row = 0 ; pe_row < PEROW ; ++pe_row) begin:Arithmetic_unit
        if (ATYPE==MUX)begin
            MATmux MA (
            .*,
            .i_ipix(i_Input[pe_row]),
            .i_wpix(i_Weight[pe_row]),
            .o_sum(o_Sum[pe_row])
            );
        end
        else if (ATYPE == SIMPLE)begin
            initial General::TODO;    
        end
        else if (ATYPE == BOOTH)begin
            initial General::TODO;
        end
        else begin
            initial ErrorAu; 
        end 
    end
endgenerate

endmodule
 
