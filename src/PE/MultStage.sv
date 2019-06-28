import PECfg::DWD;
import PECfg::PSUMDWD;
import PECfg::PEROW;
import PECtlCfg::*;
typedef struct packed{
    logic signed [PSUMDWD-1:0] Psum_MS;
    logic signed [ASUMDWD-1:0]   Sum_MS;
} MSout;
typedef struct packed{
    SSctl ssctl;
    PPctl ssppctl;
}MSpipe;
module MultStage(
`clk_input,
input  FSpipeout i_pipe,
`rdyack_input(FS),
`rdyack_output(MS),
input  FSout i_data [PEROW],
output MSout o_data [PEROW],
output MSpipe o_MSpipe_MS
);

    //==================
    //logic
    //==================
    MSctl i_ctl;
        assign i_ctl = i_pipe.msctl;
    //==================
    //comb
    //==================
    `forward ( FD, FS, MS)
    logic signed [ASUMDWD-1:0] sum [PEROW] ; 
    genvar pe_row;
    generate                                                            
        for ( pe_row = 0 ; pe_row < PEROW ; ++pe_row) begin:Arithmetic_unit
            if (ATYPE==MUX)begin                                        
                MATmux MA (                                             
                .*,                                                     
                .i_ipix(i_data[pe_row].Input_FS),                               
                .i_wpix(i_data[pe_row].Weight_FS),                              
                .o_sum(sum)                                   
                );                                                      
            end                                                         
            else if (ATYPE == SIMPLE)begin                              
                initial GenCfg::TODO;                                  
            end                                                         
            else if (ATYPE == BOOTH)begin                               
                initial GenCfg::TODO;                                  
            end                                                         
            else begin                                                  
                initial ErrorAu;                                        
            end                                                         
        end                                                             
    endgenerate                                                         
    `ff_rstn
        o_MSpipe_MS <= '0;
        for ( int i=0 ; i<PEROW ; ++i)begin
            o_data[i].Psum_MS <= '0;
            o_data[i].Sum_MS <= '0;
        end
    `ff_cg( `rdyNack(FS) || `rdyNack(MS) )
        o_MSpipe_MS <= {i_pipe.ssctl,i_pipe.ssppctl};
        for ( int i=0 ; i<PEROW ; ++i)begin
            o_data[i].Psum_MS <= i_data[i].Psum_FS ;
            o_data[i].Sum_MS <= sum[i];
        end
    `ff_end
endmodule
