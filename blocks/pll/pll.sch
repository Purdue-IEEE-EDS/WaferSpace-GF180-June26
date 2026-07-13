v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 510 -350 650 -350 {lab=#net1}
N 510 -330 650 -330 {lab=#net2}
N 600 -390 650 -390 {lab=#net3}
N 600 -520 600 -390 {lab=#net3}
N 580 -370 650 -370 {lab=#net4}
N 580 -520 580 -370 {lab=#net4}
C {blocks/pll/cpump.sym} 800 -380 0 0 {name=x1}
C {blocks/pll/mux.sym} 360 -330 0 0 {name=x2}
C {ipin.sym} 210 -370 0 0 {name=p1 lab=VDD}
C {ipin.sym} 210 -350 0 0 {name=p2 lab=VSS}
C {lab_pin.sym} 650 -430 0 0 {name=p3 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 650 -410 0 0 {name=p4 sig_type=std_logic lab=VSS}
C {ipin.sym} 210 -330 0 0 {name=p5 lab=V_swap}
C {ipin.sym} 210 -310 0 0 {name=p6 lab=V_cryst}
