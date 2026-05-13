v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 895 -465 895 -385 {lab=#net1}
N 895 -465 965 -465 {lab=#net1}
N 895 -385 895 -315 {lab=#net1}
N 895 -315 965 -315 {lab=#net1}
N 1005 -435 1005 -345 {lab=out}
N 1005 -385 1115 -385 {lab=out}
N 1005 -285 1005 -265 {lab=GND}
N 1005 -515 1005 -495 {lab=VDD}
N 160 -425 160 -345 {lab=C}
N 160 -425 230 -425 {lab=C}
N 160 -345 160 -275 {lab=C}
N 160 -275 230 -275 {lab=C}
N 270 -395 270 -305 {lab=cbar}
N 270 -345 380 -345 {lab=cbar}
N 270 -245 270 -225 {lab=GND}
N 270 -475 270 -455 {lab=VDD}
N 120 -345 160 -345 {lab=C}
N 1000 -465 1015 -465 {lab=VDD}
N 1005 -315 1025 -315 {lab=GND}
N 265 -425 290 -425 {lab=VDD}
N 270 -275 285 -275 {lab=GND}
N 475 -530 475 -510 {lab=VDD}
N 470 -480 485 -480 {lab=VDD}
N 615 -530 615 -510 {lab=VDD}
N 610 -480 625 -480 {lab=VDD}
N 755 -530 755 -510 {lab=VDD}
N 750 -480 765 -480 {lab=VDD}
N 475 -450 475 -420 {lab=#net1}
N 475 -420 875 -420 {lab=#net1}
N 615 -450 615 -420 {lab=#net1}
N 755 -450 755 -420 {lab=#net1}
N 635 -285 635 -265 {lab=#net2}
N 635 -315 650 -315 {lab=GND}
N 635 -185 635 -165 {lab=#net3}
N 635 -215 650 -215 {lab=GND}
N 635 -85 635 -65 {lab=GND}
N 635 -115 650 -115 {lab=GND}
N 635 -420 635 -340 {lab=#net1}
N 570 -315 595 -315 {lab=a}
N 575 -215 595 -215 {lab=b}
N 580 -115 595 -115 {lab=cbar}
N 415 -480 435 -480 {lab=a}
N 555 -480 575 -480 {lab=b}
N 700 -480 715 -480 {lab=cbar}
N 870 -420 895 -420 {lab=#net1}
N 635 -265 635 -240 {lab=#net2}
N 635 -165 635 -145 {lab=#net3}
C {lab_wire.sym} 1005 -515 0 0 {name=p5 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 1005 -275 0 0 {name=p7 sig_type=std_logic lab=GND}
C {lab_wire.sym} 585 -115 0 0 {name=p10 sig_type=std_logic lab=cbar}
C {lab_wire.sym} 340 -345 1 0 {name=p12 sig_type=std_logic lab=cbar}
C {ipin.sym} 415 -480 0 0 {name=p21 lab=a}
C {opin.sym} 1110 -385 0 0 {name=p22 lab=out}
C {ipin.sym} 120 -345 0 0 {name=p9 lab=C}
C {symbols/pfet_03v3.sym} 985 -465 0 0 {name=M5
L=0.28u
W=0.22u
nf=1
m=10
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 985 -315 0 0 {name=M6
L=0.28u
W=0.22u
nf=1
m=5
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 250 -425 0 0 {name=M7
L=0.28u
W=0.22u
nf=1
m=10
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 250 -275 0 0 {name=M8
L=0.28u
W=0.22u
nf=1
m=5
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 285 -425 0 0 {name=p11 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 1010 -465 0 0 {name=p17 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 1020 -315 0 0 {name=p23 sig_type=std_logic lab=GND}
C {lab_wire.sym} 280 -275 0 0 {name=p24 sig_type=std_logic lab=GND}
C {lab_wire.sym} 475 -530 0 0 {name=p33 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 455 -480 0 0 {name=M13
L=0.28u
W=0.22u
nf=1
m=10
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 480 -480 0 0 {name=p34 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 615 -530 0 0 {name=p35 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 595 -480 0 0 {name=M14
L=0.28u
W=0.22u
nf=1
m=10
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 620 -480 0 0 {name=p36 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 755 -530 0 0 {name=p37 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 735 -480 0 0 {name=M15
L=0.28u
W=0.22u
nf=1
m=10
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 760 -480 0 0 {name=p38 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 615 -315 0 0 {name=M16
L=0.28u
W=0.22u
nf=1
m=5
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 645 -315 0 0 {name=p40 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 615 -215 0 0 {name=M17
L=0.28u
W=0.22u
nf=1
m=5
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 645 -215 0 0 {name=p42 sig_type=std_logic lab=GND}
C {lab_wire.sym} 635 -70 0 0 {name=p43 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 615 -115 0 0 {name=M18
L=0.28u
W=0.22u
nf=1
m=5
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 645 -115 0 0 {name=p44 sig_type=std_logic lab=GND}
C {lab_wire.sym} 705 -480 0 0 {name=p45 sig_type=std_logic lab=cbar}
C {ipin.sym} 565 -480 0 0 {name=p46 lab=b}
C {lab_wire.sym} 570 -315 0 0 {name=p1 sig_type=std_logic lab=a}
C {lab_wire.sym} 580 -215 0 0 {name=p2 sig_type=std_logic lab=b}
C {ipin.sym} 270 -475 0 0 {name=p3 lab=VDD}
C {ipin.sym} 270 -225 0 0 {name=p4 lab=GND}
