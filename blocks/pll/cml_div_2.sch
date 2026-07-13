v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 0 370 10 370 {lab=GND}
N 10 370 10 400 {lab=GND}
N 0 400 10 400 {lab=GND}
N -300 -110 -300 -10 {lab=o1}
N -90 -110 -90 -10 {lab=o2}
N -300 80 -90 80 {lab=#net1}
N -90 50 -90 80 {lab=#net1}
N -200 80 -200 130 {lab=#net1}
N 100 50 100 80 {lab=#net2}
N 100 80 300 80 {lab=#net2}
N 300 50 300 80 {lab=#net2}
N 200 80 200 130 {lab=#net2}
N 140 20 160 20 {lab=o2}
N 240 20 260 20 {lab=o1}
N 160 20 240 -30 {lab=o2}
N 160 -30 240 20 {lab=o1}
N 100 -30 160 -30 {lab=o1}
N 100 -25 100 -10 {lab=o1}
N 100 -30 100 -25 {lab=o1}
N 300 -30 300 -10 {lab=o2}
N 0 230 200 230 {lab=#net3}
N 200 190 200 230 {lab=#net3}
N -200 230 0 230 {lab=#net3}
N -200 190 -200 230 {lab=#net3}
N -300 -40 100 -40 {lab=o1}
N 100 -40 100 -30 {lab=o1}
N 300 -60 300 -30 {lab=o2}
N -190 370 -180 370 {lab=GND}
N -190 370 -190 400 {lab=GND}
N -190 400 -180 400 {lab=GND}
N -140 370 -40 370 {lab=IREF}
N -90 -190 445 -190 {lab=VDD}
N 445 -190 570 -190 {lab=VDD}
N -360 20 -340 20 {lab=o3}
N -50 20 -30 20 {lab=o4}
N -180 320 840 320 {lab=IREF}
N 140 160 200 160 {lab=GND}
N -200 160 -140 160 {lab=GND}
N -430 -190 -90 -190 {lab=VDD}
N -300 50 -300 80 {lab=#net1}
N -300 20 -240 20 {lab=GND}
N 240 -30 300 -30 {lab=o2}
N -90 -60 300 -60 {lab=o2}
N -280 160 -240 160 {lab=i1}
N 570 -110 570 -10 {lab=o3}
N 780 -110 780 -10 {lab=o4}
N 780 -190 780 -170 {lab=VDD}
N 570 80 780 80 {lab=#net4}
N 780 50 780 80 {lab=#net4}
N 670 80 670 130 {lab=#net4}
N 970 50 970 80 {lab=#net5}
N 970 80 1170 80 {lab=#net5}
N 1170 50 1170 80 {lab=#net5}
N 1070 80 1070 130 {lab=#net5}
N 1010 20 1030 20 {lab=o4}
N 1110 20 1130 20 {lab=o3}
N 1030 20 1110 -30 {lab=o4}
N 1030 -30 1110 20 {lab=o3}
N 970 -30 1030 -30 {lab=o3}
N 970 -25 970 -10 {lab=o3}
N 970 -30 970 -25 {lab=o3}
N 1170 -30 1170 -10 {lab=o4}
N 870 230 1070 230 {lab=#net6}
N 1070 190 1070 230 {lab=#net6}
N 670 230 870 230 {lab=#net6}
N 670 190 670 230 {lab=#net6}
N 570 -40 970 -40 {lab=o3}
N 970 -40 970 -30 {lab=o3}
N 1170 -60 1170 -30 {lab=o4}
N 510 20 530 20 {lab=o2}
N 820 20 840 20 {lab=o1}
N 1010 160 1070 160 {lab=GND}
N 670 160 730 160 {lab=GND}
N 570 -190 570 -170 {lab=VDD}
N 570 50 570 80 {lab=#net4}
N 570 20 630 20 {lab=GND}
N 1110 -30 1170 -30 {lab=o4}
N 780 -60 1170 -60 {lab=o4}
N 570 -190 780 -190 {lab=VDD}
N 0 230 0 340 {lab=#net3}
N -180 320 -180 340 {lab=IREF}
N 880 320 890 320 {lab=GND}
N 890 320 890 350 {lab=GND}
N 880 350 890 350 {lab=GND}
N 880 230 880 290 {lab=#net6}
N -140 320 -140 370 {lab=IREF}
N 240 160 280 160 {lab=i2}
N -90 -190 -90 -170 {lab=VDD}
N -300 -190 -300 -170 {lab=VDD}
C {symbols/nfet_03v3.sym} -320 20 0 0 {name=M1
L=0.28u
W=1.44u
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} -70 20 0 1 {name=M2
L=0.28u
W=1.44u
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} -20 370 0 0 {name=M4
L=0.28u
W=3.66u
nf=6
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
m=1}
C {lab_pin.sym} -240 20 0 1 {name=p6 lab=GND}
C {lab_pin.sym} -90 20 0 0 {name=p7 lab=GND}
C {lab_pin.sym} 0 400 0 0 {name=p8 lab=GND}
C {symbols/nfet_03v3.sym} -220 160 0 0 {name=M6
L=0.28u
W=4.5u
nf=3
mult=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_pin.sym} -140 160 0 1 {name=p9 lab=GND}
C {symbols/nfet_03v3.sym} 120 20 0 1 {name=M7
L=0.28u
W=1.44u
nf=2
mult=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 280 20 0 0 {name=M8
L=0.28u
W=1.44u
nf=2
mult=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 100 20 0 0 {name=p10 lab=GND}
C {lab_pin.sym} 300 20 0 1 {name=p19 lab=GND}
C {symbols/nfet_03v3.sym} 220 160 0 1 {name=M11
L=0.28u
W=4.5u
nf=3
mult=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 140 160 0 0 {name=p20 lab=GND}
C {symbols/nfet_03v3.sym} -160 370 0 1 {name=M9
L=0.28u
W=0.61u
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_pin.sym} -180 400 0 1 {name=p21 lab=GND}
C {devices/code_shown.sym} -255 -595 0 0 {name=MODELS only_toplevel=true lvs_ignore=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
"}
C {devices/code_shown.sym} -220 -395 0 0 {name=NGSPICE only_toplevel=true lvs_ignore=true
value="V_VDD   VDD     0 DC 3.3
V_VinP   i1     0 PULSE(1.94 2.68 0 104p 180p 106p 400p)
V_VinN   i2     0 PULSE(2.68 1.94 0 104p 180p 106p 400p)
*V_VinP   i1     0 SIN(0.85 0.45 2G 0 0 0)
*V_VinN   i2     0 SIN(0.85 0.45 2G 0 0 180)

.control
save all
tran 10p 350n
write my_test_1.raw
plot i1 o1 xlimit 100n 103n
.endc
"}
C {lab_pin.sym} -360 20 0 0 {name=p11 sig_type=std_logic lab=o3
}
C {lab_pin.sym} -30 20 2 0 {name=p12 sig_type=std_logic lab=o4}
C {symbols/nfet_03v3.sym} 550 20 0 0 {name=M20
L=0.28u
W=1.44u
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 800 20 0 1 {name=M21
L=0.28u
W=1.44u
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 630 20 0 1 {name=p25 lab=GND}
C {lab_pin.sym} 780 20 0 0 {name=p26 lab=GND}
C {symbols/nfet_03v3.sym} 650 160 0 0 {name=M25
L=0.28u
W=4.5u
nf=3
mult=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 730 160 0 1 {name=p27 lab=GND}
C {symbols/nfet_03v3.sym} 990 20 0 1 {name=M26
L=0.28u
W=1.44u
nf=2
mult=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 1150 20 0 0 {name=M27
L=0.28u
W=1.44u
nf=2
mult=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 970 20 0 0 {name=p28 lab=GND}
C {lab_pin.sym} 1170 20 0 1 {name=p29 lab=GND}
C {symbols/nfet_03v3.sym} 1090 160 0 1 {name=M28
L=0.28u
W=4.5u
nf=3
mult=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 1010 160 0 0 {name=p30 lab=GND}
C {lab_pin.sym} 630 160 0 0 {name=p13 sig_type=std_logic lab=i2}
C {lab_pin.sym} 570 -80 0 0 {name=p14 sig_type=std_logic lab=o3}
C {lab_pin.sym} 780 -80 0 0 {name=p15 sig_type=std_logic lab=o4}
C {lab_pin.sym} 510 20 0 0 {name=p16 sig_type=std_logic lab=o2
}
C {lab_pin.sym} 840 20 2 0 {name=p17 sig_type=std_logic lab=o1}
C {lab_pin.sym} 1110 160 0 1 {name=p18 sig_type=std_logic lab=i1}
C {symbols/nfet_03v3.sym} 860 320 0 0 {name=M10
L=0.28u
W=3.66u
nf=6
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
m=1}
C {lab_pin.sym} 880 350 0 0 {name=p31 lab=GND}
C {ipin.sym} 280 160 2 0 {name=p2 lab=i2}
C {ipin.sym} -280 160 0 0 {name=p1 lab=i1}
C {opin.sym} -90 -80 0 0 {name=p5 lab=o2}
C {opin.sym} -300 -80 0 1 {name=p3 lab=o1}
C {iopin.sym} -430 -190 0 1 {name=p4 lab=VDD}
C {iopin.sym} -430 -160 0 1 {name=p32 lab=GND}
C {ipin.sym} -180 320 0 0 {name=p22 lab=IREF}
C {isource.sym} -180 290 0 0 {name=I0 value=20u spice_ignore=false lvs_ignore=true only_toplevel=true}
C {lab_pin.sym} -180 260 0 1 {name=p33 lab=GND}
C {gnd.sym} 0 400 0 0 {name=l1 lab=GND}
C {symbols/ppolyf_u_1k.sym} 780 -140 0 0 {name=R1
W=1e-6
L=15e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} 760 -140 0 0 {name=p23 lab=GND}
C {symbols/ppolyf_u_1k.sym} 570 -140 0 1 {name=R2
W=1e-6
L=15e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} 590 -140 0 1 {name=p24 lab=GND}
C {symbols/ppolyf_u_1k.sym} -90 -140 0 0 {name=R3
W=1e-6
L=15e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} -110 -140 0 0 {name=p34 lab=GND}
C {symbols/ppolyf_u_1k.sym} -300 -140 0 1 {name=R4
W=1e-6
L=15e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} -280 -140 0 1 {name=p35 lab=GND}
C {capa-2.sym} -330 -90 1 0 {name=C1
m=1
value=13.2f
footprint=1206
device=polarized_capacitor
only_toplevel=true
spice_ignore=false
lvs_ignore=true}
C {capa-2.sym} -60 -90 3 0 {name=C2
m=1
value=13.2f
footprint=1206
device=polarized_capacitor
only_toplevel=true
spice_ignore=false
lvs_ignore=true}
C {lab_pin.sym} -360 -90 0 0 {name=p36 lab=GND}
C {lab_pin.sym} -30 -90 0 1 {name=p37 lab=GND}
