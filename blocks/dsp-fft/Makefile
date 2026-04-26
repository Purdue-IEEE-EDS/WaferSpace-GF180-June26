TOP = fft_wrapper

# Tools
YOSYS ?= yosys
IVERILOG ?= iverilog
VVP ?= vvp
STA ?= sta
OPENROAD ?= openroad

PDK_ROOT   ?= /headless/QucsWorkspace/IHP-Open-PDK
SCL        ?= gf180mcu_fd_sc_mcu9t5v0
CORNER     ?= tt_025C_3v30
LIB_DIR    = $(PDK_ROOT)/gf180mcuD/libs.ref/$(SCL)
LIB_FILE   = $(PDK_ROOT)/gf180mcuD/libs.ref/$(SCL)/lib/$(SCL)__$(CORNER).lib
TECH_LEF   = $(LIB_DIR)/techlef/$(SCL)__max.tlef
CELL_LEF   = $(LIB_DIR)/lef/$(SCL).lef

# Directories
RTL_DIR = src
TB_DIR  = tb
SIM_DIR = sim
SYN_DIR = syn

# RTL sources
RTL := \
	$(RTL_DIR)/fft.sv \
	$(RTL_DIR)/fft_wrapper.sv \
	$(RTL_DIR)/stage.sv \
	$(RTL_DIR)/r2.sv \
	$(RTL_DIR)/rotator.sv \
	$(RTL_DIR)/triv_rotator.sv \
	$(RTL_DIR)/twiddle_rom.sv \
	$(RTL_DIR)/buffer.sv

# Testbenches
TB_FFT   = $(TB_DIR)/tb_fft.sv
TB_STAGE = $(TB_DIR)/tb_stage.sv

# Outputs
FFT_VVP   = $(SIM_DIR)/tb_fft.vvp
STAGE_VVP = $(SIM_DIR)/tb_stage.vvp

SYN_NET = $(SYN_DIR)/fft_syn.v
SYN_SCRIPT = $(SYN_DIR)/synth.ys
STA_SCRIPT = $(SYN_DIR)/sta.tcl

.PHONY: sim sim_fft sim_stage syn sta clean

$(FFT_VVP): $(RTL) $(TB_FFT)
	mkdir -p $(SIM_DIR)
	$(IVERILOG) -g2012 -o $@ $(RTL) $(TB_FFT)

sim_fft: $(FFT_VVP)
	cp $(TB_DIR)/data.mem $(SIM_DIR)/
	cd $(SIM_DIR) && $(VVP) tb_fft.vvp

$(STAGE_VVP): $(RTL_DIR)/stage.sv $(TB_STAGE)
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

syn: $(SYN_NET)

$(SYN_SCRIPT):
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

sta: $(SYN_NET)
	echo "read_liberty $(LIB_FILE)" > $(STA_SCRIPT)
	echo "read_verilog $(SYN_NET)" >> $(STA_SCRIPT)
	echo "link_design $(TOP)" >> $(STA_SCRIPT)
	echo "create_clock -period 3.2 [get_ports clk]" >> $(STA_SCRIPT)
	echo "report_checks" >> $(STA_SCRIPT)
	echo "report_wns" >> $(STA_SCRIPT)
	$(STA) -exit $(STA_SCRIPT)

clean:
	rm -rf $(SIM_DIR) $(SYN_DIR)
