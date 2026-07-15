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
lab=Vctrl}
N 80 130 80 150 {
lab=#net1}
N -60 150 80 150 {
lab=#net1}
N -60 130 -60 170 {
lab=#net1}
N -120 200 -100 200 {
lab=Vctrl}
N -120 100 -120 200 {
lab=Vctrl}
N -120 100 -100 100 {
lab=Vctrl}
N -60 70 -60 100 {
lab=Vpp}
N -60 200 -60 230 {
lab=Vss}
N 80 -80 80 -60 {
lab=Vpp}
N 0 50 0 280 {
lab=Vss}
N -60 230 0 230 {
lab=Vss}
N -190 0 50 0 {
lab=Vin}
N 80 50 80 90 {
lab=Vss}
N 0 50 80 50 {
lab=Vss}
N -190 -140 80 -140 {
lab=Vctrl}
N -120 -140 -120 100 {
lab=Vctrl}
N 0 -180 0 -60 {
lab=Vpp}
N 0 -60 80 -60 {
lab=Vpp}
N -60 -60 0 -60 {
lab=Vpp}
N -60 -60 -60 70 {
lab=Vpp}
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
C {symbols/nfet_03v3.sym} -80 200 0 0 {name=M3
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
C {symbols/pfet_03v3.sym} -80 100 0 0 {name=M4
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
C {iopin.sym} 0 -180 3 0 {name=p4 lab=Vpp}
C {iopin.sym} 0 280 1 0 {name=p5 lab=Vss}
