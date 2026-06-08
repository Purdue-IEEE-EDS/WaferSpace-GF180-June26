v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 30 140 50 {lab=Vout}
N 140 -60 140 -40 {lab=#net1}
N 140 20 140 25 {lab=Vout}
N 0 -60 0 -40 {lab=#net1}
N 0 20 0 25 {lab=#net2}
N 140 25 140 30 {lab=Vout}
N 0 -60 65 -60 {lab=#net1}
N 0 30 0 50 {lab=#net2}
N 0 110 0 130 {lab=0}
N 140 110 140 130 {lab=0}
N 70 130 70 135 {lab=0}
N 65 -60 140 -60 {lab=#net1}
N 40 80 55 80 {lab=#net2}
N 0 130 140 130 {lab=0}
N 65 80 100 80 {lab=#net2}
N 70 135 70 155 {lab=0}
N 0 25 0 30 {lab=#net2}
N 55 80 65 80 {lab=#net2}
N 65 35 65 80 {lab=#net2}
N 0 35 65 35 {lab=#net2}
N 140 30 205 30 {lab=Vout}
N 65 -81.25 65 -60 {lab=#net1}
N 65 -156.25 65 -141.25 {lab=Vdd}
N 61.25 -111.25 65 -111.25 {lab=Vdd}
C {gnd.sym} 140 80 3 0 {name=l9 lab=0}
C {symbols/nfet_03v3.sym} 120 80 0 0 {name=M16
L=1u
W=2u
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
C {symbols/pfet_03v3.sym} 160 -10 0 1 {name=M1
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
model=pfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 140 -10 0 0 {name=p4 sig_type=std_logic lab=Vdd}
C {symbols/pfet_03v3.sym} -20 -10 0 0 {name=M19
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
model=pfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 0 -10 0 1 {name=p20 sig_type=std_logic lab=Vdd}
C {gnd.sym} 0 80 1 1 {name=l10 lab=0}
C {symbols/nfet_03v3.sym} 20 80 0 1 {name=M22
L=1u
W=2u
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
C {ipin.sym} -40 -10 0 0 {name=p5 lab=VinP}
C {ipin.sym} 180 -10 2 0 {name=p6 lab=VinN}
C {gnd.sym} 70 155 0 0 {name=l6 lab=0}
C {opin.sym} 205 30 0 0 {name=p2 lab=Vout}
C {param.sym} -560 88.75 0 0 {name=s4 value="bbW=2u"
}
C {param.sym} -560 108.75 0 0 {name=s5 value="bbL=1u"
}
C {lab_pin.sym} 25 -111.25 0 0 {name=p7 sig_type=std_logic lab=Vbias}
C {lab_pin.sym} 65 -156.25 1 0 {name=p75 sig_type=std_logic lab=Vdd}
C {symbols/pfet_03v3.sym} 45 -111.25 0 0 {name=M29
L=1u
W=4u
nf=1
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 63.75 -111.25 2 0 {name=p94 sig_type=std_logic lab=Vdd}
C {ipin.sym} -12.5 -235 0 0 {name=p1 lab=Vdd}
C {ipin.sym} -13.75 -210 0 0 {name=p3 lab=Vbias}
