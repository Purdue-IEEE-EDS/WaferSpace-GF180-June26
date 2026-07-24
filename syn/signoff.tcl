read_liberty /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu9t5v0/lib/gf180mcu_fd_sc_mcu9t5v0__tt_025C_3v30.lib
read_verilog syn/fft_pnr.v
link_design fft
read_spef signoff/min.spef
create_clock -name adc_clk -period 1.8 [get_ports adc_clk]
create_generated_clock -name fft_clk -source [get_ports adc_clk] -divide_by 4 [get_pins divider/_4_/Q ]
get_clocks
set_propagated_clock [all_clocks]

set_multicycle_path -setup 4 -from [get_clocks fft_clk] -to [get_clocks adc_clk]
set_multicycle_path -hold 3 -from [get_clocks fft_clk] -to [get_clocks adc_clk]
set_multicycle_path 3 -setup -from [get_pins stp_im/genblk1[*].stp/*/CLK] -to [get_clocks fft_clk]
set_multicycle_path 2 -hold  -from [get_pins stp_im/genblk1[*].stp/*/CLK] -to [get_clocks fft_clk]
set_multicycle_path 3 -setup -from [get_pins stp_re/genblk1[*].stp/*/CLK] -to [get_clocks fft_clk]
set_multicycle_path 2 -hold  -from [get_pins stp_re/genblk1[*].stp/*/CLK] -to [get_clocks fft_clk]
set_multicycle_path 3 -setup -from [get_pins stp_im/stp0/*/CLK] -to [get_clocks fft_clk]
set_multicycle_path 2 -hold  -from [get_pins stp_im/stp0/*/CLK] -to [get_clocks fft_clk]
set_multicycle_path 3 -setup -from [get_pins stp_re/stp0/*/CLK] -to [get_clocks fft_clk]
set_multicycle_path 2 -hold  -from [get_pins stp_re/stp0/*/CLK] -to [get_clocks fft_clk]
puts "
=== WORST PATH (max) ==="
report_checks -path_delay max -fields {fanout capacitance slew} -digits 3

puts "
=== WORST PATH (min / hold) ==="
report_checks -path_delay min -fields {fanout capacitance slew} -digits 3

puts "
=== SUMMARY ==="
report_tns
report_wns
