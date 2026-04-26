TOP = fft_wrapper

# ---------------- Tools ----------------
YOSYS    ?= yosys
IVERILOG ?= iverilog
VVP      ?= vvp
STA      ?= sta
OPENROAD ?= openroad

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

# ---------------- Directories ----------------
RTL_DIR = src
TB_DIR  = tb
SIM_DIR = sim
SYN_DIR = syn
PNR_DIR = $(SYN_DIR)/pnr

# ---------------- RTL ----------------
RTL = \
	$(RTL_DIR)/fft.sv \
	$(RTL_DIR)/fft_wrapper.sv \
	$(RTL_DIR)/stage.sv \
	$(RTL_DIR)/r2.sv \
	$(RTL_DIR)/rotator.sv \
	$(RTL_DIR)/triv_rotator.sv \
	$(RTL_DIR)/twiddle_rom.sv \
	$(RTL_DIR)/buffer.sv

TB_FFT   = $(TB_DIR)/tb_fft.sv
TB_STAGE = $(TB_DIR)/tb_stage.sv

# ---------------- Outputs ----------------
FFT_VVP      = $(SIM_DIR)/tb_fft.vvp
STAGE_VVP    = $(SIM_DIR)/tb_stage.vvp
SYN_NET      = $(SYN_DIR)/fft_syn.v
SIM_SYN_VVP  = $(SIM_DIR)/tb_fft_syn.vvp

PNR_SCRIPT   = $(PNR_DIR)/pnr.tcl
PNR_DEF      = $(PNR_DIR)/fft.def
PNR_GDS      = $(PNR_DIR)/fft.gds
PNR_SDC      = $(PNR_DIR)/fft.sdc

SYN_SCRIPT   = $(SYN_DIR)/synth.ys
STA_SCRIPT   = $(SYN_DIR)/sta.tcl

# ============================================================
# SIMULATION (RTL)
# ============================================================

$(FFT_VVP): $(RTL) $(TB_FFT)
	mkdir -p $(SIM_DIR)
	$(IVERILOG) -g2012 -o $@ $(RTL) $(TB_FFT)

sim_fft: $(FFT_VVP)
	cp $(TB_DIR)/data.mem $(SIM_DIR)/
	cd $(SIM_DIR) && $(VVP) tb_fft.vvp

$(STAGE_VVP): $(RTL) $(TB_STAGE)
	mkdir -p $(SIM_DIR)
	$(IVERILOG) -g2012 -o $@ \
		$(RTL_DIR)/stage.sv \
		$(RTL_DIR)/buffer.sv \
		$(RTL_DIR)/rotator.sv \
		$(RTL_DIR)/triv_rotator.sv \
		$(RTL_DIR)/r2.sv \
		$(RTL_DIR)/twiddle_rom.sv \
		$(TB_STAGE)

sim_stage: $(STAGE_VVP)
	cd $(SIM_DIR) && $(VVP) tb_stage.vvp

sim: sim_fft sim_stage

# ============================================================
# SYNTHESIS
# ============================================================

$(SYN_SCRIPT): $(RTL)
	mkdir -p $(SYN_DIR)
	echo "read_verilog -sv $(RTL)" > $@
	echo "hierarchy -top $(TOP) -check" >> $@
	echo "proc; opt; memory; opt" >> $@
	echo "techmap; opt" >> $@
	echo "dfflibmap -liberty $(LIB_FILE)" >> $@
	echo "abc -liberty $(LIB_FILE) -D 3200" >> $@
	echo "clean" >> $@
	echo "write_verilog $(SYN_NET)" >> $@

$(SYN_NET): $(RTL) $(SYN_SCRIPT)
	$(YOSYS) -s $(SYN_SCRIPT)

syn: $(SYN_NET)

# ============================================================
# STA 
# ============================================================

STA_SCRIPT = $(SYN_DIR)/sta.tcl

sta: $(SYN_NET)
	@echo "read_liberty $(LIB_FILE)" > $(STA_SCRIPT)
	@echo "read_verilog $(SYN_NET)" >> $(STA_SCRIPT)
	@echo "link_design $(TOP)" >> $(STA_SCRIPT)
	@echo "" >> $(STA_SCRIPT)
	@echo "create_clock -name clk -period 3.2 [get_ports clk]" >> $(STA_SCRIPT)
	@echo "" >> $(STA_SCRIPT)
	@echo "puts \"\\n=== SETUP PATHS ===\"" >> $(STA_SCRIPT)
	@echo "report_checks -path_delay max -fields {slew capacitance fanout} -digits 3" >> $(STA_SCRIPT)
	@echo "" >> $(STA_SCRIPT)
	@echo "puts \"\\n=== HOLD PATHS ===\"" >> $(STA_SCRIPT)
	@echo "report_checks -path_delay min -digits 3" >> $(STA_SCRIPT)
	@echo "" >> $(STA_SCRIPT)
	@echo "puts \"\\n=== SUMMARY ===\"" >> $(STA_SCRIPT)
	@echo "report_wns" >> $(STA_SCRIPT)
	@echo "report_tns" >> $(STA_SCRIPT)
	$(STA) -exit $(STA_SCRIPT)

# ============================================================
# GATE SIM
# ============================================================

sim_syn: $(SYN_NET)
	mkdir -p $(SIM_DIR)
	cp $(TB_DIR)/data.mem $(SIM_DIR)/
	$(IVERILOG) -g2012 -o $(SIM_SYN_VVP) \
		$(CELL_VLOG) \
		$(SYN_NET) \
		$(TB_FFT)
	cd $(SIM_DIR) && $(VVP) tb_fft_syn.vvp

# ============================================================
# PNR (OpenROAD)
# ============================================================

$(PNR_SDC):
	mkdir -p $(PNR_DIR)
	echo "create_clock -period 3.2 [get_ports clk]" > $@

$(PNR_SCRIPT): $(SYN_NET) $(PNR_SDC)
	mkdir -p $(PNR_DIR)
	echo "read_lef $(TECH_LEF)" > $@
	echo "read_lef $(CELL_LEF)" >> $@
	echo "read_liberty $(LIB_FILE)" >> $@
	echo "read_verilog $(SYN_NET)" >> $@
	echo "link_design $(TOP)" >> $@
	echo "read_sdc $(PNR_SDC)" >> $@
	echo "initialize_floorplan -utilization 40 -aspect_ratio 1.0" >> $@
	echo "global_placement" >> $@
	echo "detailed_placement" >> $@
	echo "clock_tree_synthesis" >> $@
	echo "global_route" >> $@
	echo "detailed_route" >> $@
	echo "write_def $(PNR_DEF)" >> $@
	echo "write_verilog $(PNR_DIR)/fft_pnr.v" >> $@

$(PNR_DEF): $(SYN_NET) $(PNR_SCRIPT)
	mkdir -p $(PNR_DIR)
	$(OPENROAD) $(PNR_SCRIPT)

pnr: $(PNR_DEF)

# ============================================================
# POST-PNR STA
# ============================================================

sta_pnr: $(PNR_DEF)
	mkdir -p $(SYN_DIR)
	echo "read_liberty $(LIB_FILE)" > $(STA_SCRIPT)
	echo "read_verilog $(SYN_NET)" >> $(STA_SCRIPT)
	echo "read_def $(PNR_DEF)" >> $(STA_SCRIPT)
	echo "link_design $(TOP)" >> $(STA_SCRIPT)
	echo "create_clock -period 3.2 [get_ports clk]" >> $(STA_SCRIPT)
	echo "set_propagated_clock [all_clocks]" >> $(STA_SCRIPT)
	echo "report_checks -path_delay max" >> $(STA_SCRIPT)
	echo "report_wns" >> $(STA_SCRIPT)
	echo "report_tns" >> $(STA_SCRIPT)
	$(STA) -exit $(STA_SCRIPT)

# ============================================================
# GDS
# ============================================================

GDS = $(PNR_DIR)/fft.gds

gds: $(PNR_DEF)
	$(OPENROAD) -exit $(PNR_SCRIPT)
	@echo "GDS generated at $(GDS)"

# ============================================================
# CLEAN
# ============================================================

clean:
	rm -rf $(SIM_DIR) $(SYN_DIR)
