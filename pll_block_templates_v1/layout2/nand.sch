v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 150 10 150 40 {lab=#net1}
N 50 -90 260 -90 {lab=Z}
N 150 -90 150 -50 {lab=Z}
N 150 -50 300 -50 {lab=Z}
N 50 -150 260 -150 {lab=VDD}
N 150 70 170 70 {lab=GND}
N 150 100 170 100 {lab=GND}
N 170 70 170 100 {lab=GND}
N 150 -20 170 -20 {lab=GND}
N 170 -20 170 70 {lab=GND}
N 90 70 110 70 {lab=B}
N 10 -20 110 -20 {lab=A}
N 10 -120 10 -20 {lab=A}
N 90 -70 90 70 {lab=B}
N 90 -70 300 -70 {lab=B}
N 300 -120 300 -70 {lab=B}
N 50 -120 110 -120 {lab=VDD}
N 110 -150 110 -120 {lab=VDD}
N 210 -120 260 -120 {lab=VDD}
N 210 -150 210 -120 {lab=VDD}
C {symbols/nfet_03v3.sym} 130 -20 0 0 {name=M1
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
C {symbols/pfet_03v3.sym} 30 -120 0 0 {name=M2
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
model=pfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 280 -120 0 1 {name=M3
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
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 130 70 0 0 {name=M4
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
C {ipin.sym} 10 -20 0 0 {name=p1 lab=A}
C {iopin.sym} 160 -150 3 0 {name=p2 lab=VDD}
C {opin.sym} 300 -50 0 0 {name=p3 lab=Z}
C {iopin.sym} 150 100 1 0 {name=p4 lab=GND}
C {ipin.sym} 90 70 0 0 {name=p5 lab=B}
