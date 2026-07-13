v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 220 -280 220 -100 {lab=Vin2}
N 280 -280 280 -100 {lab=Vout1}
N 120 -190 220 -190 {lab=Vin2}
N 280 -190 380 -190 {lab=Vout1}
N 220 -600 220 -420 {lab=Vin1}
N 280 -600 280 -420 {lab=Vout2}
N 120 -510 220 -510 {lab=Vin1}
N 280 -510 380 -510 {lab=Vout2}
N -40 -370 -40 -330 {lab=#net1}
N -80 -400 -80 -300 {lab=Vswap}
N -40 -300 -40 -270 {lab=VSS}
N -40 -350 250 -350 {lab=#net1}
N 250 -380 250 -320 {lab=#net1}
N 220 -900 220 -720 {lab=Vin2}
N 280 -900 280 -720 {lab=Vout2}
N 120 -810 220 -810 {lab=Vin2}
N 280 -810 380 -810 {lab=Vout2}
N 380 -810 380 -510 {lab=Vout2}
N 250 -680 250 -640 {lab=Vswap}
N 220 20 220 200 {lab=Vin1}
N 280 20 280 200 {lab=Vout1}
N 120 110 220 110 {lab=Vin1}
N 280 110 380 110 {lab=Vout1}
N 380 -190 380 110 {lab=Vout1}
N 250 -60 250 -20 {lab=Vswap}
N 40 -350 40 240 {lab=#net1}
N 40 240 250 240 {lab=#net1}
N 40 -940 40 -350 {lab=#net1}
N 40 -940 250 -940 {lab=#net1}
N 250 -900 250 -860 {lab=VSS}
N 250 -760 250 -720 {lab=VDD}
N 250 -600 250 -560 {lab=VSS}
N 250 -460 250 -420 {lab=VDD}
N 250 -280 250 -240 {lab=VSS}
N 250 -140 250 -100 {lab=VDD}
N 250 20 250 60 {lab=VSS}
N 250 160 250 200 {lab=VDD}
N -40 -430 -40 -400 {lab=VDD}
C {symbols/nfet_03v3.sym} 250 -300 1 0 {name=M1
L=1u
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
C {symbols/pfet_03v3.sym} 250 -80 3 0 {name=M2
L=1u
W=16u
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
C {ipin.sym} 120 -510 0 0 {name=p1 lab=Vin1}
C {opin.sym} 380 -190 0 0 {name=p2 lab=Vout1}
C {symbols/nfet_03v3.sym} 250 -620 1 0 {name=M3
L=1u
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
C {symbols/pfet_03v3.sym} 250 -400 3 0 {name=M4
L=1u
W=16u
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
C {ipin.sym} 120 -190 0 0 {name=p3 lab=Vin2}
C {opin.sym} 380 -510 0 0 {name=p4 lab=Vout2}
C {symbols/nfet_03v3.sym} -60 -300 0 0 {name=M5
L=1u
W=1u
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
C {symbols/pfet_03v3.sym} -60 -400 2 1 {name=M6
L=1u
W=4u
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
C {iopin.sym} -40 -430 3 0 {name=p5 lab=VDD}
C {iopin.sym} -40 -270 1 0 {name=p6 lab=VSS}
C {ipin.sym} -80 -350 0 0 {name=p7 lab=Vswap}
C {lab_pin.sym} 250 -660 0 0 {name=p8 sig_type=std_logic lab=Vswap}
C {lab_pin.sym} 250 -40 0 0 {name=p9 sig_type=std_logic lab=Vswap}
C {symbols/nfet_03v3.sym} 250 -920 1 0 {name=M7
L=1u
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
C {symbols/pfet_03v3.sym} 250 -700 3 0 {name=M8
L=1u
W=16u
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
C {lab_wire.sym} 120 110 0 0 {name=p10 sig_type=std_logic lab=Vin1}
C {symbols/nfet_03v3.sym} 250 0 1 0 {name=M9
L=1u
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
C {symbols/pfet_03v3.sym} 250 220 3 0 {name=M10
L=1u
W=16u
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
C {lab_wire.sym} 120 -810 0 0 {name=p11 sig_type=std_logic lab=Vin2}
C {lab_pin.sym} 250 -860 3 0 {name=p12 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 250 -760 1 0 {name=p13 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 250 -560 3 0 {name=p14 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 250 -460 1 0 {name=p15 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 250 -240 3 0 {name=p16 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 250 -140 1 0 {name=p17 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 250 60 3 0 {name=p18 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 250 160 1 0 {name=p19 sig_type=std_logic lab=VDD}
