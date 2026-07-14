v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -420 150 -370 150 {lab=Vin_inv}
N -420 150 -420 370 {lab=Vin_inv}
N -420 370 -370 370 {lab=Vin_inv}
N -330 180 -330 340 {lab=Vout_inv}
N -330 400 -330 440 {lab=GND}
N -330 70 -330 120 {lab=VDD}
N -330 150 -250 150 {lab=VDD}
N -250 110 -250 150 {lab=VDD}
N -330 110 -250 110 {lab=VDD}
N -330 370 -220 370 {lab=GND}
N -330 430 -220 430 {lab=GND}
N -500 260 -420 260 {lab=Vin_inv}
N -330 260 -130 260 {lab=Vout_inv}
N -130 260 40 260 {lab=Vout_inv}
N -220 370 -220 430 {lab=GND}
C {symbols/pfet_03v3.sym} -350 150 0 0 {name=M1
L=0.28u
W=0.66u
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
C {symbols/nfet_03v3.sym} -350 370 0 0 {name=M2
L=0.28u
W=0.3u
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
C {ipin.sym} -500 260 0 0 {name=p4 lab=Vin_inv}
C {opin.sym} 40 260 0 0 {name=p7 lab=Vout_inv}
C {ipin.sym} -330 70 0 0 {name=p1 lab=VDD}
C {ipin.sym} -330 440 0 0 {name=p2 lab=GND}
