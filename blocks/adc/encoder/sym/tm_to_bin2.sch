v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 1010 -690 1080 -690 {lab=wl[1:61]}
N 860 -750 860 -720 {lab=VDD}
N 860 -580 860 -550 {lab=GND}
N 610 -670 710 -670 {lab=comp[0:60]}
N 610 -650 705 -650 {lab=comp[1:61]}
N 705 -650 710 -650 {lab=comp[1:61]}
N 610 -630 710 -630 {lab=comp[2:62]}
N 1010 -400 1080 -400 {lab=wl[0]}
N 860 -460 860 -430 {lab=VDD}
N 860 -290 860 -260 {lab=GND}
N 610 -380 710 -380 {lab=VDD}
N 610 -360 705 -360 {lab=comp[0]}
N 705 -360 710 -360 {lab=comp[0]}
N 610 -340 710 -340 {lab=comp[1]}
N 1010 -990 1080 -990 {lab=wl[62]}
N 860 -1050 860 -1020 {lab=VDD}
N 860 -880 860 -850 {lab=GND}
N 610 -970 710 -970 {lab=comp[61]}
N 610 -950 705 -950 {lab=comp[62]}
N 705 -950 710 -950 {lab=comp[62]}
N 610 -930 710 -930 {lab=GND}
N 1090 -1000 1090 -410 {lab=wl[0:62]
bus=true}
N 340 -1000 490 -1000 {lab=comp[0:62]
bus=true
}
N 500 -1010 610 -1010 {lab=comp[61]}
N 610 -1010 610 -970 {lab=comp[61]}
N 480 -1000 480 -320 {lab=comp[0:62]
bus=true}
N 490 -360 610 -360 {lab=comp[0]}
N 490 -380 610 -380 {lab=VDD}
N 490 -630 610 -630 {lab=comp[2:62]}
N 490 -650 610 -650 {lab=comp[1:61]}
N 490 -670 610 -670 {lab=comp[0:60]}
N 490 -950 610 -950 {lab=comp[62]}
C {opin.sym} 1095 -630 0 0 {name=p421 lab=wl[62:0]}
C {lab_wire.sym} 1040 -990 0 0 {name=p10 sig_type=std_logic lab=wl[62]}
C {lab_wire.sym} 1050 -400 0 0 {name=p16 sig_type=std_logic lab=wl[0]}
C {lab_wire.sym} 1060 -690 0 0 {name=p17 sig_type=std_logic lab=wl[1:61]}
C {lab_wire.sym} 410 -1000 0 0 {name=p4 sig_type=std_logic lab=comp[0:62]}
C {bus_connect_nolab.sym} 490 -1000 0 0 {name=r1}
C {lab_wire.sym} 580 -950 0 0 {name=p6 sig_type=std_logic lab=comp[62]}
C {ipin.sym} 337.5 -999.7436562655409 0 0 {name=p8 lab=comp[0:62]}
C {bus_connect_nolab.sym} 480 -940 0 0 {name=r2}
C {bus_connect_nolab.sym} 480 -660 0 0 {name=r3}
C {bus_connect_nolab.sym} 480 -640 0 0 {name=r4}
C {bus_connect_nolab.sym} 480 -620 0 0 {name=r5}
C {bus_connect_nolab.sym} 480 -370 0 0 {name=r6}
C {bus_connect_nolab.sym} 480 -350 0 0 {name=r7}
C {lab_wire.sym} 590 -1010 0 0 {name=p11 sig_type=std_logic lab=comp[61]}
C {lab_wire.sym} 610 -670 0 0 {name=p14 sig_type=std_logic lab=comp[0:60]}
C {lab_wire.sym} 610 -650 0 0 {name=p15 sig_type=std_logic lab=comp[1:61]}
C {lab_wire.sym} 610 -630 0 0 {name=p18 sig_type=std_logic lab=comp[2:62]}
C {lab_wire.sym} 620 -360 0 0 {name=p19 sig_type=std_logic lab=comp[0]}
C {lab_wire.sym} 620 -340 0 0 {name=p20 sig_type=std_logic lab=comp[1]}
C {lab_wire.sym} 860 -750 0 0 {name=p1 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 860 -550 0 0 {name=p2 sig_type=std_logic lab=GND}
C {lab_wire.sym} 860 -450 0 0 {name=p5 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 860 -260 0 0 {name=p9 sig_type=std_logic lab=GND}
C {lab_wire.sym} 620 -380 0 0 {name=p12 sig_type=std_logic lab=VDD}
C {bus_connect_nolab.sym} 1080 -990 0 0 {name=r8}
C {bus_connect_nolab.sym} 1080 -690 0 0 {name=r9}
C {bus_connect_nolab.sym} 1080 -400 0 0 {name=r10}
C {lab_wire.sym} 630 -930 0 0 {name=p13 sig_type=std_logic lab=GND}
C {lab_wire.sym} 1090 -760 0 0 {name=p21 sig_type=std_logic lab=wl[0:62]}
C {ipin.sym} 860 -1049.743656265541 0 0 {name=p3 lab=VDD}
C {ipin.sym} 860 -852.2436562655409 0 0 {name=p7 lab=GND}
C {blocks/adc/encoder/sym/NAND3.sym} 860 -950 0 0 {name=x1}
C {blocks/adc/encoder/sym/NAND3.sym} 860 -650 0 0 {name=x2[61:1]}
C {blocks/adc/encoder/sym/NAND3.sym} 860 -360 0 0 {name=x3}
