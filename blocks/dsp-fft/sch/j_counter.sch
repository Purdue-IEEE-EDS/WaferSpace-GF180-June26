v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 540 -340 580 -340 {lab=#net1}
N 580 -340 580 -300 {lab=#net1}
N 580 -300 640 -300 {lab=#net1}
N 940 -280 1000 -280 {lab=#net2}
N 1000 -430 1000 -280 {lab=#net2}
N 210 -430 1000 -430 {lab=#net2}
N 210 -300 240 -300 {lab=#net2}
N 620 -320 640 -320 {lab=VDD}
N 620 -340 640 -340 {lab=RST}
N 620 -280 640 -280 {lab=GND}
N 210 -340 240 -340 {lab=RST}
N 210 -320 240 -320 {lab=VDD}
N 210 -280 240 -280 {lab=GND}
N 390 -240 390 -210 {lab=CLK}
N 790 -240 790 -200 {lab=CLK}
N 110 -430 210 -430 {lab=#net2}
N 110 -430 110 -300 {lab=#net2}
N 110 -300 220 -300 {lab=#net2}
N 580 -110 1010 -110 {lab=#net3}
N 1010 -320 1010 -110 {lab=#net3}
N 1010 -320 1070 -320 {lab=#net3}
N 1050 -300 1070 -300 {lab=GND}
N 1050 -360 1070 -360 {lab=VDD}
N 1180 -340 1240 -340 {lab=out}
N 1000 -340 1070 -340 {lab=#net2}
N 540 -110 580 -110 {lab=#net3}
N 540 -280 540 -110 {lab=#net3}
C {tspc_dff.sym} 400 -310 0 0 {name=x1}
C {tspc_dff.sym} 800 -310 0 0 {name=x2}
C {lab_wire.sym} 630 -320 0 0 {name=p32 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 630 -340 0 0 {name=p1 sig_type=std_logic lab=RST}
C {lab_wire.sym} 630 -280 0 0 {name=p2 sig_type=std_logic lab=GND}
C {lab_wire.sym} 790 -210 0 0 {name=p3 sig_type=std_logic lab=CLK}
C {ipin.sym} 210 -320 0 0 {name=p4 lab=VDD}
C {ipin.sym} 210 -340 0 0 {name=p5 lab=RST}
C {ipin.sym} 210 -280 0 0 {name=p7 lab=GND}
C {ipin.sym} 390 -220 0 0 {name=p8 lab=CLK}
C {AND2.sym} 1130 -330 0 0 {name=x3}
C {lab_wire.sym} 1060 -360 0 0 {name=p6 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 1050 -300 0 0 {name=p9 sig_type=std_logic lab=GND}
C {opin.sym} 1230 -340 0 0 {name=p10 lab=out}
