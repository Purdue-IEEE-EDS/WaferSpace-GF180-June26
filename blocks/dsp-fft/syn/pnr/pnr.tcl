read_lef /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu9t5v0/techlef/gf180mcu_fd_sc_mcu9t5v0__max.tlef
read_lef /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu9t5v0/lef/gf180mcu_fd_sc_mcu9t5v0.lef
read_liberty /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu9t5v0/lib/gf180mcu_fd_sc_mcu9t5v0__tt_025C_3v30.lib
read_verilog syn/fft_syn.v
link_design fft
read_sdc syn/pnr/fft.sdc

initialize_floorplan -utilization 55 -aspect_ratio 1.5 -core_space 10 -site GF018hv5v_green_sc9

insert_tiecells gf180mcu_fd_sc_mcu9t5v0__tiel/ZN -prefix TIE_LOW_
insert_tiecells gf180mcu_fd_sc_mcu9t5v0__tieh/Z -prefix TIE_HIGH_

make_tracks Metal1 -x_offset 0.24 -x_pitch 0.48 -y_offset 0.28 -y_pitch 0.56
make_tracks Metal2 -x_offset 0.28 -x_pitch 0.56 -y_offset 0.24 -y_pitch 0.48
make_tracks Metal3 -x_offset 0.28 -x_pitch 0.56 -y_offset 0.28 -y_pitch 0.56
make_tracks Metal4 -x_offset 0.28 -x_pitch 0.56 -y_offset 0.28 -y_pitch 0.56
make_tracks Metal5 -x_offset 0.28 -x_pitch 0.56 -y_offset 0.28 -y_pitch 0.56

set_routing_layers -signal Metal1-Metal5
set_wire_rc -signal -layer Metal3
set_wire_rc -clock -layer Metal4

place_pins -hor_layers Metal3 -ver_layers Metal2

add_global_connection -net VDD -pin_pattern VDD -power
add_global_connection -net VSS -pin_pattern VSS -ground
set_voltage_domain -power VDD -ground VSS
define_pdn_grid -name core -pins {Metal5}
add_pdn_stripe -grid core -layer Metal1 -width 0.48 -followpins
add_pdn_stripe -grid core -layer Metal4 -width 1.6 -spacing 1.6 -pitch 40.0 -offset 2.0
add_pdn_stripe -grid core -layer Metal5 -width 1.6 -spacing 1.6 -pitch 40.0 -offset 2.0
add_pdn_connect -layers {Metal1 Metal4}
add_pdn_connect -layers {Metal4 Metal5}
pdngen

global_placement -timing_driven -density 0.45 -pad_left 2 -pad_right 2
estimate_parasitics -placement
repair_design
detailed_placement
estimate_parasitics -placement
check_placement

clock_tree_synthesis -root_buf gf180mcu_fd_sc_mcu9t5v0__clkbuf_8 -buf_list {gf180mcu_fd_sc_mcu9t5v0__clkbuf_2 gf180mcu_fd_sc_mcu9t5v0__clkbuf_4 gf180mcu_fd_sc_mcu9t5v0__clkbuf_8} -sink_clustering_enable
set_propagated_clock [all_clocks]
repair_clock_nets -max_wire_length 1000
detailed_placement

estimate_parasitics -placement
repair_timing -setup -setup_margin 0.05 -verbose
repair_timing -hold -hold_margin 0.05 -verbose
detailed_placement

global_route -verbose -allow_congestion
set_routing_layers -signal Metal1-Metal5
detailed_route

estimate_parasitics -placement
repair_timing -setup -setup_margin 0.05 -verbose
repair_timing -hold -hold_margin 0.05 -verbose
repair_timing -setup -skip_buffering -verbose
detailed_placement
detailed_route
report_checks -path_delay max -fields {cap net fanout input_pin} -group_path_count 10
report_checks -path_delay min -fields {cap net fanout input_pin} -group_path_count 10
report_tns
report_wns
report_clock_skew
report_design_area
report_power

write_def syn/pnr/fft_pnr.def
write_verilog syn/fft_pnr.v
