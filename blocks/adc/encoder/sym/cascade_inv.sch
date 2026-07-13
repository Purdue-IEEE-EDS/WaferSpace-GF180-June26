v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 265 -210 265 -130 {lab=CLK_EVAL}
N 265 -210 335 -210 {lab=CLK_EVAL}
N 265 -130 265 -60 {lab=CLK_EVAL}
N 265 -60 335 -60 {lab=CLK_EVAL}
N 375 -180 375 -90 {lab=#net1}
N 375 -130 485 -130 {lab=#net1}
N 375 -30 375 -10 {lab=GND}
N 375 -260 375 -240 {lab=VDD}
N 215 -130 255 -130 {lab=CLK_EVAL}
N 370 -210 385 -210 {lab=VDD}
N 375 -60 395 -60 {lab=GND}
N 255 -130 265 -130 {lab=CLK_EVAL}
N 525 -180 525 -90 {lab=#net2}
N 525 -130 635 -130 {lab=#net2}
N 525 -30 525 -10 {lab=GND}
N 525 -260 525 -240 {lab=VDD}
N 520 -210 535 -210 {lab=VDD}
N 525 -60 545 -60 {lab=GND}
N 485 -210 485 -60 {lab=#net1}
N 675 -180 675 -90 {lab=CLK_SAMPLE}
N 675 -130 785 -130 {lab=CLK_SAMPLE}
N 675 -30 675 -10 {lab=GND}
N 675 -260 675 -240 {lab=VDD}
N 670 -210 685 -210 {lab=VDD}
N 675 -60 695 -60 {lab=GND}
N 635 -210 635 -60 {lab=#net2}
C {symbols/pfet_03v3.sym} 355 -210 0 0 {name=M431
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
C {symbols/nfet_03v3.sym} 355 -60 0 0 {name=M432
L=0.28u
W=0.44u
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
C {lab_wire.sym} 380 -210 0 0 {name=p1043 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 390 -60 0 0 {name=p1044 sig_type=std_logic lab=GND}
C {lab_wire.sym} 525 -260 0 0 {name=p88 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 525 -20 0 0 {name=p89 sig_type=std_logic lab=GND}
C {symbols/pfet_03v3.sym} 505 -210 0 0 {name=M1
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
C {symbols/nfet_03v3.sym} 505 -60 0 0 {name=M7
L=0.28u
W=1.32u
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
C {lab_wire.sym} 530 -210 0 0 {name=p90 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 540 -60 0 0 {name=p91 sig_type=std_logic lab=GND}
C {lab_wire.sym} 675 -260 0 0 {name=p92 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 675 -20 0 0 {name=p93 sig_type=std_logic lab=GND}
C {symbols/pfet_03v3.sym} 655 -210 0 0 {name=M8
L=0.28u
W=7.92u
nf=4
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
C {symbols/nfet_03v3.sym} 655 -60 0 0 {name=M9
L=0.28u
W=3.96u
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
C {lab_wire.sym} 680 -210 0 0 {name=p94 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 690 -60 0 0 {name=p95 sig_type=std_logic lab=GND}
C {ipin.sym} 375 -260 0 0 {name=p83 lab=VDD}
C {ipin.sym} 375 -20 0 0 {name=p1 lab=GND}
C {ipin.sym} 230 -130 0 0 {name=p2 lab=CLK_EVAL}
C {opin.sym} 785 -130 0 0 {name=p21 lab=CLK_SAMPLE}
