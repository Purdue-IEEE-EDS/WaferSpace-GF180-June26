v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 1390 -2480 2190 -2080 {flags=graph
y1=0
y2=3.3
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=-5.3945747e-10
x2=4.4605424e-09
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="clk
rst"
color="4 11"
dataset=-1
unitx=1
logx=0
logy=0
}
B 2 1390 -2080 2190 -1680 {flags=graph
y1=-0.033
y2=3.3
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=-5.3945747e-10
x2=4.4605424e-09
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="d
q"
color="10 5"
dataset=-1
unitx=1
logx=0
logy=0
}
T {"
V_VDD VDD 0 3.3

V_CLK CLK 0 pulse(0 3.3 260p 10p 10p 290p 500p)
V_D D 0 pwl(0 0 250p 0 260p 3.3 300p 3.3 310p 0 1.75n 0)
V_RST RST 0 pulse(3.3 3.3 0s 10p 10p 240p 500p)
.control
  save CLK D RST Q
  run
  write tspc_dff_rst_test.raw
.endc
.tran 1p 5n

"} 2900 -1880 0 0 0.4 0.4 {}
N 1770 -1170 1770 -1120 {lab=GND}
N 1770 -1260 1770 -1230 {lab=Q}
N 1700 -1260 1750 -1260 {lab=Q}
N 1750 -1260 1880 -1260 {lab=Q}
N 590 -1480 590 -1460 {lab=VDD}
N 585 -1430 600 -1430 {lab=VDD}
N 585 -1280 600 -1280 {lab=VDD}
N 820 -1480 820 -1460 {lab=VDD}
N 815 -1430 830 -1430 {lab=VDD}
N 820 -1330 820 -1310 {lab=#net1}
N 815 -1280 830 -1280 {lab=VDD}
N 1040 -1480 1040 -1460 {lab=VDD}
N 1035 -1430 1050 -1430 {lab=VDD}
N 590 -1100 590 -1080 {lab=GND}
N 590 -1130 610 -1130 {lab=GND}
N 510 -1130 550 -1130 {lab=D}
N 590 -1250 590 -1160 {lab=A}
N 820 -1130 840 -1130 {lab=GND}
N 740 -1130 780 -1130 {lab=A}
N 1250 -1280 1270 -1280 {lab=GND}
N 1170 -1280 1210 -1280 {lab=CLK}
N 1250 -1100 1250 -1080 {lab=GND}
N 1250 -1130 1270 -1130 {lab=GND}
N 1170 -1130 1210 -1130 {lab=B}
N 1480 -1100 1480 -1080 {lab=GND}
N 1480 -1130 1500 -1130 {lab=GND}
N 1400 -1130 1440 -1130 {lab=QB}
N 1480 -1330 1480 -1310 {lab=VDD}
N 1475 -1280 1490 -1280 {lab=VDD}
N 1250 -1480 1250 -1460 {lab=VDD}
N 1245 -1430 1260 -1430 {lab=VDD}
N 590 -1400 590 -1310 {lab=#net2}
N 510 -1430 550 -1430 {lab=D}
N 510 -1280 550 -1280 {lab=CLK}
N 440 -1130 510 -1130 {lab=D}
N 440 -1430 440 -1130 {lab=D}
N 440 -1430 510 -1430 {lab=D}
N 400 -1280 440 -1280 {lab=D}
N 590 -1200 710 -1200 {lab=A}
N 710 -1280 710 -1200 {lab=A}
N 710 -1280 780 -1280 {lab=A}
N 730 -1430 780 -1430 {lab=CLK}
N 960 -1430 1000 -1430 {lab=RST}
N 820 -970 820 -950 {lab=GND}
N 820 -1000 840 -1000 {lab=GND}
N 740 -1000 780 -1000 {lab=CLK}
N 820 -1250 820 -1160 {lab=B}
N 820 -1400 820 -1330 {lab=#net1}
N 1090 -1430 1210 -1430 {lab=B}
N 1090 -1430 1090 -1130 {lab=B}
N 1090 -1130 1170 -1130 {lab=B}
N 1040 -1400 1040 -1340 {lab=B}
N 1040 -1340 1090 -1340 {lab=B}
N 820 -1220 1090 -1220 {lab=B}
N 1400 -1280 1440 -1280 {lab=QB}
N 1400 -1280 1400 -1130 {lab=QB}
N 1480 -1250 1480 -1160 {lab=Q}
N 1480 -1200 1530 -1200 {lab=Q}
N 1250 -1400 1250 -1310 {lab=QB}
N 1250 -1250 1250 -1160 {lab=#net3}
N 1250 -1340 1400 -1340 {lab=QB}
N 1400 -1340 1400 -1270 {lab=QB}
N 710 -1130 740 -1130 {lab=A}
N 710 -1200 710 -1130 {lab=A}
N 820 -1100 820 -1030 {lab=#net4}
N 1620 -1260 1700 -1260 {lab=Q}
N 1620 -1260 1620 -1200 {lab=Q}
N 1530 -1200 1620 -1200 {lab=Q}
C {code_shown.sym} 2315 -1505 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice ss
"}
C {code_shown.sym} 2345 -1325 0 0 {name=SPICE only_toplevel=false value="
V_VDD VDD 0 3.3

V_CLK CLK 0 pulse(0 3.3 260p 10p 10p 290p 500p)
V_D D 0 pwl(0 0 150p 0 160p 3.3 400p 3.3 410p 0 1100p 0 1110p 3.3 1400p 3.3 1410p 0 2100p 0 2110p 3.3 2400p 3.3 2410p 0 3100p 0 3110p 3.3 3400p 3.3 3410p 0 4100p 0 4110p 3.3 4400p 3.3 4410p 0 5n 0)
V_RST RST 0 pulse(0 3.3 150p 10p 10p 5n 10n)
.control
  save CLK D RST Q
  run
  write tspc_dff_rst_test.raw
.endc
.tran 1p 5n

"}
C {launcher.sym} 1500 -1640 0 0 {name=h5
descr="load waves"
tclcommand="xschem raw_read $netlist_dir/dff_test.raw tran"
}
C {lab_wire.sym} 1770 -1130 0 0 {name=p22 sig_type=std_logic lab=GND}
C {capa.sym} 1770 -1200 0 0 {name=C2
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {opin.sym} 1880 -1260 0 0 {name=p21 lab=Q}
C {ipin.sym} 400 -1280 0 0 {name=p23 lab=D}
C {symbols/pfet_03v3.sym} 570 -1430 0 0 {name=M1
L=0.28u
W=0.88u
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
C {lab_wire.sym} 595 -1430 0 0 {name=p35 sig_type=std_logic lab=VDD
m=8}
C {symbols/pfet_03v3.sym} 570 -1280 0 0 {name=M7
L=0.28u
W=0.88u
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
C {lab_wire.sym} 595 -1280 0 0 {name=p37 sig_type=std_logic lab=VDD
m=35}
C {symbols/pfet_03v3.sym} 800 -1430 0 0 {name=M8
L=0.28u
W=0.88u
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
C {lab_wire.sym} 825 -1430 0 0 {name=p38 sig_type=std_logic lab=VDD
m=8
W=0.88u}
C {symbols/pfet_03v3.sym} 800 -1280 0 0 {name=M9
L=0.28u
W=0.88u
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
C {lab_wire.sym} 825 -1280 0 0 {name=p39 sig_type=std_logic lab=VDD
m=35
W=0.88u}
C {symbols/pfet_03v3.sym} 1020 -1430 0 0 {name=M10
L=0.28u
W=0.88u
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
C {lab_wire.sym} 1045 -1430 0 0 {name=p40 sig_type=std_logic lab=VDD
m=8}
C {symbols/nfet_03v3.sym} 570 -1130 0 0 {name=M19
L=0.28u
W=0.36u
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
C {lab_wire.sym} 605 -1130 0 0 {name=p41 sig_type=std_logic lab=GND
m=3}
C {symbols/nfet_03v3.sym} 800 -1130 0 0 {name=M20
L=0.28u
W=0.36u
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
C {lab_wire.sym} 835 -1130 0 0 {name=p42 sig_type=std_logic lab=GND
m=1}
C {symbols/nfet_03v3.sym} 1230 -1280 0 0 {name=M21
L=0.28u
W=0.36u
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
C {lab_wire.sym} 1265 -1280 0 0 {name=p43 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 1230 -1130 0 0 {name=M22
L=0.28u
W=0.36u
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
C {lab_wire.sym} 1265 -1130 0 0 {name=p44 sig_type=std_logic lab=GND}
C {lab_wire.sym} 1250 -1080 0 0 {name=p45 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 1460 -1130 0 0 {name=M23
L=0.28u
W=1.1u
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
C {lab_wire.sym} 1495 -1130 0 0 {name=p46 sig_type=std_logic lab=GND}
C {lab_wire.sym} 1480 -1080 0 0 {name=p47 sig_type=std_logic lab=GND}
C {symbols/pfet_03v3.sym} 1460 -1280 0 0 {name=M24
L=0.28u
W=2.2u
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
C {lab_wire.sym} 1485 -1280 0 0 {name=p48 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1230 -1430 0 0 {name=M25
L=0.28u
W=0.88u
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
C {lab_wire.sym} 1255 -1430 0 0 {name=p49 sig_type=std_logic lab=VDD
m=8}
C {symbols/nfet_03v3.sym} 800 -1000 0 0 {name=M26
L=0.28u
W=0.36u
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
C {lab_wire.sym} 835 -1000 0 0 {name=p50 sig_type=std_logic lab=GND
m=1}
C {lab_wire.sym} 820 -950 0 0 {name=p51 sig_type=std_logic lab=GND
m=1}
C {lab_wire.sym} 820 -1480 0 0 {name=p52 sig_type=std_logic lab=VDD
m=8
W=0.88u}
C {lab_wire.sym} 1040 -1480 0 0 {name=p53 sig_type=std_logic lab=VDD
m=8}
C {lab_wire.sym} 1250 -1480 0 0 {name=p54 sig_type=std_logic lab=VDD
m=8}
C {lab_wire.sym} 1480 -1330 0 0 {name=p55 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 760 -1000 0 0 {name=p56 sig_type=std_logic lab=CLK
m=1}
C {lab_wire.sym} 1180 -1280 0 0 {name=p57 sig_type=std_logic lab=CLK}
C {lab_wire.sym} 760 -1430 0 0 {name=p58 sig_type=std_logic lab=CLK
m=8
W=0.88u}
C {ipin.sym} 520 -1280 0 0 {name=p59 lab=CLK}
C {ipin.sym} 970 -1430 0 0 {name=p60 lab=RST
m=8}
C {ipin.sym} 590 -1480 0 0 {name=p61 lab=VDD
m=8}
C {ipin.sym} 590 -1080 0 0 {name=p62 lab=GND
m=3}
C {lab_wire.sym} 720 -1280 0 0 {name=p63 sig_type=std_logic lab=A
m=3
W=0.88u}
C {lab_wire.sym} 1010 -1220 0 0 {name=p64 sig_type=std_logic lab=B
m=3}
C {lab_wire.sym} 1370 -1340 0 0 {name=p65 sig_type=std_logic lab=QB
m=3}
