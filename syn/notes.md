# Synthesis and tools notes
## design compiler
* use variables just like using shell
useful variable such as `$current_design`, so that your tcl files can be easily modular.
```shell
source $current_design\_syn.sdc
report_timing >> $current_design.txt
```
# Synthesis issues
## An unexpected critical path
* As prof suggested, some unexpected critical path may occured if logics are not properly blocked by registers,
this will directly impact the resulting **area** and timing. At first I couldn't figure out how synthesizing  
MATmux module resulting much smaller area than doing it inside the PE, by following prof's suggestion and found  
out that the output of MultStage is directly connected to MATmux sum and wasn't blocked behind the register,  
and the following synthesis results makes much more sense.
```verilog
//inside MultStage.sv
        MATmux MA (                                             
                .*,                                                     
                .i_ipix(i_data[pe_row].Input_FS),                               
                .i_wpix(i_data[pe_row].Weight_FS),                              
                .o_sum(o_data[pe_row].Sum_MS) // this line connect output directly to comb circuit                                   
                );             
//after modification in sequential part
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
    `ff_e
``` 
from this example, the morale is that when examine a unreasonable large synthesis result, you might  
need to check **critical path**, where it might be a cause of unblocked comb wires.
