typedef struct packed{
    logic dval;
    logic inc;
    logic reset;
} LpCtl;
module LoopCounter #(
parameter NDEPTH = 3,
parameter int IDXDW [NDEPTH]= '{3,5,3},
parameter IDXMAXDW = 11,
parameter STARTPOINT = 0
)(
`clk_input,
input  [IDXMAXDW-1:0] i_loopSize [NDEPTH],
output [IDXMAXDW-1:0] o_loopIdx [NDEPTH],
input  LpCtl i_ctl, 
output [NDEPTH-1:0] o_loopEnd
//TODO idx > 1 ? idx output ?
);
    //================
    //parameter
    //================
  
 


    //=================
    //logic
    //=================
    logic [NDEPTH-1:0] loopEnd ;
        assign o_loopEnd = loopEnd;
    logic [IDXMAXDW-1:0] loopIdx_r [NDEPTH], loopIdx_w [NDEPTH];


    `define MSKIDX [i][IDXDW[i]-1:0] 
    genvar i;
    generate
        for ( i=0 ; i<NDEPTH ; ++i)begin 
            assign loopEnd[i] =  loopIdx_r[i] == i_loopSize `MSKIDX || i_loopSize[i] == '0;
            assign o_loopIdx[i] = loopIdx_r[i];
            if ( i==0 ) begin
                always_comb begin
                    loopIdx_w[i]=loopIdx_r[i];
                    if(i_ctl.reset)
                        loopIdx_w `MSKIDX = STARTPOINT;
                    else if (i_ctl.inc)
                        loopIdx_w `MSKIDX = (loopEnd[0])? 1 : loopIdx_r `MSKIDX + 1'b1; 
                    else
                        loopIdx_w `MSKIDX = loopIdx_r `MSKIDX;
                end
            end     
            else begin
                always_comb begin
                    loopIdx_w[i] = loopIdx_r[i];
                    if(i_ctl.reset)
                        loopIdx_w `MSKIDX = 1 ;
                    else if (i_ctl.inc) 
                        loopIdx_w `MSKIDX = (&loopEnd[i:0])? 1 : (&loopEnd[i-1:0])? loopIdx_r `MSKIDX +1'b1 : loopIdx_r `MSKIDX ;  
                    else
                        loopIdx_w `MSKIDX = loopIdx_r `MSKIDX ;   
                end        
            end
        end
    endgenerate

    `ff_rstn
        for ( int j=1 ; j<NDEPTH ; ++j)
            loopIdx_r[j] <= 1;    
        loopIdx_r[0] <= STARTPOINT;
    `ff_cg(i_ctl.dval)
        for ( int j=0 ; j<NDEPTH ; ++j)
            loopIdx_r[j] <= loopIdx_w[j];
    `ff_end

endmodule
`ifdef Loop
module Loop;
   
    parameter NDEPTH = 3;
    parameter IDXMAXDW = 11;
    //parameter int IDXDW [NDEPTH] = {3,5,3};
    LpCtl i_ctl;
    logic [NDEPTH-1:0] o_loopEnd;
    logic [IDXMAXDW-1:0] i_loopSize [NDEPTH]; 
        assign i_loopSize = {11'd5,11'd0,11'd7};
    `default_Nico_define
LoopCounter #(
.NDEPTH, .IDXDW( {10'd3,10'd5,10'd3} ), .IDXMAXDW
) dut(
.*
//`clk_connect,
//.i_loopSize({11'd5,11'd30,11'd7}),
//.i_ctl(i_ctl)
//.o_loopEnd(loopend)
);
`default_Nico_init_block(Loop,10000)
endmodule
`endif
