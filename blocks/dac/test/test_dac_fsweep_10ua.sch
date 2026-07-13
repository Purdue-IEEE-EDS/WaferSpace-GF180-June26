v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Master IREF=10uA} -113.75 -748.75 0 0 0.2 0.2 {}
N 425 -570 425 -550 {lab=0}
N 330 -575 330 -555 {lab=0}
N 330 -645 330 -635 {lab=#net1}
N 425 -640 425 -630 {lab=#net2}
N 425 -730 425 -700 {lab=VOUT_N}
N 330 -730 330 -705 {lab=VOUT_P}
N 487.5 -1212.5 487.5 -1192.5 {lab=Vdd}
N 276.25 -1178.75 375 -1178.75 {lab=Vdd}
N 328.75 -1178.75 328.75 -1176.25 {lab=Vdd}
N 375 -1178.75 375 -1176.25 {lab=Vdd}
N 277.5 -1178.75 277.5 -1175 {lab=Vdd}
N 375 -1180 375 -1178.75 {lab=Vdd}
N 287.5 -1186.25 287.5 -1178.75 {lab=Vdd}
C {simulator_commands_shown.sym} 630 -1475 0 0 {name=COMMANDS1
simulator=ngspice
only_toplevel=false 
value="
.save all
.control

tran 1p 5ns
* plot VU1syncP+6 VU1syncN+6 VU2syncP+6 VU2syncN+6 VgN+12 VgP Dm ClkP+18 ClkN+18 i(Vl1)*5E4-6 i(Vl2)*5E4-6 (i(Vl1)-i(Vl2))*5E4-12
* plot ClkP+6 ClkN+6 VU0in VB1in VU0syncP-6 VU0syncN-12 VB1syncP-6 VB1syncN-12
* plot Vout1P+15E-3 Vout1N+15E-3 Vout1P-Vout1N
* plot ClkP+5 ClkN+5 VB3syncP VB3syncN VB3bufP-5 VB3bufN-5 xb3.x1.Vg1P-10 xb3.x1.Vg1N-10
plot 3.3-xb3.Vg1P 3.3-xb3.Vg1N

* plot x1.x1.Vcx x1.x1.Vg1P x1.x1.Vg1N

* plot VB1syncP VB1syncN-6 VB4syncN-6 VU0bufP-12 VB1bufP-12 VB4bufP-12 VU0bufN-18 VB1bufN-18 VB4bufN-18
plot i(Vl1)-i(Vl2) i(Vl1)+100E-6 i(Vl2)+100E-6

let imax = 10E-6
let imin = -10E-6
plot i(VB3P)-i(VB3N) imax imin

let diff = i(Vl1)-i(Vl2)
plot pulseP diff/\{imax\}*5 fghz
* plot pulseP fghz
.endc
"}
C {code_shown.sym} 390 -1515 0 0 {name=s1 only_toplevel=false value="
.op
.save all
"}
C {res.sym} 330 -675 0 0 {name=R3
value=100
footprint=1206
device=resistor
m=1
savecurrent=true}
C {res.sym} 425 -670 0 0 {name=R4
value=100
footprint=1206
device=resistor
m=1}
C {gnd.sym} 425 -550 0 0 {name=l15 lab=0}
C {gnd.sym} 330 -555 0 0 {name=l16 lab=0}
C {vsource.sym} 330 -605 0 0 {name=Vl1 value=0.0 savecurrent=true
}
C {vsource.sym} 425 -600 0 0 {name=Vl2 value=0.0 savecurrent=true
}
C {lab_pin.sym} 330 -730 0 1 {name=p18 sig_type=std_logic lab=VOUT_P}
C {lab_pin.sym} 425 -730 0 1 {name=p19 sig_type=std_logic lab=VOUT_N}
C {lab_pin.sym} -253.75 -912.5 2 0 {name=p2 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -253.75 -942.5 0 0 {name=VB3 value="0.0" savecurrent=true
}
C {vsource.sym} -148.75 -942.5 0 0 {name=VB4 value="0.0" savecurrent=true
}
C {lab_pin.sym} -148.75 -912.5 2 0 {name=p8 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {code_shown.sym} 645 -820 0 0 {name=s5 only_toplevel=false value=".param fs=0.5G fe=6G Tsw=15ns Vhi=3.3 Vlo=0
Bphase phase 0 V = (fs*Tsw/ln(fe/fs)) * ((fe/fs)^(time/Tsw) - 1)
BpulseP pulseP 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vhi : Vlo
BpulseN pulseN 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vlo : Vhi
Bfghz  fghz  0 V = (fs * (fe/fs)^(time/Tsw)) / 1e9

"}
C {lab_pin.sym} -148.75 -972.5 2 0 {name=p42 sig_type=std_logic lab=VB3bufN
value="DC 3.3"
}
C {lab_pin.sym} -253.75 -972.5 2 0 {name=p7 sig_type=std_logic lab=VB3bufP}
C {lab_pin.sym} 103.75 -911.25 2 1 {name=p303 sig_type=std_logic lab=pulseP}
C {lab_pin.sym} 103.75 -891.25 2 1 {name=p304 sig_type=std_logic lab=pulseN}
C {cellv9/dac_cell_10ua_v9.sym} 203.75 -871.25 0 0 {name=x1}
C {lab_pin.sym} 103.75 -831.25 2 1 {name=p305 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 103.75 -851.25 2 1 {name=p306 sig_type=std_logic lab=IREF0}
C {lab_pin.sym} 103.75 -871.25 2 1 {name=p308 sig_type=std_logic lab=VCAS}
C {lab_pin.sym} 363.75 -891.25 0 1 {name=p337 sig_type=std_logic lab=VOUT_N}
C {lab_pin.sym} 363.75 -911.25 0 1 {name=p338 sig_type=std_logic lab=VOUT_P}
C {ammeter.sym} 333.75 -911.25 3 0 {name=VB0P savecurrent=true spice_ignore=0}
C {ammeter.sym} 333.75 -891.25 3 0 {name=VB0N savecurrent=true spice_ignore=0}
C {iref/dac_iref.sym} -128.75 -638.75 0 0 {name=x6}
C {lab_pin.sym} -228.75 -648.75 2 1 {name=p128 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -28.75 -648.75 0 1 {name=p129 sig_type=std_logic lab=VCAS}
C {lab_pin.sym} -28.75 -628.75 0 1 {name=p130 sig_type=std_logic lab=IREF[35..0]}
C {isource.sym} -130 -773.75 0 0 {name=Iref2 value="DC 10uA AC 0"}
C {gnd.sym} -130 -743.75 0 0 {name=l1 lab=0}
C {lab_pin.sym} -130 -803.75 2 1 {name=p5 sig_type=std_logic lab=IREF_MASTER_10UA}
C {lab_pin.sym} -228.75 -628.75 0 0 {name=p12 sig_type=std_logic lab=IREF_MASTER_10UA}
C {code_shown.sym} 642.5 -1005 0 0 {name=s3 only_toplevel=false value=
"
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical
"}
C {gnd.sym} 487.5 -1072.5 0 0 {name=l4 lab=0}
C {vsource.sym} 487.5 -1102.5 0 0 {name=Vdd value=3.3 savecurrent=true}
C {lab_pin.sym} 487.5 -1212.5 1 0 {name=p13 sig_type=std_logic lab=Vdd}
C {res.sym} 487.5 -1162.5 0 0 {name=R1
value=2
footprint=1206
device=resistor
m=1}
C {capa.sym} 277.5 -1148.75 0 0 {name=C1
m=1
value=0.1u
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 277.5 -1118.75 0 0 {name=l2 lab=0}
C {capa.sym} 328.75 -1148.75 0 0 {name=C2
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 328.75 -1118.75 0 0 {name=l3 lab=0}
C {capa.sym} 375 -1148.75 0 0 {name=C3
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 375 -1118.75 0 0 {name=l5 lab=0}
C {lab_pin.sym} 287.5 -1186.25 1 0 {name=p26 sig_type=std_logic lab=Vdd}
