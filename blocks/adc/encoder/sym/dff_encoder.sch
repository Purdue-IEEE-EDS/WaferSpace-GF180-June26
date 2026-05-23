v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 350 -610 350 -590 {lab=VDD}
N 345 -560 360 -560 {lab=VDD}
N 345 -410 360 -410 {lab=VDD}
N 580 -610 580 -590 {lab=VDD}
N 575 -560 590 -560 {lab=VDD}
N 580 -460 580 -440 {lab=#net1}
N 575 -410 590 -410 {lab=VDD}
N 800 -610 800 -590 {lab=VDD}
N 795 -560 810 -560 {lab=VDD}
N 350 -230 350 -210 {lab=GND}
N 350 -260 370 -260 {lab=GND}
N 270 -260 310 -260 {lab=D}
N 350 -380 350 -290 {lab=A}
N 580 -260 600 -260 {lab=GND}
N 500 -260 540 -260 {lab=A}
N 1010 -410 1030 -410 {lab=GND}
N 930 -410 970 -410 {lab=CLK}
N 1010 -230 1010 -210 {lab=GND}
N 1010 -260 1030 -260 {lab=GND}
N 930 -260 970 -260 {lab=B}
N 1240 -230 1240 -210 {lab=GND}
N 1240 -260 1260 -260 {lab=GND}
N 1160 -260 1200 -260 {lab=QB}
N 1240 -460 1240 -440 {lab=VDD}
N 1235 -410 1250 -410 {lab=VDD}
N 1010 -610 1010 -590 {lab=VDD}
N 1005 -560 1020 -560 {lab=VDD}
N 350 -530 350 -440 {lab=#net2}
N 270 -560 310 -560 {lab=D}
N 270 -410 310 -410 {lab=CLK}
N 200 -260 270 -260 {lab=D}
N 200 -560 200 -260 {lab=D}
N 200 -560 270 -560 {lab=D}
N 160 -410 200 -410 {lab=D}
N 350 -330 470 -330 {lab=A}
N 470 -410 470 -330 {lab=A}
N 470 -410 540 -410 {lab=A}
N 490 -560 540 -560 {lab=CLK}
N 720 -560 760 -560 {lab=RST}
N 580 -100 580 -80 {lab=GND}
N 580 -130 600 -130 {lab=GND}
N 500 -130 540 -130 {lab=CLK}
N 580 -380 580 -290 {lab=B}
N 580 -530 580 -460 {lab=#net1}
N 850 -560 970 -560 {lab=B}
N 850 -560 850 -260 {lab=B}
N 850 -260 930 -260 {lab=B}
N 800 -530 800 -470 {lab=B}
N 800 -470 850 -470 {lab=B}
N 580 -350 850 -350 {lab=B}
N 1160 -410 1200 -410 {lab=QB}
N 1160 -410 1160 -260 {lab=QB}
N 1240 -380 1240 -290 {lab=Q}
N 1240 -330 1290 -330 {lab=Q}
N 1010 -530 1010 -440 {lab=QB}
N 1010 -380 1010 -290 {lab=#net3}
N 1010 -470 1160 -470 {lab=QB}
N 1160 -470 1160 -400 {lab=QB}
N 470 -260 500 -260 {lab=A}
N 470 -330 470 -260 {lab=A}
N 580 -230 580 -160 {lab=#net4}
C {opin.sym} 1290 -330 0 0 {name=p425 lab=Q}
C {ipin.sym} 160 -410 0 0 {name=p17 lab=D}
C {symbols/pfet_03v3.sym} 330 -560 0 0 {name=M2
L=0.28u
W=0.22u
nf=1
m=8
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 355 -560 0 0 {name=p3 sig_type=std_logic lab=VDD
m=8}
C {symbols/pfet_03v3.sym} 330 -410 0 0 {name=M3
L=0.28u
W=0.22u
nf=1
m=8
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 355 -410 0 0 {name=p5 sig_type=std_logic lab=VDD
m=35}
C {symbols/pfet_03v3.sym} 560 -560 0 0 {name=M4
L=0.28u
W=0.22u
nf=1
m=8
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 585 -560 0 0 {name=p4 sig_type=std_logic lab=VDD
m=8}
C {symbols/pfet_03v3.sym} 560 -410 0 0 {name=M5
L=0.28u
W=0.22u
nf=1
m=8
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 585 -410 0 0 {name=p6 sig_type=std_logic lab=VDD
m=35}
C {symbols/pfet_03v3.sym} 780 -560 0 0 {name=M6
L=0.28u
W=0.22u
nf=1
m=8
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 805 -560 0 0 {name=p7 sig_type=std_logic lab=VDD
m=8}
C {symbols/nfet_03v3.sym} 330 -260 0 0 {name=M11
L=0.28u
W=0.22u
nf=1
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
C {lab_wire.sym} 365 -260 0 0 {name=p8 sig_type=std_logic lab=GND
m=3}
C {symbols/nfet_03v3.sym} 560 -260 0 0 {name=M12
L=0.28u
W=0.22u
nf=1
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
C {lab_wire.sym} 595 -260 0 0 {name=p10 sig_type=std_logic lab=GND
m=3}
C {symbols/nfet_03v3.sym} 990 -410 0 0 {name=M13
L=0.28u
W=0.22u
nf=1
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
C {lab_wire.sym} 1025 -410 0 0 {name=p12 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 990 -260 0 0 {name=M14
L=0.28u
W=0.22u
nf=1
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
C {lab_wire.sym} 1025 -260 0 0 {name=p24 sig_type=std_logic lab=GND}
C {lab_wire.sym} 1010 -210 0 0 {name=p25 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 1220 -260 0 0 {name=M15
L=0.28u
W=0.22u
nf=1
m=8
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 1255 -260 0 0 {name=p26 sig_type=std_logic lab=GND}
C {lab_wire.sym} 1240 -210 0 0 {name=p27 sig_type=std_logic lab=GND}
C {symbols/pfet_03v3.sym} 1220 -410 0 0 {name=M16
L=0.28u
W=0.22u
nf=1
m=16
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 1245 -410 0 0 {name=p28 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 990 -560 0 0 {name=M17
L=0.28u
W=0.22u
nf=1
m=8
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 1015 -560 0 0 {name=p29 sig_type=std_logic lab=VDD
m=8}
C {symbols/nfet_03v3.sym} 560 -130 0 0 {name=M18
L=0.28u
W=0.22u
nf=1
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
C {lab_wire.sym} 595 -130 0 0 {name=p30 sig_type=std_logic lab=GND
m=3}
C {lab_wire.sym} 580 -80 0 0 {name=p31 sig_type=std_logic lab=GND
m=3}
C {lab_wire.sym} 580 -610 0 0 {name=p14 sig_type=std_logic lab=VDD
m=8}
C {lab_wire.sym} 800 -610 0 0 {name=p32 sig_type=std_logic lab=VDD
m=8}
C {lab_wire.sym} 1010 -610 0 0 {name=p33 sig_type=std_logic lab=VDD
m=8}
C {lab_wire.sym} 1240 -460 0 0 {name=p34 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 520 -130 0 0 {name=p36 sig_type=std_logic lab=CLK
m=3}
C {lab_wire.sym} 940 -410 0 0 {name=p37 sig_type=std_logic lab=CLK}
C {lab_wire.sym} 520 -560 0 0 {name=p2 sig_type=std_logic lab=CLK
m=8}
C {ipin.sym} 280 -410 0 0 {name=p11 lab=CLK}
C {ipin.sym} 730 -560 0 0 {name=p13 lab=RST
m=8}
C {ipin.sym} 350 -610 0 0 {name=p1 lab=VDD
m=8}
C {ipin.sym} 350 -210 0 0 {name=p9 lab=GND
m=3}
C {lab_wire.sym} 480 -410 0 0 {name=p15 sig_type=std_logic lab=A
m=3}
C {lab_wire.sym} 770 -350 0 0 {name=p16 sig_type=std_logic lab=B
m=3}
C {lab_wire.sym} 1130 -470 0 0 {name=p18 sig_type=std_logic lab=QB
m=3}
