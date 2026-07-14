# ROM2 verification and extraction Makefile
# Location: /foss/designs/WaferSpace-GF180-June26/blocks/adc/encoder/layout/rom/Makefile
# Usage:
#   make drc         - run DRC only
#   make lvs         - run LVS only
#   make extract     - run post-layout extraction only
#   make all         - run drc, lvs, extract in order
#   make clean       - remove result directories

# ─── paths ────────────────────────────────────────────────────────────────────
GDS     = ROM2_2.gds
CDL     = ROM2.cdl
TOPCELL = rom2
VARIANT = D

DRC_SCRIPT  = ../../drc/run_drc.py
LVS_SCRIPT  = ../../lvs/run_lvs.py

MAGIC_TECH  = /foss/pdks/ciel/gf180mcu/versions/8f2d1529c86235d726979eb9ecb7e9628108590b/gf180mcuD/libs.tech/magic/gf180mcuD.tech
EXTRACT_TCL = extract.tcl

DRC_DIR = ../../drc/rom_results
LVS_DIR = ../../lvs/rom_results

# ─── targets ──────────────────────────────────────────────────────────────────
.PHONY: all drc lvs extract clean

all: drc lvs extract

drc:
	@echo "=== Running DRC ==="
	@mkdir -p $(DRC_DIR)
	python3 $(DRC_SCRIPT) \
		--path=$(GDS) \
		--variant=$(VARIANT) \
		--topcell=$(TOPCELL) \
		--run_mode=flat \
		--run_dir=$(DRC_DIR)
	@echo "=== DRC complete: results in $(DRC_DIR) ==="

lvs:
	@echo "=== Running LVS ==="
	@mkdir -p $(LVS_DIR)
	python3 $(LVS_SCRIPT) \
		--layout=$(GDS) \
		--netlist=$(CDL) \
		--variant=$(VARIANT) \
		--topcell=$(TOPCELL) \
		--run_mode=flat \
		--run_dir=$(LVS_DIR) \
		--lvs_sub=GND
	@echo "=== LVS complete: results in $(LVS_DIR) ==="

extract:
	@echo "=== Running post-layout extraction ==="
	magic -T $(MAGIC_TECH) -noconsole -dnull < $(EXTRACT_TCL)
	# TODO: inspect extracted .spice and add sed fixups here if needed
	@echo "=== Extraction complete ==="

clean:
	@echo "=== Cleaning result directories ==="
	rm -rf $(DRC_DIR) $(LVS_DIR)
	@echo "=== Clean complete ==="
