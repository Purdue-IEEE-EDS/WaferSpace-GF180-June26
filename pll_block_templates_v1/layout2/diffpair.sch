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
N 350 40 410 40 {lab=GND}
N 350 10 350 40 {lab=GND}
N 260 -250 300 -250 {lab=GND}
N 400 -250 440 -250 {lab=GND}
N 240 -280 460 -280 {lab=VDD}
N 50 10 310 10 {lab=#net2}
N 30 -20 30 70 {lab=GND}
N 30 70 50 70 {lab=GND}
N 460 -220 920 -220 {lab=Vout}
N 350 -80 350 -20 {lab=#net1}
N 460 -220 460 -150 {lab=Vout}
N 240 -220 240 -150 {lab=#net3}
C {ipin.sym} 200 -120 0 0 {name=p1 lab=Vin}
C {symbols/nfet_03v3.sym} 220 -120 0 0 {name=M1
L=0.56u
W=4.5u
nf=3
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
L=0.56u
W=4.5u
nf=3
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
C {symbols/nfet_03v3.sym} 330 10 0 0 {name=M3
L=0.56u
W=9u
nf=6
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
C {lab_pin.sym} 410 40 0 1 {name=p5 sig_type=std_logic lab=GND}
C {symbols/ppolyf_u_1k.sym} 240 -250 0 1 {name=R1
W=2e-6
L=24e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {symbols/ppolyf_u_1k.sym} 460 -250 0 0 {name=R2
W=2e-6
L=24e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} 300 -250 0 1 {name=p6 sig_type=std_logic lab=GND}
C {lab_pin.sym} 400 -250 0 0 {name=p7 sig_type=std_logic lab=GND}
C {symbols/ppolyf_u.sym} 50 40 0 0 {name=R4
W=1e-6
L=1e-6
model=ppolyf_u
spiceprefix=X
m=1}
C {symbols/ppolyf_u.sym} 50 -20 0 0 {name=R5
W=1e-6
L=2e-6
model=ppolyf_u
spiceprefix=X
m=1}
C {lab_wire.sym} 50 -50 0 0 {name=p10 sig_type=std_logic lab=VDD}
C {iopin.sym} 350 -280 1 1 {name=p8 lab=VDD}
C {opin.sym} 920 -220 0 0 {name=p11 lab=Vout}
C {iopin.sym} 50 70 0 0 {name=p9 lab=GND}
