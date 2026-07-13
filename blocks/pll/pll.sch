v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 720 -350 810 -350 {lab=#net1}
N 720 -330 810 -330 {lab=#net2}
N 760 -390 810 -390 {lab=#net3}
N 760 -520 760 -390 {lab=#net3}
N 740 -370 810 -370 {lab=#net4}
N 740 -520 740 -370 {lab=#net4}
N 400 -330 420 -330 {lab=V_swap}
N 400 -350 420 -350 {lab=VSS}
N 400 -370 420 -370 {lab=VDD}
C {blocks/pll/cpump.sym} 960 -380 0 0 {name=x1}
C {blocks/pll/mux.sym} 570 -330 0 0 {name=x2}
C {ipin.sym} 400 -370 0 0 {name=p1 lab=VDD}
C {ipin.sym} 400 -350 0 0 {name=p2 lab=VSS}
C {lab_pin.sym} 810 -430 0 0 {name=p3 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 810 -410 0 0 {name=p4 sig_type=std_logic lab=VSS}
C {ipin.sym} 400 -330 0 0 {name=p5 lab=V_swap}
C {ipin.sym} 120 -310 0 0 {name=p6 lab=V_cryst}
C {blocks/pll/pfd.sym} 270 -300 0 0 {name=x3}
