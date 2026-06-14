
PYTHON ?= python3
AMS_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
ROOT_DIR := $(abspath $(AMS_DIR)/..)
SINE_TRUNC_W ?= 14
SINE_COARSE_W ?= 7
SINE_GUARD_W ?= 3
MAG_W         ?= 9

all: cal_dac_codegen main_dac_codegen

cal_dac_codegen:
	ngspice vlnggen ams/cal_dac_codegen.v
	$(PYTHON) symgen.py --device cal_dac_codegen --input clk --output "sclk data load" --verilog ams/cal_dac_codegen.v

main_dac_codegen:
	ngspice vlnggen ams/main_dac_codegen.v
	$(PYTHON) symgen.py --device main_dac_codegen --input clk --output "dac_i_p[35:0] dac_i_n[35:0] dac_q_p[35:0] dac_q_n[35:0]" --verilog ams/main_dac_codegen.v

clean:
	rm -rf $(ROOT_DIR)/cal_dac_codegen_obj_dir
	rm -rf $(ROOT_DIR)/main_dac_codegen_obj_dir
	rm -f $(ROOT_DIR)/*.so
