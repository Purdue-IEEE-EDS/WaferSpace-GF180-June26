v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -1330 -800 -1330 -770 {lab=vdd}
N -1330 -800 -1120 -800 {lab=vdd}
N -1120 -800 -1120 -770 {lab=vdd}
N -1220 -800 -1220 -740 {lab=vdd}
N -1330 -710 -1330 -670 {lab=outp}
N -1120 -710 -1120 -670 {lab=outn}
N -1330 -570 -1120 -570 {lab=vdd}
N -1220 -740 -1220 -640 {lab=vdd}
N -1220 -640 -1220 -610 {lab=vdd}
N -1330 -670 -1330 -630 {lab=outp}
N -1120 -670 -1120 -630 {lab=outn}
N -1220 -610 -1220 -600 {lab=vdd}
N -1220 -600 -1220 -570 {lab=vdd}
N -950 -680 -950 -660 {lab=di_p}
N -740 -680 -740 -660 {lab=di_n}
N -950 -660 -950 -640 {lab=di_p}
N -740 -660 -740 -640 {lab=di_n}
N -950 -580 -950 -550 {lab=tail}
N -950 -550 -740 -550 {lab=tail}
N -740 -580 -740 -550 {lab=tail}
N -840 -550 -840 -520 {lab=tail}
N -1330 -500 -1330 -470 {lab=vdd}
N -1330 -500 -1120 -500 {lab=vdd}
N -1120 -500 -1120 -470 {lab=vdd}
N -1330 -410 -1330 -370 {lab=di_p}
N -1120 -410 -1120 -370 {lab=di_n}
N -1330 -320 -1330 -290 {lab=vdd}
N -1330 -320 -1120 -320 {lab=vdd}
N -1120 -320 -1120 -290 {lab=vdd}
N -1330 -230 -1330 -190 {lab=Q}
N -1120 -230 -1120 -190 {lab=Q}
N -1330 -190 -1120 -190 {lab=Q}
N -1220 -190 -1220 -170 {lab=Q}
N -1220 -110 -1220 -80 {lab=nq}
N -1220 -80 -1220 -60 {lab=nq}
N -920 -320 -920 -290 {lab=vdd}
N -920 -320 -710 -320 {lab=vdd}
N -710 -320 -710 -290 {lab=vdd}
N -920 -230 -920 -190 {lab=Q_bar}
N -710 -230 -710 -190 {lab=Q_bar}
N -920 -190 -710 -190 {lab=Q_bar}
N -810 -190 -810 -170 {lab=Q_bar}
N -810 -110 -810 -80 {lab=nb}
N -810 -80 -810 -60 {lab=nb}
C {symbols/pfet_03v3.sym} -1350 -740 0 0 {name=Mpr1
L=0.28u
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
C {symbols/pfet_03v3.sym} -1100 -740 0 1 {name=Mpr2
L=0.28u
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
C {lab_wire.sym} -1220 -800 0 0 {name=p2 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -1370 -740 0 0 {name=p3 sig_type=std_logic lab=clk}
C {lab_wire.sym} -1080 -740 0 1 {name=p6 sig_type=std_logic lab=clk

}
C {lab_wire.sym} -1330 -670 0 0 {name=p4 sig_type=std_logic lab=outp}
C {lab_wire.sym} -1120 -670 0 1 {name=p5 sig_type=std_logic lab=outn

}
C {symbols/pfet_03v3.sym} -1350 -600 2 1 {name=Mp3
L=0.28u
W=8u
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
C {symbols/pfet_03v3.sym} -1100 -600 2 0 {name=Mp4
L=0.28u
W=8u
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
C {lab_wire.sym} -1370 -600 0 0 {name=p7 sig_type=std_logic lab=outn}
C {lab_wire.sym} -1080 -600 0 1 {name=p8 sig_type=std_logic lab=outp

}
C {symbols/nfet_03v3.sym} -970 -710 0 0 {name=Mn3
L=0.28u
W=10u
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
C {lab_wire.sym} -950 -740 0 0 {name=p9 sig_type=std_logic lab=outp}
C {symbols/nfet_03v3.sym} -720 -710 0 1 {name=Mn4
L=0.28u
W=10u
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
C {lab_wire.sym} -740 -740 0 1 {name=p10 sig_type=std_logic lab=outn

}
C {lab_wire.sym} -700 -710 0 1 {name=p11 sig_type=std_logic lab=outp

}
C {lab_wire.sym} -990 -710 0 0 {name=p12 sig_type=std_logic lab=outn}
C {lab_wire.sym} -1120 -740 0 0 {name=p13 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -1330 -740 0 1 {name=p14 sig_type=std_logic lab=vdd

}
C {lab_wire.sym} -950 -660 0 0 {name=p15 sig_type=std_logic lab=di_p}
C {lab_wire.sym} -740 -660 0 1 {name=p16 sig_type=std_logic lab=di_n

}
C {symbols/nfet_03v3.sym} -970 -610 0 0 {name=Mn1
L=0.28u
W=10u
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
C {symbols/nfet_03v3.sym} -720 -610 0 1 {name=Mn2
L=0.28u
W=10u
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
C {lab_wire.sym} -700 -610 0 1 {name=p17 sig_type=std_logic lab=inn

}
C {lab_wire.sym} -990 -610 0 0 {name=p18 sig_type=std_logic lab=inp}
C {lab_wire.sym} -840 -550 0 0 {name=p19 sig_type=std_logic lab=tail}
C {symbols/nfet_03v3.sym} -860 -490 0 0 {name=Mn0
L=0.28u
W=20u
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
C {lab_wire.sym} -880 -490 0 0 {name=p20 sig_type=std_logic lab=clk}
C {lab_wire.sym} -1330 -600 0 1 {name=p26 sig_type=std_logic lab=vdd

}
C {lab_wire.sym} -1120 -600 0 0 {name=p27 sig_type=std_logic lab=vdd}
C {symbols/pfet_03v3.sym} -1350 -440 0 0 {name=Mpr3
L=0.28u
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
C {symbols/pfet_03v3.sym} -1100 -440 0 1 {name=Mpr4
L=0.28u
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
C {lab_wire.sym} -1220 -500 0 0 {name=p1 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -1370 -440 0 0 {name=p21 sig_type=std_logic lab=clk}
C {lab_wire.sym} -1080 -440 0 1 {name=p22 sig_type=std_logic lab=clk

}
C {lab_wire.sym} -1330 -370 0 0 {name=p23 sig_type=std_logic lab=di_p}
C {lab_wire.sym} -1120 -370 0 1 {name=p28 sig_type=std_logic lab=di_n

}
C {lab_wire.sym} -1120 -440 0 0 {name=p29 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -1330 -440 0 1 {name=p30 sig_type=std_logic lab=vdd

}
C {iopin.sym} -1520 -600 0 0 {name=p24 lab=vdd}
C {ipin.sym} -1470 -570 0 0 {name=p25 lab=inp}
C {ipin.sym} -1470 -540 0 0 {name=p31 lab=inn}
C {ipin.sym} -1470 -510 0 0 {name=p32 lab=clk}
C {opin.sym} -1520 -480 0 0 {name=p33 lab=Q}
C {opin.sym} -1520 -450 0 0 {name=p34 lab=Q_bar}
C {symbols/pfet_03v3.sym} -1350 -260 0 0 {name=Mpqa
L=0.28u
W=4u
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
C {symbols/pfet_03v3.sym} -1100 -260 0 1 {name=Mpqb
L=0.28u
W=4u
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
C {lab_wire.sym} -1220 -320 0 0 {name=p35 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -1370 -260 0 0 {name=p36 sig_type=std_logic lab=outp}
C {lab_wire.sym} -1080 -260 0 1 {name=p37 sig_type=std_logic lab=Q_bar

}
C {lab_wire.sym} -1120 -260 0 0 {name=p40 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -1330 -260 0 1 {name=p41 sig_type=std_logic lab=vdd

}
C {lab_wire.sym} -1220 -190 0 0 {name=p38 sig_type=std_logic lab=Q}
C {symbols/nfet_03v3.sym} -1240 -140 0 0 {name=Mnqa
L=0.28u
W=3u
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
C {lab_wire.sym} -1260 -140 0 0 {name=p39 sig_type=std_logic lab=outp}
C {lab_wire.sym} -1220 -80 0 0 {name=p42 sig_type=std_logic lab=nq}
C {symbols/nfet_03v3.sym} -1240 -30 0 0 {name=Mnqb
L=0.28u
W=3u
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
C {lab_wire.sym} -1260 -30 0 0 {name=p43 sig_type=std_logic lab=Q_bar}
C {symbols/pfet_03v3.sym} -940 -260 0 0 {name=Mpba
L=0.28u
W=4u
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
C {symbols/pfet_03v3.sym} -690 -260 0 1 {name=Mpbb
L=0.28u
W=4u
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
C {lab_wire.sym} -810 -320 0 0 {name=p44 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -960 -260 0 0 {name=p45 sig_type=std_logic lab=outn}
C {lab_wire.sym} -670 -260 0 1 {name=p46 sig_type=std_logic lab=Q

}
C {lab_wire.sym} -710 -260 0 0 {name=p47 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -920 -260 0 1 {name=p48 sig_type=std_logic lab=vdd

}
C {lab_wire.sym} -810 -190 0 0 {name=p49 sig_type=std_logic lab=Q_bar}
C {symbols/nfet_03v3.sym} -830 -140 0 0 {name=Mnba
L=0.28u
W=3u
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
C {lab_wire.sym} -850 -140 0 0 {name=p50 sig_type=std_logic lab=outn}
C {lab_wire.sym} -810 -80 0 0 {name=p51 sig_type=std_logic lab=nb}
C {symbols/nfet_03v3.sym} -830 -30 0 0 {name=Mnbb
L=0.28u
W=3u
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
C {lab_wire.sym} -850 -30 0 0 {name=p52 sig_type=std_logic lab=Q}
C {iopin.sym} -1520 -420 0 0 {name=p53 lab=vss}
C {lab_wire.sym} -950 -710 0 1 {name=p54 sig_type=std_logic lab=vss

}
C {lab_wire.sym} -950 -610 0 1 {name=p55 sig_type=std_logic lab=vss

}
C {lab_wire.sym} -840 -460 0 1 {name=p56 sig_type=std_logic lab=vss

}
C {lab_wire.sym} -840 -490 0 1 {name=p57 sig_type=std_logic lab=vss

}
C {lab_wire.sym} -740 -610 0 0 {name=p58 sig_type=std_logic lab=vss}
C {lab_wire.sym} -740 -710 0 0 {name=p59 sig_type=std_logic lab=vss}
C {lab_wire.sym} -1220 -140 0 1 {name=p60 sig_type=std_logic lab=vss

}
C {lab_wire.sym} -1220 -30 0 1 {name=p61 sig_type=std_logic lab=vss

}
C {lab_wire.sym} -810 -140 0 1 {name=p62 sig_type=std_logic lab=vss

}
C {lab_wire.sym} -810 -30 0 1 {name=p63 sig_type=std_logic lab=vss

}
C {lab_wire.sym} -810 0 0 1 {name=p64 sig_type=std_logic lab=vss

}
C {lab_wire.sym} -1220 0 0 1 {name=p65 sig_type=std_logic lab=vss

}
C {title.sym} -1520 -910 0 0 {name=l2 author="Pranav Vadde"}
C {symbols/pfet_03v3.sym} -560 -460 0 0 {name=Meqo
L=0.28u
W=10u
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
C {lab_wire.sym} -580 -460 0 0 {name=p66 sig_type=std_logic lab=clk}
C {lab_wire.sym} -540 -430 0 0 {name=p67 sig_type=std_logic lab=outp}
C {lab_wire.sym} -540 -490 0 0 {name=p68 sig_type=std_logic lab=outn}
C {symbols/pfet_03v3.sym} -560 -350 0 0 {name=Meqd
L=0.28u
W=10u
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
C {lab_wire.sym} -580 -350 0 0 {name=p69 sig_type=std_logic lab=clk}
C {lab_wire.sym} -540 -320 0 0 {name=p70 sig_type=std_logic lab=di_p}
C {lab_wire.sym} -540 -380 0 0 {name=p71 sig_type=std_logic lab=di_n}
C {lab_wire.sym} -540 -460 0 1 {name=p72 sig_type=std_logic lab=vdd

}
C {lab_wire.sym} -540 -350 0 1 {name=p73 sig_type=std_logic lab=vdd

}
