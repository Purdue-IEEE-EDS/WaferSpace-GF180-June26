v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 470 -1490 470 -1470 {lab=VDD}
N 465 -1440 480 -1440 {lab=VDD}
N 465 -1290 480 -1290 {lab=VDD}
N 700 -1490 700 -1470 {lab=VDD}
N 695 -1440 710 -1440 {lab=VDD}
N 1220 -1610 1220 -1590 {lab=VDD}
N 1215 -1560 1230 -1560 {lab=VDD}
N 470 -1110 470 -1090 {lab=GND}
N 470 -1140 490 -1140 {lab=GND}
N 390 -1140 430 -1140 {lab=D}
N 470 -1260 470 -1170 {lab=#net1}
N 700 -1140 720 -1140 {lab=GND}
N 620 -1140 660 -1140 {lab=#net1}
N 1130 -1290 1150 -1290 {lab=GND}
N 1050 -1290 1090 -1290 {lab=CLK}
N 1130 -1110 1130 -1090 {lab=GND}
N 1130 -1140 1150 -1140 {lab=GND}
N 1050 -1140 1090 -1140 {lab=#net2}
N 1360 -1110 1360 -1090 {lab=GND}
N 1360 -1140 1380 -1140 {lab=GND}
N 1280 -1140 1320 -1140 {lab=#net3}
N 1360 -1340 1360 -1320 {lab=VDD}
N 1355 -1290 1370 -1290 {lab=VDD}
N 1130 -1490 1130 -1470 {lab=VDD}
N 1125 -1440 1140 -1440 {lab=VDD}
N 470 -1410 470 -1320 {lab=#net4}
N 390 -1440 430 -1440 {lab=D}
N 390 -1290 430 -1290 {lab=CLK}
N 320 -1140 390 -1140 {lab=D}
N 320 -1440 320 -1140 {lab=D}
N 320 -1440 390 -1440 {lab=D}
N 280 -1290 320 -1290 {lab=D}
N 470 -1210 590 -1210 {lab=#net1}
N 610 -1440 660 -1440 {lab=CLK}
N 1140 -1560 1180 -1560 {lab=RST}
N 700 -980 700 -960 {lab=GND}
N 700 -1010 720 -1010 {lab=GND}
N 620 -1010 660 -1010 {lab=CLK}
N 970 -1440 1090 -1440 {lab=#net2}
N 970 -1440 970 -1140 {lab=#net2}
N 970 -1140 1050 -1140 {lab=#net2}
N 1220 -1530 1220 -1470 {lab=#net3}
N 700 -1230 970 -1230 {lab=#net2}
N 1280 -1290 1320 -1290 {lab=#net3}
N 1280 -1290 1280 -1140 {lab=#net3}
N 1360 -1260 1360 -1170 {lab=Q}
N 1360 -1210 1410 -1210 {lab=Q}
N 1130 -1410 1130 -1320 {lab=#net3}
N 1130 -1260 1130 -1170 {lab=#net5}
N 1130 -1350 1280 -1350 {lab=#net3}
N 1280 -1350 1280 -1280 {lab=#net3}
N 590 -1140 620 -1140 {lab=#net1}
N 590 -1210 590 -1140 {lab=#net1}
N 700 -1110 700 -1040 {lab=#net6}
N 1220 -1470 1220 -1350 {lab=#net3}
N 700 -1410 700 -1170 {lab=#net2}
C {opin.sym} 1410 -1210 0 0 {name=p425 lab=Q}
C {code_shown.sym} 1575 -925 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {code_shown.sym} 1595 -755 0 0 {name=SPICE only_toplevel=false value="
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
C {ipin.sym} 280 -1290 0 0 {name=p17 lab=D}
C {symbols/pfet_03v3.sym} 450 -1440 0 0 {name=M2
L=0.28u
W=0.22u
nf=1
m=35
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 475 -1440 0 0 {name=p3 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 450 -1290 0 0 {name=M3
L=0.28u
W=0.22u
nf=1
m=35
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 475 -1290 0 0 {name=p5 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 680 -1440 0 0 {name=M4
L=0.28u
W=0.22u
nf=1
m=35
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 705 -1440 0 0 {name=p4 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1200 -1560 0 0 {name=M6
L=0.28u
W=0.22u
nf=1
m=35
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 1225 -1560 0 0 {name=p7 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 450 -1140 0 0 {name=M11
L=0.28u
W=0.22u
nf=1
m=17
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 485 -1140 0 0 {name=p8 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 680 -1140 0 0 {name=M12
L=0.28u
W=0.22u
nf=1
m=17
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 715 -1140 0 0 {name=p10 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 1110 -1290 0 0 {name=M13
L=0.28u
W=0.22u
nf=1
m=17
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 1145 -1290 0 0 {name=p12 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 1110 -1140 0 0 {name=M14
L=0.28u
W=0.22u
nf=1
m=17
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 1145 -1140 0 0 {name=p24 sig_type=std_logic lab=GND}
C {lab_wire.sym} 1130 -1090 0 0 {name=p25 sig_type=std_logic lab=GND}
C {symbols/nfet_03v3.sym} 1340 -1140 0 0 {name=M15
L=0.28u
W=0.22u
nf=1
m=17
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 1375 -1140 0 0 {name=p26 sig_type=std_logic lab=GND}
C {lab_wire.sym} 1360 -1090 0 0 {name=p27 sig_type=std_logic lab=GND}
C {symbols/pfet_03v3.sym} 1340 -1290 0 0 {name=M16
L=0.28u
W=0.22u
nf=1
m=35
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 1365 -1290 0 0 {name=p28 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1110 -1440 0 0 {name=M17
L=0.28u
W=0.22u
nf=1
m=35
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 1135 -1440 0 0 {name=p29 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 680 -1010 0 0 {name=M18
L=0.28u
W=0.22u
nf=1
m=17
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 715 -1010 0 0 {name=p30 sig_type=std_logic lab=GND}
C {lab_wire.sym} 700 -960 0 0 {name=p31 sig_type=std_logic lab=GND}
C {lab_wire.sym} 700 -1490 0 0 {name=p14 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 1220 -1610 0 0 {name=p32 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 1130 -1490 0 0 {name=p33 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 1360 -1340 0 0 {name=p34 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 640 -1010 0 0 {name=p36 sig_type=std_logic lab=CLK}
C {lab_wire.sym} 1060 -1290 0 0 {name=p37 sig_type=std_logic lab=CLK}
C {lab_wire.sym} 640 -1440 0 0 {name=p2 sig_type=std_logic lab=CLK}
C {ipin.sym} 400 -1290 0 0 {name=p11 lab=CLK}
C {ipin.sym} 1150 -1560 0 0 {name=p13 lab=RST}
C {ipin.sym} 470 -1490 0 0 {name=p1 lab=VDD}
C {ipin.sym} 470 -1090 0 0 {name=p9 lab=GND}
