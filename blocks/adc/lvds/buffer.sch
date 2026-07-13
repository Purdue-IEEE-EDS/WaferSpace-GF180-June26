v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -90 -110 -40 -110 {lab=Vin_buff}
N -90 -110 -90 110 {lab=Vin_buff}
N -90 110 -40 110 {lab=Vin_buff}
N -0 -80 -0 80 {lab=#net1}
N -0 140 -0 180 {lab=GND}
N 0 -190 0 -140 {lab=VDD}
N 0 -110 80 -110 {lab=VDD}
N 80 -150 80 -110 {lab=VDD}
N 0 -150 80 -150 {lab=VDD}
N 0 110 110 110 {lab=GND}
N 110 110 110 170 {lab=GND}
N 0 170 110 170 {lab=GND}
N -170 0 -90 0 {lab=Vin_buff}
N 0 -0 200 -0 {lab=#net1}
N 330 -80 330 80 {lab=#net2}
N 220 -110 290 -110 {lab=#net1}
N 220 -110 220 110 {lab=#net1}
N 220 110 290 110 {lab=#net1}
N 200 -0 220 0 {lab=#net1}
N 330 -160 330 -140 {lab=VDD}
N 330 -170 330 -160 {lab=VDD}
N 330 -110 410 -110 {lab=VDD}
N 410 -150 410 -110 {lab=VDD}
N 330 -150 410 -150 {lab=VDD}
N 330 140 330 190 {lab=GND}
N 330 150 430 150 {lab=GND}
N 430 110 430 150 {lab=GND}
N 330 110 430 110 {lab=GND}
N 330 0 490 0 {lab=#net2}
N 620 -80 620 80 {lab=#net3}
N 510 -110 580 -110 {lab=#net2}
N 510 -110 510 110 {lab=#net2}
N 510 110 580 110 {lab=#net2}
N 490 0 510 0 {lab=#net2}
N 620 -160 620 -140 {lab=VDD}
N 620 -170 620 -160 {lab=VDD}
N 620 -110 700 -110 {lab=VDD}
N 700 -150 700 -110 {lab=VDD}
N 620 -150 700 -150 {lab=VDD}
N 620 140 620 190 {lab=GND}
N 620 150 720 150 {lab=GND}
N 720 110 720 150 {lab=GND}
N 620 110 720 110 {lab=GND}
N 620 0 780 0 {lab=#net3}
N 910 -80 910 80 {lab=Vout_buff}
N 800 -110 870 -110 {lab=#net3}
N 800 -110 800 110 {lab=#net3}
N 800 110 870 110 {lab=#net3}
N 780 0 800 0 {lab=#net3}
N 910 -160 910 -140 {lab=VDD}
N 910 -170 910 -160 {lab=VDD}
N 910 -110 990 -110 {lab=VDD}
N 990 -150 990 -110 {lab=VDD}
N 910 -150 990 -150 {lab=VDD}
N 910 140 910 190 {lab=GND}
N 910 150 1010 150 {lab=GND}
N 1010 110 1010 150 {lab=GND}
N 910 110 1010 110 {lab=GND}
N 910 0 1070 0 {lab=Vout_buff}
C {symbols/pfet_03v3.sym} -20 -110 0 0 {name=M1
L=0.28u
W=0.66u
nf=1
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
C {symbols/nfet_03v3.sym} -20 110 0 0 {name=M2
L=0.28u
W=0.3u
nf=1
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
C {ipin.sym} 0 -190 1 0 {name=p1 lab=VDD}
C {ipin.sym} -170 0 0 0 {name=p2 lab=Vin_buff}
C {symbols/pfet_03v3.sym} 310 -110 0 0 {name=M3
L=0.28u
W=2.64u
nf=1
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
C {symbols/nfet_03v3.sym} 310 110 0 0 {name=M4
L=0.28u
W=0.88u
nf=1
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
C {lab_wire.sym} 330 -170 0 0 {name=p3 sig_type=std_logic lab=VDD}
C {opin.sym} 1070 0 0 0 {name=p4 lab=Vout_buff}
C {symbols/pfet_03v3.sym} 600 -110 0 0 {name=M5
L=0.28u
W=10.56u
nf=1
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
C {symbols/nfet_03v3.sym} 600 110 0 0 {name=M6
L=0.28u
W=3.52u
nf=1
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
C {lab_wire.sym} 620 -170 0 0 {name=p5 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 890 -110 0 0 {name=M7
L=0.28u
W=45u
nf=15
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
C {symbols/nfet_03v3.sym} 890 110 0 0 {name=M8
L=0.28u
W=14u
nf=1
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
C {lab_wire.sym} 910 -170 0 0 {name=p6 sig_type=std_logic lab=VDD}
C {ipin.sym} 0 180 3 0 {name=p7 lab=GND}
C {lab_wire.sym} 330 190 3 0 {name=p8 sig_type=std_logic lab=GND}
C {lab_wire.sym} 620 190 3 0 {name=p9 sig_type=std_logic lab=GND}
C {lab_wire.sym} 910 190 3 0 {name=p10 sig_type=std_logic lab=GND}
