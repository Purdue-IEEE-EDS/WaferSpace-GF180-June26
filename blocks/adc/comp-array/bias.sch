v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 470 150 470 170 {lab=nbias}
N 470 130 470 150 {lab=nbias}
N 410 200 430 200 {lab=nbias}
N 410 160 410 200 {lab=nbias}
N 410 160 470 160 {lab=nbias}
N 650 190 650 210 {lab=vss}
N 650 110 650 130 {lab=nbias}
C {title.sym} 20 -40 0 0 {name=l2 author="Pranav Vadde"}
C {iopin.sym} 210 100 0 0 {name=pvdd lab=vdd}
C {iopin.sym} 210 130 0 0 {name=pvss lab=vss}
C {opin.sym} 200 160 0 0 {name=p1 lab=nbias}
C {symbols/nfet_03v3.sym} 450 200 0 0 {name=Mref
L=0.5u
W=4u
nf=2
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 470 200 0 1 {name=p16 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 470 230 0 1 {name=p17 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 470 150 0 0 {name=p3 sig_type=std_logic lab=nbias
}
C {symbols/ppolyf_u_3k.sym} 470 100 0 0 {name=R1
W=1e-6
L=7.24e-6
model=ppolyf_u_3k
spiceprefix=X
m=1}
C {lab_wire.sym} 450 100 0 0 {name=p2 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 470 70 0 0 {name=p4 sig_type=std_logic lab=vdd
}
C {symbols/cap_nmos_03v3_b.sym} 650 160 0 0 {name=C1
W=16e-6
L=16e-6
model=cap_nmos_03v3_b
spiceprefix=X
m=1}
C {lab_wire.sym} 650 110 0 0 {name=p35 sig_type=std_logic lab=nbias
}
C {lab_wire.sym} 650 210 0 0 {name=p36 sig_type=std_logic lab=vss
}
