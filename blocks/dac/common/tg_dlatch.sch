v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 1205 1020 1210 1020 {lab=Vdd}
N 1210 1055 1210 1070 {lab=#net1}
N 1210 1045 1210 1055 {lab=#net1}
N 1170 1020 1170 1100 {lab=#net2}
N 1210 970 1210 990 {lab=Vdd}
N 1155 1060 1170 1060 {lab=#net2}
N 935 1020 935 1025 {lab=Vdd}
N 905 1020 905 1095 {lab=Din}
N 965 1020 965 1095 {lab=X}
N 965 1060 985 1060 {lab=X}
N 1130 1195 1130 1200 {lab=Vdd}
N 1100 1195 1100 1270 {lab=X}
N 1160 1195 1160 1270 {lab=#net1}
N 1160 1235 1180 1235 {lab=#net1}
N 960 715 965 715 {lab=Vdd}
N 965 750 965 765 {lab=EnN}
N 965 740 965 750 {lab=EnN}
N 925 715 925 795 {lab=Ein}
N 965 665 965 685 {lab=Vdd}
N 880 755 910 755 {lab=Ein}
N 965 755 1005 755 {lab=EnN}
N 1055 715 1060 715 {lab=Vdd}
N 1060 750 1060 765 {lab=EnP}
N 1060 740 1060 750 {lab=EnP}
N 1020 715 1020 795 {lab=EnN}
N 1060 755 1100 755 {lab=EnP}
N 1060 665 1060 680 {lab=Vdd}
N 1060 680 1060 685 {lab=Vdd}
N 1005 755 1020 755 {lab=EnN}
N 910 755 925 755 {lab=Ein}
N 1090 1020 1095 1020 {lab=Vdd}
N 1095 1055 1095 1070 {lab=#net2}
N 1095 1045 1095 1055 {lab=#net2}
N 1055 1020 1055 1100 {lab=X}
N 1040 1060 1055 1060 {lab=X}
N 995 755 995 795 {lab=EnN}
N 1090 755 1090 795 {lab=EnP}
N 1385 1020 1390 1020 {lab=Vdd}
N 1390 1055 1390 1070 {lab=#net3}
N 1390 1045 1390 1055 {lab=#net3}
N 1350 1020 1350 1100 {lab=#net1}
N 1305 1060 1335 1060 {lab=#net1}
N 1390 1060 1430 1060 {lab=#net3}
N 1480 1020 1485 1020 {lab=Vdd}
N 1485 1055 1485 1070 {lab=Q}
N 1485 1045 1485 1055 {lab=Q}
N 1445 1020 1445 1100 {lab=#net3}
N 1485 1060 1525 1060 {lab=Q}
N 1485 970 1485 985 {lab=Vdd}
N 1485 985 1485 990 {lab=Vdd}
N 1430 1060 1445 1060 {lab=#net3}
N 1335 1060 1350 1060 {lab=#net1}
N 1390 970 1390 990 {lab=Vdd}
N 1390 970 1485 970 {lab=Vdd}
N 965 665 1060 665 {lab=Vdd}
N 1095 975 1095 990 {lab=Vdd}
N 1180 1235 1235 1235 {lab=#net1}
N 1095 1060 1150 1060 {lab=#net2}
N 1020 1060 1040 1060 {lab=X}
N 985 1060 995 1060 {lab=X}
N 1210 1060 1305 1060 {lab=#net1}
N 1150 1060 1155 1060 {lab=#net2}
N 880 665 965 665 {lab=Vdd}
N 995 1060 1020 1060 {lab=X}
N 1005 1235 1085 1235 {lab=X}
N 1005 1060 1005 1235 {lab=X}
N 870 1060 905 1060 {lab=Din}
N 1085 1235 1100 1235 {lab=X}
N 1005 1200 1025 1200 {lab=X}
N 1260 1060 1260 1235 {lab=#net1}
N 1235 1235 1260 1235 {lab=#net1}
N 1530 1060 1620 1060 {lab=Q}
N 1525 1060 1530 1060 {lab=Q}
N 1575 1060 1575 1085 {lab=Q}
C {symbols/pfet_03v3.sym} 1190 1020 0 0 {name=M21
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
model=pfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 1210 1020 0 1 {name=p9 sig_type=std_logic lab=Vdd}
C {gnd.sym} 1210 1100 3 0 {name=l1 lab=0}
C {symbols/nfet_03v3.sym} 1190 1100 0 0 {name=M22
L=0.28u
W=0.22u
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
C {gnd.sym} 1210 1130 0 1 {name=l4 lab=0}
C {ipin.sym} 880 755 2 1 {name=p10 lab=Ein}
C {ipin.sym} 880 665 0 0 {name=p30 lab=Vdd}
C {opin.sym} 1620 1060 0 0 {name=p31 lab=Q}
C {ipin.sym} 870 1060 2 1 {name=p32 lab=D}
C {symbols/pfet_03v3.sym} 935 1000 1 0 {name=M23
L=0.28u
W=\{tgpW\}
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
C {symbols/nfet_03v3.sym} 935 1115 3 0 {name=M24
L=0.28u
W=0.22u
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
C {gnd.sym} 935 1095 2 1 {name=l21 lab=0}
C {lab_pin.sym} 935 1020 1 1 {name=p33 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 935 980 0 0 {name=p34 sig_type=std_logic lab=EnN}
C {lab_pin.sym} 935 1135 0 0 {name=p35 sig_type=std_logic lab=EnP}
C {symbols/pfet_03v3.sym} 1130 1175 1 0 {name=M25
L=0.28u
W=\{tgpW\}
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
C {symbols/nfet_03v3.sym} 1130 1290 3 0 {name=M26
L=0.28u
W=0.22u
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
C {gnd.sym} 1130 1270 2 1 {name=l22 lab=0}
C {lab_pin.sym} 1130 1195 1 1 {name=p36 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 1130 1155 0 0 {name=p37 sig_type=std_logic lab=EnP}
C {lab_pin.sym} 1130 1310 0 0 {name=p38 sig_type=std_logic lab=EnN}
C {symbols/pfet_03v3.sym} 945 715 0 0 {name=M27
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
model=pfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 965 715 0 1 {name=p39 sig_type=std_logic lab=Vdd}
C {gnd.sym} 965 795 3 0 {name=l23 lab=0}
C {symbols/nfet_03v3.sym} 945 795 0 0 {name=M28
L=0.28u
W=0.22u
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
C {gnd.sym} 965 825 0 1 {name=l26 lab=0}
C {symbols/pfet_03v3.sym} 1040 715 0 0 {name=M29
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
model=pfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 1060 715 0 1 {name=p40 sig_type=std_logic lab=Vdd}
C {gnd.sym} 1060 795 3 0 {name=l29 lab=0}
C {symbols/nfet_03v3.sym} 1040 795 0 0 {name=M30
L=0.28u
W=0.22u
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
C {gnd.sym} 1060 825 0 1 {name=l30 lab=0}
C {symbols/pfet_03v3.sym} 1075 1020 0 0 {name=M31
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
model=pfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 1095 1020 0 1 {name=p41 sig_type=std_logic lab=Vdd}
C {gnd.sym} 1095 1100 3 0 {name=l31 lab=0}
C {symbols/nfet_03v3.sym} 1075 1100 0 0 {name=M32
L=0.28u
W=0.22u
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
C {gnd.sym} 1095 1130 0 1 {name=l32 lab=0}
C {lab_pin.sym} 1210 970 2 1 {name=p42 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 995 795 1 1 {name=p43 sig_type=std_logic lab=EnN}
C {lab_pin.sym} 1090 795 1 1 {name=p44 sig_type=std_logic lab=EnP}
C {symbols/pfet_03v3.sym} 1370 1020 0 0 {name=M33
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
model=pfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 1390 1020 0 1 {name=p45 sig_type=std_logic lab=Vdd}
C {gnd.sym} 1390 1100 3 0 {name=l33 lab=0}
C {symbols/nfet_03v3.sym} 1370 1100 0 0 {name=M34
L=0.28u
W=0.22u
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
C {gnd.sym} 1390 1130 0 1 {name=l34 lab=0}
C {symbols/pfet_03v3.sym} 1465 1020 0 0 {name=M37
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
model=pfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 1485 1020 0 1 {name=p46 sig_type=std_logic lab=Vdd}
C {gnd.sym} 1485 1100 3 0 {name=l35 lab=0}
C {symbols/nfet_03v3.sym} 1465 1100 0 0 {name=M38
L=0.28u
W=0.22u
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
C {gnd.sym} 1485 1130 0 1 {name=l36 lab=0}
C {lab_pin.sym} 1390 970 2 1 {name=p47 sig_type=std_logic lab=Vdd}
C {param.sym} 840 920 0 0 {name=s1 value="tgpW=0.22u"}
C {lab_pin.sym} 1095 975 2 1 {name=p48 sig_type=std_logic lab=Vdd}
C {opin.sym} 1025 1200 0 0 {name=p49 lab=X}
C {capa.sym} 1575 1115 0 0 {name=C1
m=1
value=10f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 1575 1145 0 1 {name=l2 lab=0}
