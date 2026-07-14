v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 640 -500 640 -485 {lab=VDD}
N 640 -640 640 -620 {lab=GND}
N 670 -640 670 -490 {lab=#net2}
N 610 -640 610 -490 {lab=#net3}
N 640 -220 640 -205 {lab=VDD}
N 640 -360 640 -340 {lab=GND}
N 670 -360 670 -210 {lab=#net4}
N 610 -360 610 -210 {lab=#net5}
N 640 -450 640 -400 {lab=#net6}
N 570 -570 610 -570 {lab=#net3}
N 670 -570 700 -570 {lab=#net2}
N 580 -290 610 -290 {lab=#net5}
N 670 -290 700 -290 {lab=#net4}
N 640 -710 640 -680 {lab=#net7}
N 640 -170 640 -150 {lab=#net8}
C {j_counter.sym} 310 -680 0 0 {name=x1}
C {shift_reg.sym} 240 0 0 0 {name=x2}
C {tspc_dff.sym} 960 -250 0 0 {name=x3}
C {tspc_dff.sym} 960 -80 0 0 {name=x4}
C {tspc_dff.sym} 960 80 0 0 {name=x5}
C {tspc_dff.sym} 960 240 0 0 {name=x6}
C {opin.sym} 1070 -715 0 0 {name=p22 lab=out}
C {ipin.sym} 965 -565 0 0 {name=p3 lab=VDD}
C {symbols/pfet_03v3.sym} 640 -470 3 0 {name=M1
L=0.28u
W=0.22u
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
C {lab_wire.sym} 640 -495 3 0 {name=p8 sig_type=std_logic lab=VDD
W=3.3u
nf=1
m=15}
C {symbols/nfet_03v3.sym} 640 -660 1 0 {name=M2
L=0.28u
W=0.22u
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
C {lab_wire.sym} 640 -625 1 0 {name=p9 sig_type=std_logic lab=GND
nf=4
W=2.54u}
C {symbols/pfet_03v3.sym} 640 -190 3 0 {name=M3
L=0.28u
W=0.22u
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
C {lab_wire.sym} 640 -215 3 0 {name=p6 sig_type=std_logic lab=VDD
W=3.3u
nf=1
m=15}
C {symbols/nfet_03v3.sym} 640 -380 1 0 {name=M4
L=0.28u
W=0.22u
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
C {lab_wire.sym} 640 -345 1 0 {name=p10 sig_type=std_logic lab=GND
nf=4
W=2.54u}
