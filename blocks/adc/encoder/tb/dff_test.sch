v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 1000 -2040 1800 -1640 {flags=graph
y1=-0.12
y2=3.4
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=5e-09
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="d

q"
color="12 13"
dataset=-1
unitx=1
logx=0
logy=0
}
B 2 1000 -2440 1800 -2040 {flags=graph
y1=0
y2=3.3
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=5e-09
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="clk
rst"
color="7 10"
dataset=-1
unitx=1
logx=0
logy=0
}
N 350 -1390 350 -1370 {lab=VDD}
N 345 -1340 360 -1340 {lab=VDD}
N 345 -1190 360 -1190 {lab=VDD}
N 580 -1390 580 -1370 {lab=VDD}
N 575 -1340 590 -1340 {lab=VDD}
N 580 -1240 580 -1220 {lab=#net1}
N 575 -1190 590 -1190 {lab=VDD}
N 800 -1390 800 -1370 {lab=VDD}
N 795 -1340 810 -1340 {lab=VDD}
N 350 -1010 350 -990 {lab=GND}
N 350 -1040 370 -1040 {lab=GND}
N 270 -1040 310 -1040 {lab=D}
N 350 -1160 350 -1070 {lab=#net2}
N 580 -1040 600 -1040 {lab=GND}
N 500 -1040 540 -1040 {lab=#net2}
N 1010 -1190 1030 -1190 {lab=GND}
N 930 -1190 970 -1190 {lab=CLK}
N 1010 -1010 1010 -990 {lab=GND}
N 1010 -1040 1030 -1040 {lab=GND}
N 930 -1040 970 -1040 {lab=#net3}
N 1240 -1010 1240 -990 {lab=GND}
N 1240 -1040 1260 -1040 {lab=GND}
N 1160 -1040 1200 -1040 {lab=#net4}
N 1240 -1240 1240 -1220 {lab=VDD}
N 1235 -1190 1250 -1190 {lab=VDD}
N 1010 -1390 1010 -1370 {lab=VDD}
N 1005 -1340 1020 -1340 {lab=VDD}
N 350 -1310 350 -1220 {lab=#net5}
N 270 -1340 310 -1340 {lab=D}
N 270 -1190 310 -1190 {lab=CLK}
N 200 -1040 270 -1040 {lab=D}
N 200 -1340 200 -1040 {lab=D}
N 200 -1340 270 -1340 {lab=D}
N 160 -1190 200 -1190 {lab=D}
N 350 -1110 470 -1110 {lab=#net2}
N 470 -1190 470 -1110 {lab=#net2}
N 470 -1190 540 -1190 {lab=#net2}
N 490 -1340 540 -1340 {lab=CLK}
N 720 -1340 760 -1340 {lab=RST}
N 580 -880 580 -860 {lab=GND}
N 580 -910 600 -910 {lab=GND}
N 500 -910 540 -910 {lab=CLK}
N 580 -1160 580 -1070 {lab=#net3}
N 580 -1310 580 -1240 {lab=#net1}
N 850 -1340 970 -1340 {lab=#net3}
N 850 -1340 850 -1040 {lab=#net3}
N 850 -1040 930 -1040 {lab=#net3}
N 800 -1310 800 -1250 {lab=#net3}
N 800 -1250 850 -1250 {lab=#net3}
N 580 -1130 850 -1130 {lab=#net3}
N 1160 -1190 1200 -1190 {lab=#net4}
N 1160 -1190 1160 -1040 {lab=#net4}
N 1240 -1160 1240 -1070 {lab=Q}
N 1240 -1110 1290 -1110 {lab=Q}
N 1010 -1310 1010 -1220 {lab=#net4}
N 1010 -1160 1010 -1070 {lab=#net6}
N 1010 -1250 1160 -1250 {lab=#net4}
N 1160 -1250 1160 -1180 {lab=#net4}
N 470 -1040 500 -1040 {lab=#net2}
N 470 -1110 470 -1040 {lab=#net2}
N 580 -1010 580 -940 {lab=#net7}
C {opin.sym} 1290 -1110 0 0 {name=p425 lab=Q}
C {code_shown.sym} 1555 -1405 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {code_shown.sym} 1575 -1235 0 0 {name=SPICE only_toplevel=false value="
V_VDD VDD 0 3.3

V_CLK CLK 0 pulse(0 3.3 0s 10p 10p 240p 500p)
V_D D 0 pwl(0 0 250p 0 260p 3.3 1.25n 3.3 1.26n 0 1.75n 0 1.76n 3.3 2.25n 3.3 2.26n 0 3.25n 0 3.26n 3.3 3.75n 3.3 3.76n 0 4.25n 0 4.26n 3.3 6n 3.3)
V_RST RST 0 pulse(3.3 3.3 0s 10p 10p 240p 500p)
.control
  save CLK D RST Q
  run
  write tspc_dff_rst_test.raw
.endc
.tran 1p 5n

"}
C {ipin.sym} 160 -1190 0 0 {name=p17 lab=D}
C {symbols/pfet_03v3.sym} 330 -1340 0 0 {name=M2
L=0.28u
W=0.22u
nf=1
m=10
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 355 -1340 0 0 {name=p3 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 330 -1190 0 0 {name=M3
L=0.28u
W=0.22u
nf=1
m=10
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 355 -1190 0 0 {name=p5 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 560 -1340 0 0 {name=M4
L=0.28u
W=0.22u
nf=1
m=10
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 585 -1340 0 0 {name=p4 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 560 -1190 0 0 {name=M5
L=0.28u
W=0.22u
nf=1
m=10
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 585 -1190 0 0 {name=p6 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 780 -1340 0 0 {name=M6
L=0.28u
W=0.22u
nf=1
m=10
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 805 -1340 0 0 {name=p7 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 330 -1040 0 0 {name=M11
L=0.28u
W=0.22u
nf=1
m=5
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 365 -1040 0 0 {name=p8 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 560 -1040 0 0 {name=M12
L=0.28u
W=0.22u
nf=1
m=5
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 595 -1040 0 0 {name=p10 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 990 -1190 0 0 {name=M13
L=0.28u
W=0.22u
nf=1
m=5
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 1025 -1190 0 0 {name=p12 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 990 -1040 0 0 {name=M14
L=0.28u
W=0.22u
nf=1
m=5
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 1025 -1040 0 0 {name=p24 sig_type=std_logic lab=GND}
C {lab_wire.sym} 1010 -990 0 0 {name=p25 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 1220 -1040 0 0 {name=M15
L=0.28u
W=0.22u
nf=1
m=5
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 1255 -1040 0 0 {name=p26 sig_type=std_logic lab=GND}
C {lab_wire.sym} 1240 -990 0 0 {name=p27 sig_type=std_logic lab=GND}
C {symbols/pfet_03v3.sym} 1220 -1190 0 0 {name=M16
L=0.28u
W=0.22u
nf=1
m=10
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 1245 -1190 0 0 {name=p28 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 990 -1340 0 0 {name=M17
L=0.28u
W=0.22u
nf=1
m=10
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 1015 -1340 0 0 {name=p29 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 560 -910 0 0 {name=M18
L=0.28u
W=0.22u
nf=1
m=5
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 595 -910 0 0 {name=p30 sig_type=std_logic lab=GND}
C {lab_wire.sym} 580 -860 0 0 {name=p31 sig_type=std_logic lab=GND}
C {lab_wire.sym} 580 -1390 0 0 {name=p14 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 800 -1390 0 0 {name=p32 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 1010 -1390 0 0 {name=p33 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 1240 -1240 0 0 {name=p34 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 520 -910 0 0 {name=p36 sig_type=std_logic lab=CLK}
C {lab_wire.sym} 940 -1190 0 0 {name=p37 sig_type=std_logic lab=CLK}
C {launcher.sym} 1070 -1600 0 0 {name=h5
descr="load waves"
tclcommand="xschem raw_read $netlist_dir/dff_test.raw tran"
}
C {lab_wire.sym} 520 -1340 0 0 {name=p2 sig_type=std_logic lab=CLK}
C {ipin.sym} 280 -1190 0 0 {name=p11 lab=CLK}
C {ipin.sym} 730 -1340 0 0 {name=p13 lab=RST}
C {ipin.sym} 350 -1390 0 0 {name=p1 lab=VDD}
C {ipin.sym} 350 -990 0 0 {name=p9 lab=GND}
