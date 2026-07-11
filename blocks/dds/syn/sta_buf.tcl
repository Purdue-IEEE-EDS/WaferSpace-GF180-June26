read_lef /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu9t5v0/techlef/gf180mcu_fd_sc_mcu9t5v0__max.tlef
read_lef /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu9t5v0/lef/gf180mcu_fd_sc_mcu9t5v0.lef
read_liberty /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu9t5v0/lib/gf180mcu_fd_sc_mcu9t5v0__tt_025C_3v30.lib
read_verilog syn/dds_top_syn.v
link_design dds_top
read_sdc syn/sta_buf.sdc

# Minimal floorplan for wire RC estimation
initialize_floorplan -utilization 80 -aspect_ratio 1.0 -core_space 5 -site GF018hv5v_green_sc9

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

# Global placement for parasitic estimation
global_placement -density 0.95 -pad_left 0 -pad_right 0
estimate_parasitics -placement

# Buffer insertion + gate sizing

# Multi-pass repair — pass N+1 picks up paths deprioritized in pass N
puts "
=== REPAIR PASS 1 ==="
repair_timing -setup -verbose
detailed_placement
estimate_parasitics -placement

puts "
=== REPAIR PASS 2 ==="
repair_timing -setup -verbose
detailed_placement
estimate_parasitics -placement

puts "
=== BUFFERED: WORST PATH (max) ==="
report_checks -path_delay max -fields {fanout capacitance slew} -digits 3

puts "
=== BUFFERED: WORST PATH (min / hold) ==="
report_checks -path_delay min -digits 3

puts "
=== BUFFERED: SUMMARY ==="
report_tns
report_wns
puts "
=== WORST PATHS BY MODULE ==="
foreach inst {u_freq u_accum u_dp u_ser_i} {
    puts "
--- $inst ---"
    set mod_cells [get_cells -hier "$inst/*"]
    if {[llength $mod_cells] == 0} {
        puts "No cells matched $inst/*"
        continue
    }
    report_checks -path_delay max -through $mod_cells -fields {fanout capacitance slew} -digits 3 -group_path_count 3
}

# Write buffered netlist for inspection
write_verilog syn/dds_top_buf.v
write_def syn/dds_top_sta_buf.def
puts "
=== TIMING SUMMARY ==="
report_tns
report_wns
puts "
=== PHYSICAL SUMMARY ==="
puts "placement_knobs floorplan_util=80 aspect_ratio=1.0 core_space_um=5 gp_density=0.95 pad_left=0 pad_right=0"
report_design_area
set block [ord::get_db_block]
set dbu [$block getDefUnits]
set die [$block getDieArea]
set core [$block getCoreArea]
set die_w [expr {double([$die xMax] - [$die xMin]) / $dbu}]
set die_h [expr {double([$die yMax] - [$die yMin]) / $dbu}]
set core_w [expr {double([$core xMax] - [$core xMin]) / $dbu}]
set core_h [expr {double([$core yMax] - [$core yMin]) / $dbu}]
set std_cell_area_dbu2 0.0
foreach inst [$block getInsts] {
    set master [$inst getMaster]
    set std_cell_area_dbu2 [expr {$std_cell_area_dbu2 + double([$master getWidth]) * double([$master getHeight])}]
}
set die_area_um2 [expr {$die_w * $die_h}]
set core_area_um2 [expr {$core_w * $core_h}]
set std_cell_area_um2 [expr {$std_cell_area_dbu2 / double($dbu) / double($dbu)}]
set util_pct [expr {100.0 * $std_cell_area_um2 / $core_area_um2}]
puts [format "die_um %.3f x %.3f area_um2 %.3f" $die_w $die_h $die_area_um2]
puts [format "core_um %.3f x %.3f area_um2 %.3f" $core_w $core_h $core_area_um2]
puts [format "std_cell_area_um2 %.3f core_util_pct %.2f" $std_cell_area_um2 $util_pct]
puts [format "counts instances %d pins %d nets %d rows %d" [llength [$block getInsts]] [llength [$block getBTerms]] [llength [$block getNets]] [llength [$block getRows]]]
