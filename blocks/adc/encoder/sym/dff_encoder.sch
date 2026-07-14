v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 1660 360 1710 360 {lab=Q}
N 1710 360 1840 360 {lab=Q}
N 550 140 550 160 {lab=VDD}
N 545 190 560 190 {lab=VDD}
N 545 340 560 340 {lab=VDD}
N 780 140 780 160 {lab=VDD}
N 775 190 790 190 {lab=VDD}
N 780 290 780 310 {lab=#net1}
N 775 340 790 340 {lab=VDD}
N 1000 140 1000 160 {lab=VDD}
N 995 190 1010 190 {lab=VDD}
N 550 520 550 540 {lab=GND}
N 550 490 570 490 {lab=GND}
N 470 490 510 490 {lab=D}
N 550 370 550 460 {lab=A}
N 780 490 800 490 {lab=GND}
N 700 490 740 490 {lab=A}
N 1210 340 1230 340 {lab=GND}
N 1130 340 1170 340 {lab=CLK}
N 1210 520 1210 540 {lab=GND}
N 1210 490 1230 490 {lab=GND}
N 1130 490 1170 490 {lab=B}
N 1440 520 1440 540 {lab=GND}
N 1440 490 1460 490 {lab=GND}
N 1360 490 1400 490 {lab=QB}
N 1440 290 1440 310 {lab=VDD}
N 1435 340 1450 340 {lab=VDD}
N 1210 140 1210 160 {lab=VDD}
N 1205 190 1220 190 {lab=VDD}
N 550 220 550 310 {lab=#net2}
N 470 190 510 190 {lab=D}
N 470 340 510 340 {lab=CLK}
N 400 490 470 490 {lab=D}
N 400 190 400 490 {lab=D}
N 400 190 470 190 {lab=D}
N 360 340 400 340 {lab=D}
N 550 420 670 420 {lab=A}
N 670 340 670 420 {lab=A}
N 670 340 740 340 {lab=A}
N 690 190 740 190 {lab=CLK}
N 920 190 960 190 {lab=RST}
N 780 650 780 670 {lab=GND}
N 780 620 800 620 {lab=GND}
N 700 620 740 620 {lab=CLK}
N 780 370 780 460 {lab=B}
N 780 220 780 290 {lab=#net1}
N 1050 190 1170 190 {lab=B}
N 1050 190 1050 490 {lab=B}
N 1050 490 1130 490 {lab=B}
N 1000 220 1000 280 {lab=B}
N 1000 280 1050 280 {lab=B}
N 780 400 1050 400 {lab=B}
N 1360 340 1400 340 {lab=QB}
N 1360 340 1360 490 {lab=QB}
N 1440 370 1440 460 {lab=Q}
N 1440 420 1490 420 {lab=Q}
N 1210 220 1210 310 {lab=QB}
N 1210 370 1210 460 {lab=#net3}
N 1210 280 1360 280 {lab=QB}
N 1360 280 1360 350 {lab=QB}
N 670 490 700 490 {lab=A}
N 670 420 670 490 {lab=A}
N 780 520 780 590 {lab=#net4}
N 1580 360 1660 360 {lab=Q}
N 1580 360 1580 420 {lab=Q}
N 1490 420 1580 420 {lab=Q}
C {opin.sym} 1840 360 0 0 {name=p19 lab=Q}
C {ipin.sym} 360 340 0 0 {name=p22 lab=D}
C {symbols/pfet_03v3.sym} 530 190 0 0 {name=M1
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
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 555 190 0 0 {name=p23 sig_type=std_logic lab=VDD
m=8}
C {symbols/pfet_03v3.sym} 530 340 0 0 {name=M7
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
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 555 340 0 0 {name=p35 sig_type=std_logic lab=VDD
m=35}
C {symbols/pfet_03v3.sym} 760 190 0 0 {name=M8
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
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 785 190 0 0 {name=p38 sig_type=std_logic lab=VDD
m=8}
C {symbols/pfet_03v3.sym} 760 340 0 0 {name=M9
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
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 785 340 0 0 {name=p39 sig_type=std_logic lab=VDD
m=35}
C {symbols/pfet_03v3.sym} 980 190 0 0 {name=M10
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
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 1005 190 0 0 {name=p40 sig_type=std_logic lab=VDD
m=8}
C {symbols/nfet_03v3.sym} 530 490 0 0 {name=M19
L=0.28u
W=0.36u
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
C {lab_wire.sym} 565 490 0 0 {name=p41 sig_type=std_logic lab=GND
m=3}
C {symbols/nfet_03v3.sym} 760 490 0 0 {name=M20
L=0.28u
W=0.36u
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
C {lab_wire.sym} 795 490 0 0 {name=p42 sig_type=std_logic lab=GND
m=1}
C {symbols/nfet_03v3.sym} 1190 340 0 0 {name=M21
L=0.28u
W=0.36u
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
C {lab_wire.sym} 1225 340 0 0 {name=p43 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 1190 490 0 0 {name=M22
L=0.28u
W=0.36u
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
C {lab_wire.sym} 1225 490 0 0 {name=p44 sig_type=std_logic lab=GND}
C {lab_wire.sym} 1210 540 0 0 {name=p45 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 1420 490 0 0 {name=M23
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
C {lab_wire.sym} 1455 490 0 0 {name=p46 sig_type=std_logic lab=GND}
C {lab_wire.sym} 1440 540 0 0 {name=p47 sig_type=std_logic lab=GND}
C {symbols/pfet_03v3.sym} 1420 340 0 0 {name=M24
L=0.28u
W=1.76u
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
C {lab_wire.sym} 1445 340 0 0 {name=p48 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1190 190 0 0 {name=M25
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
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 1215 190 0 0 {name=p49 sig_type=std_logic lab=VDD
m=8}
C {symbols/nfet_03v3.sym} 760 620 0 0 {name=M26
L=0.28u
W=0.36u
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
C {lab_wire.sym} 795 620 0 0 {name=p50 sig_type=std_logic lab=GND
m=1}
C {lab_wire.sym} 780 670 0 0 {name=p51 sig_type=std_logic lab=GND
m=1}
C {lab_wire.sym} 780 140 0 0 {name=p52 sig_type=std_logic lab=VDD
m=8}
C {lab_wire.sym} 1000 140 0 0 {name=p53 sig_type=std_logic lab=VDD
m=8}
C {lab_wire.sym} 1210 140 0 0 {name=p54 sig_type=std_logic lab=VDD
m=8}
C {lab_wire.sym} 1440 290 0 0 {name=p55 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 720 620 0 0 {name=p56 sig_type=std_logic lab=CLK
m=1}
C {lab_wire.sym} 1140 340 0 0 {name=p57 sig_type=std_logic lab=CLK}
C {lab_wire.sym} 720 190 0 0 {name=p58 sig_type=std_logic lab=CLK
m=8}
C {ipin.sym} 480 340 0 0 {name=p59 lab=CLK}
C {ipin.sym} 930 190 0 0 {name=p60 lab=RST
m=8}
C {ipin.sym} 550 140 0 0 {name=p61 lab=VDD
m=8}
C {ipin.sym} 550 540 0 0 {name=p62 lab=GND
m=3}
C {lab_wire.sym} 680 340 0 0 {name=p63 sig_type=std_logic lab=A
m=3}
C {lab_wire.sym} 970 400 0 0 {name=p64 sig_type=std_logic lab=B
m=3}
C {lab_wire.sym} 1330 280 0 0 {name=p65 sig_type=std_logic lab=QB
m=3}
