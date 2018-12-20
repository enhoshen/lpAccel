typedef struct packed{
    logic dval;
    logic inc;
    logic reset;
} LpCtl;
module LoopCounter #(
parameter NDepth = 3,
parameter int IdxDW [NDepth]= '{3,5,3},
parameter IdxMaxDW = 11
)(
`clk_input,
input  [IdxMaxDW-1:0] i_loopSize [NDepth],
input  LpCtl i_ctl, 
output [NDepth-1:0] o_loopEnd
);
    //================
    //parameter
    //================
  
 


    //=================
    //logic
    //=================
    logic [NDepth-1:0] loopEnd ;
        assign o_loopEnd = loopEnd;
    logic [IdxMaxDW-1:0] loopIdx_r [NDepth], loopIdx_w [NDepth];
    

    `define MSKIDX [i][IdxDW[i]-1:0] 
    genvar i;
    generate
        for ( i=0 ; i<NDepth ; ++i)begin 
            assign loopEnd[i] =  loopIdx_r[i] == i_loopSize `MSKIDX;
            if ( i==0 ) begin
                always_comb begin
                    loopIdx_w[i][IdxMaxDW-1:IdxDW[i]]='0;
                    if(i_ctl.reset)
                        loopIdx_w `MSKIDX = 1;
                    else if (i_ctl.inc)
                        loopIdx_w `MSKIDX = (loopEnd[0])? 1 : loopIdx_r `MSKIDX + 1'b1; 
                    else
                        loopIdx_w `MSKIDX = loopIdx_r `MSKIDX;
                end
            end     
            else begin
                always_comb begin
                    loopIdx_w[i][IdxMaxDW-1:IdxDW[i]]='0;
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
        for ( int j=0 ; j<NDepth ; ++j)
            loopIdx_r[j] <= 1;    
    `ff_cg(i_ctl.dval)
        for ( int j=0 ; j<NDepth ; ++j)
            loopIdx_r[j] <= loopIdx_w[j];
    `ff_end

endmodule
`ifdef Loop
module Loop;
   
    parameter NDepth = 3;
    parameter IdxMaxDW = 11;
    //parameter int IdxDW [NDepth] = {3,5,3};
    LpCtl i_ctl;
    logic [NDepth-1:0] o_loopEnd;
    logic [IdxMaxDW-1:0] i_loopSize [NDepth]; 
        assign i_loopSize = {11'd5,11'd20,11'd7};
    `clk_logic;
    `Pos(rst_out , i_rstn)
    `PosIf(ck_ev, i_clk, i_rstn)
    `WithFinish    
LoopCounter #(
.NDepth(NDepth), .IdxDW( {10'd3,10'd5,10'd3} ), .IdxMaxDW(IdxMaxDW)
) dut(
.*
//`clk_connect,
//.i_loopSize({11'd5,11'd30,11'd7}),
//.i_ctl(i_ctl)
//.o_loopEnd(loopend)
);
always #(`cycle/2) i_clk = ~i_clk;
initial begin
    $fsdbDumpfile("loop.fsdb");
    $fsdbDumpvars(0, Loop, "+all");
    i_clk =0;
    i_rstn=1;
    #(`cycle/2) $NicotbInit();
    #11 i_rstn = 0;
    #10 i_rstn = 1;
    #(`cycle*10000) $display("timeout");
    $NicotbFinal();
    $finish;
    $fsdbDumpoff();
end


endmodule
`endif
