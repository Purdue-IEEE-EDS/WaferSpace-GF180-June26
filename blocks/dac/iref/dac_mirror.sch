v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -1.25 23.75 -1.25 28.75 {lab=#net1}
N -1.25 28.75 -1.25 48.75 {lab=#net1}
N -1.25 108.75 -1.25 138.75 {lab=0}
N -1.25 -97.5 -1.25 -67.5 {lab=IREF}
N -1.25 -67.5 -1.25 -62.5 {lab=IREF}
N -1.25 -2.5 -1.25 22.5 {lab=#net1}
N -1.25 22.5 -1.25 23.75 {lab=#net1}
C {gnd.sym} -1.25 -32.5 3 0 {name=l1 lab=0}
C {symbols/nfet_03v3.sym} -21.25 -32.5 0 0 {name=M1
L=\{repL\}
W=\{repW\}
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
C {gnd.sym} -1.25 78.75 3 0 {name=l8 lab=0}
C {symbols/nfet_03v3.sym} -21.25 78.75 0 0 {name=M2
L=\{repL\}
W=\{repW\}
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
C {gnd.sym} -1.25 138.75 0 0 {name=l9 lab=0}
C {lab_pin.sym} -41.25 78.75 0 0 {name=p24 sig_type=std_logic lab=VN_CAS}
C {lab_pin.sym} -41.25 -32.5 0 0 {name=p27 sig_type=std_logic lab=VN_MIR}
C {lab_pin.sym} -1.25 -96.25 2 0 {name=p28 sig_type=std_logic lab=IREF}
C {ipin.sym} 2.5 -172.5 0 0 {name=p1 lab=VN_MIR}
C {opin.sym} 20 -171.25 0 0 {name=p9 lab=IREF}
C {ipin.sym} 2.5 -142.5 0 0 {name=p14 lab=VN_CAS}
