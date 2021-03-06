###################################################################

# Created by write_sdc on Tue Jul 23 03:15:17 2019

###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance pF -power mW -voltage V       \
-current mA
set_operating_conditions -max typical -max_library typical\
                         -min fast -min_library fast
set_wire_load_model -name tsmc090_wl10 -library typical
set_max_transition 0.3 [current_design]
set_max_fanout 100 [current_design]
set_load -pin_load 1 [get_ports r_Input_ack]
set_load -pin_load 1 [get_ports r_Weight_ack]
set_load -pin_load 1 [get_ports r_GB_ack]
set_load -pin_load 1 [get_ports w_Input_ack]
set_load -pin_load 1 [get_ports w_Weight_ack]
set_load -pin_load 1 [get_ports w_GB_ack]
set_load -pin_load 1 [get_ports {o_Input[0][15]}]
set_load -pin_load 1 [get_ports {o_Input[0][14]}]
set_load -pin_load 1 [get_ports {o_Input[0][13]}]
set_load -pin_load 1 [get_ports {o_Input[0][12]}]
set_load -pin_load 1 [get_ports {o_Input[0][11]}]
set_load -pin_load 1 [get_ports {o_Input[0][10]}]
set_load -pin_load 1 [get_ports {o_Input[0][9]}]
set_load -pin_load 1 [get_ports {o_Input[0][8]}]
set_load -pin_load 1 [get_ports {o_Input[0][7]}]
set_load -pin_load 1 [get_ports {o_Input[0][6]}]
set_load -pin_load 1 [get_ports {o_Input[0][5]}]
set_load -pin_load 1 [get_ports {o_Input[0][4]}]
set_load -pin_load 1 [get_ports {o_Input[0][3]}]
set_load -pin_load 1 [get_ports {o_Input[0][2]}]
set_load -pin_load 1 [get_ports {o_Input[0][1]}]
set_load -pin_load 1 [get_ports {o_Input[0][0]}]
set_load -pin_load 1 [get_ports {o_Weight[0][15]}]
set_load -pin_load 1 [get_ports {o_Weight[0][14]}]
set_load -pin_load 1 [get_ports {o_Weight[0][13]}]
set_load -pin_load 1 [get_ports {o_Weight[0][12]}]
set_load -pin_load 1 [get_ports {o_Weight[0][11]}]
set_load -pin_load 1 [get_ports {o_Weight[0][10]}]
set_load -pin_load 1 [get_ports {o_Weight[0][9]}]
set_load -pin_load 1 [get_ports {o_Weight[0][8]}]
set_load -pin_load 1 [get_ports {o_Weight[0][7]}]
set_load -pin_load 1 [get_ports {o_Weight[0][6]}]
set_load -pin_load 1 [get_ports {o_Weight[0][5]}]
set_load -pin_load 1 [get_ports {o_Weight[0][4]}]
set_load -pin_load 1 [get_ports {o_Weight[0][3]}]
set_load -pin_load 1 [get_ports {o_Weight[0][2]}]
set_load -pin_load 1 [get_ports {o_Weight[0][1]}]
set_load -pin_load 1 [get_ports {o_Weight[0][0]}]
set_load -pin_load 1 [get_ports {o_GB[0][31]}]
set_load -pin_load 1 [get_ports {o_GB[0][30]}]
set_load -pin_load 1 [get_ports {o_GB[0][29]}]
set_load -pin_load 1 [get_ports {o_GB[0][28]}]
set_load -pin_load 1 [get_ports {o_GB[0][27]}]
set_load -pin_load 1 [get_ports {o_GB[0][26]}]
set_load -pin_load 1 [get_ports {o_GB[0][25]}]
set_load -pin_load 1 [get_ports {o_GB[0][24]}]
set_load -pin_load 1 [get_ports {o_GB[0][23]}]
set_load -pin_load 1 [get_ports {o_GB[0][22]}]
set_load -pin_load 1 [get_ports {o_GB[0][21]}]
set_load -pin_load 1 [get_ports {o_GB[0][20]}]
set_load -pin_load 1 [get_ports {o_GB[0][19]}]
set_load -pin_load 1 [get_ports {o_GB[0][18]}]
set_load -pin_load 1 [get_ports {o_GB[0][17]}]
set_load -pin_load 1 [get_ports {o_GB[0][16]}]
set_load -pin_load 1 [get_ports {o_GB[0][15]}]
set_load -pin_load 1 [get_ports {o_GB[0][14]}]
set_load -pin_load 1 [get_ports {o_GB[0][13]}]
set_load -pin_load 1 [get_ports {o_GB[0][12]}]
set_load -pin_load 1 [get_ports {o_GB[0][11]}]
set_load -pin_load 1 [get_ports {o_GB[0][10]}]
set_load -pin_load 1 [get_ports {o_GB[0][9]}]
set_load -pin_load 1 [get_ports {o_GB[0][8]}]
set_load -pin_load 1 [get_ports {o_GB[0][7]}]
set_load -pin_load 1 [get_ports {o_GB[0][6]}]
set_load -pin_load 1 [get_ports {o_GB[0][5]}]
set_load -pin_load 1 [get_ports {o_GB[0][4]}]
set_load -pin_load 1 [get_ports {o_GB[0][3]}]
set_load -pin_load 1 [get_ports {o_GB[0][2]}]
set_load -pin_load 1 [get_ports {o_GB[0][1]}]
set_load -pin_load 1 [get_ports {o_GB[0][0]}]
set_load -pin_load 1 [get_ports {o_GB[1][31]}]
set_load -pin_load 1 [get_ports {o_GB[1][30]}]
set_load -pin_load 1 [get_ports {o_GB[1][29]}]
set_load -pin_load 1 [get_ports {o_GB[1][28]}]
set_load -pin_load 1 [get_ports {o_GB[1][27]}]
set_load -pin_load 1 [get_ports {o_GB[1][26]}]
set_load -pin_load 1 [get_ports {o_GB[1][25]}]
set_load -pin_load 1 [get_ports {o_GB[1][24]}]
set_load -pin_load 1 [get_ports {o_GB[1][23]}]
set_load -pin_load 1 [get_ports {o_GB[1][22]}]
set_load -pin_load 1 [get_ports {o_GB[1][21]}]
set_load -pin_load 1 [get_ports {o_GB[1][20]}]
set_load -pin_load 1 [get_ports {o_GB[1][19]}]
set_load -pin_load 1 [get_ports {o_GB[1][18]}]
set_load -pin_load 1 [get_ports {o_GB[1][17]}]
set_load -pin_load 1 [get_ports {o_GB[1][16]}]
set_load -pin_load 1 [get_ports {o_GB[1][15]}]
set_load -pin_load 1 [get_ports {o_GB[1][14]}]
set_load -pin_load 1 [get_ports {o_GB[1][13]}]
set_load -pin_load 1 [get_ports {o_GB[1][12]}]
set_load -pin_load 1 [get_ports {o_GB[1][11]}]
set_load -pin_load 1 [get_ports {o_GB[1][10]}]
set_load -pin_load 1 [get_ports {o_GB[1][9]}]
set_load -pin_load 1 [get_ports {o_GB[1][8]}]
set_load -pin_load 1 [get_ports {o_GB[1][7]}]
set_load -pin_load 1 [get_ports {o_GB[1][6]}]
set_load -pin_load 1 [get_ports {o_GB[1][5]}]
set_load -pin_load 1 [get_ports {o_GB[1][4]}]
set_load -pin_load 1 [get_ports {o_GB[1][3]}]
set_load -pin_load 1 [get_ports {o_GB[1][2]}]
set_load -pin_load 1 [get_ports {o_GB[1][1]}]
set_load -pin_load 1 [get_ports {o_GB[1][0]}]
set_ideal_network [get_ports i_clk]
set_ideal_network [get_ports i_rstn]
set_ideal_network [get_ports {i_Input[0][15]}]
set_ideal_network [get_ports {i_Input[0][14]}]
set_ideal_network [get_ports {i_Input[0][13]}]
set_ideal_network [get_ports {i_Input[0][12]}]
set_ideal_network [get_ports {i_Input[0][11]}]
set_ideal_network [get_ports {i_Input[0][10]}]
set_ideal_network [get_ports {i_Input[0][9]}]
set_ideal_network [get_ports {i_Input[0][8]}]
set_ideal_network [get_ports {i_Input[0][7]}]
set_ideal_network [get_ports {i_Input[0][6]}]
set_ideal_network [get_ports {i_Input[0][5]}]
set_ideal_network [get_ports {i_Input[0][4]}]
set_ideal_network [get_ports {i_Input[0][3]}]
set_ideal_network [get_ports {i_Input[0][2]}]
set_ideal_network [get_ports {i_Input[0][1]}]
set_ideal_network [get_ports {i_Input[0][0]}]
set_ideal_network [get_ports {i_Weight[0][15]}]
set_ideal_network [get_ports {i_Weight[0][14]}]
set_ideal_network [get_ports {i_Weight[0][13]}]
set_ideal_network [get_ports {i_Weight[0][12]}]
set_ideal_network [get_ports {i_Weight[0][11]}]
set_ideal_network [get_ports {i_Weight[0][10]}]
set_ideal_network [get_ports {i_Weight[0][9]}]
set_ideal_network [get_ports {i_Weight[0][8]}]
set_ideal_network [get_ports {i_Weight[0][7]}]
set_ideal_network [get_ports {i_Weight[0][6]}]
set_ideal_network [get_ports {i_Weight[0][5]}]
set_ideal_network [get_ports {i_Weight[0][4]}]
set_ideal_network [get_ports {i_Weight[0][3]}]
set_ideal_network [get_ports {i_Weight[0][2]}]
set_ideal_network [get_ports {i_Weight[0][1]}]
set_ideal_network [get_ports {i_Weight[0][0]}]
set_ideal_network [get_ports {i_GB[0][31]}]
set_ideal_network [get_ports {i_GB[0][30]}]
set_ideal_network [get_ports {i_GB[0][29]}]
set_ideal_network [get_ports {i_GB[0][28]}]
set_ideal_network [get_ports {i_GB[0][27]}]
set_ideal_network [get_ports {i_GB[0][26]}]
set_ideal_network [get_ports {i_GB[0][25]}]
set_ideal_network [get_ports {i_GB[0][24]}]
set_ideal_network [get_ports {i_GB[0][23]}]
set_ideal_network [get_ports {i_GB[0][22]}]
set_ideal_network [get_ports {i_GB[0][21]}]
set_ideal_network [get_ports {i_GB[0][20]}]
set_ideal_network [get_ports {i_GB[0][19]}]
set_ideal_network [get_ports {i_GB[0][18]}]
set_ideal_network [get_ports {i_GB[0][17]}]
set_ideal_network [get_ports {i_GB[0][16]}]
set_ideal_network [get_ports {i_GB[0][15]}]
set_ideal_network [get_ports {i_GB[0][14]}]
set_ideal_network [get_ports {i_GB[0][13]}]
set_ideal_network [get_ports {i_GB[0][12]}]
set_ideal_network [get_ports {i_GB[0][11]}]
set_ideal_network [get_ports {i_GB[0][10]}]
set_ideal_network [get_ports {i_GB[0][9]}]
set_ideal_network [get_ports {i_GB[0][8]}]
set_ideal_network [get_ports {i_GB[0][7]}]
set_ideal_network [get_ports {i_GB[0][6]}]
set_ideal_network [get_ports {i_GB[0][5]}]
set_ideal_network [get_ports {i_GB[0][4]}]
set_ideal_network [get_ports {i_GB[0][3]}]
set_ideal_network [get_ports {i_GB[0][2]}]
set_ideal_network [get_ports {i_GB[0][1]}]
set_ideal_network [get_ports {i_GB[0][0]}]
set_ideal_network [get_ports {i_GB[1][31]}]
set_ideal_network [get_ports {i_GB[1][30]}]
set_ideal_network [get_ports {i_GB[1][29]}]
set_ideal_network [get_ports {i_GB[1][28]}]
set_ideal_network [get_ports {i_GB[1][27]}]
set_ideal_network [get_ports {i_GB[1][26]}]
set_ideal_network [get_ports {i_GB[1][25]}]
set_ideal_network [get_ports {i_GB[1][24]}]
set_ideal_network [get_ports {i_GB[1][23]}]
set_ideal_network [get_ports {i_GB[1][22]}]
set_ideal_network [get_ports {i_GB[1][21]}]
set_ideal_network [get_ports {i_GB[1][20]}]
set_ideal_network [get_ports {i_GB[1][19]}]
set_ideal_network [get_ports {i_GB[1][18]}]
set_ideal_network [get_ports {i_GB[1][17]}]
set_ideal_network [get_ports {i_GB[1][16]}]
set_ideal_network [get_ports {i_GB[1][15]}]
set_ideal_network [get_ports {i_GB[1][14]}]
set_ideal_network [get_ports {i_GB[1][13]}]
set_ideal_network [get_ports {i_GB[1][12]}]
set_ideal_network [get_ports {i_GB[1][11]}]
set_ideal_network [get_ports {i_GB[1][10]}]
set_ideal_network [get_ports {i_GB[1][9]}]
set_ideal_network [get_ports {i_GB[1][8]}]
set_ideal_network [get_ports {i_GB[1][7]}]
set_ideal_network [get_ports {i_GB[1][6]}]
set_ideal_network [get_ports {i_GB[1][5]}]
set_ideal_network [get_ports {i_GB[1][4]}]
set_ideal_network [get_ports {i_GB[1][3]}]
set_ideal_network [get_ports {i_GB[1][2]}]
set_ideal_network [get_ports {i_GB[1][1]}]
set_ideal_network [get_ports {i_GB[1][0]}]
set_ideal_network [get_ports r_Input_rdy]
set_ideal_network [get_ports r_Weight_rdy]
set_ideal_network [get_ports r_GB_rdy]
set_ideal_network [get_ports w_Input_rdy]
set_ideal_network [get_ports w_Weight_rdy]
set_ideal_network [get_ports w_GB_rdy]
create_clock [get_ports i_clk]  -period 3  -waveform {0 1.5}
set_clock_latency 0.1  [get_clocks i_clk]
set_clock_uncertainty 0.1  [get_clocks i_clk]
set_input_delay -clock i_clk  0.01  [get_ports i_rstn]
set_input_delay -clock i_clk  0.01  [get_ports {i_Input[0][15]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Input[0][14]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Input[0][13]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Input[0][12]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Input[0][11]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Input[0][10]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Input[0][9]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Input[0][8]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Input[0][7]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Input[0][6]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Input[0][5]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Input[0][4]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Input[0][3]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Input[0][2]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Input[0][1]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Input[0][0]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Weight[0][15]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Weight[0][14]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Weight[0][13]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Weight[0][12]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Weight[0][11]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Weight[0][10]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Weight[0][9]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Weight[0][8]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Weight[0][7]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Weight[0][6]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Weight[0][5]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Weight[0][4]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Weight[0][3]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Weight[0][2]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Weight[0][1]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_Weight[0][0]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][31]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][30]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][29]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][28]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][27]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][26]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][25]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][24]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][23]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][22]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][21]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][20]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][19]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][18]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][17]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][16]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][15]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][14]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][13]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][12]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][11]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][10]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][9]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][8]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][7]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][6]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][5]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][4]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][3]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][2]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][1]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[0][0]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][31]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][30]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][29]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][28]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][27]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][26]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][25]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][24]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][23]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][22]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][21]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][20]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][19]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][18]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][17]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][16]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][15]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][14]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][13]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][12]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][11]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][10]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][9]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][8]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][7]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][6]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][5]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][4]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][3]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][2]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][1]}]
set_input_delay -clock i_clk  0.01  [get_ports {i_GB[1][0]}]
set_input_delay -clock i_clk  0.01  [get_ports r_Input_rdy]
set_input_delay -clock i_clk  0.01  [get_ports r_Weight_rdy]
set_input_delay -clock i_clk  0.01  [get_ports r_GB_rdy]
set_input_delay -clock i_clk  0.01  [get_ports w_Input_rdy]
set_input_delay -clock i_clk  0.01  [get_ports w_Weight_rdy]
set_input_delay -clock i_clk  0.01  [get_ports w_GB_rdy]
set_output_delay -clock i_clk  0.01  [get_ports r_Input_ack]
set_output_delay -clock i_clk  0.01  [get_ports r_Weight_ack]
set_output_delay -clock i_clk  0.01  [get_ports r_GB_ack]
set_output_delay -clock i_clk  0.01  [get_ports w_Input_ack]
set_output_delay -clock i_clk  0.01  [get_ports w_Weight_ack]
set_output_delay -clock i_clk  0.01  [get_ports w_GB_ack]
set_output_delay -clock i_clk  0.01  [get_ports {o_Input[0][15]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Input[0][14]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Input[0][13]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Input[0][12]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Input[0][11]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Input[0][10]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Input[0][9]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Input[0][8]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Input[0][7]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Input[0][6]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Input[0][5]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Input[0][4]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Input[0][3]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Input[0][2]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Input[0][1]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Input[0][0]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Weight[0][15]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Weight[0][14]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Weight[0][13]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Weight[0][12]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Weight[0][11]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Weight[0][10]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Weight[0][9]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Weight[0][8]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Weight[0][7]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Weight[0][6]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Weight[0][5]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Weight[0][4]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Weight[0][3]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Weight[0][2]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Weight[0][1]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_Weight[0][0]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][31]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][30]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][29]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][28]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][27]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][26]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][25]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][24]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][23]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][22]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][21]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][20]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][19]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][18]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][17]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][16]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][15]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][14]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][13]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][12]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][11]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][10]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][9]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][8]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][7]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][6]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][5]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][4]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][3]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][2]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][1]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[0][0]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][31]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][30]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][29]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][28]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][27]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][26]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][25]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][24]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][23]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][22]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][21]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][20]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][19]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][18]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][17]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][16]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][15]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][14]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][13]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][12]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][11]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][10]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][9]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][8]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][7]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][6]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][5]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][4]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][3]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][2]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][1]}]
set_output_delay -clock i_clk  0.01  [get_ports {o_GB[1][0]}]
set_drive 1  [get_ports i_clk]
set_drive 1  [get_ports i_rstn]
set_drive 1  [get_ports {i_Input[0][15]}]
set_drive 1  [get_ports {i_Input[0][14]}]
set_drive 1  [get_ports {i_Input[0][13]}]
set_drive 1  [get_ports {i_Input[0][12]}]
set_drive 1  [get_ports {i_Input[0][11]}]
set_drive 1  [get_ports {i_Input[0][10]}]
set_drive 1  [get_ports {i_Input[0][9]}]
set_drive 1  [get_ports {i_Input[0][8]}]
set_drive 1  [get_ports {i_Input[0][7]}]
set_drive 1  [get_ports {i_Input[0][6]}]
set_drive 1  [get_ports {i_Input[0][5]}]
set_drive 1  [get_ports {i_Input[0][4]}]
set_drive 1  [get_ports {i_Input[0][3]}]
set_drive 1  [get_ports {i_Input[0][2]}]
set_drive 1  [get_ports {i_Input[0][1]}]
set_drive 1  [get_ports {i_Input[0][0]}]
set_drive 1  [get_ports {i_Weight[0][15]}]
set_drive 1  [get_ports {i_Weight[0][14]}]
set_drive 1  [get_ports {i_Weight[0][13]}]
set_drive 1  [get_ports {i_Weight[0][12]}]
set_drive 1  [get_ports {i_Weight[0][11]}]
set_drive 1  [get_ports {i_Weight[0][10]}]
set_drive 1  [get_ports {i_Weight[0][9]}]
set_drive 1  [get_ports {i_Weight[0][8]}]
set_drive 1  [get_ports {i_Weight[0][7]}]
set_drive 1  [get_ports {i_Weight[0][6]}]
set_drive 1  [get_ports {i_Weight[0][5]}]
set_drive 1  [get_ports {i_Weight[0][4]}]
set_drive 1  [get_ports {i_Weight[0][3]}]
set_drive 1  [get_ports {i_Weight[0][2]}]
set_drive 1  [get_ports {i_Weight[0][1]}]
set_drive 1  [get_ports {i_Weight[0][0]}]
set_drive 1  [get_ports {i_GB[0][31]}]
set_drive 1  [get_ports {i_GB[0][30]}]
set_drive 1  [get_ports {i_GB[0][29]}]
set_drive 1  [get_ports {i_GB[0][28]}]
set_drive 1  [get_ports {i_GB[0][27]}]
set_drive 1  [get_ports {i_GB[0][26]}]
set_drive 1  [get_ports {i_GB[0][25]}]
set_drive 1  [get_ports {i_GB[0][24]}]
set_drive 1  [get_ports {i_GB[0][23]}]
set_drive 1  [get_ports {i_GB[0][22]}]
set_drive 1  [get_ports {i_GB[0][21]}]
set_drive 1  [get_ports {i_GB[0][20]}]
set_drive 1  [get_ports {i_GB[0][19]}]
set_drive 1  [get_ports {i_GB[0][18]}]
set_drive 1  [get_ports {i_GB[0][17]}]
set_drive 1  [get_ports {i_GB[0][16]}]
set_drive 1  [get_ports {i_GB[0][15]}]
set_drive 1  [get_ports {i_GB[0][14]}]
set_drive 1  [get_ports {i_GB[0][13]}]
set_drive 1  [get_ports {i_GB[0][12]}]
set_drive 1  [get_ports {i_GB[0][11]}]
set_drive 1  [get_ports {i_GB[0][10]}]
set_drive 1  [get_ports {i_GB[0][9]}]
set_drive 1  [get_ports {i_GB[0][8]}]
set_drive 1  [get_ports {i_GB[0][7]}]
set_drive 1  [get_ports {i_GB[0][6]}]
set_drive 1  [get_ports {i_GB[0][5]}]
set_drive 1  [get_ports {i_GB[0][4]}]
set_drive 1  [get_ports {i_GB[0][3]}]
set_drive 1  [get_ports {i_GB[0][2]}]
set_drive 1  [get_ports {i_GB[0][1]}]
set_drive 1  [get_ports {i_GB[0][0]}]
set_drive 1  [get_ports {i_GB[1][31]}]
set_drive 1  [get_ports {i_GB[1][30]}]
set_drive 1  [get_ports {i_GB[1][29]}]
set_drive 1  [get_ports {i_GB[1][28]}]
set_drive 1  [get_ports {i_GB[1][27]}]
set_drive 1  [get_ports {i_GB[1][26]}]
set_drive 1  [get_ports {i_GB[1][25]}]
set_drive 1  [get_ports {i_GB[1][24]}]
set_drive 1  [get_ports {i_GB[1][23]}]
set_drive 1  [get_ports {i_GB[1][22]}]
set_drive 1  [get_ports {i_GB[1][21]}]
set_drive 1  [get_ports {i_GB[1][20]}]
set_drive 1  [get_ports {i_GB[1][19]}]
set_drive 1  [get_ports {i_GB[1][18]}]
set_drive 1  [get_ports {i_GB[1][17]}]
set_drive 1  [get_ports {i_GB[1][16]}]
set_drive 1  [get_ports {i_GB[1][15]}]
set_drive 1  [get_ports {i_GB[1][14]}]
set_drive 1  [get_ports {i_GB[1][13]}]
set_drive 1  [get_ports {i_GB[1][12]}]
set_drive 1  [get_ports {i_GB[1][11]}]
set_drive 1  [get_ports {i_GB[1][10]}]
set_drive 1  [get_ports {i_GB[1][9]}]
set_drive 1  [get_ports {i_GB[1][8]}]
set_drive 1  [get_ports {i_GB[1][7]}]
set_drive 1  [get_ports {i_GB[1][6]}]
set_drive 1  [get_ports {i_GB[1][5]}]
set_drive 1  [get_ports {i_GB[1][4]}]
set_drive 1  [get_ports {i_GB[1][3]}]
set_drive 1  [get_ports {i_GB[1][2]}]
set_drive 1  [get_ports {i_GB[1][1]}]
set_drive 1  [get_ports {i_GB[1][0]}]
set_drive 1  [get_ports r_Input_rdy]
set_drive 1  [get_ports r_Weight_rdy]
set_drive 1  [get_ports r_GB_rdy]
set_drive 1  [get_ports w_Input_rdy]
set_drive 1  [get_ports w_Weight_rdy]
set_drive 1  [get_ports w_GB_rdy]
