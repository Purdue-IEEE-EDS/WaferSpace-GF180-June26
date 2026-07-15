v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
C {opin.sym} 10 -20 0 0 {name=p1 lab=outp}
C {opin.sym} 10 0 0 0 {name=p2 lab=outn}
C {ipin.sym} 10 -60 0 0 {name=p3 lab=inp}
C {ipin.sym} 10 -40 0 0 {name=p4 lab=inn}
C {symbols/ppolyf_u_1k.sym} 170 -20 0 0 {name=R1
W=1u
L=6u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {iopin.sym} -20 40 0 0 {name=p5 lab=vss}
C {lab_wire.sym} 170 -50 0 0 {name=p31 sig_type=std_logic lab=inp}
C {lab_wire.sym} 170 10 0 0 {name=p6 sig_type=std_logic lab=outp}
C {lab_wire.sym} 150 -20 0 0 {name=p8 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 -10 0 0 {name=R2
W=1u
L=6u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 330 -40 0 0 {name=outn1 sig_type=std_logic lab=inn}
C {lab_wire.sym} 330 20 0 0 {name=outn2 sig_type=std_logic lab=outn}
C {lab_wire.sym} 310 -10 0 0 {name=outn3 sig_type=std_logic lab=vss}
