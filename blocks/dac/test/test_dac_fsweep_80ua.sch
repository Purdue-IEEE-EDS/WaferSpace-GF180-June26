v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 380 -760 380 -740 {lab=0}
N 235 -765 235 -745 {lab=0}
N 235 -835 235 -825 {lab=#net1}
N 380 -830 380 -820 {lab=#net2}
N 380 -920 380 -890 {lab=Vout1N}
N 235 -920 235 -895 {lab=Vout1P}
N -660 -1160 -660 -1140 {lab=pulseP}
N -535 -1165 -535 -1140 {lab=pulseN}
N 321.25 -1270 321.25 -1250 {lab=Vdd}
N 403.75 -1252.5 502.5 -1252.5 {lab=Vdd}
N 456.25 -1252.5 456.25 -1250 {lab=Vdd}
N 502.5 -1252.5 502.5 -1250 {lab=Vdd}
N 405 -1252.5 405 -1248.75 {lab=Vdd}
N 502.5 -1253.75 502.5 -1252.5 {lab=Vdd}
N 415 -1260 415 -1252.5 {lab=Vdd}
C {simulator_commands_shown.sym} 630 -1475 0 0 {name=COMMANDS1
simulator=ngspice
only_toplevel=false 
value="
.save all
.control

tran 1p 50ns
* plot VU1syncP+6 VU1syncN+6 VU2syncP+6 VU2syncN+6 VgN+12 VgP Dm ClkP+18 ClkN+18 i(Vl1)*5E4-6 i(Vl2)*5E4-6 (i(Vl1)-i(Vl2))*5E4-12
* plot ClkP+6 ClkN+6 VU0in VB1in VU0syncP-6 VU0syncN-12 VB1syncP-6 VB1syncN-12
* plot Vout1P+15E-3 Vout1N+15E-3 Vout1P-Vout1N
* plot ClkP+5 ClkN+5 VB3syncP VB3syncN VB3bufP-5 VB3bufN-5 xb3.x1.Vg1P-10 xb3.x1.Vg1N-10


*plot VB3bufP+4 VB3bufN+4 xb3.Vcx xb3.Vcx-xb3.Vg1P xb3.Vcx-xb3.Vg1N xb3.Vcx-xb3.VcxP

* plot VB1syncP VB1syncN-6 VB4syncN-6 VU0bufP-12 VB1bufP-12 VB4bufP-12 VU0bufN-18 VB1bufN-18 VB4bufN-18
plot i(Vl1)-i(Vl2) i(Vl1)+100E-6 i(Vl2)+100E-6
plot i(v.x1.VinP) i(v.x1.VinN)

let imax = 80E-6
let imin = -80E-6
plot i(VB3P)-i(VB3N) imax imin xlimit 3ns 6ns

let diff = i(Vl1)-i(Vl2)
plot pulseP diff/\{imax\}*5 fghz

plot x1.Vg1P x1.Vg1N VB3bufP VB3bufN
plot x1.VH x1.VL x1.Vg1P

plot i(Vdd)
* plot i(VoutB3P)+100E-6 i(VoutB3N)+100E-6 i(VoutB3P)-i(VoutB3N) i(VoutB3N)+i(VoutB3P) i(v.x1.Vcrr1)-200E-6 i(v.x1.Vcrr2)-200E-6

* wrdata /foss/designs/dds/dac_isource_unary_pmos_80ua_v4_tt_500ps.csv ClkP ClkN Din VdsyncP VdsyncN i(Vl1) i(Vl2) 
.endc
"}
C {code_shown.sym} 390 -1515 0 0 {name=s1 only_toplevel=false value="
.op
.save all
"}
C {code_shown.sym} 390 -1615 0 0 {name=s2 only_toplevel=false value=
"
.include /headless/QucsWorkspace/IHP-Open-PDK/gf180mcuD/libs.tech/ngspice/design.ngspice typical
.lib /headless/QucsWorkspace/IHP-Open-PDK/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
"}
C {res.sym} 235 -865 0 0 {name=R3
value=100
footprint=1206
device=resistor
m=1
savecurrent=true}
C {res.sym} 380 -860 0 0 {name=R4
value=100
footprint=1206
device=resistor
m=1}
C {gnd.sym} 380 -740 0 0 {name=l15 lab=0}
C {gnd.sym} 235 -745 0 0 {name=l16 lab=0}
C {vsource.sym} 235 -795 0 0 {name=Vl1 value=0.0 savecurrent=true
}
C {vsource.sym} 380 -790 0 0 {name=Vl2 value=0.0 savecurrent=true
}
C {lab_pin.sym} 235 -920 0 1 {name=p18 sig_type=std_logic lab=Vout1P}
C {lab_pin.sym} 380 -920 0 1 {name=p19 sig_type=std_logic lab=Vout1N}
C {code_shown.sym} 655 -845 0 0 {name=s5 only_toplevel=false value=".param fs=0.25G fe=1G Tsw=50ns Vhi=3.3 Vlo=0.0
Bphase phase 0 V = (fs*Tsw/ln(fe/fs)) * ((fe/fs)^(time/Tsw) - 1)
BpulseP pulseP 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vhi : Vlo
BpulseN pulseN 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vlo : Vhi
Bfghz  fghz  0 V = (fs * (fe/fs)^(time/Tsw)) / 1e9

"}
C {lab_pin.sym} -385 -805 2 1 {name=p21 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -385 -905 2 1 {name=p32 sig_type=std_logic lab=VB3bufP}
C {lab_pin.sym} -385 -885 2 1 {name=p46 sig_type=std_logic lab=VB3bufN}
C {lab_pin.sym} -125 -885 0 1 {name=p47 sig_type=std_logic lab=Vout1N}
C {lab_pin.sym} -125 -905 0 1 {name=p48 sig_type=std_logic lab=Vout1P}
C {cellv9/dac_cell_80ua_v9.sym} -285 -855 0 0 {name=x1}
C {lab_pin.sym} -660 -1220 0 1 {name=p5 sig_type=std_logic lab=VB3bufP}
C {lab_pin.sym} -535 -1225 0 1 {name=p6 sig_type=std_logic lab=VB3bufN}
C {lab_pin.sym} -660 -1140 2 0 {name=p2 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -660 -1190 0 0 {name=VB3 value="0.0" savecurrent=true
}
C {vsource.sym} -535 -1195 0 0 {name=VB5 value="0.0" savecurrent=true
}
C {lab_pin.sym} -535 -1140 2 0 {name=p8 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {iref/dac_iref.sym} -275 -1065 0 0 {name=x3}
C {lab_pin.sym} -375 -1085 2 1 {name=p7 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -175 -1085 0 1 {name=p9 sig_type=std_logic lab=VPCas}
C {lab_pin.sym} -175 -1065 0 1 {name=p10 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -175 -1045 0 1 {name=p11 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -385 -825 2 1 {name=p1 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -385 -845 2 1 {name=p3 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -385 -865 2 1 {name=p4 sig_type=std_logic lab=VPCas}
C {ammeter.sym} -155 -905 3 0 {name=VB3P savecurrent=true spice_ignore=0}
C {ammeter.sym} -155 -885 3 0 {name=VB3N savecurrent=true spice_ignore=0}
C {lab_pin.sym} -385 -675 2 1 {name=p12 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -385 -775 2 1 {name=p14 sig_type=std_logic lab=VB3bufP}
C {lab_pin.sym} -385 -755 2 1 {name=p15 sig_type=std_logic lab=VB3bufN}
C {lab_pin.sym} -125 -755 0 1 {name=p16 sig_type=std_logic lab=Vout1N}
C {lab_pin.sym} -125 -775 0 1 {name=p17 sig_type=std_logic lab=Vout1P}
C {cellv9/dac_cell_80ua_v9.sym} -285 -725 0 0 {name=x2}
C {lab_pin.sym} -385 -695 2 1 {name=p20 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -385 -715 2 1 {name=p22 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -385 -735 2 1 {name=p23 sig_type=std_logic lab=VPCas}
C {ammeter.sym} -155 -775 3 0 {name=VB1 savecurrent=true spice_ignore=0}
C {ammeter.sym} -155 -755 3 0 {name=VB2 savecurrent=true spice_ignore=0}
C {gnd.sym} 321.25 -1130 0 0 {name=l1 lab=0}
C {vsource.sym} 321.25 -1160 0 0 {name=Vdd value=3.3 savecurrent=true}
C {lab_pin.sym} 321.25 -1270 1 0 {name=p24 sig_type=std_logic lab=Vdd}
C {res.sym} 321.25 -1220 0 0 {name=R1
value=2
footprint=1206
device=resistor
m=1}
C {capa.sym} 405 -1222.5 0 0 {name=C1
m=1
value=0.1u
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 405 -1192.5 0 0 {name=l2 lab=0}
C {capa.sym} 456.25 -1222.5 0 0 {name=C2
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 456.25 -1192.5 0 0 {name=l3 lab=0}
C {capa.sym} 502.5 -1222.5 0 0 {name=C3
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 502.5 -1192.5 0 0 {name=l4 lab=0}
C {lab_pin.sym} 415 -1260 1 0 {name=p13 sig_type=std_logic lab=Vdd}
