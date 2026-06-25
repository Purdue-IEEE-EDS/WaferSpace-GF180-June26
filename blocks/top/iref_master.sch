v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -293.75 -190 -263.75 -190 {lab=#net1}
N -333.75 -160 -333.75 -145 {lab=#net1}
N -333.75 -250 -333.75 -220 {lab=VP_CAS}
N -333.75 -145 -333.75 -125 {lab=#net1}
N -103.75 -190 -73.75 -190 {lab=#net1}
N -143.75 -160 -143.75 -85 {lab=VN_MIRR}
N -143.75 -265 -143.75 -220 {lab=#net2}
N -143.75 -85 -143.75 -60 {lab=VN_MIRR}
N -143.75 -60 -143.75 -40 {lab=VN_MIRR}
N -103.75 -10 -88.75 -10 {lab=VN_MIRR}
N 41.25 -190 66.25 -190 {lab=#net1}
N 1.25 -160 1.25 -60 {lab=VN_CAS}
N 1.25 -265 1.25 -220 {lab=#net3}
N 1.25 -60 1.25 -40 {lab=VN_CAS}
N 1.25 -60 86.25 -60 {lab=VN_CAS}
N 41.25 100 86.25 100 {lab=VN_CAS}
N 41.25 -10 61.25 -10 {lab=VN_MIRR}
N -103.75 -295 -73.75 -295 {lab=VP_CAS}
N 41.25 -295 66.25 -295 {lab=VP_CAS}
N -333.75 -390 -333.75 -325 {lab=Vdd}
N -143.75 -390 -143.75 -325 {lab=Vdd}
N -293.75 -295 -263.75 -295 {lab=VP_CAS}
N 1.25 20 1.25 70 {lab=#net4}
N 1.25 -390 1.25 -325 {lab=Vdd}
N -143.75 -60 -88.75 -60 {lab=VN_MIRR}
N -143.75 20 -143.75 45 {lab=0}
N 61.25 -85 61.25 -10 {lab=VN_MIRR}
N -143.75 -85 61.25 -85 {lab=VN_MIRR}
N -88.75 -60 -88.75 -10 {lab=VN_MIRR}
N -143.75 -390 1.25 -390 {lab=Vdd}
N 1.25 130 1.25 160 {lab=0}
N -263.75 -295 -263.75 -250 {lab=VP_CAS}
N -73.75 -295 -73.75 -250 {lab=VP_CAS}
N 66.25 -295 66.25 -250 {lab=VP_CAS}
N -73.75 -250 66.25 -250 {lab=VP_CAS}
N 66.25 -190 66.25 -145 {lab=#net1}
N -263.75 -190 -263.75 -145 {lab=#net1}
N -333.75 -145 -263.75 -145 {lab=#net1}
N -333.75 -250 -263.75 -250 {lab=VP_CAS}
N -73.75 -190 -73.75 -145 {lab=#net1}
N -263.75 -145 -73.75 -145 {lab=#net1}
N 86.25 -60 86.25 100 {lab=VN_CAS}
N -333.75 -390 -143.75 -390 {lab=Vdd}
N -263.75 -250 -73.75 -250 {lab=VP_CAS}
N -333.75 -265 -333.75 -250 {lab=VP_CAS}
N -73.75 -145 66.25 -145 {lab=#net1}
N -333.75 -126.25 -333.75 -110 {lab=#net1}
N 301.25 -88.75 301.25 -68.75 {lab=IREF_ADC}
N 301.25 -8.75 301.25 41.25 {lab=#net5}
N 301.25 101.25 301.25 131.25 {lab=0}
N 301.25 -108.75 301.25 -88.75 {lab=IREF_ADC}
N 561.25 -86.25 561.25 -66.25 {lab=IREF_DAC}
N 561.25 -6.25 561.25 43.75 {lab=#net6}
N 561.25 103.75 561.25 133.75 {lab=0}
N 561.25 -106.25 561.25 -86.25 {lab=IREF_DAC}
N 813.75 -83.75 813.75 -63.75 {lab=IREF_LVDS}
N 813.75 -3.75 813.75 46.25 {lab=#net7}
N 813.75 106.25 813.75 136.25 {lab=0}
N 813.75 -103.75 813.75 -83.75 {lab=IREF_LVDS}
N 1076.25 -83.75 1076.25 -63.75 {lab=IREF_PLL}
N 1076.25 -3.75 1076.25 46.25 {lab=#net8}
N 1076.25 106.25 1076.25 136.25 {lab=0}
N 1076.25 -103.75 1076.25 -83.75 {lab=IREF_PLL}
C {symbols/pfet_03v3.sym} -313.75 -295 0 1 {name=M1
L=\{refL\}
W=\{refW\}
nf=20
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
C {symbols/pfet_03v3.sym} -313.75 -190 0 1 {name=M2
L=\{refL\}
W=\{refW\}
nf=20
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
C {lab_pin.sym} -333.75 -190 0 0 {name=p1 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -333.75 -295 0 0 {name=p2 sig_type=std_logic lab=Vdd}
C {symbols/pfet_03v3.sym} -123.75 -295 0 1 {name=M3
L=\{refL\}
W=\{refW\}
nf=20
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
C {symbols/pfet_03v3.sym} -123.75 -190 0 1 {name=M21
L=\{refL\}
W=\{refW\}
nf=20
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
C {lab_pin.sym} -143.75 -190 0 0 {name=p3 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -143.75 -295 0 0 {name=p4 sig_type=std_logic lab=Vdd}
C {gnd.sym} -143.75 40 0 1 {name=l1 lab=0}
C {gnd.sym} -143.75 -10 1 1 {name=l7 lab=0}
C {symbols/nfet_03v3.sym} -123.75 -10 0 1 {name=M22
L=\{refL*4\}
W=\{refW\}
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
C {lab_pin.sym} -333.75 -390 1 0 {name=p5 sig_type=std_logic lab=Vdd}
C {symbols/pfet_03v3.sym} 21.25 -295 0 1 {name=M23
L=\{refL\}
W=\{refW\}
nf=20
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
C {symbols/pfet_03v3.sym} 21.25 -190 0 1 {name=M24
L=\{refL\}
W=\{refW\}
nf=20
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
C {lab_pin.sym} 1.25 -190 0 0 {name=p34 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 1.25 -295 0 0 {name=p35 sig_type=std_logic lab=Vdd}
C {gnd.sym} 1.25 100 1 1 {name=l8 lab=0}
C {symbols/nfet_03v3.sym} 21.25 100 0 1 {name=M25
L=\{refL\}
W=\{refW\}
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
C {gnd.sym} 1.25 -10 1 1 {name=l9 lab=0}
C {symbols/nfet_03v3.sym} 21.25 -10 0 1 {name=M26
L=\{refL\}
W=\{refW\}
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
C {gnd.sym} 1.25 160 0 1 {name=l10 lab=0}
C {lab_pin.sym} -143.75 -85 0 0 {name=p36 sig_type=std_logic lab=VN_MIRR}
C {lab_pin.sym} 86.25 55 0 0 {name=p37 sig_type=std_logic lab=VN_CAS}
C {lab_pin.sym} 66.25 -271.25 2 0 {name=p38 sig_type=std_logic lab=VP_CAS}
C {param.sym} -375 161.25 0 0 {name=s1 value="refW=10u"}
C {param.sym} -375 186.25 0 0 {name=s2 value="refL=1u"}
C {ammeter.sym} -333.75 -80 0 0 {name=VIREF_MASTER savecurrent=true spice_ignore=0}
C {gnd.sym} 301.25 71.25 1 1 {name=l28 lab=0}
C {symbols/nfet_03v3.sym} 321.25 71.25 0 1 {name=M30
L=\{refL\}
W=\{refW\}
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
C {gnd.sym} 301.25 -38.75 1 1 {name=l29 lab=0}
C {symbols/nfet_03v3.sym} 321.25 -38.75 0 1 {name=M31
L=\{refL\}
W=\{refW\}
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
C {gnd.sym} 301.25 131.25 0 1 {name=l30 lab=0}
C {lab_pin.sym} 341.25 -38.75 2 0 {name=p44 sig_type=std_logic lab=VN_MIRR}
C {lab_pin.sym} 341.25 71.25 2 0 {name=p45 sig_type=std_logic lab=VN_CAS}
C {lab_pin.sym} 301.25 -108.75 2 0 {name=p46 sig_type=std_logic lab=IREF_ADC}
C {gnd.sym} 561.25 73.75 1 1 {name=l31 lab=0}
C {symbols/nfet_03v3.sym} 581.25 73.75 0 1 {name=M32
L=\{refL\}
W=\{refW\}
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
C {gnd.sym} 561.25 -36.25 1 1 {name=l32 lab=0}
C {symbols/nfet_03v3.sym} 581.25 -36.25 0 1 {name=M33
L=\{refL\}
W=\{refW\}
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
C {gnd.sym} 561.25 133.75 0 1 {name=l33 lab=0}
C {lab_pin.sym} 601.25 -36.25 2 0 {name=p47 sig_type=std_logic lab=VN_MIRR}
C {lab_pin.sym} 601.25 73.75 2 0 {name=p48 sig_type=std_logic lab=VN_CAS}
C {lab_pin.sym} 561.25 -106.25 2 0 {name=p49 sig_type=std_logic lab=IREF_DAC}
C {gnd.sym} 813.75 76.25 1 1 {name=l34 lab=0}
C {symbols/nfet_03v3.sym} 833.75 76.25 0 1 {name=M34
L=\{refL\}
W=\{refW\}
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
C {gnd.sym} 813.75 -33.75 1 1 {name=l35 lab=0}
C {symbols/nfet_03v3.sym} 833.75 -33.75 0 1 {name=M35
L=\{refL\}
W=\{refW\}
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
C {gnd.sym} 813.75 136.25 0 1 {name=l36 lab=0}
C {lab_pin.sym} 853.75 -33.75 2 0 {name=p50 sig_type=std_logic lab=VN_MIRR}
C {lab_pin.sym} 853.75 76.25 2 0 {name=p51 sig_type=std_logic lab=VN_CAS}
C {lab_pin.sym} 813.75 -103.75 2 0 {name=p52 sig_type=std_logic lab=IREF_LVDS}
C {lab_pin.sym} -333.75 -50 0 0 {name=p53 sig_type=std_logic lab=IREF_EXT}
C {gnd.sym} 1076.25 76.25 1 1 {name=l37 lab=0}
C {symbols/nfet_03v3.sym} 1096.25 76.25 0 1 {name=M36
L=\{refL\}
W=\{refW\}
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
C {gnd.sym} 1076.25 -33.75 1 1 {name=l38 lab=0}
C {symbols/nfet_03v3.sym} 1096.25 -33.75 0 1 {name=M37
L=\{refL\}
W=\{refW\}
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
C {gnd.sym} 1076.25 136.25 0 1 {name=l39 lab=0}
C {lab_pin.sym} 1116.25 -33.75 2 0 {name=p54 sig_type=std_logic lab=VN_MIRR}
C {lab_pin.sym} 1116.25 76.25 2 0 {name=p55 sig_type=std_logic lab=VN_CAS}
C {lab_pin.sym} 1076.25 -103.75 2 0 {name=p56 sig_type=std_logic lab=IREF_PLL}
C {opin.sym} -265 -595 0 0 {name=p57 lab=IREF_ADC}
C {opin.sym} -265 -570 0 0 {name=p58 lab=IREF_DAC
}
C {ipin.sym} -295 -572.5 0 0 {name=p59 lab=Vdd}
C {ipin.sym} -295 -595 0 0 {name=p61 lab=IREF_EXT}
C {opin.sym} -265 -545 0 0 {name=p62 lab=IREF_LVDS
}
C {opin.sym} -265 -520 0 0 {name=p63 lab=IREF_PLL
}
