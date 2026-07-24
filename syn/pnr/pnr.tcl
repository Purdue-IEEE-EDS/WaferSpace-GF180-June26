read_lef /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu9t5v0/techlef/gf180mcu_fd_sc_mcu9t5v0__max.tlef
read_lef /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu9t5v0/lef/gf180mcu_fd_sc_mcu9t5v0.lef
read_liberty /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu9t5v0/lib/gf180mcu_fd_sc_mcu9t5v0__tt_025C_3v30.lib
read_verilog syn/fft_syn.v
link_design fft
read_sdc syn/pnr/fft.sdc

initialize_floorplan -utilization 50 -aspect_ratio 1.25 -core_space 10 -site GF018hv5v_green_sc9

insert_tiecells gf180mcu_fd_sc_mcu9t5v0__tiel/ZN -prefix TIE_LOW_
insert_tiecells gf180mcu_fd_sc_mcu9t5v0__tieh/Z -prefix TIE_HIGH_

make_tracks Metal1 -x_offset 0.24 -x_pitch 0.48 -y_offset 0.28 -y_pitch 0.56
make_tracks Metal2 -x_offset 0.28 -x_pitch 0.56 -y_offset 0.24 -y_pitch 0.48
make_tracks Metal3 -x_offset 0.28 -x_pitch 0.56 -y_offset 0.28 -y_pitch 0.56
make_tracks Metal4 -x_offset 0.28 -x_pitch 0.56 -y_offset 0.28 -y_pitch 0.56
make_tracks Metal5 -x_offset 0.28 -x_pitch 0.56 -y_offset 0.28 -y_pitch 0.56

set_io_pin_constraint -pin_names {din_re[*]} -region right:600-1000 -group -order
set_io_pin_constraint -pin_names {din_im[*]} -region right:1000-1400 -group -order
set_io_pin_constraint -pin_names {dout_re[*]} -region bottom:* -group -order
set_io_pin_constraint -pin_names {dout_im[*]} -region bottom:* -group -order
set_io_pin_constraint -pin_names {adc_clk}  -region top:*
set_io_pin_constraint -pin_names {rst}  -region top:*
set_io_pin_constraint -pin_names {valid_out} -region bottom:*
set_routing_layers -signal Metal1-Metal5
set_wire_rc -signal -layer Metal3
set_wire_rc -clock -layer Metal4

place_pins -hor_layers Metal3 -ver_layers Metal2

add_global_connection -net VDD -pin_pattern {^VDD} -power
add_global_connection -net VSS -pin_pattern {^VSS} -ground
add_global_connection -net VDD -pin_pattern {^VNW} -power
add_global_connection -net VSS -pin_pattern {^VPW} -ground
set_voltage_domain -power VDD -ground VSS
define_pdn_grid -name core -pins {Metal5}
add_pdn_stripe -grid core -layer Metal1 -width 0.48 -followpins
add_pdn_stripe -grid core -layer Metal4 -width 1.6 -spacing 1.6 -pitch 40.0 -offset 2.0
add_pdn_stripe -grid core -layer Metal5 -width 1.6 -spacing 1.6 -pitch 40.0 -offset 2.0
add_pdn_connect -layers {Metal1 Metal4}
add_pdn_connect -layers {Metal4 Metal5}
tapcell -tapcell_master gf180mcu_fd_sc_mcu9t5v0__filltie -dist 15  -endcap_master gf180mcu_fd_sc_mcu9t5v0__endcap
global_connect
pdngen

global_placement -timing_driven -density 0.50 -pad_left 3 -pad_right 3
write_def syn/pnr/fft_pnr.def
estimate_parasitics -placement
repair_design
detailed_placement
estimate_parasitics -placement
check_placement

clock_tree_synthesis -root_buf gf180mcu_fd_sc_mcu9t5v0__clkbuf_8 -buf_list {gf180mcu_fd_sc_mcu9t5v0__clkbuf_2 gf180mcu_fd_sc_mcu9t5v0__clkbuf_4 gf180mcu_fd_sc_mcu9t5v0__clkbuf_8} -sink_clustering_enable
set_propagated_clock [all_clocks]
detailed_placement
global_connect

estimate_parasitics -placement
repair_timing -setup -setup_margin 0.05 -repair_tns 100 -max_passes 5 -verbose
estimate_parasitics -placement
repair_timing -hold -hold_margin 0.05 -verbose
detailed_placement

write_verilog syn/fft_unrouted_pnr.v
set_routing_layers -signal Metal1-Metal5
global_route -verbose
repair_antennas gf180mcu_fd_sc_mcu9t5v0__antenna -iterations 5 -ratio_margin 10
detailed_placement
detailed_route -output_drc syn/pnr/post_route_drc.rpt -droute_end_iter 64 -drc_report_iter_step 1
set repair_antenna_iteration 0
while { [check_antennas] && $repair_antenna_iteration < 5} {
repair_antennas gf180mcu_fd_sc_mcu9t5v0__antenna -iterations 1 -ratio_margin 10
check_placement
detailed_route
incr repair_antenna_iteration}

extract_parasitics -ext_model_file /foss/pdks/gf180mcuD/libs.tech/librelane/rules.openrcx.gf180mcuD.max
repair_timing -setup -setup_margin 0.07 -repair_tns 100 -max_passes 5 -verbose
extract_parasitics -ext_model_file /foss/pdks/gf180mcuD/libs.tech/librelane/rules.openrcx.gf180mcuD.min
repair_timing -hold -hold_margin 0.07 -verbose
detailed_route -output_drc syn/pnr/post_route_drc.rpt -droute_end_iter 64 -drc_report_iter_step 1
set repair_antenna_iteration 0
while { [check_antennas] && $repair_antenna_iteration < 5} {
repair_antennas gf180mcu_fd_sc_mcu9t5v0__antenna -iterations 1 -ratio_margin 10
check_placement
detailed_route
incr repair_antenna_iteration}

filler_placement "gf180mcu_fd_sc_mcu9t5v0__fill_64 gf180mcu_fd_sc_mcu9t5v0__fill_32 gf180mcu_fd_sc_mcu9t5v0__fill_16 gf180mcu_fd_sc_mcu9t5v0__fill_8 gf180mcu_fd_sc_mcu9t5v0__fill_4 gf180mcu_fd_sc_mcu9t5v0__fill_2 gf180mcu_fd_sc_mcu9t5v0__fill_1"
global_connect
report_checks -path_delay max -fields {cap net fanout input_pin} -group_path_count 10
report_checks -path_delay min -fields {cap net fanout input_pin} -group_path_count 10
report_tns
report_wns
report_clock_skew
report_design_area
report_power

write_def syn/pnr/fft_pnr.def
write_verilog syn/fft_pnr.v
write_verilog -include_pwr_gnd magic_lvs/fft_powered_pnr.v
extract_parasitics -ext_model_file /foss/pdks/gf180mcuD/libs.tech/librelane/rules.openrcx.gf180mcuD.max
write_spef signoff/max.spef
extract_parasitics -ext_model_file /foss/pdks/gf180mcuD/libs.tech/librelane/rules.openrcx.gf180mcuD.nom
write_spef signoff/nom.spef
extract_parasitics -ext_model_file /foss/pdks/gf180mcuD/libs.tech/librelane/rules.openrcx.gf180mcuD.min
write_spef signoff/min.spef
check_antennas
