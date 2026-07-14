v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 470 20 470 80 {lab=tailB}
N 470 20 590 20 {lab=tailB}
N 350 20 470 20 {lab=tailB}
N 350 -20 350 20 {lab=tailB}
N 590 -20 590 20 {lab=tailB}
N 350 -140 350 -80 {lab=op}
N 590 -140 590 -80 {lab=on}
N 350 -240 350 -200 {lab=vdd}
N 350 -240 590 -240 {lab=vdd}
N 590 -240 590 -200 {lab=vdd}
N 100 -40 100 -20 {lab=tailA}
N 100 -40 180 -40 {lab=tailA}
N 20 -40 100 -40 {lab=tailA}
N -20 -190 -20 -130 {lab=on}
N 220 -190 220 -130 {lab=op}
N 220 -70 220 -40 {lab=tailA}
N 180 -40 220 -40 {lab=tailA}
N -20 -40 20 -40 {lab=tailA}
N -20 -70 -20 -40 {lab=tailA}
C {symbols/nfet_03v3.sym} 450 110 0 0 {name=M0b
L=0.5u
W=12u
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
C {lab_wire.sym} 470 20 0 0 {name=p19 sig_type=std_logic lab=tailB}
C {lab_wire.sym} 430 110 0 0 {name=p2 sig_type=std_logic lab=nbias
}
C {symbols/nfet_03v3.sym} 330 -50 0 0 {name=M2b
L=0.28u
W=24u
nf=12
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
C {lab_wire.sym} 310 -50 0 0 {name=p3 sig_type=std_logic lab=inn
}
C {symbols/nfet_03v3.sym} 610 -50 0 1 {name=M1b
L=0.28u
W=24u
nf=12
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
C {lab_wire.sym} 630 -50 0 1 {name=p4 sig_type=std_logic lab=refn
}
C {lab_wire.sym} 350 -100 0 0 {name=p5 sig_type=std_logic lab=op}
C {lab_wire.sym} 590 -100 0 1 {name=p6 sig_type=std_logic lab=on
}
C {symbols/ppolyf_u_1k.sym} 350 -170 0 0 {name=RdP
W=2u
L=10.7u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {symbols/ppolyf_u_1k.sym} 590 -170 0 1 {name=RdN
W=2u
L=10.7u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 480 -240 0 0 {name=p7 sig_type=std_logic lab=vdd}
C {iopin.sym} -230 -180 0 0 {name=p1 lab=vdd}
C {ipin.sym} -180 -150 0 0 {name=p8 lab=inp}
C {ipin.sym} -180 -120 0 0 {name=p9 lab=refp}
C {ipin.sym} -180 -90 0 0 {name=p10 lab=nbias}
C {opin.sym} -230 -60 0 0 {name=p11 lab=op}
C {opin.sym} -230 -30 0 0 {name=p12 lab=on}
C {iopin.sym} -240 0 0 0 {name=p13 lab=vss}
C {lab_wire.sym} 590 -50 0 0 {name=p14 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 350 -50 0 1 {name=p15 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 470 110 0 1 {name=p16 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 470 140 0 1 {name=p17 sig_type=std_logic lab=vss
}
C {ipin.sym} -120 -150 0 0 {name=p18 lab=inn}
C {ipin.sym} -110 -120 0 0 {name=p20 lab=refn}
C {symbols/nfet_03v3.sym} 80 10 0 0 {name=M0a
L=0.5u
W=12u
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
C {lab_wire.sym} 60 10 0 0 {name=p21 sig_type=std_logic lab=nbias
}
C {lab_wire.sym} 100 10 0 1 {name=p22 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 100 40 0 1 {name=p23 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 100 -40 0 0 {name=p27 sig_type=std_logic lab=tailA}
C {symbols/nfet_03v3.sym} -40 -100 0 0 {name=M1a
L=0.28u
W=24u
nf=12
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
C {lab_wire.sym} -60 -100 0 0 {name=p29 sig_type=std_logic lab=inp
}
C {symbols/nfet_03v3.sym} 240 -100 0 1 {name=M2a
L=0.28u
W=24u
nf=12
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
C {lab_wire.sym} 260 -100 0 1 {name=p30 sig_type=std_logic lab=refp
}
C {lab_wire.sym} -20 -150 0 0 {name=p31 sig_type=std_logic lab=on}
C {lab_wire.sym} 220 -150 0 1 {name=p32 sig_type=std_logic lab=op
}
C {lab_wire.sym} 220 -100 0 0 {name=p33 sig_type=std_logic lab=vss
}
C {lab_wire.sym} -20 -100 0 1 {name=p34 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 610 -170 0 1 {name=p24 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 330 -170 0 0 {name=p25 sig_type=std_logic lab=vss
}
