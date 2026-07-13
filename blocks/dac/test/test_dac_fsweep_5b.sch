v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 410 -1265 410 -1245 {lab=Vdd}
N 403.75 -786.25 403.75 -766.25 {lab=0}
N 298.75 -781.25 298.75 -761.25 {lab=0}
N 298.75 -851.25 298.75 -841.25 {lab=#net1}
N 403.75 -856.25 403.75 -846.25 {lab=#net2}
C {simulator_commands_shown.sym} 630 -1475 0 0 {name=COMMANDS1
simulator=ngspice
only_toplevel=false 
value="
.save all
.control

tran 1p 10ns
plot ClkP+5 ClkN+5 VB3bufP-5 VB3bufN-5 x1.Vg1P-10 x1.Vg1N-10 x2.Vg1P-15 x2.Vg1N-15

plot i(v.x1.VB3P)-i(v.x1.VB3N) i(v.x1.VU0P)-i(v.x1.VU0N) i(v.x1.VB4P)-i(v.x1.VB4N) i(v.x1.VB2P)-i(v.x1.VB2N) i(v.x1.VB1P)-i(v.x1.VB1N)

let diff = i(Vl1)-i(Vl2)

let imax = 630E-6
let imin = -630E-6
plot pulseP \{diff/\{imax\}\}*5 fghz

plot VoutP VoutN pulseP+5 pulseN+5

plot i(Vl1)-i(Vl2) imax imin fghz*100E-6
plot i(Vdd)

plot i(v.x1.VU0P) i(v.x1.VU0N)
plot i(v.x1.VU0P)-i(v.x1.VU0N)

* plot i(VoutB3P)+100E-6 i(VoutB3N)+100E-6 i(VoutB3P)-i(VoutB3N) i(VoutB3N)+i(VoutB3P) i(v.x1.Vcrr1)-200E-6 i(v.x1.Vcrr2)-200E-6
* plot i(Vl1) VB1in/5E4+200E-6 VU0in/5E4+200E-6
.endc
"}
C {code_shown.sym} 390 -1515 0 0 {name=s1 only_toplevel=false value="
.op
.save all
"}
C {gnd.sym} 410 -1125 0 0 {name=l4 lab=0}
C {vsource.sym} 410 -1155 0 0 {name=Vdd value=3.3 savecurrent=true}
C {lab_pin.sym} 410 -1265 1 0 {name=p13 sig_type=std_logic lab=Vdd}
C {res.sym} 298.75 -881.25 0 0 {name=R3
value=25
footprint=1206
device=resistor
m=1
savecurrent=true}
C {res.sym} 403.75 -886.25 0 0 {name=R4
value=25
footprint=1206
device=resistor
m=1}
C {gnd.sym} 403.75 -766.25 0 0 {name=l15 lab=0}
C {gnd.sym} 298.75 -761.25 0 0 {name=l16 lab=0}
C {vsource.sym} 298.75 -811.25 0 0 {name=Vl1 value=0.0 savecurrent=true
}
C {vsource.sym} 403.75 -816.25 0 0 {name=Vl2 value=0.0 savecurrent=true
}
C {lab_pin.sym} 298.75 -911.25 0 1 {name=p18 sig_type=std_logic lab=VoutP}
C {lab_pin.sym} 403.75 -916.25 0 1 {name=p19 sig_type=std_logic lab=VoutN}
C {code_shown.sym} -421.25 -1148.75 0 0 {name=s5 only_toplevel=false value=".param fs=0.5G fe=4G Tsw=20ns Vhi=3.3 Vlo=0
Bphase phase 0 V = (fs*Tsw/ln(fe/fs)) * ((fe/fs)^(time/Tsw) - 1)
BpulseP pulseP 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vhi : Vlo
BpulseN pulseN 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vlo : Vhi
Bfghz  fghz  0 V = (fs * (fe/fs)^(time/Tsw)) / 1e9

"}
C {lab_pin.sym} -351.25 -791.25 2 0 {name=p5 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -351.25 -821.25 0 0 {name=VB2 value="0.0" savecurrent=true
}
C {lab_pin.sym} -246.25 -791.25 2 0 {name=p6 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {vsource.sym} -246.25 -821.25 0 0 {name=VB4 value="0.0" savecurrent=true
}
C {lab_pin.sym} -246.25 -851.25 2 0 {name=p9 sig_type=std_logic lab=VB0bufN
value="DC 3.3"
}
C {lab_pin.sym} -351.25 -851.25 2 0 {name=p10 sig_type=std_logic lab=VB0bufP}
C {res.sym} 410 -1215 0 0 {name=R1
value=2
footprint=1206
device=resistor
m=1}
C {code_shown.sym} 610 -1665 0 0 {name=s3 only_toplevel=false value=
"
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical
"}
C {lab_pin.sym} -42.5 -795 2 1 {name=p1 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -42.5 -840 2 1 {name=p3 sig_type=std_logic lab=pulseP}
C {lab_pin.sym} 157.5 -840 0 1 {name=p11 sig_type=std_logic lab=VoutP}
C {lab_pin.sym} 157.5 -820 0 1 {name=p12 sig_type=std_logic lab=VoutN}
C {dac_5b.sym} 57.5 -810 0 0 {name=x1}
C {lab_pin.sym} -42.5 -820 2 1 {name=p2 sig_type=std_logic lab=pulseN}
