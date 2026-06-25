v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {10uA copy for source} 473.75 151.25 0 0 0.25 0.25 {}
T {10uA copy for buffer} 473.75 175 0 0 0.25 0.25 {}
N 108.75 127.5 108.75 137.5 {lab=IREF_10UA}
N 148.75 97.5 148.75 137.5 {lab=IREF_10UA}
N 108.75 137.5 108.75 187.5 {lab=IREF_10UA}
N 108.75 42.5 108.75 67.5 {lab=#net1}
N 108.75 137.5 148.75 137.5 {lab=IREF_10UA}
N 108.75 -42.5 108.75 -16.25 {lab=Vdd}
N 148.75 97.5 187.5 97.5 {lab=IREF_10UA}
N 147.5 12.5 148.75 12.5 {lab=VCAS}
N 456.25 127.5 456.25 137.5 {lab=VB_10UA}
N 456.25 137.5 456.25 187.5 {lab=VB_10UA}
N 456.25 42.5 456.25 67.5 {lab=#net2}
N 456.25 -42.5 456.25 -16.25 {lab=Vdd}
N 416.25 12.5 417.5 12.5 {lab=VCAS}
N 456.25 187.5 456.25 233.75 {lab=VB_10UA}
N 456.25 233.75 456.25 235 {lab=VB_10UA}
N 456.25 235 456.25 236.25 {lab=VB_10UA}
N 456.25 265 460 265 {lab=0}
N 496.25 216.25 496.25 265 {lab=VB_10UA}
N 456.25 216.25 496.25 216.25 {lab=VB_10UA}
N 496.25 265 520 265 {lab=VB_10UA}
N 456.25 295 456.25 307.5 {lab=0}
N 452.5 12.5 456.25 12.5 {lab=Vdd}
N 415 97.5 416.25 97.5 {lab=VMIR}
N -161.25 -51.25 -161.25 -30 {lab=VCAS}
N -200 -51.25 -161.25 -51.25 {lab=VCAS}
N -201.25 -51.25 -198.75 -51.25 {lab=VCAS}
N -278.75 -51.25 -257.5 -51.25 {lab=VCAS_IN}
N 108.75 186.25 108.75 187.5 {lab=IREF_10UA}
N 186.25 97.5 188.75 97.5 {lab=IREF_10UA}
N 452.5 97.5 456.25 97.5 {lab=Vdd}
N -161.25 -30 -161.25 -28.75 {lab=VCAS}
N 285 97.5 285 118.75 {lab=VMIR}
N 246.25 97.5 285 97.5 {lab=VMIR}
N 245 97.5 247.5 97.5 {lab=VMIR}
N 285 118.75 285 120 {lab=VMIR}
C {symbols/pfet_03v3.sym} 128.75 97.5 0 1 {name=M1
L=\{mirL\}
W=\{mirW\}
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
C {lab_pin.sym} 108.75 97.5 0 0 {name=p20 sig_type=std_logic lab=Vdd}
C {symbols/pfet_03v3.sym} 128.75 12.5 0 1 {name=M49
L=\{casL\}
W=\{casW\}
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
C {lab_pin.sym} 108.75 12.5 0 0 {name=p109 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 108.75 -42.5 1 0 {name=p111 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 148.75 12.5 2 0 {name=p115 sig_type=std_logic lab=VCAS}
C {lab_pin.sym} 108.75 186.25 0 0 {name=p112 sig_type=std_logic lab=IREF_10UA}
C {symbols/pfet_03v3.sym} 436.25 97.5 0 0 {name=M8
L=\{mirL\}
W=\{mirW\}
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
C {lab_pin.sym} 456.25 97.5 0 1 {name=p22 sig_type=std_logic lab=Vdd}
C {symbols/pfet_03v3.sym} 436.25 12.5 0 0 {name=M25
L=\{casL\}
W=\{casW\}
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
C {lab_pin.sym} 456.25 12.5 0 1 {name=p23 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 456.25 -42.5 3 1 {name=p54 sig_type=std_logic lab=Vdd}
C {symbols/nfet_03v3.sym} 476.25 265 0 1 {name=M26
L=1u
W=8u
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
C {gnd.sym} 456.25 307.5 0 1 {name=l15 lab=0}
C {lab_pin.sym} 518.75 265 0 1 {name=p89 sig_type=std_logic lab=VB_10UA}
C {gnd.sym} 456.25 265 1 0 {name=l16 lab=0}
C {lab_pin.sym} -278.75 -51.25 2 1 {name=p55 sig_type=std_logic lab=VCAS_IN}
C {symbols/ppolyf_u_1k.sym} -228.75 -51.25 1 0 {name=R4
W=2e-6
L=10e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} -228.75 -71.25 3 1 {name=p56 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -161.25 -51.25 0 1 {name=p57 sig_type=std_logic lab=VCAS}
C {symbols/cap_mim_analog.sym} -161.25 1.25 0 0 {name=C1
W=5e-6
L=5e-6
model=cap_mim_2f0_m3m4_noshield
spiceprefix=X
m=1
C=50fF}
C {gnd.sym} -161.25 31.25 0 0 {name=Data1 lab=0
value="PULSE(3.3 0 \{clk*0.5\} 30ps 30ps \{clk*1\} \{clk*2\})"
}
C {opin.sym} -163.75 -286.25 0 0 {name=p80 lab=VMIR}
C {opin.sym} -161.25 -311.25 0 0 {name=p81 lab=VCAS}
C {ipin.sym} -193.75 -261.25 0 0 {name=p129 lab=Vdd}
C {ipin.sym} -193.75 -313.75 0 0 {name=p130 lab=VCAS_IN}
C {ipin.sym} -193.75 -286.25 0 0 {name=p131 lab=IREF_10UA}
C {param.sym} 140 -201.25 0 0 {name=s5 value="casW=4u"
}
C {param.sym} 142.5 -226.25 0 0 {name=s7 value="mirW=4u"
}
C {param.sym} 142.5 -248.75 0 0 {name=s9 value="mirL=1u"
}
C {param.sym} 145 -178.75 0 0 {name=s12 value="casL=1u"
}
C {opin.sym} -163.75 -256.25 0 0 {name=p1 lab=VB_10UA}
C {symbols/ppolyf_u_1k.sym} 217.5 97.5 1 0 {name=R1
W=2e-6
L=10e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_pin.sym} 217.5 77.5 3 1 {name=p2 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 285 97.5 3 1 {name=p3 sig_type=std_logic lab=VMIR}
C {symbols/cap_mim_analog.sym} 285 150 0 0 {name=C2
W=5e-6
L=5e-6
model=cap_mim_2f0_m3m4_noshield
spiceprefix=X
m=1
C=50fF}
C {gnd.sym} 285 180 0 0 {name=Data2 lab=0
value="PULSE(3.3 0 \{clk*0.5\} 30ps 30ps \{clk*1\} \{clk*2\})"
}
C {lab_pin.sym} 416.25 97.5 2 1 {name=p4 sig_type=std_logic lab=VMIR}
C {lab_pin.sym} 416.25 12.5 2 1 {name=p5 sig_type=std_logic lab=VCAS}
