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
N 1000 -465 1015 -465 {lab=VDD}
N 1005 -315 1025 -315 {lab=GND}
N 475 -530 475 -510 {lab=VDD}
N 470 -480 485 -480 {lab=VDD}
N 615 -530 615 -510 {lab=VDD}
N 610 -480 625 -480 {lab=VDD}
N 475 -450 475 -420 {lab=#net1}
N 475 -420 875 -420 {lab=#net1}
N 615 -450 615 -420 {lab=#net1}
N 635 -285 635 -265 {lab=#net2}
N 635 -315 650 -315 {lab=GND}
N 635 -185 635 -165 {lab=#net3}
N 635 -215 650 -215 {lab=GND}
N 635 -420 635 -340 {lab=#net1}
N 570 -315 595 -315 {lab=a}
N 575 -215 595 -215 {lab=b}
N 415 -480 435 -480 {lab=a}
N 555 -480 575 -480 {lab=b}
N 870 -420 895 -420 {lab=#net1}
N 635 -265 635 -240 {lab=#net2}
N 635 -165 635 -145 {lab=#net3}
C {lab_wire.sym} 1005 -515 0 0 {name=p5 sig_type=std_logic lab=VDD
W=3.3u
nf=1
m=15}
C {lab_wire.sym} 1005 -275 0 0 {name=p7 sig_type=std_logic lab=GND
nf=4
W=2.54u}
C {ipin.sym} 415 -480 0 0 {name=p21 lab=a
W=3.3u
nf=1
m=15}
C {opin.sym} 1110 -385 0 0 {name=p22 lab=out}
C {symbols/pfet_03v3.sym} 985 -465 0 0 {name=M5
L=0.28u
W=2u
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
C {symbols/nfet_03v3.sym} 985 -315 0 0 {name=M6
L=0.28u
W=1.0u
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
C {lab_wire.sym} 1010 -465 0 0 {name=p17 sig_type=std_logic lab=VDD
W=3.3u
nf=1
m=15}
C {lab_wire.sym} 1020 -315 0 0 {name=p23 sig_type=std_logic lab=GND
nf=4
W=2.54u}
C {symbols/pfet_03v3.sym} 455 -480 0 0 {name=M13
L=0.28u
W=2u
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
C {lab_wire.sym} 480 -480 0 0 {name=p34 sig_type=std_logic lab=VDD
W=3.3u
nf=5
m=15}
C {lab_wire.sym} 615 -530 0 0 {name=p35 sig_type=std_logic lab=VDD
W=3.3u
nf=5
m=15}
C {symbols/pfet_03v3.sym} 595 -480 0 0 {name=M14
L=0.28u
W=2u
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
C {lab_wire.sym} 620 -480 0 0 {name=p36 sig_type=std_logic lab=VDD
W=3.3u
nf=5
m=15}
C {symbols/nfet_03v3.sym} 615 -315 0 0 {name=M16
L=0.28u
W=1.0u
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
C {lab_wire.sym} 645 -315 0 0 {name=p40 sig_type=std_logic lab=GND
m=10
nf=4
W=2.54u}
C {symbols/nfet_03v3.sym} 615 -215 0 0 {name=M17
L=0.28u
W=1.0u
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
C {lab_wire.sym} 645 -215 0 0 {name=p42 sig_type=std_logic lab=GND
m=1
W=2.54u
nf=4}
C {ipin.sym} 565 -480 0 0 {name=p46 lab=b
W=3.3u
nf=5
m=15}
C {lab_wire.sym} 570 -315 0 0 {name=p1 sig_type=std_logic lab=a
m=10
nf=4
W=2.54u}
C {lab_wire.sym} 580 -215 0 0 {name=p2 sig_type=std_logic lab=b
m=1
W=2.54u
nf=4}
C {ipin.sym} 475 -525 0 0 {name=p3 lab=VDD}
C {ipin.sym} 635 -155 0 0 {name=p4 lab=GND}
