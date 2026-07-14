v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 220 20 220 40 {lab=IREF_DAC}
N 220 -70 222.5 -70 {lab=Vdd}
N 260 -70 260 -42.5 {lab=#net1}
N 260 -42.5 260 -40 {lab=#net1}
N 220 -40 260 -40 {lab=#net1}
N 220 -152.5 220 -100 {lab=Vdd}
N 792.5 -238.75 792.5 -218.75 {lab=Vdd}
N 425 20 425 40 {lab=#net2}
N 422.5 -70 425 -70 {lab=Vdd}
N 425 -152.5 425 -100 {lab=Vdd}
N 260 -70 385 -70 {lab=#net1}
C {param.sym} 188.75 -237.5 0 0 {name=s4 value="refW=10u"}
C {param.sym} 188.75 -212.5 0 0 {name=s5 value="refL=1u"}
C {isource.sym} 0 -47.5 0 0 {name=I0 value=20uA}
C {gnd.sym} 0 -17.5 0 1 {name=l1 lab=0}
C {symbols/pfet_03v3.sym} 240 -70 0 1 {name=M3
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
C {ammeter.sym} 220 -10 0 0 {name=VIREF_MIRROR savecurrent=true spice_ignore=0}
C {lab_pin.sym} 220 -70 0 0 {name=p3 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 220 -152.5 1 0 {name=p4 sig_type=std_logic lab=Vdd}
C {simulator_commands_shown.sym} 890 -311.25 0 0 {name=COMMANDS1
simulator=ngspice
only_toplevel=false 
value="
.save all
.control

tran 1p 5ns
plot i(VIREF_MASTER) i(VIREF_MIRROR) i(VIREF_LOCAL)
plot IREF_EXT

.endc
"}
C {code_shown.sym} 695 -601.25 0 0 {name=s1 only_toplevel=false value="
.op
.save all
"}
C {code_shown.sym} 680 -786.25 0 0 {name=s3 only_toplevel=false value=
"
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical
"}
C {gnd.sym} 792.5 -158.75 0 0 {name=l10 lab=0}
C {vsource.sym} 792.5 -188.75 0 0 {name=Vdd value=3.3 savecurrent=true}
C {lab_pin.sym} 792.5 -238.75 1 0 {name=p5 sig_type=std_logic lab=Vdd}
C {ammeter.sym} 0 -107.5 0 0 {name=VIREF_MASTER savecurrent=true spice_ignore=0}
C {lab_pin.sym} 0 -77.5 0 0 {name=p25 sig_type=std_logic lab=IREF_EXT}
C {opin.sym} 47.5 133.75 0 0 {name=p29 lab=IREF_ADC}
C {opin.sym} 47.5 153.75 0 0 {name=p30 lab=IREF_DAC
}
C {opin.sym} 47.5 173.75 0 0 {name=p31 lab=IREF_LVDS
}
C {opin.sym} 47.5 193.75 0 0 {name=p32 lab=IREF_PLL
}
C {symbols/pfet_03v3.sym} 405 -70 0 0 {name=M23
L=\{refL\}
W=\{refW\}
nf=20
m=5
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {ammeter.sym} 425 -10 0 1 {name=VIREF_LOCAL savecurrent=true spice_ignore=0}
C {lab_pin.sym} 425 -70 0 1 {name=p36 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 425 -152.5 3 1 {name=p37 sig_type=std_logic lab=Vdd}
C {/foss/designs/top/iref_master.sym} -52.5 163.75 0 0 {name=x1}
C {lab_pin.sym} -152.5 133.75 0 0 {name=p1 sig_type=std_logic lab=IREF_EXT}
C {lab_pin.sym} -152.5 153.75 0 0 {name=p2 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 220 40 2 1 {name=p6 sig_type=std_logic lab=IREF_DAC}
C {res.sym} 425 70 0 0 {name=R1
value=1k
footprint=1206
device=resistor
m=1}
C {gnd.sym} 425 100 0 0 {name=l2 lab=0}
