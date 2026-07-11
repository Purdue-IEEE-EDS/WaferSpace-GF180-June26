# DDS Modulator — Makefile
SINE_TRUNC_W ?= 14
SINE_COARSE_W ?= 7
SINE_GUARD_W ?= 3
SINE_SLOPE_W ?= 8
MAG_W        ?= 9
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
FTW_DIR    = rtl/ftw
PHASE_DIR  = rtl/phase
DP_DIR     = rtl/datapath
DAC_DIR    = rtl/cal_dac
CMN_DIR    = rtl/common
SPI_DIR    = rtl/spi
SER_DIR    = rtl/serializer
SIM_DIR    = sim
SYN_DIR    = syn

# ── Source files ─────────────────────────────────────────────
FTW_RTL     = $(FTW_DIR)/profile_normalizer.v \
              $(FTW_DIR)/freq_runner.v  \
              $(FTW_DIR)/ftw_ctrl.v     \
              $(FTW_DIR)/seg_timer.v    \
              $(FTW_DIR)/step_half.v    \
              $(FTW_DIR)/dp_half.v

PHASE_RTL   = $(PHASE_DIR)/phase_accum_vec4.v

BB_RTL      =

DP_RTL      = $(DP_DIR)/phase_to_sincos_interp.v \
              $(DP_DIR)/sincos_interp_rom.v      \
              $(DP_DIR)/sincos_interp_mag.v      \
              $(DP_DIR)/dac_encoder.v            \
              $(DP_DIR)/dds_datapath.v           \
              $(DP_DIR)/dds_datapath_vec.v

SER_RTL     = $(SER_DIR)/serializer_4to1.v

DAC_RTL     = $(DAC_DIR)/cal_dac_chain.v \
              $(DAC_DIR)/cal_dac_scan.v

COMMON_RTL  = $(CMN_DIR)/carry_out.v     \
              $(CMN_DIR)/clock_divider_4x.v \
              $(CMN_DIR)/reset_sync.v    \
              $(CMN_DIR)/sync_edge.v

DDS_RTL     = $(FTW_RTL) $(PHASE_RTL) $(DP_RTL) $(SER_RTL) $(DAC_RTL) $(COMMON_RTL)

SPI_RTL    = $(SPI_DIR)/spi_slave.v        \
             $(SPI_DIR)/dds_regmap.v

TOP_RTL    = $(RTL_DIR)/dds_top.v

RTL_ALL    = $(DDS_RTL) $(SPI_RTL) $(TOP_RTL)

FREQ_TB    = $(SIM_DIR)/tb_freq_ctrl.v
ACCUM_TB   = $(SIM_DIR)/tb_phase_accum.v
SPI_TB     = $(SIM_DIR)/tb_spi_slave.v
SPI_SWEEP_TB = $(SIM_DIR)/tb_dds_spi_sclk_sweep.v
CAL_DAC_TB = $(SIM_DIR)/tb_cal_dac_chain.v
CAL_DAC_SCAN_TB = $(SIM_DIR)/tb_cal_dac_scan.v
CAL_DAC_AMS_TB = $(SIM_DIR)/tb_cal_dac_ams.v
CAL_DAC_SPI_TB = $(SIM_DIR)/tb_cal_dac_spi.v
MAIN_DAC_AMS_TB = $(SIM_DIR)/tb_main_dac_ams.v
TOP_TB     = $(SIM_DIR)/tb_dds_top.v
USER_E2E_TB = $(SIM_DIR)/tb_dds_user_e2e.v
DIRECT_BYPASS_TB = $(SIM_DIR)/tb_dds_direct_bypass.v
WAVE_SCAN_MATCH_TB = $(SIM_DIR)/tb_dds_wave_scan_match.v

LUT_V      = $(DP_DIR)/sincos_interp_init.v
LUT_HEX    = $(DP_DIR)/sincos_interp.hex
LUT_SCRIPT = scripts/gen_sincos_interp.py

SYN_NET    = $(SYN_DIR)/dds_top_syn.v
SYN_SCRIPT = $(SYN_DIR)/synth.ys

# STA tool: use standalone 'sta' if found, else fall back to 'openroad'
#STA        ?= $(shell command -v openroad >/dev/null 2>&1 && echo openroad || { command -v sta >/dev/null 2>&1 && echo sta; })
STA ?= openroad
OPENROAD   ?= openroad
KLAYOUT    ?= klayout

# Clock plan for the 4:1 DDS build:
#   clk      = external fast 4x serializer clock at 500 MHz
#   clk_4x   = internal alias of top-level clk
#   clk_vec  = internal divide-by-4 vector clock at 125 MHz
SER_CLK_PERIOD ?= 2.0
SER_CLK_PS     ?= 2000
FAST_CLK_NAME  ?= clk_4x

DDS_CFG_IN_PORTS = dds_spi_clk dds_ftw_a* dds_ftw_b* dds_ftw_step* dds_chirp_n* dds_mode* dds_auto_restart dds_phase_rst_on_launch dds_cal_code* dds_direct_en dds_direct_i* dds_direct_q*
CORE_SYNC_IN_PORTS = io_update sync_in
CORE_ASYNC_IN_PORTS = rst_n $(DDS_CFG_IN_PORTS)
CORE_OUT_PORTS = dac_i* dac_q* cal_clk cal_data cal_load
STA_SCRIPT = $(SYN_DIR)/sta.tcl
CELL_VLOG  = $(PDK_ROOT)/gf180mcuD/libs.ref/$(SCL)/verilog/primitives.v \
             $(PDK_ROOT)/gf180mcuD/libs.ref/$(SCL)/verilog/$(SCL).v

.PHONY: all lut lut_hex lint sim sim_freq sim_accum sim_spi sim_spi_sweep sim_cal_dac sim_cal_dac_scan sim_cal_dac_ams sim_cal_dac_spi sim_cal_dac_e2e sim_main_dac_ams sim_top sim_user_e2e sim_direct_bypass sim_wave_scan_match wave syn sta sta_buf sim_syn gds clean \
       $(SYN_SCRIPT) $(STA_SCRIPT) $(STA_BUF_SCRIPT) $(STA_BUF_SDC)

all: lut lint sim

# ── LUT generation ───────────────────────────────────────────

lut: $(LUT_V)

$(LUT_V): $(LUT_SCRIPT)
	$(PYTHON) $(LUT_SCRIPT) $(SINE_TRUNC_W) $(MAG_W) $(SINE_COARSE_W) $(SINE_GUARD_W) $(SINE_SLOPE_W) $(LUT_V)

lut_hex: $(LUT_HEX)

$(LUT_HEX): $(LUT_SCRIPT)
	$(PYTHON) $(LUT_SCRIPT) $(SINE_TRUNC_W) $(MAG_W) $(SINE_COARSE_W) $(SINE_GUARD_W) $(SINE_SLOPE_W) $(LUT_HEX)

# ── Lint ─────────────────────────────────────────────────────

lint: $(LUT_V) $(RTL_ALL)
	$(IVERILOG) -Wall -g2012 -tnull $(RTL_ALL)
	@echo "Lint OK"

# ── freq_runner unit test ───────────────────────────────────

$(SIM_DIR)/tb_freq_ctrl.vvp: $(FTW_DIR)/freq_runner.v $(FTW_DIR)/seg_timer.v $(FTW_DIR)/dp_half.v $(FTW_DIR)/step_half.v $(FREQ_TB)
	$(IVERILOG) -Wall -g2012 -o $@ $(FTW_DIR)/freq_runner.v $(FTW_DIR)/seg_timer.v $(FTW_DIR)/dp_half.v $(FTW_DIR)/step_half.v $(FREQ_TB)

sim_freq: $(SIM_DIR)/tb_freq_ctrl.vvp
	cd $(SIM_DIR) && $(VVP) tb_freq_ctrl.vvp
	@echo "Waveform → $(SIM_DIR)/tb_freq_ctrl.vcd"

# ── phase_accum unit test ───────────────────────────────────

$(SIM_DIR)/tb_phase_accum.vvp: $(PHASE_DIR)/phase_accum_vec4.v $(ACCUM_TB)
	$(IVERILOG) -Wall -g2012 -o $@ $(PHASE_DIR)/phase_accum_vec4.v $(ACCUM_TB)

sim_accum: $(SIM_DIR)/tb_phase_accum.vvp
	cd $(SIM_DIR) && $(VVP) tb_phase_accum.vvp
	@echo "Waveform → $(SIM_DIR)/tb_phase_accum.vcd"

# ── SPI slave unit test ─────────────────────────────────────

$(SIM_DIR)/tb_spi_slave.vvp: $(SPI_DIR)/spi_slave.v $(SPI_DIR)/dds_regmap.v $(SPI_TB)
	$(IVERILOG) -Wall -g2012 -o $@ $(SPI_DIR)/spi_slave.v $(SPI_DIR)/dds_regmap.v $(SPI_TB)

sim_spi: $(SIM_DIR)/tb_spi_slave.vvp
	cd $(SIM_DIR) && $(VVP) tb_spi_slave.vvp
	@echo "Waveform → $(SIM_DIR)/tb_spi_slave.vcd"

$(SIM_DIR)/tb_dds_spi_sclk_sweep.vvp: $(LUT_V) $(RTL_ALL) $(SPI_SWEEP_TB)
	$(IVERILOG) -Wall -g2012 -o $@ $(RTL_ALL) $(SPI_SWEEP_TB)

sim_spi_sweep: $(SIM_DIR)/tb_dds_spi_sclk_sweep.vvp
	cd $(SIM_DIR) && $(VVP) tb_dds_spi_sclk_sweep.vvp
	@echo "Waveform → $(SIM_DIR)/tb_dds_spi_sclk_sweep.vcd"

# ── Calibration DAC scan-chain unit test ───────────────────

$(SIM_DIR)/tb_cal_dac_chain.vvp: $(DAC_RTL) $(CAL_DAC_TB)
	$(IVERILOG) -Wall -g2012 -o $@ $(DAC_RTL) $(CAL_DAC_TB)

sim_cal_dac: $(SIM_DIR)/tb_cal_dac_chain.vvp
	cd $(SIM_DIR) && $(VVP) tb_cal_dac_chain.vvp
	@echo "Waveform → $(SIM_DIR)/tb_cal_dac_chain.vcd"

$(SIM_DIR)/tb_cal_dac_scan.vvp: $(DAC_RTL) $(CAL_DAC_SCAN_TB)
	$(IVERILOG) -Wall -g2012 -o $@ $(DAC_RTL) $(CAL_DAC_SCAN_TB)

sim_cal_dac_scan: $(SIM_DIR)/tb_cal_dac_scan.vvp
	cd $(SIM_DIR) && $(VVP) tb_cal_dac_scan.vvp
	@echo "Waveform → $(SIM_DIR)/tb_cal_dac_scan.vcd"

$(SIM_DIR)/tb_cal_dac_ams.vvp: $(LUT_V) $(RTL_ALL) $(CAL_DAC_AMS_TB)
	$(IVERILOG) -Wall -g2012 -o $@ $(RTL_ALL) $(CAL_DAC_AMS_TB)

sim_cal_dac_ams: $(SIM_DIR)/tb_cal_dac_ams.vvp
	cd $(SIM_DIR) && $(VVP) tb_cal_dac_ams.vvp
	@echo "Waveform → $(SIM_DIR)/tb_cal_dac_ams.vcd"

$(SIM_DIR)/tb_main_dac_ams.vvp: $(LUT_V) ams/ams/main_dac_codegen.v $(MAIN_DAC_AMS_TB)
	$(IVERILOG) -Wall -g2012 -o $@ ams/ams/main_dac_codegen.v $(MAIN_DAC_AMS_TB)

sim_main_dac_ams: $(SIM_DIR)/tb_main_dac_ams.vvp
	cd $(SIM_DIR) && $(VVP) tb_main_dac_ams.vvp
	@echo "Waveform → $(SIM_DIR)/tb_main_dac_ams.vcd"

$(SIM_DIR)/tb_cal_dac_spi.vvp: $(LUT_V) $(RTL_ALL) $(CAL_DAC_SPI_TB)
	$(IVERILOG) -Wall -g2012 -o $@ $(RTL_ALL) $(CAL_DAC_SPI_TB)

sim_cal_dac_spi: $(SIM_DIR)/tb_cal_dac_spi.vvp
	cd $(SIM_DIR) && $(VVP) tb_cal_dac_spi.vvp
	@echo "Waveform → $(SIM_DIR)/tb_cal_dac_spi.vcd"

sim_cal_dac_e2e: sim_cal_dac_spi

# ── Top-level integration test ──────────────────────────────

$(SIM_DIR)/tb_dds_top.vvp: $(LUT_V) $(RTL_ALL) $(TOP_TB)
	$(IVERILOG) -Wall -g2012 -o $@ $(RTL_ALL) $(TOP_TB)

sim_top: $(SIM_DIR)/tb_dds_top.vvp
	cd $(SIM_DIR) && $(VVP) tb_dds_top.vvp
	@echo "Waveform → $(SIM_DIR)/tb_dds_top.vcd"

$(SIM_DIR)/tb_dds_user_e2e.vvp: $(LUT_V) $(RTL_ALL) $(USER_E2E_TB)
	$(IVERILOG) -Wall -g2012 -o $@ $(RTL_ALL) $(USER_E2E_TB)

sim_user_e2e: $(SIM_DIR)/tb_dds_user_e2e.vvp
	cd $(SIM_DIR) && $(VVP) tb_dds_user_e2e.vvp
	@echo "Waveform → $(SIM_DIR)/tb_dds_user_e2e.vcd"
	@echo "CSV      → $(SIM_DIR)/tb_dds_user_e2e_wave.csv"

$(SIM_DIR)/tb_dds_direct_bypass.vvp: $(LUT_V) $(RTL_ALL) $(DIRECT_BYPASS_TB)
	$(IVERILOG) -Wall -g2012 -o $@ $(RTL_ALL) $(DIRECT_BYPASS_TB)

sim_direct_bypass: $(SIM_DIR)/tb_dds_direct_bypass.vvp
	cd $(SIM_DIR) && $(VVP) tb_dds_direct_bypass.vvp
	@echo "Waveform → $(SIM_DIR)/tb_dds_direct_bypass.vcd"

$(SIM_DIR)/tb_dds_wave_scan_match.vvp: $(LUT_V) $(RTL_ALL) $(WAVE_SCAN_MATCH_TB)
	$(IVERILOG) -Wall -g2012 -o $@ $(RTL_ALL) $(WAVE_SCAN_MATCH_TB)

sim_wave_scan_match: $(SIM_DIR)/tb_dds_wave_scan_match.vvp
	cd $(SIM_DIR) && $(VVP) tb_dds_wave_scan_match.vvp
	@echo "Waveform → $(SIM_DIR)/tb_dds_wave_scan_match.vcd"
	@echo "CSV      → $(SIM_DIR)/tb_dds_wave_scan_match.csv"
	@if $(PYTHON) -c "import matplotlib" >/dev/null 2>&1; then \
		$(PYTHON) scripts/wave_scan.py --sample-rate-hz 500000000; \
	else \
		echo "Skipping scripts/wave_scan.py (matplotlib not installed)"; \
	fi

wave: sim_wave_scan_match

# ── All sim ──────────────────────────────────────────────────
#
# Runs each TB even if a previous one failed, then prints a summary
# at the end.  Exit code = number of failed TBs.  Individual targets
# (sim_freq, sim_accum, sim_spi, sim_top) still work standalone.

sim: $(SIM_DIR)/tb_freq_ctrl.vvp $(SIM_DIR)/tb_phase_accum.vvp $(SIM_DIR)/tb_spi_slave.vvp $(SIM_DIR)/tb_dds_spi_sclk_sweep.vvp $(SIM_DIR)/tb_cal_dac_chain.vvp $(SIM_DIR)/tb_cal_dac_scan.vvp $(SIM_DIR)/tb_cal_dac_ams.vvp $(SIM_DIR)/tb_cal_dac_spi.vvp $(SIM_DIR)/tb_main_dac_ams.vvp $(SIM_DIR)/tb_dds_top.vvp $(SIM_DIR)/tb_dds_user_e2e.vvp $(SIM_DIR)/tb_dds_direct_bypass.vvp $(SIM_DIR)/tb_dds_wave_scan_match.vvp
	@pass=0; fail=0; summary=""; \
	 for tb in tb_freq_ctrl tb_phase_accum tb_spi_slave tb_dds_spi_sclk_sweep tb_cal_dac_chain tb_cal_dac_scan tb_cal_dac_ams tb_cal_dac_spi tb_main_dac_ams tb_dds_top tb_dds_user_e2e tb_dds_direct_bypass tb_dds_wave_scan_match; do \
	     printf "\n================= %s =================\n" $$tb; \
	     out=$$(cd $(SIM_DIR) && $(VVP) $$tb.vvp 2>&1); \
	     printf "%s\n" "$$out"; \
	     if printf "%s" "$$out" | grep -Eq "ALL TESTS PASSED"; then \
	         summary="$${summary}  PASS  $$tb\n"; \
	         pass=$$((pass+1)); \
	     else \
	         err=$$(printf "%s" "$$out" | grep -oE "FAILED: [0-9]+ error[s]?" | head -1); \
	         [ -z "$$err" ] && err="no result line"; \
	         summary="$${summary}  FAIL  $$tb  [$$err]\n"; \
	         fail=$$((fail+1)); \
	     fi; \
	 done; \
	 printf "\n========================================\n"; \
	 printf "  Test summary: %d passed, %d failed\n" $$pass $$fail; \
	 printf "========================================\n"; \
	 printf "%b" "$$summary"; \
	 printf "========================================\n"; \
	 exit $$fail

# ── Synthesis ────────────────────────────────────────────────

syn: $(SYN_NET)

$(SYN_SCRIPT): Makefile
	@mkdir -p $(SYN_DIR)
	@echo "# ── Read RTL ──"                                     >  $@
	@echo "read_verilog -sv -DSYNTHESIS $(RTL_ALL)"              >> $@
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
	@echo "# -D $(SER_CLK_PS): delay target (ps) = fast clk period" >> $@
	@echo "# No -dff: do NOT retime across register boundaries" >> $@
	@echo "abc -liberty $(LIB_FILE) -D $(SER_CLK_PS)"           >> $@
	@echo ""                                                     >> $@
	@echo "# ── Final cleanup and stats ──"                     >> $@
	@echo "opt_clean"                                            >> $@
	@echo "stat -liberty $(LIB_FILE)"                            >> $@
	@echo "# ── Final hierarchy ──"                             >> $@
	@echo "ls"                                                   >> $@
	@echo ""                                                     >> $@
	@echo "# ── Write netlist ──"                                >> $@
	@echo "write_verilog -noattr $(SYN_NET)"                     >> $@

$(SYN_NET): $(RTL_ALL) $(LUT_V) $(SYN_SCRIPT)
	$(YOSYS) -s $(SYN_SCRIPT)

# ── STA ──────────────────────────────────────────────────────

# STA flags: standalone sta accepts -no_splash, openroad does not
STA_FLAGS  = -exit $(if $(filter sta,$(notdir $(STA))),-no_splash,)

sta: $(SYN_NET) $(STA_SCRIPT)
	$(STA) $(STA_FLAGS) $(STA_SCRIPT)

$(STA_SCRIPT): $(SYN_NET) Makefile
ifeq ($(filter sta,$(notdir $(STA))),)
	@echo "read_lef $(TECH_LEF)"                              >  $@
	@echo "read_lef $(CELL_LEF)"                              >> $@
	@echo "read_liberty $(LIB_FILE)"                          >> $@
else
	@echo "read_liberty $(LIB_FILE)"                          >  $@
endif
	@echo "read_verilog $(SYN_NET)"                           >> $@
	@echo "link_design dds_top"                               >> $@
	@echo "create_clock -name $(FAST_CLK_NAME) -period $(SER_CLK_PERIOD) [get_ports clk]" >> $@
	@echo "create_generated_clock -name clk_vec -source [get_ports clk] -divide_by 4 [get_nets clk_div4]" >> $@
	@echo ""                                                  >> $@
	@echo "set_input_delay  0.1 -clock $(FAST_CLK_NAME) [get_ports {$(CORE_SYNC_IN_PORTS)}]" >> $@
	@echo "# DDS config bundle comes from the external SPI block and is synchronized inside dds_top." >> $@
	@echo "set_false_path -from [get_ports {$(CORE_ASYNC_IN_PORTS)}]" >> $@
	@echo "# Divider self-feedback defines generated clocks; reset-sync outputs are synchronized release controls." >> $@
	@echo "set_false_path -from [get_cells {u_clk_div4/*}] -to [get_cells {u_clk_div4/*}]" >> $@
	@echo "set_false_path -from [get_cells {u_ser_rst_sync/* u_vec_rst_sync/*}]" >> $@
	@echo "set_output_delay 0.1 -clock $(FAST_CLK_NAME) [get_ports {$(CORE_OUT_PORTS)}]" >> $@
	@echo ""                                                  >> $@
	@echo "set_max_fanout 16 [current_design]"                >> $@
	@echo "set_max_transition 1.0 [current_design]"           >> $@
	@echo ""                                                  >> $@
	@echo "puts \"\n=== WORST PATH (max) ===\""               >> $@
	@echo "report_checks -path_delay max -fields {fanout capacitance slew} -digits 3" >> $@
	@echo ""                                                  >> $@
	@echo "puts \"\n=== WORST PATH (min / hold) ===\""        >> $@
	@echo "report_checks -path_delay min -digits 3"           >> $@
	@echo ""                                                  >> $@
	@echo ""                                                  >> $@
	@echo "puts \"\n=== freq_runner ===\""                    >> $@
	@echo "report_checks -path_delay max -through [get_cells u_freq/*] -fields {fanout capacitance slew} -digits 3" >> $@
	@echo ""                                                  >> $@
	@echo "puts \"\n=== phase_accum ===\""                    >> $@
	@echo "report_checks -path_delay max -through [get_cells u_accum/*] -fields {fanout capacitance slew} -digits 3" >> $@
	@echo ""                                                  >> $@
	@echo "puts \"\n=== datapath ===\""                       >> $@
	@echo "report_checks -path_delay max -through [get_cells u_dp/*] -fields {fanout capacitance slew} -digits 3" >> $@
	@echo ""                                                  >> $@
	@echo "puts \"\n=== sincos_interp_rom ===\""              >> $@
	@echo "report_checks -path_delay max -through [get_cells u_dp/g_lane[0].u_lane/u_sincos_interp/u_interp_rom/*] -fields {fanout capacitance slew} -digits 3" >> $@
	@echo ""                                                  >> $@
	@echo "puts \"\n=== SUMMARY ===\""                        >> $@
	@echo "report_tns"                                        >> $@
	@echo "report_wns"                                        >> $@

# ── Buffered STA (OpenROAD: buffer insertion + gate sizing) ──

STA_BUF_SCRIPT = $(SYN_DIR)/sta_buf.tcl
STA_BUF_SDC    = $(SYN_DIR)/sta_buf.sdc
STA_BUF_NET    = $(SYN_DIR)/dds_top_buf.v
STA_BUF_DEF    = $(SYN_DIR)/dds_top_sta_buf.def
STA_BUF_GDS    = $(SYN_DIR)/dds_top.gds
STA_BUF_REPAIR_DESIGN ?= 0
LIB_DIR        = $(PDK_ROOT)/gf180mcuD/libs.ref/$(SCL)
TECH_LEF       = $(LIB_DIR)/techlef/$(SCL)__max.tlef
CELL_LEF       = $(LIB_DIR)/lef/$(SCL).lef
SITE_NAME      ?= GF018hv5v_green_sc9
STA_BUF_UTIL   ?= 80
STA_BUF_ASPECT_RATIO ?= 1.0
STA_BUF_CORE_SPACE ?= 5
STA_BUF_GP_DENSITY ?= 0.95
STA_BUF_PAD_LEFT ?= 0
STA_BUF_PAD_RIGHT ?= 0

.PHONY: sta_buf

sta_buf: $(STA_BUF_DEF)

$(STA_BUF_DEF): $(SYN_NET) $(STA_BUF_SDC) $(STA_BUF_SCRIPT)
	$(OPENROAD) -exit $(STA_BUF_SCRIPT) 2>&1 | tee $(SYN_DIR)/sta_buf.log

$(STA_BUF_SDC): $(SYN_NET) Makefile
	@mkdir -p $(SYN_DIR)
	@echo "create_clock -name $(FAST_CLK_NAME) -period $(SER_CLK_PERIOD) [get_ports clk]" >  $@
	@echo "create_generated_clock -name clk_vec -source [get_ports clk] -divide_by 4 [get_nets clk_div4]" >> $@
	@echo "set_input_delay  0.1 -clock $(FAST_CLK_NAME) [get_ports {$(CORE_SYNC_IN_PORTS)}]" >> $@
	@echo "# DDS config bundle comes from the external SPI block and is synchronized inside dds_top." >> $@
	@echo "set_false_path -from [get_ports {$(CORE_ASYNC_IN_PORTS)}]"      >> $@
	@echo "# Divider self-feedback defines generated clocks; reset-sync outputs are synchronized release controls." >> $@
	@echo "set_false_path -from [get_cells {u_clk_div4/*}] -to [get_cells {u_clk_div4/*}]" >> $@
	@echo "set_false_path -from [get_cells {u_ser_rst_sync/* u_vec_rst_sync/*}]" >> $@
	@echo "set_output_delay 0.1 -clock $(FAST_CLK_NAME) [get_ports {$(CORE_OUT_PORTS)}]" >> $@
	@echo "set_max_fanout 16 [current_design]"                             >> $@
	@echo "set_max_transition 1.0 [current_design]"                        >> $@

$(STA_BUF_SCRIPT): $(SYN_NET) $(STA_BUF_SDC) Makefile
	@mkdir -p $(SYN_DIR)
	@echo "read_lef $(TECH_LEF)"                                           >  $@
	@echo "read_lef $(CELL_LEF)"                                           >> $@
	@echo "read_liberty $(LIB_FILE)"                                       >> $@
	@echo "read_verilog $(SYN_NET)"                                        >> $@
	@echo "link_design dds_top"                                            >> $@
	@echo "read_sdc $(STA_BUF_SDC)"                                        >> $@
	@echo ""                                                               >> $@
	@echo "# Minimal floorplan for wire RC estimation"                     >> $@
	@echo "initialize_floorplan -utilization $(STA_BUF_UTIL) -aspect_ratio $(STA_BUF_ASPECT_RATIO) -core_space $(STA_BUF_CORE_SPACE) -site $(SITE_NAME)" >> $@
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
	@echo "# Global placement for parasitic estimation"                    >> $@
	@echo "global_placement -density $(STA_BUF_GP_DENSITY) -pad_left $(STA_BUF_PAD_LEFT) -pad_right $(STA_BUF_PAD_RIGHT)" >> $@
	@echo "estimate_parasitics -placement"                                 >> $@
ifeq ($(STA_BUF_REPAIR_DESIGN),1)
	@echo "repair_design"                                                  >> $@
	@echo "detailed_placement"                                             >> $@
	@echo "estimate_parasitics -placement"                                 >> $@
endif
	@echo ""                                                               >> $@
	@echo "# Buffer insertion + gate sizing"                               >> $@
	@echo ""                                                               >> $@
	@echo "# Multi-pass repair — pass N+1 picks up paths deprioritized in pass N" >> $@
	@echo "puts \"\n=== REPAIR PASS 1 ===\""                               >> $@
	@echo "repair_timing -setup -verbose"                                  >> $@
	@echo "detailed_placement"                                             >> $@
	@echo "estimate_parasitics -placement"                                 >> $@
	@echo ""                                                               >> $@
	@echo "puts \"\n=== REPAIR PASS 2 ===\""                               >> $@
	@echo "repair_timing -setup -verbose"                                  >> $@
	@echo "detailed_placement"                                             >> $@
	@echo "estimate_parasitics -placement"                                 >> $@
	@echo ""                                                               >> $@
	@echo "puts \"\n=== BUFFERED: WORST PATH (max) ===\""                  >> $@
	@echo "report_checks -path_delay max -fields {fanout capacitance slew} -digits 3" >> $@
	@echo ""                                                               >> $@
	@echo "puts \"\n=== BUFFERED: WORST PATH (min / hold) ===\""           >> $@
	@echo "report_checks -path_delay min -digits 3"                        >> $@
	@echo ""                                                               >> $@
	@echo "puts \"\n=== BUFFERED: SUMMARY ===\""                           >> $@
	@echo "report_tns"                                                     >> $@
	@echo "report_wns"                                                     >> $@
	@echo 'puts "\n=== WORST PATHS BY MODULE ==="' >> $@
	@echo 'foreach inst {u_freq u_accum u_dp u_ser_i} {' >> $@
	@echo '    puts "\n--- $$inst ---"' >> $@
	@echo '    set mod_cells [get_cells -hier "$$inst/*"]' >> $@
	@echo '    if {[llength $$mod_cells] == 0} {' >> $@
	@echo '        puts "No cells matched $$inst/*"' >> $@
	@echo '        continue' >> $@
	@echo '    }' >> $@
	@echo '    report_checks -path_delay max -through $$mod_cells -fields {fanout capacitance slew} -digits 3 -group_path_count 3' >> $@
	@echo '}' >> $@
	@echo ""                                                               >> $@
	@echo "# Write buffered netlist for inspection"                        >> $@
	@echo "write_verilog $(STA_BUF_NET)"                                   >> $@
	@echo "write_def $(STA_BUF_DEF)"                                       >> $@
	@echo "puts \"\n=== TIMING SUMMARY ===\""                            >> $@
	@echo "report_tns"                                                   >> $@
	@echo "report_wns"                                                   >> $@
	@echo "puts \"\n=== PHYSICAL SUMMARY ===\""                          >> $@
	@echo "puts \"placement_knobs floorplan_util=$(STA_BUF_UTIL) aspect_ratio=$(STA_BUF_ASPECT_RATIO) core_space_um=$(STA_BUF_CORE_SPACE) gp_density=$(STA_BUF_GP_DENSITY) pad_left=$(STA_BUF_PAD_LEFT) pad_right=$(STA_BUF_PAD_RIGHT)\"" >> $@
	@echo "report_design_area"                                           >> $@
	@echo 'set block [ord::get_db_block]'                                >> $@
	@echo 'set dbu [$$block getDefUnits]'                                >> $@
	@echo 'set die [$$block getDieArea]'                                 >> $@
	@echo 'set core [$$block getCoreArea]'                               >> $@
	@echo 'set die_w [expr {double([$$die xMax] - [$$die xMin]) / $$dbu}]' >> $@
	@echo 'set die_h [expr {double([$$die yMax] - [$$die yMin]) / $$dbu}]' >> $@
	@echo 'set core_w [expr {double([$$core xMax] - [$$core xMin]) / $$dbu}]' >> $@
	@echo 'set core_h [expr {double([$$core yMax] - [$$core yMin]) / $$dbu}]' >> $@
	@echo 'set std_cell_area_dbu2 0.0'                                   >> $@
	@echo 'foreach inst [$$block getInsts] {'                            >> $@
	@echo '    set master [$$inst getMaster]'                            >> $@
	@echo '    set std_cell_area_dbu2 [expr {$$std_cell_area_dbu2 + double([$$master getWidth]) * double([$$master getHeight])}]' >> $@
	@echo '}'                                                            >> $@
	@echo 'set die_area_um2 [expr {$$die_w * $$die_h}]'                  >> $@
	@echo 'set core_area_um2 [expr {$$core_w * $$core_h}]'               >> $@
	@echo 'set std_cell_area_um2 [expr {$$std_cell_area_dbu2 / double($$dbu) / double($$dbu)}]' >> $@
	@echo 'set util_pct [expr {100.0 * $$std_cell_area_um2 / $$core_area_um2}]' >> $@
	@echo 'puts [format "die_um %.3f x %.3f area_um2 %.3f" $$die_w $$die_h $$die_area_um2]' >> $@
	@echo 'puts [format "core_um %.3f x %.3f area_um2 %.3f" $$core_w $$core_h $$core_area_um2]' >> $@
	@echo 'puts [format "std_cell_area_um2 %.3f core_util_pct %.2f" $$std_cell_area_um2 $$util_pct]' >> $@
	@echo 'puts [format "counts instances %d pins %d nets %d rows %d" [llength [$$block getInsts]] [llength [$$block getBTerms]] [llength [$$block getNets]] [llength [$$block getRows]]]' >> $@


# ── Gate-level sim ───────────────────────────────────────────

sim_syn: $(SYN_NET)
	$(IVERILOG) -Wall -g2012 -o $(SIM_DIR)/tb_dds_top_syn.vvp \
	    $(CELL_VLOG) $(SYN_NET) $(TOP_TB)
	cd $(SIM_DIR) && $(VVP) tb_dds_top_syn.vvp
	@echo "Gate-level sim done → $(SIM_DIR)/tb_dds_top_syn.vcd"

# ── GDS (KLayout) ───────────────────────────────────────────

gds: $(STA_BUF_GDS)

$(STA_BUF_GDS): $(STA_BUF_DEF)
	$(KLAYOUT) -zz \
	  -rd design_name=dds_top \
	  -rd in_def=$(STA_BUF_DEF) \
	  -rd tech_lef=$(TECH_LEF) \
	  -rd cell_lef=$(CELL_LEF) \
	  -rd in_gds=$(LIB_DIR)/gds/$(SCL).gds \
	  -rd out_gds=$(STA_BUF_GDS) \
	  -rd seal_gds="" \
	  -rm scripts/def2gds.py
	@test -s $(STA_BUF_GDS)
	@echo "GDS → $(STA_BUF_GDS)"

# ── Clean ────────────────────────────────────────────────────

clean:
	rm -f $(LUT_V) $(LUT_OLD) $(SIM_DIR)/*.vvp $(SIM_DIR)/*.vcd
	rm -rf $(SYN_DIR)
