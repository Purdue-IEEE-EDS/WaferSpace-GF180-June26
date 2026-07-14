v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 740 -330 780 -330 {lab=out0}
N 780 -330 780 -290 {lab=out0}
N 780 -290 840 -290 {lab=out0}
N 410 -290 440 -290 {lab=serial_in}
N 820 -310 840 -310 {lab=VDD}
N 820 -330 840 -330 {lab=RST}
N 820 -270 840 -270 {lab=GND}
N 410 -330 440 -330 {lab=RST}
N 410 -310 440 -310 {lab=VDD}
N 410 -270 440 -270 {lab=GND}
N 590 -230 590 -200 {lab=CLK}
N 990 -230 990 -190 {lab=CLK}
N 1510 -330 1550 -330 {lab=out2}
N 1550 -330 1550 -290 {lab=out2}
N 1550 -290 1610 -290 {lab=out2}
N 1590 -310 1610 -310 {lab=VDD}
N 1590 -330 1610 -330 {lab=RST}
N 1590 -270 1610 -270 {lab=GND}
N 1360 -230 1360 -200 {lab=CLK}
N 1760 -230 1760 -190 {lab=CLK}
N 1140 -330 1170 -330 {lab=out1}
N 1170 -330 1170 -290 {lab=out1}
N 1170 -290 1210 -290 {lab=out1}
N 1190 -310 1210 -310 {lab=VDD}
N 1190 -330 1210 -330 {lab=RST}
N 1190 -270 1210 -270 {lab=GND}
N 1910 -330 1950 -330 {lab=out3}
N 770 -390 770 -330 {lab=out0}
N 1160 -390 1160 -330 {lab=out1}
N 1540 -390 1540 -330 {lab=out2}
N 1940 -390 1940 -330 {lab=out3}
C {tspc_dff.sym} 600 -300 0 0 {name=x1}
C {tspc_dff.sym} 1000 -300 0 0 {name=x2}
C {lab_wire.sym} 830 -310 0 0 {name=p32 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 830 -330 0 0 {name=p1 sig_type=std_logic lab=RST}
C {lab_wire.sym} 830 -270 0 0 {name=p2 sig_type=std_logic lab=GND}
C {lab_wire.sym} 990 -200 0 0 {name=p3 sig_type=std_logic lab=CLK}
C {ipin.sym} 410 -310 0 0 {name=p4 lab=VDD}
C {ipin.sym} 410 -330 0 0 {name=p5 lab=RST}
C {ipin.sym} 410 -270 0 0 {name=p7 lab=GND}
C {ipin.sym} 590 -210 0 0 {name=p8 lab=CLK}
C {tspc_dff.sym} 1370 -300 0 0 {name=x3}
C {tspc_dff.sym} 1770 -300 0 0 {name=x4}
C {lab_wire.sym} 1600 -310 0 0 {name=p6 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 1600 -330 0 0 {name=p9 sig_type=std_logic lab=RST}
C {lab_wire.sym} 1600 -270 0 0 {name=p10 sig_type=std_logic lab=GND}
C {lab_wire.sym} 1760 -200 0 0 {name=p11 sig_type=std_logic lab=CLK}
C {lab_wire.sym} 1200 -310 0 0 {name=p13 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 1200 -330 0 0 {name=p14 sig_type=std_logic lab=RST}
C {lab_wire.sym} 1200 -270 0 0 {name=p15 sig_type=std_logic lab=GND}
C {lab_wire.sym} 1360 -210 0 0 {name=p12 sig_type=std_logic lab=CLK}
C {opin.sym} 770 -390 0 0 {name=p16 lab=out0}
C {opin.sym} 1160 -390 0 0 {name=p17 lab=out1}
C {opin.sym} 1540 -390 0 0 {name=p18 lab=out2}
C {opin.sym} 1940 -390 0 0 {name=p19 lab=out3}
C {ipin.sym} 410 -290 0 0 {name=p20 lab=serial_in}
