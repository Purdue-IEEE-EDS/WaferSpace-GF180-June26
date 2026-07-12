v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 590 140 610 140 {lab=iref_adc}
N 590 140 590 190 {lab=iref_adc}
N 590 190 650 190 {lab=iref_adc}
N 650 170 650 190 {lab=iref_adc}
N 650 90 650 110 {lab=vdd}
N 650 90 730 90 {lab=vdd}
N 730 90 730 140 {lab=vdd}
N 650 140 730 140 {lab=vdd}
N 480 140 590 140 {lab=iref_adc}
N 370 140 440 140 {lab=vdd}
N 370 100 370 140 {lab=vdd}
N 440 100 440 110 {lab=vdd}
N 370 90 650 90 {lab=vdd}
N 370 90 370 100 {lab=vdd}
N 440 90 440 100 {lab=vdd}
N 440 170 440 220 {lab=nbias}
N 480 250 490 250 {lab=nbias}
N 490 210 490 250 {lab=nbias}
N 440 210 490 210 {lab=nbias}
N 490 250 490 280 {lab=nbias}
N 650 250 650 280 {lab=iref_adc}
N 540 250 650 250 {lab=iref_adc}
N 540 140 540 250 {lab=iref_adc}
N 440 280 440 340 {lab=vss}
N 440 340 490 340 {lab=vss}
N 350 280 440 280 {lab=vss}
N 350 250 350 280 {lab=vss}
N 350 250 440 250 {lab=vss}
N 490 340 650 340 {lab=vss}
C {title.sym} 20 -40 0 0 {name=l2 author="Pranav Vadde"}
C {iopin.sym} 210 100 0 0 {name=pvdd lab=vdd}
C {iopin.sym} 210 130 0 0 {name=pvss lab=vss}
C {opin.sym} 200 160 0 0 {name=p1 lab=nbias}
C {ipin.sym} 290 190 0 0 {name=p5 lab=iref_adc}
C {symbols/pfet_03v3.sym} 630 140 0 0 {name=Mp_in
L=1u
W=10u
nf=2
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
C {lab_wire.sym} 660 90 0 1 {name=p2 sig_type=std_logic lab=vdd
}
C {lab_wire.sym} 570 140 0 0 {name=p3 sig_type=std_logic lab=iref_adc

}
C {symbols/pfet_03v3.sym} 460 140 0 1 {name=Mp_mirr
L=1u
W=10u
nf=2
m=5
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 440 180 2 1 {name=p4 sig_type=std_logic lab=nbias

}
C {symbols/nfet_03v3.sym} 460 250 0 1 {name=Mref
L=0.5u
W=4u
nf=2
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
C {symbols/cap_nmos_03v3_b.sym} 490 310 0 0 {name=Cnb
W=16u
L=16u
model=cap_nmos_03v3_b
spiceprefix=X
m=1}
C {lab_wire.sym} 440 340 2 1 {name=p6 sig_type=std_logic lab=vss

}
C {symbols/cap_nmos_03v3_b.sym} 650 310 0 0 {name=Cpb
W=8u
L=8u
model=cap_nmos_03v3_b
spiceprefix=X
m=1}
