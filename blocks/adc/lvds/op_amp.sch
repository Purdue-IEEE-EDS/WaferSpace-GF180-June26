v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -120 -100 -120 -30 {lab=Vdd}
N -120 -100 120 -100 {lab=Vdd}
N 120 -100 120 -30 {lab=Vdd}
N -0 -170 -0 -100 {lab=Vdd}
N -120 -0 0 -0 {lab=Vdd}
N -0 -0 120 -0 {lab=Vdd}
N -0 -100 0 -0 {lab=Vdd}
N 120 30 120 80 {lab=VdM2}
N -120 30 -120 80 {lab=VdM1}
N -80 110 80 110 {lab=Vb2}
N 0 80 0 110 {lab=Vb2}
N -120 140 -120 230 {lab=vgM1}
N 120 140 120 220 {lab=VdM4}
N 120 220 120 230 {lab=VdM4}
N 160 260 200 260 {lab=Vin_p}
N -210 260 -160 260 {lab=Vin_n}
N 120 290 120 360 {lab=VsM5}
N -120 360 120 360 {lab=VsM5}
N -120 290 -120 360 {lab=VsM5}
N -120 260 120 260 {lab=Vdd}
N 0 370 -0 390 {lab=VsM5}
N 0 360 0 370 {lab=VsM5}
N -160 110 -120 110 {lab=Vdd}
N -180 110 -160 110 {lab=Vdd}
N 120 110 200 110 {lab=Vdd}
N 160 -0 420 0 {lab=VdM4}
N 420 0 560 0 {lab=VdM4}
N 360 -0 360 190 {lab=VdM4}
N 120 190 360 190 {lab=VdM4}
N 120 -100 600 -100 {lab=Vdd}
N 600 -100 600 -30 {lab=Vdd}
N 600 -100 960 -100 {lab=Vdd}
N 960 -100 960 -30 {lab=Vdd}
N 600 -0 960 0 {lab=Vdd}
N 780 -100 780 -0 {lab=Vdd}
N 1000 -0 1140 0 {lab=vgM1}
N 1140 -140 1140 0 {lab=vgM1}
N -260 -140 1140 -140 {lab=vgM1}
N -260 -140 -260 200 {lab=vgM1}
N -260 200 -120 200 {lab=vgM1}
N 600 30 600 90 {lab=VdM7}
N 960 30 960 90 {lab=VdM9}
N 640 120 920 120 {lab=Vb1}
N 780 80 780 120 {lab=Vb1}
N 960 150 960 200 {lab=Vout}
N 600 150 600 200 {lab=VgM14}
N 640 230 920 230 {lab=Vb2}
N 780 200 780 230 {lab=Vb2}
N 960 260 960 340 {lab=#net1}
N 600 260 600 340 {lab=#net2}
N 960 180 1180 180 {lab=Vout}
N 640 370 920 370 {lab=VgM14}
N 600 400 600 440 {lab=0}
N 960 400 960 440 {lab=0}
N 780 370 780 560 {lab=VgM14}
N 460 560 780 560 {lab=VgM14}
N 460 180 460 560 {lab=VgM14}
N 460 180 600 180 {lab=VgM14}
N -260 0 -160 -0 {lab=vgM1}
N -0 450 -0 500 {lab=Vss}
N 0 240 0 260 {lab=Vdd}
N 120 50 170 50 {lab=VdM2}
N -160 50 -120 50 {lab=VdM1}
N 960 60 1000 60 {lab=VdM9}
N 550 60 600 60 {lab=VdM7}
N 550 230 600 230 {lab=0}
N 960 230 1060 230 {lab=0}
N 520 120 600 120 {lab=Vdd}
N 960 120 1070 120 {lab=Vdd}
N 590 370 600 370 {lab=0}
N 590 370 590 420 {lab=0}
N 590 420 600 420 {lab=0}
N 960 370 970 370 {lab=0}
N 970 370 970 400 {lab=0}
N 970 400 970 420 {lab=0}
N 960 420 970 420 {lab=0}
C {symbols/pfet_03v3.sym} -140 0 0 0 {name=M1
L=0.28u
W=10.5u
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
C {symbols/pfet_03v3.sym} 140 0 0 1 {name=M2
L=0.28u
W=10.5u
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
C {ipin.sym} 0 -170 1 0 {name=p1 lab=Vdd
}
C {symbols/pfet_03v3.sym} -100 110 0 1 {name=M3
L=0.28u
W=10.5u
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
C {symbols/pfet_03v3.sym} 100 110 0 0 {name=M4
L=0.28u
W=10.5u
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
C {ipin.sym} 780 200 0 0 {name=p2 lab=Vb2}
C {symbols/nfet_03v3.sym} 140 260 0 1 {name=M5
L=0.28u
W=52.5u
nf=15
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
C {symbols/nfet_03v3.sym} -140 260 0 0 {name=M6
L=0.28u
W=52.5u
nf=15
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
C {ipin.sym} 200 260 0 1 {name=p3 lab=Vin_p}
C {ipin.sym} -210 260 0 0 {name=p4 lab=Vin_n}
C {symbols/pfet_03v3.sym} 580 0 0 0 {name=M7
L=0.28u
W=10.5u
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
C {symbols/pfet_03v3.sym} 980 0 0 1 {name=M9
L=0.28u
W=10.5u
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
C {ipin.sym} 780 80 2 1 {name=p5 lab=Vb1}
C {symbols/nfet_03v3.sym} 620 230 0 1 {name=M11
L=0.28u
W=5.25u
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
C {symbols/nfet_03v3.sym} 940 230 0 0 {name=M12
L=0.28u
W=5.25u
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
C {symbols/nfet_03v3.sym} 620 370 0 1 {name=M13
L=0.28u
W=5.25u
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
C {symbols/nfet_03v3.sym} 940 370 0 0 {name=M14
L=0.28u
W=5.25u
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
C {opin.sym} 1180 180 0 0 {name=p7 lab=Vout}
C {gnd.sym} 600 440 0 0 {name=l2 lab=0}
C {gnd.sym} 960 440 0 0 {name=l3 lab=0}
C {isource.sym} 0 420 0 0 {name=ibias value=250u}
C {lab_wire.sym} -180 110 0 0 {name=p9 sig_type=std_logic lab=Vdd}
C {lab_wire.sym} 0 240 0 0 {name=p10 sig_type=std_logic lab=Vdd}
C {lab_wire.sym} 200 110 0 1 {name=p8 sig_type=std_logic lab=Vdd}
C {lab_wire.sym} 170 50 0 1 {name=p11 sig_type=std_logic lab=VdM2}
C {lab_wire.sym} -160 50 0 0 {name=p12 sig_type=std_logic lab=VdM1}
C {lab_wire.sym} 1000 60 0 1 {name=p13 sig_type=std_logic lab=VdM9}
C {lab_wire.sym} 550 60 0 0 {name=p14 sig_type=std_logic lab=VdM7}
C {lab_wire.sym} -260 0 0 0 {name=p15 sig_type=std_logic lab=vgM1}
C {lab_wire.sym} 360 190 0 1 {name=p16 sig_type=std_logic lab=VdM4}
C {lab_wire.sym} 120 360 0 1 {name=p17 sig_type=std_logic lab=VsM5}
C {lab_wire.sym} 780 560 0 1 {name=p18 sig_type=std_logic lab=VgM14}
C {symbols/pfet_03v3.sym} 620 120 0 1 {name=M8
L=0.28u
W=10.5u
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
C {symbols/pfet_03v3.sym} 940 120 0 0 {name=M10
L=0.28u
W=10.5u
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
C {gnd.sym} 550 230 1 0 {name=l4 lab=0}
C {gnd.sym} 1060 230 3 1 {name=l5 lab=0}
C {lab_wire.sym} 520 120 0 0 {name=p19 sig_type=std_logic lab=Vdd}
C {lab_wire.sym} 1070 120 0 1 {name=p20 sig_type=std_logic lab=Vdd}
C {lab_wire.sym} 0 80 0 0 {name=p6 sig_type=std_logic lab=Vb2}
C {ipin.sym} 0 500 3 0 {name=p21 lab=Vss}
