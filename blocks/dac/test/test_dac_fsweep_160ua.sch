v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Master IREF=10uA} -418.75 182.5 0 0 0.2 0.2 {}
N 347.5 296.25 347.5 316.25 {lab=0}
N 252.5 291.25 252.5 311.25 {lab=0}
N 252.5 221.25 252.5 231.25 {lab=#net1}
N 347.5 226.25 347.5 236.25 {lab=#net2}
N 347.5 136.25 347.5 166.25 {lab=VOUT_N}
N 252.5 136.25 252.5 161.25 {lab=VOUT_P}
C {simulator_commands_shown.sym} 460 -400 0 0 {name=COMMANDS1
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
plot 3.3-xb3.x1.Vg1P 3.3-xb3.x1.Vg1N

* plot x1.x1.Vcx x1.x1.Vg1P x1.x1.Vg1N

* plot VB1syncP VB1syncN-6 VB4syncN-6 VU0bufP-12 VB1bufP-12 VB4bufP-12 VU0bufN-18 VB1bufN-18 VB4bufN-18
plot i(Vl1)-i(Vl2) i(Vl1)+100E-6 i(Vl2)+100E-6

let imax = 160E-6
let imin = -160E-6
plot i(VB4)-i(VB5) imax imin
plot i(VB1)-i(VB2) i(VB4)-i(VB5) imax imin

let diff = i(Vl1)-i(Vl2)
plot pulseP diff/\{imax\}*5 fghz
* plot pulseP fghz



* plot i(VoutB3P)+100E-6 i(VoutB3N)+100E-6 i(VoutB3P)-i(VoutB3N) i(VoutB3N)+i(VoutB3P) i(v.x1.Vcrr1)-200E-6 i(v.x1.Vcrr2)-200E-6
* plot i(v.x1.Vcrr1) i(v.x1.Vcrr2)
* plot i(Vl1) VB1in/5E4+200E-6 VU0in/5E4+200E-6
* wrdata /foss/designs/dds/dac_isource_unary_pmos_80ua_v4_tt_500ps.csv ClkP ClkN Din VdsyncP VdsyncN i(Vl1) i(Vl2) 
.endc
"}
C {code_shown.sym} 220 -440 0 0 {name=s1 only_toplevel=false value="
.op
.save all
"}
C {gnd.sym} 240 -70 0 0 {name=l4 lab=0}
C {vsource.sym} 240 -100 0 0 {name=Vdd value=3.3 savecurrent=true}
C {lab_pin.sym} 240 -130 1 0 {name=p13 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -590 -50 2 0 {name=p2 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -590 -80 0 0 {name=VB3 value="0.0" savecurrent=true
}
C {lab_pin.sym} -475 -50 2 0 {name=p8 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {code_shown.sym} 466.25 186.25 0 0 {name=s5 only_toplevel=false value=".param fs=0.5G fe=6G Tsw=15ns Vhi=3.3 Vlo=0
Bphase phase 0 V = (fs*Tsw/ln(fe/fs)) * ((fe/fs)^(time/Tsw) - 1)
BpulseP pulseP 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vhi : Vlo
BpulseN pulseN 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vlo : Vhi
Bfghz  fghz  0 V = (fs * (fe/fs)^(time/Tsw)) / 1e9

"}
C {vsource.sym} -475 -80 0 0 {name=VB8 value="0.0" savecurrent=true
}
C {lab_pin.sym} -475 -110 2 0 {name=p42 sig_type=std_logic lab=VB3bufN
value="DC 3.3"
}
C {lab_pin.sym} -590 -110 2 0 {name=p7 sig_type=std_logic lab=VB3bufP}
C {iref/dac_iref.sym} -505 41.25 0 0 {name=x6}
C {lab_pin.sym} -605 31.25 2 1 {name=p128 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -405 31.25 0 1 {name=p129 sig_type=std_logic lab=VCAS}
C {lab_pin.sym} -405 51.25 0 1 {name=p130 sig_type=std_logic lab=IREF[35..0]}
C {isource.sym} -435 157.5 0 0 {name=Iref2 value="DC 10uA AC 0"}
C {gnd.sym} -435 187.5 0 0 {name=l5 lab=0}
C {lab_pin.sym} -435 127.5 2 1 {name=p4 sig_type=std_logic lab=IREF_MASTER_10UA}
C {lab_pin.sym} -605 51.25 0 0 {name=p12 sig_type=std_logic lab=IREF_MASTER_10UA}
C {res.sym} 252.5 191.25 0 0 {name=R3
value=100
footprint=1206
device=resistor
m=1
savecurrent=true}
C {res.sym} 347.5 196.25 0 0 {name=R4
value=100
footprint=1206
device=resistor
m=1}
C {gnd.sym} 347.5 316.25 0 0 {name=l15 lab=0}
C {gnd.sym} 252.5 311.25 0 0 {name=l16 lab=0}
C {vsource.sym} 252.5 261.25 0 0 {name=Vl1 value=0.0 savecurrent=true
}
C {vsource.sym} 347.5 266.25 0 0 {name=Vl2 value=0.0 savecurrent=true
}
C {lab_pin.sym} 252.5 136.25 0 1 {name=p18 sig_type=std_logic lab=VOUT_P}
C {lab_pin.sym} 347.5 136.25 0 1 {name=p19 sig_type=std_logic lab=VOUT_N}
C {lab_pin.sym} -168.75 6.25 2 1 {name=p303 sig_type=std_logic lab=pulseP}
C {lab_pin.sym} -168.75 26.25 2 1 {name=p304 sig_type=std_logic lab=pulseN}
C {lab_pin.sym} -168.75 86.25 2 1 {name=p305 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -168.75 66.25 2 1 {name=p306 sig_type=std_logic lab=IREF[1..0]}
C {lab_pin.sym} -168.75 46.25 2 1 {name=p308 sig_type=std_logic lab=VCAS}
C {lab_pin.sym} 91.25 26.25 0 1 {name=p337 sig_type=std_logic lab=VOUT_N}
C {lab_pin.sym} 91.25 6.25 0 1 {name=p338 sig_type=std_logic lab=VOUT_P}
C {ammeter.sym} 61.25 6.25 3 0 {name=VB4 savecurrent=true spice_ignore=0}
C {ammeter.sym} 61.25 26.25 3 0 {name=VB5 savecurrent=true spice_ignore=0}
C {cellv9/dac_cell_160ua_v9.sym} -68.75 46.25 0 0 {name=x1}
C {code_shown.sym} 443.75 -582.5 0 0 {name=s3 only_toplevel=false value=
"
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical
"}
C {lab_pin.sym} -172.5 -131.25 2 1 {name=p1 sig_type=std_logic lab=pulseP}
C {lab_pin.sym} -172.5 -111.25 2 1 {name=p3 sig_type=std_logic lab=pulseN}
C {lab_pin.sym} -172.5 -51.25 2 1 {name=p5 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -172.5 -71.25 2 1 {name=p6 sig_type=std_logic lab=IREF[6..3]}
C {lab_pin.sym} -172.5 -91.25 2 1 {name=p9 sig_type=std_logic lab=VCAS}
C {lab_pin.sym} 87.5 -111.25 0 1 {name=p10 sig_type=std_logic lab=VOUT_N}
C {lab_pin.sym} 87.5 -131.25 0 1 {name=p11 sig_type=std_logic lab=VOUT_P}
C {ammeter.sym} 57.5 -131.25 3 0 {name=VB1 savecurrent=true spice_ignore=0}
C {ammeter.sym} 57.5 -111.25 3 0 {name=VB2 savecurrent=true spice_ignore=0}
C {cellv9/dac_cell_320ua_v9.sym} -72.5 -91.25 0 0 {name=x2}
