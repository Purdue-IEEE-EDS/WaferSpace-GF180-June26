v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 -410 -270 {}
N 380 -210 380 -180 {lab=Vdd}
N -120 -210 380 -210 {lab=Vdd}
N -290 -210 -120 -210 {lab=Vdd}
N 380 -150 450 -150 {lab=Vdd}
N 450 -210 450 -150 {lab=Vdd}
N 380 -210 450 -210 {lab=Vdd}
N -10 -210 -10 -90 {lab=Vdd}
N -30 -60 -10 -60 {lab=Vdd}
N -30 -100 -30 -60 {lab=Vdd}
N -30 -100 -10 -100 {lab=Vdd}
N -10 -30 -10 280 {lab=#net1}
N -10 340 -10 480 {lab=0}
N -40 310 -10 310 {lab=0}
N -40 310 -40 480 {lab=0}
N 550 -210 550 30 {lab=Vdd}
N 450 -210 550 -210 {lab=Vdd}
N 30 310 60 310 {lab=#net2}
N 100 60 100 280 {lab=#net2}
N 100 -40 380 -40 {lab=#net3}
N 100 -40 100 -0 {lab=#net3}
N 200 -210 200 30 {lab=Vdd}
N 650 60 650 280 {lab=#net4}
N 40 240 40 310 {lab=#net2}
N 40 240 100 240 {lab=#net2}
N 100 340 100 480 {lab=0}
N 650 340 650 480 {lab=0}
N 690 310 760 310 {lab=#net4}
N 730 250 730 310 {lab=#net4}
N 650 250 730 250 {lab=#net4}
N 1140 -30 1140 280 {lab=#net5}
N 920 -30 920 280 {lab=Vout}
N 760 310 880 310 {lab=#net4}
N 30 -60 880 -60 {lab=#net1}
N 550 -210 1530 -210 {lab=Vdd}
N 1340 -210 1340 -90 {lab=Vdd}
N 1140 -210 1140 -90 {lab=Vdd}
N 920 -210 920 -90 {lab=Vdd}
N 680 480 1530 480 {lab=0}
N 1340 340 1340 480 {lab=0}
N 1140 340 1140 480 {lab=0}
N 920 340 920 470 {lab=0}
N 920 470 920 480 {lab=0}
N 550 310 650 310 {lab=0}
N 550 310 550 480 {lab=0}
N 920 310 1020 310 {lab=0}
N 1020 310 1020 480 {lab=0}
N 1140 310 1240 310 {lab=0}
N 1240 310 1240 480 {lab=0}
N 1340 310 1440 310 {lab=0}
N 1440 310 1440 480 {lab=0}
N 1340 -60 1430 -60 {lab=Vdd}
N 1430 -210 1430 -60 {lab=Vdd}
N 1140 -60 1240 -60 {lab=Vdd}
N 1240 -210 1240 -60 {lab=Vdd}
N 920 -60 1030 -60 {lab=Vdd}
N 1030 -210 1030 -60 {lab=Vdd}
N 30 30 60 30 {lab=in_p}
N 30 30 30 70 {lab=in_p}
N 690 30 730 30 {lab=in_n}
N 730 30 730 60 {lab=in_n}
N 1070 -60 1100 -60 {lab=#net6}
N 1070 -60 1070 310 {lab=#net6}
N 1070 310 1100 310 {lab=#net6}
N 1270 -60 1300 -60 {lab=#net5}
N 1270 -60 1270 310 {lab=#net5}
N 1270 310 1300 310 {lab=#net5}
N 1140 110 1270 110 {lab=#net5}
N 920 130 1010 130 {lab=Vout}
N 60 -60 60 -20 {lab=#net1}
N -10 -20 60 -20 {lab=#net1}
N 380 -120 380 -110 {lab=#net3}
N 380 -110 380 -50 {lab=#net3}
N 100 310 190 310 {lab=0}
N 190 310 190 480 {lab=0}
N 650 -40 650 -0 {lab=#net3}
N 380 -40 650 -40 {lab=#net3}
N 380 -50 380 -40 {lab=#net3}
N 100 30 200 30 {lab=Vdd}
N 550 30 650 30 {lab=Vdd}
N -40 480 680 480 {lab=0}
N 300 -150 340 -150 {lab=Vbias}
N 1340 -30 1340 280 {lab=#net6}
N 1070 40 1340 40 {lab=#net6}
C {symbols/pfet_03v3.sym} 360 -150 0 0 {name=M2
L=0.28u
W=20u
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
C {gnd.sym} 680 480 0 0 {name=l1 lab=0}
C {symbols/pfet_03v3.sym} 10 -60 0 1 {name=M5
L=0.28u
W=20u
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
C {symbols/nfet_03v3.sym} 10 310 0 1 {name=M6
L=0.28u
W=10u
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
C {symbols/pfet_03v3.sym} 80 30 0 0 {name=M7
L=0.28u
W=20u
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
C {symbols/pfet_03v3.sym} 670 30 0 1 {name=M10
L=0.28u
W=20u
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
C {symbols/nfet_03v3.sym} 80 310 0 0 {name=M11
L=0.28u
W=10u
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
C {symbols/nfet_03v3.sym} 670 310 0 1 {name=M14
L=0.28u
W=10u
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
C {symbols/nfet_03v3.sym} 900 310 0 0 {name=M15
L=0.28u
W=40u
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
C {symbols/pfet_03v3.sym} 900 -60 0 0 {name=M16
L=0.28u
W=80u
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
C {symbols/nfet_03v3.sym} 1120 310 0 0 {name=M17
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
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 1120 -60 0 0 {name=M18
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
C {symbols/nfet_03v3.sym} 1320 310 0 0 {name=M19
L=0.28u
W=4u
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
C {symbols/pfet_03v3.sym} 1320 -60 0 0 {name=M20
L=0.28u
W=4u
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
C {ipin.sym} -290 -210 0 0 {name=p2 lab=Vdd}
C {ipin.sym} 730 60 3 0 {name=p3 lab=in_n}
C {ipin.sym} 30 70 3 0 {name=p4 lab=in_p}
C {opin.sym} 1010 130 0 0 {name=p5 lab=Vout
}
C {devices/code_shown.sym} -140 -370 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {ipin.sym} 300 -150 0 0 {name=p1 lab=Vbias}
