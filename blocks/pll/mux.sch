v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 220 -280 220 -100 {lab=Vin1}
N 280 -280 280 -100 {lab=Vout1}
N 120 -190 220 -190 {lab=Vin1}
N 280 -190 380 -190 {lab=Vout1}
N 220 -600 220 -420 {lab=Vin2}
N 280 -600 280 -420 {lab=Vout2}
N 120 -510 220 -510 {lab=Vin2}
N 280 -510 380 -510 {lab=Vout2}
N -80 -370 -80 -330 {lab=Vswap}
N -40 -400 -40 -300 {lab=#net1}
N -80 -420 -80 -400 {lab=#net2}
N -80 -300 -80 -270 {lab=VSS}
N -40 -350 250 -350 {lab=#net1}
N 250 -380 250 -320 {lab=#net1}
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
C {ipin.sym} 120 -190 0 0 {name=p1 lab=Vin1}
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
C {ipin.sym} 120 -510 0 0 {name=p3 lab=Vin2}
C {opin.sym} 380 -510 0 0 {name=p4 lab=Vout2}
C {symbols/nfet_03v3.sym} -60 -300 0 1 {name=M5
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
C {symbols/pfet_03v3.sym} -60 -400 2 0 {name=M6
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
C {ipin.sym} -80 -430 1 0 {name=p5 lab=VDD}
C {ipin.sym} -80 -270 3 0 {name=p6 lab=VSS}
C {ipin.sym} -80 -350 0 0 {name=p7 lab=Vswap}
C {lab_pin.sym} 250 -640 0 0 {name=p8 sig_type=std_logic lab=Vswap}
C {lab_pin.sym} 250 -60 0 0 {name=p9 sig_type=std_logic lab=Vswap}
