import PECfg::DWD;
import PECfg::PSUMDWD;
import PECfg::PEROW;
import PECtlCfg::*;
typedef struct packed{
    logic [PSUMDWD-1:0] Psum_MS;
    logic [DWD-1:0]   Sum_MS;
} MSout;
module MultStage(
`clk_input,
input  MSctl i_ctl,
`rdyack_input(FS),
`rdyack_output(MS),
input  FSout i_data [PEROW],
output MSout o_data [PEROW],
input  SSctl i_MSpipe_FS,
output SSctl o_MSpipe_MS
);

    //==================
    //logic
    //==================
    //==================
    //comb
    //==================
    `forward ( FD, FS, MS)
    
    genvar pe_row;
    generate                                                            
        for ( pe_row = 0 ; pe_row < PEROW ; ++pe_row) begin:Arithmetic_unit
            if (ATYPE==MUX)begin                                        
                MATmux MA (                                             
                .*,                                                     
                .i_ipix(i_data[pe_row].Input_FS),                               
                .i_wpix(i_data[pe_row].Weight_FS),                              
                .o_sum(o_data[pe_row].Sum_MS)                                   
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
    `ff_rstn
        o_MSpipe_MS <= '0;
        for ( int i=0 ; i<PEROW ; ++i)begin
            o_data[i].Psum_MS <= '0;
        end
    `ff_cg( `rdyNack(FS) || `rdyNack(MS) )
        o_MSpipe_MS <= i_MSpipe_FS;
        for ( int i=0 ; i<PEROW ; ++i)begin
            o_data[i].Psum_MS <= i_data[i].Psum_FS ;
        end
    `ff_end
endmodule
