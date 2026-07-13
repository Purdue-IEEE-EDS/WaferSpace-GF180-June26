v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 270 -380 270 -340 {lab=Iref_pos}
N 150 -310 230 -310 {lab=V_up}
N 270 -280 270 -240 {lab=V_out}
N 270 -260 400 -260 {lab=V_out}
N 270 -210 380 -210 {lab=VSS}
N 270 -310 340 -310 {lab=VDD}
N 150 -210 230 -210 {lab=V_down}
N 270 -180 270 -140 {lab=Iref_neg}
N 380 -230 380 -140 {lab=VSS}
N 380 -140 400 -140 {lab=VSS}
N 400 -260 590 -260 {lab=V_out}
N 400 -140 530 -140 {lab=VSS}
N 530 -260 530 -200 {lab=V_out}
C {ipin.sym} 270 -380 0 0 {name=p1 lab=Iref_pos}
C {ipin.sym} 270 -140 0 0 {name=p2 lab=Iref_neg}
C {ipin.sym} 150 -310 0 0 {name=p3 lab=V_up}
C {ipin.sym} 150 -210 0 0 {name=p4 lab=V_down}
C {ipin.sym} 480 -470 0 0 {name=p5 lab=V_inv}
C {symbols/pfet_03v3.sym} 250 -310 0 0 {name=M1
L=1u
W=40u
nf=10
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
C {symbols/nfet_03v3.sym} 250 -210 0 0 {name=M2
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
C {ipin.sym} 340 -310 0 1 {name=p6 lab=VDD}
C {ipin.sym} 380 -140 1 1 {name=p7 lab=VSS}
C {symbols/ppolyf_u.sym} 400 -230 0 0 {name=R1
W=2e-6
L=8e-6
model=ppolyf_u
spiceprefix=X
m=1}
C {opin.sym} 590 -260 0 0 {name=p8 lab=V_out}
C {symbols/cap_nmos_03v3.sym} 480 -440 0 0 {name=C3
W=1e-6
L=1e-6
model=cap_nmos_03v3
spiceprefix=X
m=1}
C {lab_pin.sym} 480 -410 3 0 {name=p9 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_analog.sym} 400 -170 0 0 {name=C1
W=5e-6
L=5e-6
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {symbols/cap_mim_analog.sym} 530 -170 0 0 {name=C2
W=5e-6
L=5e-6
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
