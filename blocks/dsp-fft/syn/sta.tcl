read_liberty /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu9t5v0/lib/gf180mcu_fd_sc_mcu9t5v0__tt_025C_3v30.lib
read_verilog syn/fft_syn.v
link_design fft
create_clock -name adc_clk -period 1.5625 [get_ports adc_clk]
create_generated_clock -name clk -source [get_ports adc_clk] -divide_by 4 [get_pins divider/_4_/Q ]
get_clocks
set_false_path -from [get_ports rst]
set_false_path -from [get_cells _36579_ ]

puts "
=== WORST PATH (max) ==="
report_checks -path_delay max -group_count 10 -fields {fanout capacitance slew} -digits 3

puts "
=== WORST PATH (min / hold) ==="
report_checks -path_delay min -digits 3

puts "
=== SUMMARY ==="
report_tns
report_wns
