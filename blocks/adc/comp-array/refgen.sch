v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 190 -40 190 -10 {lab=vrefp}
N 380 -40 380 -10 {lab=vrefn}
C {iopin.sym} -20 -60 0 0 {name=pvdd lab=vdd}
C {iopin.sym} -20 -30 0 0 {name=pvss lab=vss}
C {opin.sym} -30 0 0 0 {name=p1 lab=vrefp}
C {opin.sym} -30 30 0 0 {name=p5 lab=vrefn}
C {symbols/ppolyf_u_1k.sym} 190 -70 0 0 {name=Rtop
W=2u
L=80.5u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 190 -100 0 0 {name=p119 sig_type=std_logic lab=vdd
}
C {lab_wire.sym} 190 -30 2 1 {name=p2 sig_type=std_logic lab=vrefp
}
C {lab_wire.sym} 170 -70 0 0 {name=p3 sig_type=std_logic lab=vss
}
C {symbols/ppolyf_u_1k.sym} 380 -70 0 0 {name=Rbot
W=2u
L=94.5u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 380 -100 0 0 {name=Rbot1 sig_type=std_logic lab=vss
L=94.5u}
C {lab_wire.sym} 380 -30 2 1 {name=Rbot2 sig_type=std_logic lab=vrefn
L=94.5u}
C {lab_wire.sym} 360 -70 0 0 {name=Rbot3 sig_type=std_logic lab=vss
L=94.5u}
C {symbols/cap_nmos_03v3_b.sym} 190 20 0 0 {name=Cpz
W=22.4u
L=22.4u
model=cap_nmos_03v3_b
spiceprefix=X
m=1}
C {lab_wire.sym} 190 50 2 1 {name=p7 sig_type=std_logic lab=vss

}
C {symbols/cap_nmos_03v3_b.sym} 380 20 0 0 {name=Cnz
W=22.4u
L=22.4u
model=cap_nmos_03v3_b
spiceprefix=X
m=1}
C {lab_wire.sym} 380 50 2 1 {name=p4 sig_type=std_logic lab=vss

}
