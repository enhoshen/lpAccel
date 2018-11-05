typedef struct packed{
    logic dval;
    logic inc;
    logic reset;
} LpCtl;
module LoopCounter #(
parameter NDepth = 3,
parameter MAXIdxDW = 10
)(
`clk_input,
input  [MAXIdxDW-1:0] i_loopSize [NDepth],
input  LpCtl i_ctl, 
output o_loopEnd [NDepth] 
);
    //=================
    //logic
    //=================
    logic [MAXIdxDW-1:0] loopIdx_w,loopIdx_r [NDepth];
    logic [NDepth-1:0] loopEnd ;

    genvar i;
    generate
        for ( i=1 ; i<NDepth ; ++i)begin 
            always_comb begin
                if(i_ctl.dval)
                    loopIdx_w[i] = (i_ctl.reset)? '0 : (&loopEnd[i:0] && 
                else
                    loopIdx_w[i] = loopIdx_r[i];   
            end        
        end
    endgenerate

    `ff_rstn
    `ff_cg(i_ctl.dval)
    `ff_end

endmodule
