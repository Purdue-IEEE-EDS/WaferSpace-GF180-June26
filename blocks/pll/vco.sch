v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 1250 -90 1250 -70 {lab=Vn}
N 960 -90 960 -70 {lab=Vp}
N 1210 -100 1210 90 {lab=Vp}
N 960 -100 1210 -100 {lab=Vp}
N 1000 -40 1040 -40 {lab=Vn}
N 1040 -120 1040 -40 {lab=Vn}
N 1040 -120 1250 -120 {lab=Vn}
N 1090 -200 1190 -200 {lab=#net1}
N 1090 -730 1330 -730 {lab=VDD}
N 1090 -750 1090 -730 {lab=VDD}
N 900 -40 960 -40 {lab=GND}
N 1250 -40 1310 -40 {lab=GND}
N 1000 -40 1000 90 {lab=Vn}
N 960 20 960 60 {lab=#net2}
N 730 -90 730 -70 {lab=Vp}
N 730 -90 960 -90 {lab=Vp}
N 730 20 730 60 {lab=#net2}
N 730 120 960 120 {lab=GND}
N 900 90 960 90 {lab=GND}
N 1250 90 1310 90 {lab=GND}
N 1250 20 1250 60 {lab=#net3}
N 730 20 960 20 {lab=#net2}
N 1400 -90 1400 -70 {lab=Vn}
N 1400 20 1400 60 {lab=#net3}
N 1250 -90 1400 -90 {lab=Vn}
N 1250 120 1400 120 {lab=GND}
N 1090 -230 1090 -200 {lab=#net1}
N 1090 -310 1090 -290 {lab=Vctrl}
N 1250 20 1400 20 {lab=#net3}
N 960 -590 960 -140 {lab=Vp}
N 1250 -590 1250 -145 {lab=Vn}
N 870 -700 960 -700 {lab=VDD}
N 870 -730 870 -700 {lab=VDD}
N 870 -730 1090 -730 {lab=VDD}
N 1250 -700 1330 -700 {lab=VDD}
N 1330 -730 1330 -700 {lab=VDD}
N 1000 -700 1250 -630 {lab=Vn}
N 960 -640 1210 -700 {lab=Vp}
N 960 -610 1030 -610 {lab=Vp}
N 960 -140 960 -100 {lab=Vp}
N 1250 -145 1250 -120 {lab=Vn}
N 960 -100 960 -90 {lab=Vp}
N 730 -10 730 20 {lab=#net2}
N 960 -10 960 20 {lab=#net2}
N 1250 -120 1250 -90 {lab=Vn}
N 1020 -200 1090 -200 {lab=#net1}
N 1250 -10 1250 20 {lab=#net3}
N 1400 -10 1400 20 {lab=#net3}
N 1250 -670 1250 -630 {lab=Vn}
N 960 -670 960 -640 {lab=Vp}
N 960 -640 960 -590 {lab=Vp}
N 1250 -630 1250 -590 {lab=Vn}
N 980 -170 990 -170 {lab=Vp}
N 980 -200 990 -200 {lab=Vp}
N 980 -200 980 -170 {lab=Vp}
N 980 -230 980 -200 {lab=Vp}
N 980 -230 990 -230 {lab=Vp}
N 960 -200 980 -200 {lab=Vp}
N 1230 -230 1240 -230 {lab=Vn}
N 1230 -200 1240 -200 {lab=Vn}
N 1240 -230 1240 -200 {lab=Vn}
N 1230 -170 1240 -170 {lab=Vn}
N 1240 -200 1240 -170 {lab=Vn}
N 1240 -200 1250 -200 {lab=Vn}
N 1090 -610 1130 -610 {lab=Vn}
N 1190 -610 1250 -610 {lab=Vn}
N 1130 -610 1190 -610 {lab=Vn}
N 820 -310 820 -290 {lab=GND}
N 820 -390 820 -370 {lab=Vnb}
N 710 -380 820 -380 {lab=Vnb}
N 760 -420 820 -420 {lab=GND}
N 860 -420 960 -420 {lab=Vp}
N 820 -730 820 -450 {lab=VDD}
N 820 -730 870 -730 {lab=VDD}
N 1250 -380 1310 -380 {lab=Vn}
N 1350 -270 1350 -250 {lab=GND}
N 1350 -350 1350 -330 {lab=Vpb}
N 1350 -340 1460 -340 {lab=Vpb}
N 1350 -710 1350 -410 {lab=VDD}
N 1350 -380 1410 -380 {lab=GND}
N 1330 -730 1350 -730 {lab=VDD}
N 1350 -730 1350 -710 {lab=VDD}
N 960 120 1250 120 {lab=GND}
C {gnd.sym} 900 -40 0 0 {name=l6 lab=GND}
C {gnd.sym} 1310 -40 0 0 {name=l7 lab=GND}
C {devices/code_shown.sym} 290 -1060 0 0 {name=MODELS only_toplevel=true lvs_ignore=true
format="tcleval( @value )"
value=".include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice ss
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
* .lib $::180MCU_MODELS/sm141064.ngspice res_statistical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
"}
C {symbols/nfet_03v3.sym} 1230 -40 0 0 {name=M1
L=0.28u
W=40u
nf=10
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
C {symbols/nfet_03v3.sym} 980 -40 0 1 {name=M2
L=0.28u
W=40u
nf=10
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
C {symbols/nfet_03v3.sym} 980 90 0 1 {name=M3
L=0.28u
W=15u
nf=3
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
C {gnd.sym} 900 90 0 0 {name=l2 lab=GND}
C {gnd.sym} 1310 90 0 0 {name=l3 lab=GND}
C {symbols/nfet_03v3.sym} 1230 90 0 0 {name=M4
L=0.28u
W=15u
nf=3
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
C {symbols/pplus_u.sym} 1090 -260 0 0 {name=R1
W=5e-6
L=20e-6
model=pplus_u
spiceprefix=X
m=1}
C {gnd.sym} 1070 -260 0 0 {name=l5 lab=GND}
C {symbols/pfet_03v3.sym} 1230 -700 0 0 {name=M5
L=0.28u
W=40u
nf=10
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
C {symbols/pfet_03v3.sym} 980 -700 0 1 {name=M6
L=0.28u
W=40u
nf=10
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
C {ind.sym} 1060 -610 1 0 {name=L9
m=1
value=340p
footprint=1206
device=inductor
lvs_ignore=true}
C {symbols/nfet_03v3.sym} 1010 -200 0 1 {name=M7
L=20u
W=44u
nf=2
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 1210 -200 2 1 {name=M8
L=20u
W=44u
nf=2
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 840 -420 0 1 {name=M9
L=0.28u
W=29.995u
nf=7
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
C {symbols/pplus_u.sym} 820 -340 2 1 {name=R3
W=5e-6
L=20e-6
model=pplus_u
spiceprefix=X
m=1}
C {gnd.sym} 800 -340 0 0 {name=l10 lab=GND}
C {gnd.sym} 820 -290 0 0 {name=l11 lab=GND}
C {gnd.sym} 760 -420 0 0 {name=l14 lab=GND}
C {symbols/nfet_03v3.sym} 1330 -380 0 0 {name=M10
L=0.28u
W=29.995u
nf=7
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
C {symbols/pplus_u.sym} 1350 -300 2 0 {name=R4
W=5e-6
L=20e-6
model=pplus_u
spiceprefix=X
m=1}
C {gnd.sym} 1370 -300 0 1 {name=l12 lab=GND}
C {gnd.sym} 1350 -250 0 1 {name=l13 lab=GND}
C {gnd.sym} 1410 -380 0 0 {name=l15 lab=GND}
C {devices/code_shown.sym} -25 -1065 0 0 {name=NGSPICE only_toplevel=true lvs_ignore=true
value="VDD vdd 0 dc 3.3
Vctrl vctrl 0 dc 0.1
.control
save all
tran 10ps 350ns
plot v(vp) v(vn)
plot v(vpb) v(vnb)
linearize v(vp) v(vpb)
set specwindow=blackman
fft v(vp) v(vpb)
plot mag(v(vp)) mag(v(vpb))
write VCO_GF180.raw
.endc
"}
C {iopin.sym} 1090 -750 0 1 {name=p2 lab=VDD}
C {iopin.sym} 1110 120 3 1 {name=p7 lab=GND}
C {ipin.sym} 1090 -310 0 0 {name=p1 lab=Vctrl}
C {opin.sym} 1460 -340 0 0 {name=p5 lab=Vpb}
C {opin.sym} 710 -380 0 1 {name=p6 lab=Vnb}
C {symbols/cap_mim_analog.sym} 1400 -40 2 1 {name=C5
W=5e-6
L=5e-6
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {symbols/cap_mim_analog.sym} 1400 90 0 0 {name=C2
W=5e-6
L=5e-6
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {symbols/cap_mim_analog.sym} 730 90 0 1 {name=C3
W=5e-6
L=5e-6
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {symbols/cap_mim_analog.sym} 730 -40 2 0 {name=C1
W=5e-6
L=5e-6
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {lab_wire.sym} 960 -140 0 0 {name=p3 sig_type=std_logic lab=Vp}
C {lab_wire.sym} 1250 -140 0 1 {name=p4 sig_type=std_logic lab=Vn}
