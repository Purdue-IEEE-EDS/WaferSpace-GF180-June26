v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 50 -80 50 40 {
lab=Vin}
N 110 -80 110 40 {
lab=Vout}
N 110 40 110 90 {
lab=Vout}
N 50 40 50 90 {
lab=Vin}
N 110 0 180 0 {
lab=Vout}
N 80 -140 80 -120 {
lab=#net1}
N 80 130 80 150 {
lab=Vctrl}
N -70 -160 -70 -120 {
lab=#net1}
N -130 -90 -110 -90 {
lab=Vctrl}
N -130 -190 -130 -90 {
lab=Vctrl}
N -130 -190 -110 -190 {
lab=Vctrl}
N -70 -220 -70 -190 {
lab=Vpp}
N -70 -90 -70 -60 {
lab=Vss}
N 80 -80 80 -60 {
lab=Vpp}
N -190 0 50 0 {
lab=Vin}
N 80 50 80 90 {
lab=Vss}
N 0 50 80 50 {
lab=Vss}
N 0 -180 0 -60 {
lab=Vpp}
N 0 -60 80 -60 {
lab=Vpp}
N -130 150 80 150 {
lab=Vctrl}
N -130 -90 -130 150 {
lab=Vctrl}
N -190 -140 -130 -140 {
lab=Vctrl}
N -70 -140 80 -140 {
lab=#net1}
N -0 50 0 180 {
lab=Vss}
N 0 -260 0 -180 {
lab=Vpp}
N -70 -240 -70 -220 {
lab=Vpp}
N -70 -240 0 -240 {
lab=Vpp}
N -70 -60 -70 50 {
lab=Vss}
N -70 50 -0 50 {
lab=Vss}
C {symbols/nfet_03v3.sym} 80 110 3 0 {name=M1
L=0.28u
W=4.00u
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
C {symbols/pfet_03v3.sym} 80 -100 1 0 {name=M2
L=0.28u
W=4.00u
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
C {ipin.sym} -190 0 0 0 {name=p1 lab=Vin}
C {symbols/nfet_03v3.sym} -90 -90 0 0 {name=M3
L=0.28u
W=0.22u
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
C {symbols/pfet_03v3.sym} -90 -190 0 0 {name=M4
L=0.28u
W=0.22u
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
C {opin.sym} 180 0 0 0 {name=p2 lab=Vout}
C {ipin.sym} -190 -140 0 0 {name=p3 lab=Vctrl}
C {iopin.sym} 0 -260 3 0 {name=p4 lab=Vpp}
C {iopin.sym} 0 180 1 0 {name=p5 lab=Vss}
