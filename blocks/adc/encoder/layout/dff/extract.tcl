gds read /foss/designs/encoder/layout/dff/dff_encoder.gds
load dff_encoder
flatten dff_encoder_flat
load dff_encoder_flat
extract all
ext2spice hierarchy on
ext2spice cthresh 0.01
ext2spice rthresh 0
ext2spice -o dff_encoder_sim.spice
ext2spice
quit
