v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 230 140 250 {lab=vcm_n}
N 140 150 140 170 {lab=vcm}
N 140 130 140 150 {lab=vcm}
N 140 50 140 70 {lab=vcm_p}
N 330 2570 330 2600 {lab=nd}
N 690 660 690 690 {lab=taild}
N 590 660 690 660 {lab=taild}
N 690 660 790 660 {lab=taild}
N 790 560 790 600 {lab=vctr}
N 590 560 590 600 {lab=#net1}
N 70 350 70 370 {lab=vss}
N 70 270 70 290 {lab=vcm}
N 1080 660 1080 700 {lab=#net2}
N 1040 660 1080 660 {lab=#net2}
N 1200 650 1200 680 {lab=vdd}
N 1080 600 1080 630 {lab=vdd}
N 1200 820 1200 850 {lab=vss}
N 1080 680 1160 680 {lab=#net2}
N 750 600 790 600 {lab=vctr}
N 750 600 750 630 {lab=vctr}
N 630 530 630 560 {lab=#net1}
N 590 560 630 560 {lab=#net1}
N 630 530 750 530 {lab=#net1}
N 790 500 790 530 {lab=vdd}
N 590 500 590 530 {lab=vdd}
N 790 580 1200 580 {lab=vctr}
N 590 500 790 500 {lab=vdd}
N 590 720 650 720 {lab=nd}
N 590 690 590 720 {lab=nd}
N 550 690 590 690 {lab=nd}
N 550 720 550 750 {lab=vss}
N 690 720 690 750 {lab=vss}
N 550 750 690 750 {lab=vss}
N 650 720 650 730 {lab=nd}
N 960 820 1160 820 {lab=nd}
N 1040 630 1040 660 {lab=#net2}
N 650 730 1040 730 {lab=nd}
N 960 730 960 820 {lab=nd}
N 1080 730 1080 760 {lab=vss}
C {title.sym} -220 -50 0 0 {name=l2 author="Pranav Vadde"}
C {iopin.sym} -130 70 0 0 {name=pvdd lab=vdd}
C {iopin.sym} -130 100 0 0 {name=pvss lab=vss}
C {ipin.sym} -70 150 0 0 {name=p1 lab=vcm_p}
C {ipin.sym} -70 170 0 0 {name=p2 lab=vcm_n}
C {opin.sym} -140 240 0 0 {name=p3 lab=vrefp}
C {opin.sym} -140 260 0 0 {name=p4 lab=vrefn}
C {opin.sym} -140 280 0 0 {name=p5 lab=vctr}
C {symbols/ppolyf_u_3k.sym} 140 100 0 0 {name=Rs1
W=1e-6
L=16.7e-6
model=ppolyf_u_3k
spiceprefix=X
m=1}
C {lab_wire.sym} 120 100 0 0 {name=p6 sig_type=std_logic lab=vss
}
C {symbols/ppolyf_u_3k.sym} 140 200 0 0 {name=Rs2
W=1e-6
L=16.7e-6
model=ppolyf_u_3k
spiceprefix=X
m=1}
C {lab_wire.sym} 120 200 0 0 {name=p7 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 140 50 0 0 {name=p8 sig_type=std_logic lab=vcm_p
}
C {lab_wire.sym} 140 150 0 0 {name=p9 sig_type=std_logic lab=vcm
}
C {lab_wire.sym} 140 250 0 0 {name=p10 sig_type=std_logic lab=vcm_n
}
C {symbols/ppolyf_u_1k.sym} 330 80 0 0 {name=Rset1
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 80 0 0 {name=pb1 sig_type=std_logic lab=vss}
C {lab_wire.sym} 330 50 0 0 {name=p11 sig_type=std_logic lab=vdd
}
C {symbols/ppolyf_u_1k.sym} 330 140 0 0 {name=Rset2
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 140 0 0 {name=pb2 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 200 0 0 {name=Rset3
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 200 0 0 {name=pb3 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 260 0 0 {name=Rset4
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 260 0 0 {name=pb4 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 320 0 0 {name=Rset5
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 320 0 0 {name=pb5 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 380 0 0 {name=Rset6
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 380 0 0 {name=pb6 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 440 0 0 {name=Rset7
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 440 0 0 {name=pb7 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 500 0 0 {name=Rset8
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 500 0 0 {name=pb8 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 560 0 0 {name=Rset9
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 560 0 0 {name=pb9 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 620 0 0 {name=Rset10
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 620 0 0 {name=pb10 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 680 0 0 {name=Rset11
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 680 0 0 {name=pb11 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 740 0 0 {name=Rset12
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 740 0 0 {name=pb12 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 800 0 0 {name=Rset13
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 800 0 0 {name=pb13 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 860 0 0 {name=Rset14
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 860 0 0 {name=pb14 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 920 0 0 {name=Rset15
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 920 0 0 {name=pb15 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 980 0 0 {name=Rset16
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 980 0 0 {name=pb16 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 1040 0 0 {name=Rset17
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 1040 0 0 {name=pb17 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 1100 0 0 {name=Rset18
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 1100 0 0 {name=pb18 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 1160 0 0 {name=Rset19
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 1160 0 0 {name=pb19 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 1220 0 0 {name=Rset20
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 1220 0 0 {name=pb20 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 1280 0 0 {name=Rset21
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 1280 0 0 {name=pb21 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 1340 0 0 {name=Rset22
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 1340 0 0 {name=pb22 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 1400 0 0 {name=Rset23
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 1400 0 0 {name=pb23 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 1460 0 0 {name=Rset24
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 1460 0 0 {name=pb24 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 1520 0 0 {name=Rset25
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 1520 0 0 {name=pb25 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 1580 0 0 {name=Rset26
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 1580 0 0 {name=pb26 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 1640 0 0 {name=Rset27
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 1640 0 0 {name=pb27 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 1700 0 0 {name=Rset28
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 1700 0 0 {name=pb28 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 1760 0 0 {name=Rset29
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 1760 0 0 {name=pb29 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 1820 0 0 {name=Rset30
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 1820 0 0 {name=pb30 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 1880 0 0 {name=Rset31
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 1880 0 0 {name=pb31 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 1940 0 0 {name=Rset32
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 1940 0 0 {name=pb32 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 2000 0 0 {name=Rset33
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 2000 0 0 {name=pb33 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 2060 0 0 {name=Rset34
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 2060 0 0 {name=pb34 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 2120 0 0 {name=Rset35
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 2120 0 0 {name=pb35 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 2180 0 0 {name=Rset36
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 2180 0 0 {name=pb36 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 2240 0 0 {name=Rset37
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 2240 0 0 {name=pb37 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 2300 0 0 {name=Rset38
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 2300 0 0 {name=pb38 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 2360 0 0 {name=Rset39
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 2360 0 0 {name=pb39 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 2420 0 0 {name=Rset40
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 2420 0 0 {name=pb40 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 2480 0 0 {name=Rset41
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 2480 0 0 {name=pb41 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 330 2540 0 0 {name=Rset42
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 310 2540 0 0 {name=pb42 sig_type=std_logic lab=vss}
C {lab_wire.sym} 330 2600 0 0 {name=p12 sig_type=std_logic lab=nd
}
C {symbols/nfet_03v3.sym} 570 720 0 1 {name=Mnd
L=2u
W=16u
nf=4
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
C {lab_wire.sym} 620 750 0 0 {name=p17 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 1040 730 0 0 {name=p13 sig_type=std_logic lab=nd
}
C {symbols/nfet_03v3.sym} 1060 730 0 0 {name=Mnmir
L=2u
W=16u
nf=4
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
C {lab_wire.sym} 1080 760 2 0 {name=p18 sig_type=std_logic lab=vss
}
C {symbols/pfet_03v3.sym} 1060 630 0 0 {name=Mpd
L=2u
W=32u
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
C {symbols/pfet_03v3.sym} 1180 680 0 0 {name=Msc
L=2u
W=32u
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
C {lab_wire.sym} 1200 650 0 1 {name=p26 sig_type=std_logic lab=vdd
}
C {lab_wire.sym} 1200 710 2 0 {name=p28 sig_type=std_logic lab=vrefp
}
C {symbols/nfet_03v3.sym} 1180 820 0 0 {name=Msink
L=2u
W=16u
nf=4
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
C {lab_wire.sym} 1200 850 2 0 {name=Msink2 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 1200 790 0 1 {name=Msink3 sig_type=std_logic lab=vrefn
}
C {symbols/nfet_03v3.sym} 670 720 0 0 {name=Msink5
L=2u
W=16u
nf=4
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
C {symbols/nfet_03v3.sym} 570 630 0 0 {name=Min1
L=2u
W=20u
nf=4
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
C {lab_wire.sym} 590 630 0 1 {name=Msink10 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 550 630 0 0 {name=Msink12 sig_type=std_logic lab=vcm
}
C {lab_wire.sym} 700 660 0 0 {name=Msink8 sig_type=std_logic lab=taild
}
C {symbols/nfet_03v3.sym} 770 630 0 0 {name=Min2
L=2u
W=20u
nf=4
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
C {lab_wire.sym} 790 630 0 1 {name=Msink11 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 1200 580 0 1 {name=Msink13 sig_type=std_logic lab=vctr
}
C {symbols/pfet_03v3.sym} 770 530 0 0 {name=Mld2
L=2u
W=20u
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
C {symbols/pfet_03v3.sym} 610 530 0 1 {name=Mld1
L=2u
W=20u
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
C {lab_wire.sym} 690 500 0 0 {name=p33 sig_type=std_logic lab=vdd
}
C {symbols/cap_nmos_03v3_b.sym} 70 320 0 0 {name=C1
W=16e-6
L=16e-6
model=cap_nmos_03v3_b
spiceprefix=X
m=1}
C {lab_wire.sym} 70 270 0 0 {name=p35 sig_type=std_logic lab=vcm
}
C {lab_wire.sym} 70 370 0 0 {name=p36 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 1080 600 0 1 {name=p14 sig_type=std_logic lab=vdd
}
C {lab_wire.sym} 550 690 0 0 {name=p19 sig_type=std_logic lab=nd
}
