# You can only modify clock period 
set cycle 2.5 
echo $cycle
set t_in [expr 0.01]
set t_out  0.01 

set high_fanout_net_threshold 20
# Constraint setting 
# Clock constraints 
create_clock  -period $cycle -waveform [list 0 [expr $cycle*0.5]] [get_ports i_clk] 
set_fix_hold                          [get_clocks i_clk]                                     ;# remove while P&R 
#set_dont_touch_network                [get_clocks i_clk]                                     ;# remove while P&R 
set_ideal_network                     [all_inputs]                                      ;# remove while P&R 
set_clock_uncertainty            0.1  [get_clocks i_clk] 
set_clock_latency                0.1  [get_clocks i_clk] 


#Other Constraints 
set_max_transition 0.3 [current_design]
set_max_fanout 100  [current_design] 



#Don't touch the basic env setting as below
set_operating_conditions -min_library fast -min fast -max_library typical -max typical 
set_drive        1     [all_inputs]                                                        ;# DC w IOpad 
set_load         1     [all_outputs]                                                       ;# DC w IOpad 
set_input_delay   $t_in  -clock i_clk [remove_from_collection [all_inputs] [get_ports i_clk]] 
set_output_delay  $t_out -clock i_clk [all_outputs] 
set_wire_load_model -name tsmc090_wl10 -library typical ;# remove while P&R 
set_max_area 0
