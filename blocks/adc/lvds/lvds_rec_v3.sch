v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 0 0 0 50 {lab=Vdd}
N -160 110 -110 110 {lab=Vin_p}
N -160 90 -110 90 {lab=Vin_n}
N 190 110 290 110 {lab=#net1}
N 290 110 430 110 {lab=#net1}
N 730 110 920 110 {lab=V_diff}
N -160 130 -110 130 {lab=Iref}
N 567.5 20 567.5 57.5 {lab=Vdd}
N 0 20 567.5 20 {lab=Vdd}
C {op_amp.sym} 40 110 0 0 {name=x1}
C {ipin.sym} -160 110 0 0 {name=p4 lab=Vin_p}
C {ipin.sym} -160 90 0 0 {name=p5 lab=Vin_n}
C {opin.sym} 920 110 0 0 {name=p9 lab=V_diff}
C {ipin.sym} -160 130 0 0 {name=p6 lab=Iref}
C {ipin.sym} 0 0 0 0 {name=p1 lab=Vdd}
C {buffer.sym} 580 110 0 0 {name=x2}
