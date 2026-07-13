v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 1475 -985 2275 -585 {flags=graph
y1=1.6
y2=3.6
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=3.8816306e-10
x2=2.3881615e-09
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="a
b
c"
color="15 4 8"
dataset=-1
unitx=1
logx=0
logy=0
}
B 2 1480 -510 2280 -110 {flags=graph
y1=-0.12
y2=3.6
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=3.8816306e-10
x2=2.3881615e-09
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
color=8
node=out
}
N 1250 -1020 1250 -990 {lab=VDD}
N 1250 -930 1250 -910 {lab=GND}
N 1070 -535 1070 -455 {lab=#net1}
N 1070 -535 1140 -535 {lab=#net1}
N 1070 -455 1070 -385 {lab=#net1}
N 1070 -385 1140 -385 {lab=#net1}
N 1180 -505 1180 -415 {lab=out}
N 1180 -455 1290 -455 {lab=out}
N 1180 -355 1180 -335 {lab=GND}
N 1180 -585 1180 -565 {lab=VDD}
N 335 -495 335 -415 {lab=C}
N 335 -495 405 -495 {lab=C}
N 335 -415 335 -345 {lab=C}
N 335 -345 405 -345 {lab=C}
N 445 -465 445 -375 {lab=cbar}
N 445 -415 555 -415 {lab=cbar}
N 445 -315 445 -295 {lab=GND}
N 445 -545 445 -525 {lab=VDD}
N 295 -415 335 -415 {lab=C}
N 1175 -535 1190 -535 {lab=VDD}
N 1180 -385 1200 -385 {lab=GND}
N 440 -495 465 -495 {lab=VDD}
N 445 -345 460 -345 {lab=GND}
N 650 -600 650 -580 {lab=VDD}
N 645 -550 660 -550 {lab=VDD}
N 790 -600 790 -580 {lab=VDD}
N 785 -550 800 -550 {lab=VDD}
N 930 -600 930 -580 {lab=VDD}
N 925 -550 940 -550 {lab=VDD}
N 650 -520 650 -490 {lab=#net1}
N 650 -490 1050 -490 {lab=#net1}
N 790 -520 790 -490 {lab=#net1}
N 930 -520 930 -490 {lab=#net1}
N 810 -355 810 -335 {lab=#net2}
N 810 -385 825 -385 {lab=GND}
N 810 -255 810 -235 {lab=#net3}
N 810 -285 825 -285 {lab=GND}
N 810 -155 810 -135 {lab=GND}
N 810 -185 825 -185 {lab=GND}
N 810 -490 810 -410 {lab=#net1}
N 745 -385 770 -385 {lab=a}
N 750 -285 770 -285 {lab=b}
N 755 -185 770 -185 {lab=cbar}
N 590 -550 610 -550 {lab=a}
N 730 -550 750 -550 {lab=b}
N 875 -550 890 -550 {lab=cbar}
N 1045 -490 1070 -490 {lab=#net1}
N 810 -335 810 -310 {lab=#net2}
N 810 -235 810 -215 {lab=#net3}
C {lab_wire.sym} 1180 -585 0 0 {name=p5 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 445 -535 0 0 {name=p6 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 1180 -345 0 0 {name=p7 sig_type=std_logic lab=GND}
C {lab_wire.sym} 445 -300 0 0 {name=p8 sig_type=std_logic lab=GND}
C {lab_wire.sym} 760 -185 0 0 {name=p10 sig_type=std_logic lab=cbar}
C {lab_wire.sym} 515 -415 1 0 {name=p12 sig_type=std_logic lab=cbar}
C {code_shown.sym} 130 -885 0 0 {name=SPICE only_toplevel=false value="
VA A 0 PULSE(0 3.3 250p 10p 10p 240p 500p)
VB B 0 PULSE(0 3.3 500p 10p 10p 490p 1n)
VC C 0 PULSE(0 3.3 1n 10p 10p 990p 2n)
.tran 1p 2n
.control
run

write nand.raw
.endc
"
}
C {code_shown.sym} 580 -885 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {vsource.sym} 1250 -960 0 0 {name=V1 value=3.3 savecurrent=false}
C {vdd.sym} 1250 -1020 0 0 {name=l3 lab=VDD}
C {gnd.sym} 1250 -910 0 1 {name=l4 lab=GND
}
C {ipin.sym} 590 -550 0 0 {name=p21 lab=a}
C {opin.sym} 1285 -455 0 0 {name=p22 lab=out}
C {ipin.sym} 295 -415 0 0 {name=p9 lab=C}
C {symbols/pfet_03v3.sym} 1160 -535 0 0 {name=M5
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
C {symbols/nfet_03v3.sym} 1160 -385 0 0 {name=M6
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
C {symbols/pfet_03v3.sym} 425 -495 0 0 {name=M7
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
C {symbols/nfet_03v3.sym} 425 -345 0 0 {name=M8
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
C {lab_wire.sym} 460 -495 0 0 {name=p11 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 1185 -535 0 0 {name=p17 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 1195 -385 0 0 {name=p23 sig_type=std_logic lab=GND}
C {lab_wire.sym} 455 -345 0 0 {name=p24 sig_type=std_logic lab=GND}
C {lab_wire.sym} 650 -600 0 0 {name=p33 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 630 -550 0 0 {name=M13
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
C {lab_wire.sym} 655 -550 0 0 {name=p34 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 790 -600 0 0 {name=p35 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 770 -550 0 0 {name=M14
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
C {lab_wire.sym} 795 -550 0 0 {name=p36 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 930 -600 0 0 {name=p37 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 910 -550 0 0 {name=M15
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
C {lab_wire.sym} 935 -550 0 0 {name=p38 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 790 -385 0 0 {name=M16
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
C {lab_wire.sym} 820 -385 0 0 {name=p40 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 790 -285 0 0 {name=M17
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
C {lab_wire.sym} 820 -285 0 0 {name=p42 sig_type=std_logic lab=GND}
C {lab_wire.sym} 810 -140 0 0 {name=p43 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 790 -185 0 0 {name=M18
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
C {lab_wire.sym} 820 -185 0 0 {name=p44 sig_type=std_logic lab=GND}
C {lab_wire.sym} 880 -550 0 0 {name=p45 sig_type=std_logic lab=cbar}
C {ipin.sym} 740 -550 0 0 {name=p46 lab=b}
C {launcher.sym} 1555 -550 0 0 {name=h5
descr="load waves"
tclcommand="xschem raw_read $netlist_dir/NAND3.raw tran"
}
C {lab_wire.sym} 750 -385 0 0 {name=p1 sig_type=std_logic lab=a}
C {lab_wire.sym} 750 -285 0 0 {name=p2 sig_type=std_logic lab=b}
