create_clock -name clk -period 6.25 [get_ports clk]
set_input_delay  0.1 -clock clk [get_ports {rst}]
set_max_fanout 16 [current_design]
set_max_transition 0.3 [current_design]
