v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 100 -40 100 20 {lab=tail}
N 100 -40 220 -40 {lab=tail}
N -20 -40 100 -40 {lab=tail}
N -20 -80 -20 -40 {lab=tail}
N 220 -80 220 -40 {lab=tail}
N -20 -200 -20 -140 {lab=on}
N 220 -200 220 -140 {lab=op}
N -20 -300 -20 -260 {lab=vdd}
N -20 -300 220 -300 {lab=vdd}
N 220 -300 220 -260 {lab=vdd}
C {symbols/nfet_03v3.sym} 80 50 0 0 {name=M0
L=0.5u
W=64u
nf=8
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
C {lab_wire.sym} 100 -40 0 0 {name=p19 sig_type=std_logic lab=tail}
C {lab_wire.sym} 60 50 0 0 {name=p2 sig_type=std_logic lab=nbias
}
C {symbols/nfet_03v3.sym} -40 -110 0 0 {name=M1
L=0.28u
W=96u
nf=20
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
C {lab_wire.sym} -60 -110 0 0 {name=p3 sig_type=std_logic lab=inp
}
C {symbols/nfet_03v3.sym} 240 -110 0 1 {name=M2
L=0.28u
W=96u
nf=20
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
C {lab_wire.sym} 260 -110 0 1 {name=p4 sig_type=std_logic lab=ref
}
C {lab_wire.sym} -20 -160 0 0 {name=p5 sig_type=std_logic lab=on}
C {lab_wire.sym} 220 -160 0 1 {name=p6 sig_type=std_logic lab=op
}
C {symbols/ppolyf_u_1k.sym} -20 -230 0 0 {name=RdP
W=1e-6
L=1.45e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {symbols/ppolyf_u_1k.sym} 220 -230 0 1 {name=RdN
W=1e-6
L=1.45e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 110 -300 0 0 {name=p7 sig_type=std_logic lab=vdd}
C {iopin.sym} -230 -180 0 0 {name=p1 lab=vdd}
C {ipin.sym} -180 -150 0 0 {name=p8 lab=inp}
C {ipin.sym} -180 -120 0 0 {name=p9 lab=ref}
C {ipin.sym} -180 -90 0 0 {name=p10 lab=nbias}
C {opin.sym} -230 -60 0 0 {name=p11 lab=op}
C {opin.sym} -230 -30 0 0 {name=p12 lab=on}
C {title.sym} -500 -500 0 0 {name=l2 author="Pranav Vadde"}
C {gnd.sym} 240 -230 3 0 {name=l5 lab=0
}
C {gnd.sym} -40 -230 1 1 {name=l6 lab=0
}
C {iopin.sym} -240 0 0 0 {name=p13 lab=vss}
C {lab_wire.sym} 220 -110 0 0 {name=p14 sig_type=std_logic lab=vss
}
C {lab_wire.sym} -20 -110 0 1 {name=p15 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 100 50 0 1 {name=p16 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 100 80 0 1 {name=p17 sig_type=std_logic lab=vss
}
