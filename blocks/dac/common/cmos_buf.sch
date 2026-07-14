v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 95 57.5 95 72.5 {lab=ViB}
N 95 75 95 97.5 {lab=ViB}
N 90 7.5 95 7.5 {lab=Vdd}
N 95 37.5 95 57.5 {lab=ViB}
N 55 7.5 55 52.5 {lab=Vi}
N 55 7.5 57.5 7.5 {lab=Vi}
N 95 -40 95 -25 {lab=Vdd}
N 95 67.5 135 67.5 {lab=ViB}
N 95 -25 95 -22.5 {lab=Vdd}
N 95 72.5 95 75 {lab=ViB}
N 55 52.5 55 127.5 {lab=Vi}
N 257.5 60 257.5 75 {lab=ViBB}
N 257.5 77.5 257.5 100 {lab=ViBB}
N 252.5 10 257.5 10 {lab=Vdd}
N 257.5 40 257.5 60 {lab=ViBB}
N 217.5 10 217.5 55 {lab=ViB}
N 217.5 10 220 10 {lab=ViB}
N 257.5 -37.5 257.5 -22.5 {lab=Vdd}
N 257.5 70 297.5 70 {lab=ViBB}
N 257.5 -22.5 257.5 -20 {lab=Vdd}
N 257.5 75 257.5 77.5 {lab=ViBB}
N 217.5 55 217.5 130 {lab=ViB}
C {gnd.sym} 95 127.5 3 0 {name=l13 lab=0}
C {symbols/nfet_03v3.sym} 75 127.5 0 0 {name=M49
L=0.28u
W=0.5u
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
C {symbols/pfet_03v3.sym} 75 7.5 0 0 {name=M50
L=0.28u
W=1u
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
C {lab_pin.sym} 95 7.5 0 1 {name=p111 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 135 67.5 0 1 {name=p17 sig_type=std_logic lab=ViB}
C {lab_pin.sym} 95 -40 0 1 {name=p18 sig_type=std_logic lab=Vdd}
C {gnd.sym} 95 157.5 0 0 {name=Data9 lab=0
value="PULSE(3.3 0 \{clk*0.5\} 30ps 30ps \{clk*1\} \{clk*2\})"
}
C {lab_pin.sym} 55 67.5 2 1 {name=p1 sig_type=std_logic lab=Vi}
C {ipin.sym} 65 -202.5 0 0 {name=p84 lab=Vi}
C {opin.sym} 105 -202.5 0 0 {name=p2 lab=ViBB}
C {gnd.sym} 257.5 130 3 0 {name=l1 lab=0}
C {symbols/nfet_03v3.sym} 237.5 130 0 0 {name=M1
L=0.28u
W=0.5u
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
C {symbols/pfet_03v3.sym} 237.5 10 0 0 {name=M2
L=0.28u
W=1u
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
C {lab_pin.sym} 257.5 10 0 1 {name=p3 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 297.5 70 0 1 {name=p4 sig_type=std_logic lab=ViBB}
C {lab_pin.sym} 257.5 -37.5 0 1 {name=p5 sig_type=std_logic lab=Vdd}
C {gnd.sym} 257.5 160 0 0 {name=Data1 lab=0
value="PULSE(3.3 0 \{clk*0.5\} 30ps 30ps \{clk*1\} \{clk*2\})"
}
C {lab_pin.sym} 217.5 70 2 1 {name=p6 sig_type=std_logic lab=ViB}
C {ipin.sym} 67.5 -180 0 0 {name=p7 lab=Vdd}
