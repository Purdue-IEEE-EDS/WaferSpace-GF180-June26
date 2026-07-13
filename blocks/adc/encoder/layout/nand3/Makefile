# DFF verification and extraction Makefile
# Location: /foss/designs/encoder/layout/dff/Makefile
# Usage:
#   make drc         - run DRC only
#   make lvs         - run LVS only
#   make extract     - run post-layout extraction only
#   make all         - run drc, lvs, extract in order
#   make clean       - remove result directories

# ─── paths ────────────────────────────────────────────────────────────────────
GDS     = NAND_klayout1.gds
CDL     = NAND3.cdl
TOPCELL = NAND3
VARIANT = D

DRC_SCRIPT  = ../../drc/run_drc.py
LVS_SCRIPT  = ../../lvs/run_lvs.py
MAGIC_TECH  = /foss/pdks/ciel/gf180mcu/versions/8f2d1529c86235d726979eb9ecb7e9628108590b/gf180mcuD/libs.tech/magic/gf180mcuD.tech
EXTRACT_TCL = extract.tcl

DRC_DIR = ../../drc/NAND_results
LVS_DIR = ../../lvs/NAND_results

# ─── targets ──────────────────────────────────────────────────────────────────
.PHONY: all drc lvs extract clean

# run everything in correct order
all: drc lvs extract

# DRC — flat mode, results in DRC_DIR
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

# LVS — flat mode, results in LVS_DIR
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

# Post-layout extraction — Magic ext2spice
extract:
	@echo "=== Running post-layout extraction ==="
	magic -T $(MAGIC_TECH) -noconsole -dnull < $(EXTRACT_TCL)
	@echo "=== Fixing subckt name, port order, and adding missing D/RST pins ==="
	sed -i 's/\.subckt dff_encoder_flat2 VDD GND Q CLK/.subckt dff_encoder VDD RST CLK D Q GND/' \
		../../layout/dff/dff_encoder_sim2.spice
	sed -i 's/ \*\*FLOATING//' \
		../../layout/dff/dff_encoder_sim2.spice
	@echo "=== Extraction complete: dff_encoder_sim2.spice ready ==="

# remove result directories
clean:
	@echo "=== Cleaning result directories ==="
	rm -rf $(DRC_DIR) $(LVS_DIR)
	@echo "=== Clean complete ==="
