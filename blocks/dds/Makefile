# DDS Modulator — Makefile
TRUNC_W  ?= 12
MAG_W    ?= 9
IVERILOG ?= iverilog
VVP      ?= vvp
PYTHON   ?= python3
YOSYS    ?= yosys

# ── PDK  ──────────────────
# Default: ciel install.  Override with  make PDK_ROOT=/foss/pdks  (IHP Docker)
#                                    or  export PDK_ROOT=/your/path
PDK_ROOT   ?= $(HOME)/.ciel
SCL        ?= gf180mcu_fd_sc_mcu9t5v0
CORNER     ?= tt_025C_3v30
LIB_FILE   = $(PDK_ROOT)/gf180mcuD/libs.ref/$(SCL)/lib/$(SCL)__$(CORNER).lib

# ── Directories ──────────────────────────────────────────────
RTL_DIR    = rtl
DDS_DIR    = rtl/dds
DAC_DIR    = rtl/dac
IF_DIR     = rtl/interface
SIM_DIR    = sim
SYN_DIR    = syn

# ── Source files ─────────────────────────────────────────────
DDS_RTL    = $(DDS_DIR)/sine_rom.v        \
             $(DDS_DIR)/amp_scale.v      \
             $(DAC_DIR)/mag_to_sw.v       \
             $(DDS_DIR)/phase_to_quad.v   \
             $(DDS_DIR)/dds_datapath.v    \
             $(DDS_DIR)/freq_ctrl.v       \
	     $(DDS_DIR)/dp_half.v          \
	     $(DDS_DIR)/step_half.v        \
             $(DDS_DIR)/phase_accum.v \
	     $(DDS_DIR)/carry_out.v \
	     $(DDS_DIR)/seg_timer.v \
	     $(DDS_DIR)/sync_edge.v     

IF_RTL     = $(IF_DIR)/spi_slave.v        \
             $(IF_DIR)/dds_regmap.v

TOP_RTL    = $(RTL_DIR)/dds_top.v

RTL_ALL    = $(DDS_RTL) $(IF_RTL) $(TOP_RTL)

FREQ_TB    = $(SIM_DIR)/tb_freq_ctrl.v
ACCUM_TB   = $(SIM_DIR)/tb_phase_accum.v
SPI_TB     = $(SIM_DIR)/tb_spi_slave.v
TOP_TB     = $(SIM_DIR)/tb_dds_top.v

LUT_HEX   = sine_lut.hex
LUT_SCRIPT = scripts/gen_sine_lut.py

SYN_NET    = $(SYN_DIR)/dds_top_syn.v
SYN_SCRIPT = $(SYN_DIR)/synth.ys

# STA tool: use standalone 'sta' if found, else fall back to 'openroad'
STA        ?= $(shell command -v sta >/dev/null 2>&1 && echo sta || echo openroad)
OPENROAD   ?= openroad
KLAYOUT    ?= klayout
CLK_PERIOD ?= 3.2
CLK_PS     ?= 3200
STA_SCRIPT = $(SYN_DIR)/sta.tcl
CELL_VLOG  = $(PDK_ROOT)/gf180mcuD/libs.ref/$(SCL)/verilog/primitives.v \
             $(PDK_ROOT)/gf180mcuD/libs.ref/$(SCL)/verilog/$(SCL).v

.PHONY: all lut lint sim sim_freq sim_accum sim_spi sim_top syn sta sim_syn pnr gds clean

all: lut lint sim

# ── LUT generation ───────────────────────────────────────────

lut: $(LUT_HEX)

$(LUT_HEX): $(LUT_SCRIPT)
	$(PYTHON) $(LUT_SCRIPT) $(TRUNC_W) $(MAG_W) $(LUT_HEX)

# ── Lint ─────────────────────────────────────────────────────

lint: $(RTL_ALL)
	$(IVERILOG) -Wall -g2012 -tnull $(RTL_ALL)
	@echo "Lint OK"

# ── freq_ctrl unit test ─────────────────────────────────────

$(SIM_DIR)/tb_freq_ctrl.vvp: $(DDS_DIR)/freq_ctrl.v $(DDS_DIR)/seg_timer.v $(DDS_DIR)/dp_half.v $(DDS_DIR)/step_half.v $(FREQ_TB)
	$(IVERILOG) -Wall -g2012 -o $@ $(DDS_DIR)/freq_ctrl.v $(DDS_DIR)/seg_timer.v $(DDS_DIR)/dp_half.v $(DDS_DIR)/step_half.v $(FREQ_TB)

sim_freq: $(SIM_DIR)/tb_freq_ctrl.vvp
	cd $(SIM_DIR) && $(VVP) tb_freq_ctrl.vvp
	@echo "Waveform → $(SIM_DIR)/tb_freq_ctrl.vcd"

# ── phase_accum unit test ───────────────────────────────────

$(SIM_DIR)/tb_phase_accum.vvp: $(DDS_DIR)/phase_accum.v $(ACCUM_TB)
	$(IVERILOG) -Wall -g2012 -o $@ $(DDS_DIR)/phase_accum.v $(ACCUM_TB)

sim_accum: $(SIM_DIR)/tb_phase_accum.vvp
	cd $(SIM_DIR) && $(VVP) tb_phase_accum.vvp
	@echo "Waveform → $(SIM_DIR)/tb_phase_accum.vcd"

# ── SPI slave unit test ─────────────────────────────────────

$(SIM_DIR)/tb_spi_slave.vvp: $(IF_DIR)/spi_slave.v $(SPI_TB)
	$(IVERILOG) -Wall -g2012 -o $@ $(IF_DIR)/spi_slave.v $(SPI_TB)

sim_spi: $(SIM_DIR)/tb_spi_slave.vvp
	cd $(SIM_DIR) && $(VVP) tb_spi_slave.vvp
	@echo "Waveform → $(SIM_DIR)/tb_spi_slave.vcd"

# ── Top-level integration test ──────────────────────────────

$(SIM_DIR)/tb_dds_top.vvp: $(LUT_HEX) $(RTL_ALL) $(TOP_TB)
	$(IVERILOG) -Wall -g2012 -o $@ $(RTL_ALL) $(TOP_TB)

sim_top: $(SIM_DIR)/tb_dds_top.vvp
	cp $(LUT_HEX) $(SIM_DIR)/
	cd $(SIM_DIR) && $(VVP) tb_dds_top.vvp
	@echo "Waveform → $(SIM_DIR)/tb_dds_top.vcd"

# ── All sim ──────────────────────────────────────────────────

sim: sim_freq sim_accum sim_spi sim_top

# ── Synthesis ────────────────────────────────────────────────

syn: $(SYN_NET)

$(SYN_SCRIPT): Makefile
	@mkdir -p $(SYN_DIR)
	@echo "# ── Read RTL ──"                                     >  $@
	@echo "read_verilog -sv $(RTL_ALL)"                          >> $@
	@echo ""                                                     >> $@
	@echo "# ── Elaborate hierarchy ──"                          >> $@
	@echo "hierarchy -top dds_top -check"                        >> $@
	@echo "# ── Post-elaborate hierarchy ──"                    >> $@
	@echo "ls"                                                   >> $@
	@echo ""                                                     >> $@
	@echo "# ── Behavioral → structural ──"                     >> $@
	@echo "proc"                                                 >> $@
	@echo ""                                                     >> $@
	@echo "# ── NO FLATTEN — preserve module boundaries ──"     >> $@
	@echo "# flatten is intentionally omitted."                  >> $@
	@echo "# seg_timer and kogge_stone must stay hierarchical."  >> $@
	@echo ""                                                     >> $@
	@echo "# ── Coarse optimisation ──"                         >> $@
	@echo "opt_expr"                                             >> $@
	@echo "opt_clean"                                            >> $@
	@echo "check"                                                >> $@
	@echo "opt -nodffe -nosdff"                                  >> $@
	@echo "wreduce"                                              >> $@
	@echo "peepopt"                                              >> $@
	@echo "opt_clean"                                            >> $@
	@echo ""                                                     >> $@
	@echo "# ── Arithmetic and sharing ──"                      >> $@
	@echo "alumacc"                                              >> $@
	@echo "share"                                                >> $@
	@echo "opt"                                                  >> $@
	@echo ""                                                     >> $@
	@echo "# ── Memory ──"                                      >> $@
	@echo "memory -nomap"                                        >> $@
	@echo "opt_clean"                                            >> $@
	@echo "opt -fast -full"                                      >> $@
	@echo "memory_map"                                           >> $@
	@echo "opt -full"                                            >> $@
	@echo ""                                                     >> $@
	@echo "# ── Technology mapping ──"                           >> $@
	@echo "techmap"                                              >> $@
	@echo "opt -fast"                                            >> $@
	@echo ""                                                     >> $@
	@echo "# ── Hierarchy check before ABC ──"                  >> $@
	@echo "# ── Pre-ABC hierarchy ──"                          >> $@
	@echo "ls"                                                   >> $@
	@echo ""                                                     >> $@
	@echo "# ── DFF → liberty cell mapping ──"                  >> $@
	@echo "dfflibmap -liberty $(LIB_FILE)"                       >> $@
	@echo ""                                                     >> $@
	@echo "# ── ABC: single pass, timing-driven ──"             >> $@
	@echo "# -D $(CLK_PS): delay target (ps) = clock period"    >> $@
	@echo "# No -dff: do NOT retime across register boundaries" >> $@
	@echo "abc -liberty $(LIB_FILE) -D $(CLK_PS)"               >> $@
	@echo ""                                                     >> $@
	@echo "# ── Final cleanup and stats ──"                     >> $@
	@echo "opt_clean"                                            >> $@
	@echo "stat -liberty $(LIB_FILE)"                            >> $@
	@echo "# ── Final hierarchy ──"                             >> $@
	@echo "ls"                                                   >> $@
	@echo ""                                                     >> $@
	@echo "# ── Write netlist ──"                                >> $@
	@echo "write_verilog -noattr $(SYN_NET)"                     >> $@

$(SYN_NET): $(RTL_ALL) $(LUT_HEX) $(SYN_SCRIPT)
	$(YOSYS) -s $(SYN_SCRIPT)

# ── STA ──────────────────────────────────────────────────────

# STA flags: standalone sta accepts -no_splash, openroad does not
STA_FLAGS  = -exit $(if $(filter sta,$(notdir $(STA))),-no_splash,)

sta: $(SYN_NET) $(STA_SCRIPT)
	$(STA) $(STA_FLAGS) $(STA_SCRIPT)

$(STA_SCRIPT): | $(SYN_NET)
	@echo "read_liberty $(LIB_FILE)"                          >  $@
	@echo "read_verilog $(SYN_NET)"                           >> $@
	@echo "link_design dds_top"                               >> $@
	@echo "create_clock -name clk -period $(CLK_PERIOD) [get_ports clk]" >> $@
	@echo "create_clock -name sclk -period 20.0 [get_ports sclk]"   >> $@
	@echo "create_clock -name csn_clk -period 1000.0 [get_ports csn]" >> $@
	@echo ""                                                  >> $@
	@echo "# CDC false paths — crossing handled by sync_edge and io_update protocol" >> $@
	@echo "set_false_path -from [get_clocks sclk]    -to [get_clocks clk]"  >> $@
	@echo "set_false_path -from [get_clocks clk]     -to [get_clocks sclk]" >> $@
	@echo "set_false_path -from [get_clocks csn_clk] -to [get_clocks clk]"  >> $@
	@echo "set_false_path -from [get_clocks csn_clk] -to [get_clocks sclk]" >> $@
	@echo "set_false_path -from [get_clocks sclk]    -to [get_clocks csn_clk]" >> $@
	@echo ""                                                  >> $@
	@echo "puts \"\n=== WORST PATH (max) ===\""               >> $@
	@echo "report_checks -path_delay max -fields {fanout capacitance slew} -digits 3" >> $@
	@echo ""                                                  >> $@
	@echo "puts \"\n=== WORST PATH (min / hold) ===\""        >> $@
	@echo "report_checks -path_delay min -digits 3"           >> $@
	@echo ""                                                  >> $@
	@echo "puts \"\n=== freq_ctrl ===\""                      >> $@
	@echo "report_checks -path_delay max -through [get_cells u_freq/*] -fields {fanout capacitance slew} -digits 3" >> $@
	@echo ""                                                  >> $@
	@echo "puts \"\n=== seg_timer (inside freq_ctrl) ===\""   >> $@
	@echo "report_checks -path_delay max -through [get_cells u_freq/u_timer/*] -fields {fanout capacitance slew} -digits 3" >> $@
	@echo ""                                                  >> $@
	@echo "puts \"\n=== phase_accum ===\""                    >> $@
	@echo "report_checks -path_delay max -through [get_cells u_accum/*] -fields {fanout capacitance slew} -digits 3" >> $@
	@echo ""                                                  >> $@
	@echo "puts \"\n=== datapath ===\""                       >> $@
	@echo "report_checks -path_delay max -through [get_cells u_dp/*] -fields {fanout capacitance slew} -digits 3" >> $@
	@echo ""                                                  >> $@
	@echo "puts \"\n=== sine_rom ===\""                       >> $@
	@echo "report_checks -path_delay max -through [get_cells u_dp/u_rom/*] -fields {fanout capacitance slew} -digits 3" >> $@
	@echo ""                                                  >> $@
	@echo "puts \"\n=== SUMMARY ===\""                        >> $@
	@echo "report_tns"                                        >> $@
	@echo "report_wns"                                        >> $@

# ── Gate-level sim ───────────────────────────────────────────

sim_syn: $(SYN_NET)
	cp $(LUT_HEX) $(SIM_DIR)/
	$(IVERILOG) -Wall -g2012 -o $(SIM_DIR)/tb_dds_top_syn.vvp \
	    $(CELL_VLOG) $(SYN_NET) $(TOP_TB)
	cd $(SIM_DIR) && $(VVP) tb_dds_top_syn.vvp
	@echo "Gate-level sim done → $(SIM_DIR)/tb_dds_top_syn.vcd"

# ── Place & Route (OpenROAD) ─────────────────────────────────

PNR_SCRIPT = $(SYN_DIR)/pnr.tcl
PNR_SDC    = $(SYN_DIR)/pnr.sdc
PNR_DEF    = $(SYN_DIR)/dds_top_pnr.def
PNR_GDS    = $(SYN_DIR)/dds_top.gds
LIB_DIR    = $(PDK_ROOT)/gf180mcuD/libs.ref/$(SCL)
TECH_LEF   = $(LIB_DIR)/techlef/$(SCL)__max.tlef
CELL_LEF   = $(LIB_DIR)/lef/$(SCL).lef
SITE_NAME  ?= GF018hv5v_green_sc9

pnr: $(PNR_DEF)

$(PNR_SDC): | $(SYN_DIR)
	@echo "create_clock -name clk -period $(CLK_PERIOD) [get_ports clk]"   >  $@
	@echo "create_clock -name sclk -period 20.0 [get_ports sclk]"         >> $@
	@echo "set_clock_groups -asynchronous \\"                              >> $@
	@echo "    -group [get_clocks clk] \\"                                 >> $@
	@echo "    -group [get_clocks sclk]"                                   >> $@
	@echo "set_input_delay  0.1 -clock clk [get_ports {rst_n io_update start sync_in freq_trigger sym_trigger sym_idx* freq_sel}]" >> $@
	@echo "set_output_delay 0.1 -clock clk [get_ports {dac_i* dac_q* chirp_active chirp_done}]" >> $@
	@echo "set_input_delay  2.0 -clock sclk [get_ports {csn mosi}]"       >> $@
	@echo "set_output_delay 2.0 -clock sclk [get_ports {miso}]"           >> $@
	@echo "set_max_fanout 16 [current_design]"                             >> $@
	@echo "set_max_transition 0.3 [current_design]"                        >> $@

$(PNR_SCRIPT): | $(SYN_DIR)
	@echo "read_lef $(TECH_LEF)"                                           >  $@
	@echo "read_lef $(CELL_LEF)"                                           >> $@
	@echo "read_liberty $(LIB_FILE)"                                       >> $@
	@echo "read_verilog $(SYN_NET)"                                        >> $@
	@echo "link_design dds_top"                                            >> $@
	@echo "read_sdc $(PNR_SDC)"                                            >> $@
	@echo ""                                                               >> $@
	@echo "initialize_floorplan -utilization 35 -aspect_ratio 1.0 -core_space 10 -site $(SITE_NAME)" >> $@
	@echo ""                                                               >> $@
	@echo "make_tracks Metal1 -x_offset 0.24 -x_pitch 0.48 -y_offset 0.28 -y_pitch 0.56" >> $@
	@echo "make_tracks Metal2 -x_offset 0.28 -x_pitch 0.56 -y_offset 0.24 -y_pitch 0.48" >> $@
	@echo "make_tracks Metal3 -x_offset 0.28 -x_pitch 0.56 -y_offset 0.28 -y_pitch 0.56" >> $@
	@echo "make_tracks Metal4 -x_offset 0.28 -x_pitch 0.56 -y_offset 0.28 -y_pitch 0.56" >> $@
	@echo "make_tracks Metal5 -x_offset 0.28 -x_pitch 0.56 -y_offset 0.28 -y_pitch 0.56" >> $@
	@echo ""                                                               >> $@
	@echo "set_routing_layers -signal Metal1-Metal5"                       >> $@
	@echo "set_wire_rc -signal -layer Metal3"                              >> $@
	@echo "set_wire_rc -clock -layer Metal4"                               >> $@
	@echo ""                                                               >> $@
	@echo "place_pins -hor_layers Metal3 -ver_layers Metal2"               >> $@
	@echo ""                                                               >> $@
	@echo "add_global_connection -net VDD -pin_pattern VDD -power"         >> $@
	@echo "add_global_connection -net VSS -pin_pattern VSS -ground"        >> $@
	@echo "set_voltage_domain -power VDD -ground VSS"                      >> $@
	@echo "define_pdn_grid -name core -pins {Metal5}"                      >> $@
	@echo "add_pdn_stripe -grid core -layer Metal1 -width 0.48 -followpins" >> $@
	@echo "add_pdn_stripe -grid core -layer Metal4 -width 1.6 -spacing 1.6 -pitch 40.0 -offset 2.0" >> $@
	@echo "add_pdn_stripe -grid core -layer Metal5 -width 1.6 -spacing 1.6 -pitch 40.0 -offset 2.0" >> $@
	@echo "add_pdn_connect -layers {Metal1 Metal4}"                        >> $@
	@echo "add_pdn_connect -layers {Metal4 Metal5}"                        >> $@
	@echo "pdngen"                                                         >> $@
	@echo ""                                                               >> $@
	@echo "global_placement -density 0.45 -pad_left 2 -pad_right 2"       >> $@
	@echo "estimate_parasitics -placement"                                 >> $@
	@echo "repair_design"                                                  >> $@
	@echo "detailed_placement"                                             >> $@
	@echo "check_placement"                                                >> $@
	@echo ""                                                               >> $@
	@echo "clock_tree_synthesis -root_buf $(SCL)__clkbuf_8 -buf_list {$(SCL)__clkbuf_2 $(SCL)__clkbuf_4 $(SCL)__clkbuf_8} -sink_clustering_enable" >> $@
	@echo "set_propagated_clock [all_clocks]"                              >> $@
	@echo "repair_clock_nets"                                              >> $@
	@echo "detailed_placement"                                             >> $@
	@echo ""                                                               >> $@
	@echo "estimate_parasitics -placement"                                 >> $@
	@echo "repair_timing -setup -verbose"                                  >> $@
	@echo "repair_timing -hold -verbose"                                   >> $@
	@echo "detailed_placement"                                             >> $@
	@echo ""                                                               >> $@
	@echo "global_route -verbose -allow_congestion"                        >> $@
	@echo "detailed_route -output_drc $(SYN_DIR)/route_drc.rpt -bottom_routing_layer Metal1 -top_routing_layer Metal5" >> $@
	@echo ""                                                               >> $@
	@echo "estimate_parasitics -global_routing"                            >> $@
	@echo "report_checks -path_delay max -slack_max -0.0 -group_count 5"  >> $@
	@echo "report_checks -path_delay min -slack_max -0.0 -group_count 5"  >> $@
	@echo "report_tns"                                                     >> $@
	@echo "report_wns"                                                     >> $@
	@echo "report_clock_skew"                                              >> $@
	@echo "report_design_area"                                             >> $@
	@echo ""                                                               >> $@
	@echo "write_def $(PNR_DEF)"                                           >> $@
	@echo "write_verilog $(SYN_DIR)/dds_top_pnr.v"                        >> $@

$(PNR_DEF): $(SYN_NET) $(PNR_SDC) $(PNR_SCRIPT)
	$(OPENROAD) $(PNR_SCRIPT) 2>&1 | tee $(SYN_DIR)/pnr.log

# ── GDS (KLayout) ───────────────────────────────────────────

gds: $(PNR_GDS)

$(PNR_GDS): $(PNR_DEF)
	$(KLAYOUT) -zz \
	  -rd design_name=dds_top \
	  -rd in_def=$(PNR_DEF) \
	  -rd in_gds=$(LIB_DIR)/gds/$(SCL).gds \
	  -rd out_gds=$(PNR_GDS) \
	  -rd seal_gds="" \
	  -rm scripts/def2gds.py
	@echo "GDS → $(PNR_GDS)"

# ── Clean ────────────────────────────────────────────────────

clean:
	rm -f $(LUT_HEX) $(SIM_DIR)/*.vvp $(SIM_DIR)/*.vcd $(SIM_DIR)/sine_lut.hex
	rm -rf $(SYN_DIR)
