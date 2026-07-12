v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 610 -160 610 -140 {lab=#net1}
N 610 -110 680 -110 {lab=#net1}
N 680 -160 680 -110 {lab=#net1}
N 610 -160 680 -160 {lab=#net1}
N 680 -110 680 -80 {lab=#net1}
N 680 -70 800 -70 {lab=#net1}
N 680 -80 680 -70 {lab=#net1}
N 800 -80 800 -70 {lab=#net1}
N 610 30 610 40 {lab=#net2}
N 610 40 710 40 {lab=#net2}
N 710 -40 710 40 {lab=#net2}
N 710 -40 810 -40 {lab=#net2}
N 810 -40 810 -30 {lab=#net2}
N 800 -70 900 -70 {lab=#net1}
N 900 -110 900 -70 {lab=#net1}
N 900 -110 920 -110 {lab=#net1}
N 810 -40 900 -40 {lab=#net2}
N 900 -40 900 0 {lab=#net2}
N 900 0 920 0 {lab=#net2}
N 960 -80 960 -30 {lab=outp}
N 960 0 990 0 {lab=outp}
N 990 -40 990 0 {lab=outp}
N 960 -40 990 -40 {lab=outp}
N 610 80 610 100 {lab=#net3}
N 610 130 680 130 {lab=#net3}
N 680 80 680 130 {lab=#net3}
N 610 80 680 80 {lab=#net3}
N 680 130 680 160 {lab=#net3}
N 680 170 800 170 {lab=#net3}
N 680 160 680 170 {lab=#net3}
N 800 160 800 170 {lab=#net3}
N 610 270 610 280 {lab=#net4}
N 610 280 710 280 {lab=#net4}
N 710 200 710 280 {lab=#net4}
N 710 200 810 200 {lab=#net4}
N 810 200 810 210 {lab=#net4}
N 800 170 900 170 {lab=#net3}
N 900 130 900 170 {lab=#net3}
N 900 130 920 130 {lab=#net3}
N 810 200 900 200 {lab=#net4}
N 900 200 900 240 {lab=#net4}
N 900 240 920 240 {lab=#net4}
N 960 160 960 210 {lab=outn}
N 960 240 990 240 {lab=outn}
N 990 200 990 240 {lab=outn}
N 960 200 990 200 {lab=outn}
N 530 190 530 240 {lab=inn}
N 530 240 570 240 {lab=inn}
N 530 130 530 190 {lab=inn}
N 530 130 570 130 {lab=inn}
N 530 -50 530 -0 {lab=inp}
N 530 -0 570 0 {lab=inp}
N 530 -110 530 -50 {lab=inp}
N 530 -110 570 -110 {lab=inp}
N 200 180 200 220 {lab=nbias}
N 240 250 330 250 {lab=nbias}
N 200 200 280 200 {lab=nbias}
N 280 200 280 250 {lab=nbias}
N 370 100 370 120 {lab=pbias}
N 310 100 370 100 {lab=pbias}
N 310 100 310 150 {lab=pbias}
N 310 150 330 150 {lab=pbias}
N 310 150 310 190 {lab=pbias}
N 310 190 310 200 {lab=pbias}
N 310 200 370 200 {lab=pbias}
N 370 200 370 220 {lab=pbias}
C {iopin.sym} -20 -150 0 0 {name=p1 lab=vdd}
C {ipin.sym} 30 -120 0 0 {name=p8 lab=inp}
C {opin.sym} -20 -30 0 0 {name=p11 lab=outp}
C {opin.sym} -20 0 0 0 {name=p12 lab=outn}
C {iopin.sym} -30 30 0 0 {name=p13 lab=vss}
C {ipin.sym} 30 -90 0 0 {name=p18 lab=inn}
C {title.sym} 90 -220 0 0 {name=l2 author="Pranav Vadde"}
C {symbols/ppolyf_u_1k.sym} 200 150 0 1 {name=Rb
W=1u
L=9u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 220 150 0 1 {name=p59 sig_type=std_logic lab=vss}
C {lab_wire.sym} 200 120 0 1 {name=p2 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 240 200 0 1 {name=p3 sig_type=std_logic lab=nbias
}
C {symbols/pfet_03v3.sym} 350 150 0 0 {name=Mrp
L=0.7u
W=8u
nf=4
m=4
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 220 250 0 1 {name=Mrn
L=0.7u
W=8u
nf=4
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 200 250 0 0 {name=p6 sig_type=std_logic lab=vss}
C {lab_wire.sym} 200 280 0 0 {name=p7 sig_type=std_logic lab=vss}
C {lab_wire.sym} 370 150 0 1 {name=p9 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 370 180 0 1 {name=p14 sig_type=std_logic lab=vdd}
C {symbols/nfet_03v3.sym} 350 250 0 0 {name=Mrpn
L=0.7u
W=8u
nf=4
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 360 200 0 0 {name=Mrpn2 sig_type=std_logic lab=pbias
}
C {lab_wire.sym} 370 250 0 1 {name=Mrpn3 sig_type=std_logic lab=vss}
C {lab_wire.sym} 370 280 0 1 {name=Mrpn4 sig_type=std_logic lab=vss}
C {symbols/pfet_03v3.sym} 590 -110 0 0 {name=Mp1p
L=0.28u
W=100u
nf=8
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 610 -80 0 1 {name=p19 sig_type=std_logic lab=vss}
C {lab_wire.sym} 530 -50 0 0 {name=p20 sig_type=std_logic lab=inp
}
C {lab_wire.sym} 760 -110 0 0 {name=Mrpn6 sig_type=std_logic lab=pbias
}
C {lab_wire.sym} 800 -110 0 1 {name=Mrpn8 sig_type=std_logic lab=vdd}
C {symbols/pfet_03v3.sym} 780 -110 0 0 {name=Mb1p
L=0.7u
W=8u
nf=4
m=18
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 800 -140 0 1 {name=Mrpn9 sig_type=std_logic lab=vdd}
C {symbols/nfet_03v3.sym} 590 0 0 0 {name=Mn1p
L=0.28u
W=16u
nf=4
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
C {lab_wire.sym} 610 -30 0 0 {name=p21 sig_type=std_logic lab=vdd
}
C {lab_wire.sym} 610 0 0 1 {name=p22 sig_type=std_logic lab=vss}
C {symbols/nfet_03v3.sym} 790 0 0 0 {name=Mb2p
L=0.7u
W=8u
nf=4
m=4
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 770 0 0 0 {name=p23 sig_type=std_logic lab=nbias
}
C {lab_wire.sym} 810 0 0 1 {name=p25 sig_type=std_logic lab=vss}
C {lab_wire.sym} 810 30 0 1 {name=p24 sig_type=std_logic lab=vss}
C {symbols/nfet_03v3.sym} 940 -110 0 0 {name=MNp
L=0.28u
W=60u
nf=10
m=3
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 960 -140 0 0 {name=p26 sig_type=std_logic lab=vdd
}
C {lab_wire.sym} 960 -110 0 1 {name=p27 sig_type=std_logic lab=vss}
C {symbols/pfet_03v3.sym} 940 0 0 0 {name=MPp
L=0.28u
W=60u
nf=10
m=6
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 960 30 0 1 {name=p29 sig_type=std_logic lab=vss}
C {lab_wire.sym} 960 -50 0 1 {name=p28 sig_type=std_logic lab=outp}
C {symbols/pfet_03v3.sym} 590 130 0 0 {name=Mp1n
L=0.28u
W=100u
nf=8
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 610 160 0 1 {name=p30 sig_type=std_logic lab=vss}
C {lab_wire.sym} 760 130 0 0 {name=Mrpn5 sig_type=std_logic lab=pbias
}
C {lab_wire.sym} 800 130 0 1 {name=Mrpn7 sig_type=std_logic lab=vdd}
C {symbols/pfet_03v3.sym} 780 130 0 0 {name=Mb1n
L=0.7u
W=8u
nf=4
m=18
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 800 100 0 1 {name=Mrpn10 sig_type=std_logic lab=vdd}
C {symbols/nfet_03v3.sym} 590 240 0 0 {name=Mn1n
L=0.28u
W=16u
nf=4
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
C {lab_wire.sym} 530 190 0 0 {name=p32 sig_type=std_logic lab=inn
}
C {lab_wire.sym} 610 210 0 0 {name=p33 sig_type=std_logic lab=vdd
}
C {lab_wire.sym} 610 240 0 1 {name=p34 sig_type=std_logic lab=vss}
C {symbols/nfet_03v3.sym} 790 240 0 0 {name=Mb2n
L=0.7u
W=8u
nf=4
m=4
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 770 240 0 0 {name=p35 sig_type=std_logic lab=nbias
}
C {lab_wire.sym} 810 240 0 1 {name=p36 sig_type=std_logic lab=vss}
C {lab_wire.sym} 810 270 0 1 {name=p37 sig_type=std_logic lab=vss}
C {symbols/nfet_03v3.sym} 940 130 0 0 {name=MNn
L=0.28u
W=60u
nf=10
m=3
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 960 100 0 0 {name=p38 sig_type=std_logic lab=vdd
}
C {lab_wire.sym} 960 130 0 1 {name=p39 sig_type=std_logic lab=vss}
C {symbols/pfet_03v3.sym} 940 240 0 0 {name=MPn
L=0.28u
W=60u
nf=10
m=6
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 960 270 0 1 {name=p40 sig_type=std_logic lab=vss}
C {lab_wire.sym} 960 190 0 1 {name=p41 sig_type=std_logic lab=outn}
