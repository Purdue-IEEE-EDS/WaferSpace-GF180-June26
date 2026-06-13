import pya
layout = pya.Layout()
# Load LEF/DEF files using the correct technical parser
pya.LEFDEFReader().read(layout, '/usr/share/pdk//gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu9t5v0/techlef/gf180mcu_fd_sc_mcu9t5v0__max.tlef')
pya.LEFDEFReader().read(layout, '/usr/share/pdk//gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu9t5v0/lef/gf180mcu_fd_sc_mcu9t5v0.lef')
pya.LEFDEFReader().read(layout, 'syn/pnr/fft_pnr.def')
# Merge the actual transistor-level standard cell library GDS
layout.read('/usr/share/pdk//gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu9t5v0/gds/gf180mcu_fd_sc_mcu9t5v0.gds')
# Stream out the final merged GDS file
layout.write('syn/fft.gds')
