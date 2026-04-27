read_liberty /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu9t5v0/lib/gf180mcu_fd_sc_mcu9t5v0__tt_025C_3v30.lib
read_verilog syn/fft_syn.v
link_design fft
create_clock -name clk -period 3.2 [get_ports clk]

puts "
=== WORST PATH (max) ==="
report_checks -path_delay max -fields {fanout capacitance slew} -digits 3

puts "
=== WORST PATH (min / hold) ==="
report_checks -path_delay min -digits 3

puts "
=== stage ==="
report_checks -path_delay max -through [get_cells genblk1[0].s/*] -fields {fanout capacitance slew} -digits 3

puts "
=== r2 (inside stage) ==="
report_checks -path_delay max -through [get_cells genblk1[0].s/genblk1.genblk1.butterfly/*] -fields {fanout capacitance slew} -digits 3

puts "
=== twiddle (inside stage) ==="
report_checks -path_delay max -through [get_cells genblk1[0].s/genblk1.genblk1.tw_rom/*] -fields {fanout capacitance slew} -digits 3

puts "
=== rotator (inside stage) ==="
report_checks -path_delay max -through [get_cells genblk1[0].s/genblk1.genblk1.rot/*] -fields {fanout capacitance slew} -digits 3

puts "
=== SUMMARY ==="
report_tns
report_wns
