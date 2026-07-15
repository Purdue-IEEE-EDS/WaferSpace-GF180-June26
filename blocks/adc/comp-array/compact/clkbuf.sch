v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 210 50 210 90 {lab=n1}
N 150 120 170 120 {lab=clkc_pre}
N 150 20 150 120 {lab=clkc_pre}
N 150 20 170 20 {lab=clkc_pre}
N 210 -10 230 -10 {lab=vdd}
N 230 -10 230 20 {lab=vdd}
N 210 20 230 20 {lab=vdd}
N 210 150 230 150 {lab=vss}
N 230 120 230 150 {lab=vss}
N 210 120 230 120 {lab=vss}
N 370 50 370 90 {lab=n2}
N 310 120 330 120 {lab=n1}
N 310 20 310 120 {lab=n1}
N 310 20 330 20 {lab=n1}
N 370 -10 390 -10 {lab=vdd}
N 390 -10 390 20 {lab=vdd}
N 370 20 390 20 {lab=vdd}
N 370 150 390 150 {lab=vss}
N 390 120 390 150 {lab=vss}
N 370 120 390 120 {lab=vss}
N 210 70 310 70 {lab=n1}
N 530 50 530 90 {lab=n3}
N 470 120 490 120 {lab=n2}
N 470 20 470 120 {lab=n2}
N 470 20 490 20 {lab=n2}
N 530 -10 550 -10 {lab=vdd}
N 550 -10 550 20 {lab=vdd}
N 530 20 550 20 {lab=vdd}
N 530 150 550 150 {lab=vss}
N 550 120 550 150 {lab=vss}
N 530 120 550 120 {lab=vss}
N 370 70 470 70 {lab=n2}
N 690 50 690 90 {lab=clk_array}
N 630 120 650 120 {lab=n3}
N 630 20 630 120 {lab=n3}
N 630 20 650 20 {lab=n3}
N 530 70 630 70 {lab=n3}
N 690 -10 710 -10 {lab=vdd}
N 710 -10 710 20 {lab=vdd}
N 690 20 710 20 {lab=vdd}
N 690 150 720 150 {lab=vss}
N 720 120 720 150 {lab=vss}
N 690 120 720 120 {lab=vss}
C {opin.sym} -20 10 0 0 {name=p19 lab=clk_array}
C {iopin.sym} -20 40 0 0 {name=p1 lab=vdd}
C {iopin.sym} -20 70 0 0 {name=p2 lab=vss}
C {ipin.sym} 80 -20 0 0 {name=p4 lab=clkc_pre}
C {symbols/nfet_03v3.sym} 190 120 0 0 {name=Mb1n
L=0.28u
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
C {symbols/pfet_03v3.sym} 190 20 0 0 {name=Mb1p
L=0.28u
W=6u
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
C {lab_wire.sym} 150 70 0 0 {name=p32 sig_type=std_logic lab=clkc_pre}
C {lab_wire.sym} 210 70 0 1 {name=p33 sig_type=std_logic lab=n1}
C {lab_wire.sym} 210 -10 0 0 {name=p34 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 210 150 2 0 {name=p35 sig_type=std_logic lab=vss}
C {symbols/nfet_03v3.sym} 350 120 0 0 {name=Mb2n
L=0.28u
W=12u
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
C {symbols/pfet_03v3.sym} 350 20 0 0 {name=Mb2p
L=0.28u
W=24u
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
C {lab_wire.sym} 370 70 0 1 {name=p36 sig_type=std_logic lab=n2
}
C {lab_wire.sym} 370 -10 0 0 {name=p37 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 370 150 2 0 {name=p38 sig_type=std_logic lab=vss}
C {symbols/nfet_03v3.sym} 510 120 0 0 {name=Mb3n
L=0.28u
W=40u
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
C {symbols/pfet_03v3.sym} 510 20 0 0 {name=Mb3p
L=0.28u
W=88u
nf=4
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
C {lab_wire.sym} 530 70 0 1 {name=p39 sig_type=std_logic lab=n3}
C {lab_wire.sym} 530 -10 0 0 {name=p40 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 530 150 2 0 {name=p41 sig_type=std_logic lab=vss}
C {symbols/nfet_03v3.sym} 670 120 0 0 {name=Mb4n
L=0.28u
W=18u
nf=1
m=11
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 670 20 0 0 {name=Mb4p
L=0.28u
W=19u
nf=2
m=18
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 690 70 0 1 {name=p42 sig_type=std_logic lab=clk_array}
C {lab_wire.sym} 690 -10 0 0 {name=p43 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 690 150 2 0 {name=p44 sig_type=std_logic lab=vss}
