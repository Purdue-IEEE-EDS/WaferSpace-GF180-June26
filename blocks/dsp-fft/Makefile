TOP = fft

# ---------------- Tools ----------------
YOSYS    ?= yosys
IVERILOG ?= iverilog
VVP      ?= vvp
STA      ?= sta
OPENROAD ?= openroad
KLAYOUT    ?= klayout

# ---------------- PDK ----------------
PDK_ROOT ?= /headless/QucsWorkspace/IHP-Open-PDK
SCL      ?= gf180mcu_fd_sc_mcu9t5v0
CORNER   ?= tt_025C_3v30

LIB_DIR  = $(PDK_ROOT)/gf180mcuD/libs.ref/$(SCL)
LIB_FILE = $(LIB_DIR)/lib/$(SCL)__$(CORNER).lib

TECH_LEF = $(LIB_DIR)/techlef/$(SCL)__max.tlef
CELL_LEF = $(LIB_DIR)/lef/$(SCL).lef

CELL_VLOG = $(LIB_DIR)/verilog/primitives.v \
            $(LIB_DIR)/verilog/$(SCL).v

SITE_NAME  ?= GF018hv5v_green_sc9

CLK_PERIOD ?= 6.25
CLK_PS     ?= 6250

# ---------------- Directories ----------------
RTL_DIR = src
TB_DIR  = tb
SIM_DIR = sim
SYN_DIR = syn
PNR_DIR = $(SYN_DIR)/pnr

# ---------------- RTL ----------------
RTL = \
	$(RTL_DIR)/fft.sv \
	$(RTL_DIR)/mdc_stage.sv \
	$(RTL_DIR)/mdc_ram_delay.sv \
	$(RTL_DIR)/r2.sv \
	$(RTL_DIR)/rotator.sv \
	$(RTL_DIR)/triv_rotator.sv \
	$(RTL_DIR)/adder.sv \
	$(RTL_DIR)/CLA4.sv \
	$(RTL_DIR)/CLA16.sv \
	$(RTL_DIR)/CLA32.sv \
	$(RTL_DIR)/full_adder_cla.sv \
	$(RTL_DIR)/wallace_mult.sv \
	$(RTL_DIR)/full_adder.sv \
	$(RTL_DIR)/half_adder.sv \
	$(RTL_DIR)/carry_save_adder.sv \
	$(RTL_DIR)/commutator.sv \
	$(RTL_DIR)/twiddle_rom.sv 

TB_FFT   = $(TB_DIR)/tb_fft.sv
TB_STAGE = $(TB_DIR)/tb_mdc_stage.sv

# ---------------- Outputs ----------------
FFT_VVP      = $(SIM_DIR)/tb_fft.vvp
STAGE_VVP    = $(SIM_DIR)/tb_mdc_stage.vvp
SYN_NET      = $(SYN_DIR)/fft_syn.v
SIM_SYN_VVP  = $(SIM_DIR)/tb_fft_syn.vvp

PNR_SCRIPT   = $(PNR_DIR)/pnr.tcl
PNR_SDC      = $(PNR_DIR)/fft.sdc
PNR_DEF      = $(PNR_DIR)/fft_pnr.def
PNR_GDS      = $(PNR_DIR)/fft.gds

SYN_SCRIPT   = $(SYN_DIR)/synth.ys
STA_SCRIPT   = $(SYN_DIR)/sta.tcl
STA_PNR_SCRIPT = $(SYN_DIR)/sta_pnr.tcl

# ============================================================
# SIMULATION (RTL)
# ============================================================

$(FFT_VVP): $(RTL) $(TB_FFT)
	mkdir -p $(SIM_DIR)
	$(IVERILOG) -g2012 -o $@ $(RTL) $(TB_FFT)

sim_fft: $(FFT_VVP)
	cp $(RTL_DIR)/*.mem $(SIM_DIR)/ 2>/dev/null || true
	cd $(SIM_DIR) && $(VVP) tb_fft.vvp

$(STAGE_VVP): $(RTL) $(TB_STAGE)
	mkdir -p $(SIM_DIR)
	$(IVERILOG) -g2012 -o $@ \
		$(RTL_DIR)/mdc_stage.sv \
		$(RTL_DIR)/mdc_ram_delay.sv \
		$(RTL_DIR)/rotator.sv \
		$(RTL_DIR)/triv_rotator.sv \
		$(RTL_DIR)/r2.sv \
		$(RTL_DIR)/adder.sv \
		$(RTL_DIR)/CLA4.sv \
		$(RTL_DIR)/CLA16.sv \
		$(RTL_DIR)/CLA32.sv \
		$(RTL_DIR)/full_adder_cla.sv \
		$(RTL_DIR)/twiddle_rom.sv \
		$(RTL_DIR)/wallace_mult.sv \
		$(RTL_DIR)/full_adder.sv \
		$(RTL_DIR)/half_adder.sv \
		$(RTL_DIR)/carry_save_adder.sv \
		$(RTL_DIR)/commutator.sv \
		$(TB_STAGE)

sim_stage: $(STAGE_VVP)
	cp $(RTL_DIR)/*.mem $(SIM_DIR)/ 2>/dev/null || true
	cd $(SIM_DIR) && $(VVP) tb_mdc_stage.vvp

sim: sim_stage sim_fft

# ============================================================
# SYNTHESIS
# ============================================================

$(SYN_SCRIPT): $(RTL)
	@mkdir -p $(SYN_DIR)
	@echo "# ── Read RTL ──"                                     >>  $@
	@echo "read_liberty -lib $(LIB_FILE)"                                >> $@
	@echo "read_verilog -sv $(RTL)"                          >> $@
	@echo ""                                                     >> $@
	@echo "# ── Elaborate hierarchy ──"                          >> $@
	@echo "hierarchy -top $(TOP) -check"                        >> $@
	@echo "# ── Post-elaborate hierarchy ──"                    >> $@
	@echo "ls"                                                   >> $@
	@echo ""                                                     >> $@
	@echo "# ── Behavioral → structural ──"                     >> $@
	@echo "proc"                                                 >> $@
	@echo ""                                                     >> $@
	@echo "# ── FLATTEN — dont preserve module boundaries ──"     >> $@
	@echo ""                                                     >> $@
	@echo "opt_clean"                                            >> $@
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
	@echo "splitnets -driver"                                    >> $@
	@echo "opt -fast"                                            >> $@
	@echo ""                                                     >> $@
	@echo "opt_clean"                                            >> $@
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
	@echo "abc -liberty $(LIB_FILE) -D $(CLK_PS) "               >> $@
	@echo ""                                                     >> $@
	@echo "# ── Final cleanup and stats ──"                     >> $@
	@echo "opt_clean"                                            >> $@
	@echo "stat -liberty $(LIB_FILE)"                            >> $@
	@echo "# ── Final hierarchy ──"                             >> $@
	@echo "ls"                                                   >> $@
	@echo ""                                                     >> $@
	@echo "# ── Write netlist ──"                                >> $@
	@echo "write_verilog -noattr $(SYN_NET)"                     >> $@

$(SYN_NET): $(RTL) $(SYN_SCRIPT)
	$(YOSYS) -s $(SYN_SCRIPT)

syn: $(SYN_NET)

# ============================================================
# STA 
# ============================================================

sta: $(SYN_NET) $(STA_SCRIPT)
	$(STA) -exit -no_splash $(STA_SCRIPT)

$(STA_SCRIPT): | $(SYN_DIR)
	@echo "read_liberty $(LIB_FILE)"                           >  $@
	@echo "read_verilog $(SYN_NET)"                            >> $@
	@echo "link_design $(TOP)"                                >> $@
	@echo "create_clock -name clk -period $(CLK_PERIOD) [get_ports clk]" >> $@
	@echo ""                                                  >> $@
	@echo "puts \"\n=== WORST PATH (max) ===\""               >> $@
	@echo "report_checks -path_delay max -group_count 10 -fields {fanout capacitance slew} -digits 3" >> $@
	@echo ""                                                  >> $@
	@echo "puts \"\n=== WORST PATH (min / hold) ===\""        >> $@
	@echo "report_checks -path_delay min -digits 3"           >> $@
	@echo ""                                                  >> $@
	@echo "puts \"\n=== SUMMARY ===\""                        >> $@
	@echo "report_tns"                                        >> $@
	@echo "report_wns"                                        >> $@

# ============================================================
# GATE SIM
# ============================================================

sim_syn: $(SYN_NET)
	mkdir -p $(SIM_DIR)
	$(IVERILOG) -g2012 -o $(SIM_SYN_VVP) \
		$(CELL_VLOG) \
		$(SYN_NET) \
		$(TB_FFT)
	cd $(SIM_DIR) && $(VVP) tb_fft_syn.vvp

# ============================================================
# PNR (OpenROAD)
# ============================================================

pnr: $(PNR_DEF)

$(PNR_SDC): | $(PNR_DIR)
	@echo "create_clock -name clk -period $(CLK_PERIOD) [get_ports clk]"   >> $@
	@echo "set_max_fanout 16 [current_design]"                             >> $@
	@echo "set_max_transition 1.5 [current_design]"                        >> $@
	@echo "set_false_path -from [get_ports rst]"                           >> $@
	@echo "set_false_path -to [get_pins -quiet stages_gen_blk[*].stage/*/RN]" >> $@

$(PNR_SCRIPT): | $(PNR_DIR)
	@echo "read_lef $(TECH_LEF)"                                           >  $@
	@echo "read_lef $(CELL_LEF)"                                           >> $@
	@echo "read_liberty $(LIB_FILE)"                                       >> $@
	@echo "read_verilog $(SYN_NET)"                                        >> $@
	@echo "link_design $(TOP)"                                             >> $@
	@echo "read_sdc $(PNR_SDC)"                                            >> $@
	@echo ""                                                               >> $@
	@echo "initialize_floorplan -utilization 35 -aspect_ratio 1.0 -core_space 10 -site $(SITE_NAME)" >> $@
	@echo ""                                                               >> $@
	@echo "insert_tiecells gf180mcu_fd_sc_mcu9t5v0__tiel/ZN -prefix TIE_LOW_"   >> $@
	@echo "insert_tiecells gf180mcu_fd_sc_mcu9t5v0__tieh/Z -prefix TIE_HIGH_"  >> $@
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
	@echo "add_global_connection -net VDD -pin_pattern VDD -power"          >> $@
	@echo "add_global_connection -net VSS -pin_pattern VSS -ground"         >> $@
	@echo "set_voltage_domain -power VDD -ground VSS"                      >> $@
	@echo "define_pdn_grid -name core -pins {Metal5}"                      >> $@
	@echo "add_pdn_stripe -grid core -layer Metal1 -width 0.48 -followpins" >> $@
	@echo "add_pdn_stripe -grid core -layer Metal4 -width 1.6 -spacing 1.6 -pitch 40.0 -offset 2.0" >> $@
	@echo "add_pdn_stripe -grid core -layer Metal5 -width 1.6 -spacing 1.6 -pitch 40.0 -offset 2.0" >> $@
	@echo "add_pdn_connect -layers {Metal1 Metal4}"                        >> $@
	@echo "add_pdn_connect -layers {Metal4 Metal5}"                        >> $@
	@echo "pdngen"                                                         >> $@
	@echo ""                                                               >> $@
	@echo "global_placement -density 0.45 -pad_left 2 -pad_right 2"        >> $@
	@echo "estimate_parasitics -placement"                                 >> $@
	@echo "# repair_design"                                                  >> $@
	@echo "detailed_placement"                                             >> $@
	@echo "estimate_parasitics -placement"                                 >> $@
	@echo "check_placement"                                                >> $@
	@echo ""                                                               >> $@
	@echo "clock_tree_synthesis -root_buf $(SCL)__clkbuf_8 -buf_list {$(SCL)__clkbuf_2 $(SCL)__clkbuf_4 $(SCL)__clkbuf_8} -sink_clustering_enable" >> $@
	@echo "set_propagated_clock [all_clocks]"                              >> $@
	@echo "repair_clock_nets"                                              >> $@
	@echo "detailed_placement"                                             >> $@
	@echo ""                                                               >> $@
	@echo "estimate_parasitics -placement"                                 >> $@
	@echo "repair_timing -setup -setup_margin 0.05 -verbose"               >> $@
	@echo "repair_timing -hold -hold_margin 0.05 -verbose"                 >> $@
	@echo "detailed_placement"                                             >> $@
	@echo ""                                                               >> $@
	@echo "global_route -verbose -allow_congestion"                        >> $@
	@echo "set_routing_layers -signal Metal1-Metal5"                       >> $@
	@echo "detailed_route"   >> $@
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
	@echo "write_verilog $(SYN_DIR)/fft_pnr.v"                             >> $@

$(PNR_DIR):
	mkdir -p $(PNR_DIR)

$(SYN_DIR):
	mkdir -p $(SYN_DIR)

$(PNR_DEF): $(SYN_NET) $(PNR_SDC) $(PNR_SCRIPT)
	$(OPENROAD) -exit $(PNR_SCRIPT) 2>&1 | tee $(SYN_DIR)/pnr.log

# ============================================================
# GDS
# ============================================================

gds: $(PNR_GDS)

$(PNR_GDS): $(PNR_DEF)
	$(KLAYOUT) -zz -u \
	  -rd design_name=fft \
	  -rd in_def=$(PNR_DEF) \
	  -rd in_gds=$(LIB_DIR)/gds/$(SCL).gds \
	  -rd out_gds=$(PNR_GDS) \
	  -rd seal_gds="" \
	  -r /openlane/scripts/klayout/def2gds.py
	@echo "GDS ? $(PNR_GDS)"

# ============================================================
# CLEAN
# ============================================================

clean:
	rm -rf $(SIM_DIR) $(SYN_DIR)
