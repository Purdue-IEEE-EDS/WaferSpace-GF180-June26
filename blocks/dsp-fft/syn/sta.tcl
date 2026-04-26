read_liberty /usr/share/pdk//gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu9t5v0/lib/gf180mcu_fd_sc_mcu9t5v0__tt_025C_3v30.lib
read_verilog syn/fft_syn.v
link_design fft_wrapper

create_clock -name clk -period 3.2 [get_ports clk]

puts "
=== SETUP PATHS ==="
report_checks -path_delay max -fields {slew capacitance fanout} -digits 3

puts "
=== HOLD PATHS ==="
report_checks -path_delay min -digits 3

puts "
=== SUMMARY ==="
report_wns
report_tns
