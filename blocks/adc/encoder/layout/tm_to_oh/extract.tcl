gds read /foss/designs/encoder/layout/tm_to_oh/tm_to_bin_final.gds
load tm_to_bin2
extract all
ext2spice format ngspice
ext2spice hierarchy on
ext2spice cthresh 0.01
ext2spice rthresh 0
ext2spice -o tm_to_bin2_sim.spice
quit
