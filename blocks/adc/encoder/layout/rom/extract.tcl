# ─────────────────────────────────────────
# Script: extract.tcl
# Description: Post-layout extraction for ROM2 module
# Usage: magic -T <tech> -noconsole -dnull < extract.tcl
# ─────────────────────────────────────────

# ── LOAD LAYOUT ───────────────────────────
# Read the ROM2 GDS from its absolute path
gds read /foss/designs/WaferSpace-GF180-June26/blocks/adc/encoder/layout/rom/ROM2_2.gds

# Load the top cell into Magic's active cell context
load rom2

# ── FLATTEN ───────────────────────────────
# Flatten into a new cell — Magic extracts flat cells more reliably than hierarchical ones
flatten rom2_flat

# Switch context to the flattened cell so extraction runs on it
load rom2_flat

# ── EXTRACT ───────────────────────────────
# Run parasitic extraction on all elements (devices, capacitances, resistances)
extract all

# ── EXT2SPICE SETTINGS ────────────────────
# Keep hierarchy info in the SPICE output so subckt structure is preserved
ext2spice hierarchy on

# Only emit coupling caps above 0.01fF — filters out negligible parasitics
ext2spice cthresh 0.01

# Include all resistances (threshold 0 = keep everything)
ext2spice rthresh 0

# Set the output SPICE filename
ext2spice -o rom2_sim.spice

# ── WRITE & EXIT ──────────────────────────
# Trigger the actual SPICE file write
ext2spice

# Exit Magic cleanly — required when running headless with -noconsole
quit
