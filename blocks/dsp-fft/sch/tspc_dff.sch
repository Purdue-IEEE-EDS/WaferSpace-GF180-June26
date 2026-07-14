v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 310 -540 310 -520 {lab=VDD}
N 305 -490 320 -490 {lab=VDD}
N 305 -340 320 -340 {lab=VDD}
N 540 -540 540 -520 {lab=VDD}
N 535 -490 550 -490 {lab=VDD}
N 1060 -660 1060 -640 {lab=VDD}
N 1055 -610 1070 -610 {lab=VDD}
N 310 -160 310 -140 {lab=GND}
N 310 -190 330 -190 {lab=GND}
N 230 -190 270 -190 {lab=D}
N 310 -310 310 -220 {lab=#net1}
N 540 -190 560 -190 {lab=GND}
N 460 -190 500 -190 {lab=#net1}
N 970 -340 990 -340 {lab=GND}
N 890 -340 930 -340 {lab=CLK}
N 970 -160 970 -140 {lab=GND}
N 970 -190 990 -190 {lab=GND}
N 890 -190 930 -190 {lab=#net2}
N 1200 -160 1200 -140 {lab=GND}
N 1200 -190 1220 -190 {lab=GND}
N 1120 -190 1160 -190 {lab=Q}
N 1200 -390 1200 -370 {lab=VDD}
N 1195 -340 1210 -340 {lab=VDD}
N 970 -540 970 -520 {lab=VDD}
N 965 -490 980 -490 {lab=VDD}
N 310 -460 310 -370 {lab=#net3}
N 230 -490 270 -490 {lab=D}
N 230 -340 270 -340 {lab=CLK}
N 160 -190 230 -190 {lab=D}
N 160 -490 160 -190 {lab=D}
N 160 -490 230 -490 {lab=D}
N 120 -340 160 -340 {lab=D}
N 310 -260 430 -260 {lab=#net1}
N 450 -490 500 -490 {lab=CLK}
N 980 -610 1020 -610 {lab=RST}
N 540 -30 540 -10 {lab=GND}
N 540 -60 560 -60 {lab=GND}
N 460 -60 500 -60 {lab=CLK}
N 810 -490 930 -490 {lab=#net2}
N 810 -490 810 -190 {lab=#net2}
N 810 -190 890 -190 {lab=#net2}
N 1060 -580 1060 -520 {lab=Q}
N 540 -280 810 -280 {lab=#net2}
N 1120 -340 1160 -340 {lab=Q}
N 1120 -340 1120 -190 {lab=Q}
N 1200 -310 1200 -220 {lab=Q}
N 1200 -260 1250 -260 {lab=Q}
N 970 -460 970 -370 {lab=Q}
N 970 -310 970 -220 {lab=#net4}
N 970 -400 1120 -400 {lab=Q}
N 1120 -400 1120 -330 {lab=Q}
N 430 -190 460 -190 {lab=#net1}
N 430 -260 430 -190 {lab=#net1}
N 540 -160 540 -90 {lab=#net5}
N 1060 -520 1060 -400 {lab=Q}
N 540 -460 540 -220 {lab=#net2}
C {opin.sym} 1250 -260 0 0 {name=p425 lab=Q}
C {ipin.sym} 120 -340 0 0 {name=p17 lab=D}
C {symbols/pfet_03v3.sym} 290 -490 0 0 {name=M2
L=0.28u
W=0.33u
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
C {lab_wire.sym} 315 -490 0 0 {name=p3 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 290 -340 0 0 {name=M3
L=0.28u
W=0.33u
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
C {lab_wire.sym} 315 -340 0 0 {name=p5 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 520 -490 0 0 {name=M4
L=0.28u
W=0.33u
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
C {lab_wire.sym} 545 -490 0 0 {name=p4 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1040 -610 0 0 {name=M6
L=0.28u
W=0.33u
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
C {lab_wire.sym} 1065 -610 0 0 {name=p7 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 290 -190 0 0 {name=M11
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
C {lab_wire.sym} 325 -190 0 0 {name=p8 sig_type=std_logic lab=GND
m=1}
C {symbols/nfet_03v3.sym} 520 -190 0 0 {name=M12
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
C {lab_wire.sym} 555 -190 0 0 {name=p10 sig_type=std_logic lab=GND
W=0.42u
m=1}
C {symbols/nfet_03v3.sym} 950 -340 0 0 {name=M13
L=0.28u
W=0.33u
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
C {lab_wire.sym} 985 -340 0 0 {name=p12 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 950 -190 0 0 {name=M14
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
C {lab_wire.sym} 985 -190 0 0 {name=p24 sig_type=std_logic lab=GND
W=0.42u
m=1}
C {lab_wire.sym} 970 -140 0 0 {name=p25 sig_type=std_logic lab=GND
W=0.42u
m=1}
C {symbols/nfet_03v3.sym} 1180 -190 0 0 {name=M15
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
C {lab_wire.sym} 1215 -190 0 0 {name=p26 sig_type=std_logic lab=GND
W=0.42u
m=1}
C {lab_wire.sym} 1200 -140 0 0 {name=p27 sig_type=std_logic lab=GND
W=0.42u
m=1}
C {symbols/pfet_03v3.sym} 1180 -340 0 0 {name=M16
L=0.28u
W=0.33u
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
C {lab_wire.sym} 1205 -340 0 0 {name=p28 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 950 -490 0 0 {name=M17
L=0.28u
W=0.33u
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
C {lab_wire.sym} 975 -490 0 0 {name=p29 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 520 -60 0 0 {name=M18
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
C {lab_wire.sym} 555 -60 0 0 {name=p30 sig_type=std_logic lab=GND
W=0.42u
m=1}
C {lab_wire.sym} 540 -10 0 0 {name=p31 sig_type=std_logic lab=GND
W=0.42u
m=1}
C {lab_wire.sym} 540 -540 0 0 {name=p14 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 1060 -660 0 0 {name=p32 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 970 -540 0 0 {name=p33 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 1200 -390 0 0 {name=p34 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 480 -60 0 0 {name=p36 sig_type=std_logic lab=CLK
m=1}
C {lab_wire.sym} 900 -340 0 0 {name=p37 sig_type=std_logic lab=CLK}
C {lab_wire.sym} 480 -490 0 0 {name=p2 sig_type=std_logic lab=CLK}
C {ipin.sym} 240 -340 0 0 {name=p11 lab=CLK}
C {ipin.sym} 990 -610 0 0 {name=p13 lab=RST}
C {ipin.sym} 310 -540 0 0 {name=p1 lab=VDD}
C {ipin.sym} 310 -140 0 0 {name=p9 lab=GND
m=1}
C {opin.sym} 1120 -270 0 0 {name=p6 lab=QB}
