v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 240 -120 300 -120 {lab=GND}
N 400 -120 460 -120 {lab=GND}
N 240 -90 240 -80 {lab=#net1}
N 240 -80 460 -80 {lab=#net1}
N 460 -90 460 -80 {lab=#net1}
N 350 -20 410 -20 {lab=GND}
N 350 -50 350 -20 {lab=GND}
N 260 -180 300 -180 {lab=GND}
N 400 -180 440 -180 {lab=GND}
N 240 -210 460 -210 {lab=VDD}
N 50 -50 310 -50 {lab=#net2}
N 30 -80 30 10 {lab=GND}
N 30 10 50 10 {lab=GND}
N 460 -150 600 -150 {lab=Vout}
C {ipin.sym} 200 -120 0 0 {name=p1 lab=Vin}
C {symbols/nfet_03v3.sym} 220 -120 0 0 {name=M1
L=1u
W=3u
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
C {ipin.sym} 500 -120 0 1 {name=p2 lab=Vin_n}
C {symbols/nfet_03v3.sym} 480 -120 0 1 {name=M2
L=1u
W=3u
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
C {lab_pin.sym} 300 -120 0 1 {name=p3 sig_type=std_logic lab=GND}
C {lab_pin.sym} 400 -120 0 0 {name=p4 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 330 -50 0 0 {name=M3
L=1u
W=20u
nf=5
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
C {lab_pin.sym} 410 -20 0 1 {name=p5 sig_type=std_logic lab=GND}
C {symbols/ppolyf_u_1k.sym} 240 -180 0 1 {name=R1
W=2e-6
L=20e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {symbols/ppolyf_u_1k.sym} 460 -180 0 0 {name=R2
W=2e-6
L=20e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} 300 -180 0 1 {name=p6 sig_type=std_logic lab=GND}
C {lab_pin.sym} 400 -180 0 0 {name=p7 sig_type=std_logic lab=GND}
C {symbols/ppolyf_u.sym} 50 -20 0 0 {name=R4
W=1e-6
L=1e-6
model=ppolyf_u
spiceprefix=X
m=1}
C {symbols/ppolyf_u.sym} 50 -80 0 0 {name=R5
W=1e-6
L=1e-6
model=ppolyf_u
spiceprefix=X
m=1}
C {lab_wire.sym} 50 -110 0 0 {name=p10 sig_type=std_logic lab=VDD}
C {iopin.sym} 350 -210 1 1 {name=p8 lab=VDD}
C {opin.sym} 600 -150 0 0 {name=p11 lab=Vout}
C {iopin.sym} 50 10 0 0 {name=p9 lab=GND}
