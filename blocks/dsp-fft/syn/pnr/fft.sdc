create_clock -name clk -period 6.25 [get_ports clk]
set_max_fanout 16 [current_design]
set_max_transition 1.5 [current_design]
set_false_path -from [get_ports rst]
