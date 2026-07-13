v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Master IREF=10uA} -80 -705 0 0 0.2 0.2 {}
N 565 -1035 565 -1015 {lab=Vdd}
N 526.25 -838.75 526.25 -808.75 {lab=VOUT_I_N}
N 393.75 -837.5 393.75 -812.5 {lab=VOUT_I_P}
N 521.25 -635 521.25 -605 {lab=VOUT_Q_N}
N 395 -632.5 395 -607.5 {lab=VOUT_Q_P}
C {simulator_commands_shown.sym} 630 -1475 0 0 {name=COMMANDS1
simulator=ngspice
only_toplevel=false 
value="
.save all
.control

tran 1p 2ns
* plot VU1syncP+6 VU1syncN+6 VU2syncP+6 VU2syncN+6 VgN+12 VgP Dm ClkP+18 ClkN+18 i(Vl1)*5E4-6 i(Vl2)*5E4-6 (i(Vl1)-i(Vl2))*5E4-12
* plot ClkP+6 ClkN+6 VU0in VB1in VU0syncP-6 VU0syncN-12 VB1syncP-6 VB1syncN-12
* plot Vout1P+15E-3 Vout1N+15E-3 Vout1P-Vout1N
plot ClkP+5 ClkN+5 VB3bufP-5 VB3bufN-5 x1.Vg1P-10 x1.Vg1N-10 x2.Vg1P-15 x2.Vg1N-15

plot i(VoutB3P)-i(VoutB3N) i(VoutU0P)-i(VoutU0N) i(VoutB4P)-i(VoutB4N) i(VoutB2P)-i(VoutB2N) i(VoutB1P)-i(VoutB1N)

*plot VB1syncP VB1syncN-6 VB4syncN-6 VU0bufP-12 VB1bufP-12 VB4bufP-12 VU0bufN-18 VB1bufN-18 VB4bufN-18

let diff = i(Vl1)-i(Vl2)
let imax = 630E-6
plot pulseP \{diff/\{imax\}\}*5 fghz

plot VoutP VoutN pulseP+5 pulseN+5

plot i(Vl1)-i(Vl2) imax fghz*100E-6

plot i(Vdd) ylimit -0.1 0.1

* plot i(VoutB3P)+100E-6 i(VoutB3N)+100E-6 i(VoutB3P)-i(VoutB3N) i(VoutB3N)+i(VoutB3P) i(v.x1.Vcrr1)-200E-6 i(v.x1.Vcrr2)-200E-6
* plot i(Vl1) VB1in/5E4+200E-6 VU0in/5E4+200E-6
* wrdata /foss/designs/dds/dac_isource_unary_pmos_80ua_v4_tt_500ps.csv ClkP ClkN Din VdsyncP VdsyncN i(Vl1) i(Vl2) 
.endc
"}
C {code_shown.sym} 390 -1515 0 0 {name=s1 only_toplevel=false value="
.op
.save all
"}
C {gnd.sym} 565 -955 0 0 {name=l4 lab=0}
C {vsource.sym} 565 -985 0 0 {name=Vdd value=3.3 savecurrent=true}
C {lab_pin.sym} 565 -1035 1 0 {name=p13 sig_type=std_logic lab=Vdd}
C {code_shown.sym} -160 -1190 0 0 {name=s5 only_toplevel=false value=".param fs=0.5G fe=4G Tsw=15ns Vhi=3.3 Vlo=0
Bphase phase 0 V = (fs*Tsw/ln(fe/fs)) * ((fe/fs)^(time/Tsw) - 1)
BpulseP pulseP 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vhi : Vlo
BpulseN pulseN 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vlo : Vhi
Bfghz  fghz  0 V = (fs * (fe/fs)^(time/Tsw)) / 1e9

"}
C {lab_pin.sym} 85 -940 2 0 {name=p5 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} 85 -970 0 0 {name=VB2 value="0.0" savecurrent=true
}
C {lab_pin.sym} 190 -940 2 0 {name=p6 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {vsource.sym} 190 -970 0 0 {name=VB4 value="0.0" savecurrent=true
}
C {lab_pin.sym} 190 -1000 2 0 {name=p9 sig_type=std_logic lab=VB0bufN
value="DC 3.3"
}
C {lab_pin.sym} 85 -1000 2 0 {name=p10 sig_type=std_logic lab=VB0bufP}
C {code_shown.sym} 620 -1670 0 0 {name=s3 only_toplevel=false value=
"
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical
"}
C {dac.sym} 162.5 -795 0 0 {name=x1}
C {lab_pin.sym} 62.5 -755 2 1 {name=p1 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 62.5 -835 2 1 {name=p3 sig_type=std_logic lab=pulseP}
C {lab_pin.sym} 62.5 -815 2 1 {name=p4 sig_type=std_logic lab=pulseN}
C {lab_pin.sym} 262.5 -815 0 1 {name=p12 sig_type=std_logic lab=VOUT_I_N}
C {lab_pin.sym} 62.5 -795 2 1 {name=p2 sig_type=std_logic lab=pulseP}
C {isource.sym} -96.25 -730 0 0 {name=Iref2 value="DC 10uA AC 0"}
C {gnd.sym} -96.25 -700 0 0 {name=l1 lab=0}
C {lab_pin.sym} -96.25 -760 2 1 {name=p7 sig_type=std_logic lab=IREF_MASTER_10UA}
C {lab_pin.sym} 62.5 -775 2 1 {name=p8 sig_type=std_logic lab=IREF_MASTER_10UA}
C {res.sym} 393.75 -782.5 0 0 {name=R1
value=25
footprint=1206
device=resistor
m=1
savecurrent=true}
C {res.sym} 526.25 -778.75 0 0 {name=R2
value=25
footprint=1206
device=resistor
m=1}
C {gnd.sym} 526.25 -688.75 0 0 {name=l2 lab=0}
C {gnd.sym} 393.75 -692.5 0 0 {name=l3 lab=0}
C {lab_pin.sym} 393.75 -837.5 0 1 {name=p14 sig_type=std_logic lab=VOUT_I_P}
C {lab_pin.sym} 526.25 -838.75 0 1 {name=p15 sig_type=std_logic lab=VOUT_I_N}
C {lab_pin.sym} 395 -632.5 0 1 {name=p16 sig_type=std_logic lab=VOUT_Q_P}
C {lab_pin.sym} 521.25 -635 0 1 {name=p17 sig_type=std_logic lab=VOUT_Q_N}
C {ammeter.sym} 393.75 -722.5 0 0 {name=VoIP savecurrent=true spice_ignore=0}
C {ammeter.sym} 526.25 -718.75 0 0 {name=VoIN savecurrent=true spice_ignore=0}
C {res.sym} 395 -577.5 0 0 {name=R5
value=25
footprint=1206
device=resistor
m=1
savecurrent=true}
C {res.sym} 521.25 -575 0 0 {name=R6
value=25
footprint=1206
device=resistor
m=1}
C {gnd.sym} 521.25 -485 0 0 {name=l5 lab=0}
C {gnd.sym} 395 -487.5 0 0 {name=l6 lab=0}
C {ammeter.sym} 395 -517.5 0 0 {name=VoQP savecurrent=true spice_ignore=0}
C {ammeter.sym} 521.25 -515 0 0 {name=VoQN savecurrent=true spice_ignore=0}
C {lab_pin.sym} 262.5 -795 0 1 {name=p18 sig_type=std_logic lab=VOUT_Q_P}
C {lab_pin.sym} 262.5 -775 0 1 {name=p19 sig_type=std_logic lab=VOUT_Q_N}
C {lab_pin.sym} 262.5 -835 0 1 {name=p11 sig_type=std_logic lab=VOUT_I_P}
