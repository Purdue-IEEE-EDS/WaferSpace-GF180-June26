v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 480 -220 480 -130 {lab=Vout_p}
N 920 -220 920 -130 {lab=Vout_n}
N 880 -100 920 -100 {lab=0}
N 480 -100 520 -100 {lab=0}
N 850 -250 920 -250 {lab=Vdd}
N 480 -250 550 -250 {lab=Vdd}
N 480 -70 480 -40 {lab=#net1}
N 920 -70 920 -40 {lab=#net1}
N 900 -40 920 -40 {lab=#net1}
N 480 -40 500 -40 {lab=#net1}
N 500 -40 500 -20 {lab=#net1}
N 500 -20 900 -20 {lab=#net1}
N 900 -40 900 -20 {lab=#net1}
N 480 -300 480 -280 {lab=#net2}
N 480 -320 480 -300 {lab=#net2}
N 480 -320 500 -320 {lab=#net2}
N 500 -340 500 -320 {lab=#net2}
N 920 -320 920 -280 {lab=#net2}
N 900 -320 920 -320 {lab=#net2}
N 900 -340 900 -320 {lab=#net2}
N 500 -340 900 -340 {lab=#net2}
N 700 -380 700 -340 {lab=#net2}
N 700 -20 700 40 {lab=#net1}
N 960 -250 1000 -250 {lab=Vin_n}
N 400 -250 440 -250 {lab=Vin_p}
N 400 -100 440 -100 {lab=Vin_p}
N 960 -100 1000 -100 {lab=Vin_n}
N 700 -480 700 -440 {lab=Vdd}
N 480 -200 1160 -200 {lab=Vout_p}
N 1110 -170 1140 -170 {lab=0}
N 920 -140 1160 -140 {lab=Vout_n}
N 1160 -200 1250 -200 {lab=Vout_p}
N 1160 -140 1250 -140 {lab=Vout_n}
N 700 100 700 130 {lab=0}
N 700 70 750 70 {lab=0}
N 750 70 750 120 {lab=0}
N 700 120 750 120 {lab=0}
N 700 -410 800 -410 {lab=Vdd}
N 800 -460 800 -410 {lab=Vdd}
N 700 -460 800 -460 {lab=Vdd}
N -210 -460 -210 -380 {lab=Vdd}
N -50 -460 -50 -380 {lab=Vdd}
N -210 -460 -50 -460 {lab=Vdd}
N -50 -550 -50 -460 {lab=Vdd}
N -210 -320 -210 -230 {lab=Iref}
N -50 -320 -50 -230 {lab=#net3}
N -50 -350 20 -350 {lab=Vdd}
N 20 -400 20 -350 {lab=Vdd}
N -50 -400 20 -400 {lab=Vdd}
N -280 -350 -210 -350 {lab=Vdd}
N -280 -410 -280 -350 {lab=Vdd}
N -280 -410 -210 -410 {lab=Vdd}
N -170 -350 -90 -350 {lab=Iref}
N -130 -350 -130 -290 {lab=Iref}
N -210 -290 -130 -290 {lab=Iref}
N 90 -260 270 -260 {lab=Iref}
N 270 -410 660 -410 {lab=Iref}
N 270 -410 270 -260 {lab=Iref}
N -130 -290 90 -290 {lab=Iref}
N 90 -290 90 -260 {lab=Iref}
N -110 -200 -90 -200 {lab=#net3}
N -110 -240 -110 -200 {lab=#net3}
N -110 -240 -50 -240 {lab=#net3}
N -50 -200 -10 -200 {lab=0}
N -10 -200 -10 -150 {lab=0}
N -50 -170 -50 -130 {lab=0}
N -50 -150 -10 -150 {lab=0}
N -110 -200 -110 50 {lab=#net3}
N -110 50 -110 60 {lab=#net3}
N -110 60 -110 70 {lab=#net3}
N -110 70 660 70 {lab=#net3}
C {gnd.sym} 880 -100 1 1 {name=l5 lab=0}
C {gnd.sym} 520 -100 3 0 {name=l6 lab=0}
C {lab_wire.sym} 850 -250 0 0 {name=p5 sig_type=std_logic lab=Vdd}
C {lab_wire.sym} 550 -250 0 1 {name=p6 sig_type=std_logic lab=Vdd}
C {ipin.sym} 1000 -250 0 1 {name=p1 lab=Vin_n}
C {ipin.sym} 400 -250 0 0 {name=p2 lab=Vin_p}
C {lab_wire.sym} 400 -100 0 0 {name=p3 sig_type=std_logic lab=Vin_p}
C {lab_wire.sym} 1000 -100 0 1 {name=p4 sig_type=std_logic lab=Vin_n}
C {lab_wire.sym} 700 -480 0 0 {name=p7 sig_type=std_logic lab=Vdd}
C {symbols/ppolyf_u_1k.sym} 1160 -170 0 0 {name=R1
W=22e-6
L=2e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {gnd.sym} 1110 -170 1 1 {name=l2 lab=0}
C {opin.sym} 1250 -200 0 0 {name=p10 lab=Vout_p}
C {opin.sym} 1250 -140 0 0 {name=p11 lab=Vout_n}
C {gnd.sym} 700 130 0 0 {name=l1 lab=0}
C {symbols/pfet_03v3.sym} 460 -250 0 0 {name=M1
L=0.28u
W=12u
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
C {symbols/pfet_03v3.sym} 940 -250 0 1 {name=M2
L=0.28u
W=12u
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
C {symbols/nfet_03v3.sym} 460 -100 0 0 {name=M3
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
C {symbols/nfet_03v3.sym} 940 -100 0 1 {name=M4
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
C {symbols/nfet_03v3.sym} 680 70 0 0 {name=M5
L=1u
W=70u
nf=14
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
C {symbols/pfet_03v3.sym} 680 -410 0 0 {name=M6
L=1u
W=70u
nf=14
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
C {symbols/pfet_03v3.sym} -70 -350 0 0 {name=M7
L=1u
W=70u
nf=14
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
C {symbols/pfet_03v3.sym} -190 -350 0 1 {name=M8
L=1u
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
C {ipin.sym} -210 -230 3 0 {name=p8 lab=Iref}
C {lab_wire.sym} -50 -550 0 0 {name=p9 sig_type=std_logic lab=Vdd}
C {symbols/nfet_03v3.sym} -70 -200 0 0 {name=M9
L=1u
W=70u
nf=14
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
C {gnd.sym} -50 -130 0 0 {name=l3 lab=0}
