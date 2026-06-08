v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 410 -1225 410 -1205 {lab=Vdd}
N 645 -630 645 -610 {lab=0}
N 540 -625 540 -605 {lab=0}
N 540 -695 540 -685 {lab=#net1}
N 645 -700 645 -690 {lab=#net2}
C {simulator_commands_shown.sym} 630 -1475 0 0 {name=COMMANDS1
simulator=ngspice
only_toplevel=false 
value="
.save all
.control

tran 1p 10ns
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
C {gnd.sym} 410 -1145 0 0 {name=l4 lab=0}
C {vsource.sym} 410 -1175 0 0 {name=Vdd value=3.3 savecurrent=true}
C {lab_pin.sym} 410 -1225 1 0 {name=p13 sig_type=std_logic lab=Vdd}
C {res.sym} 540 -725 0 0 {name=R3
value=25
footprint=1206
device=resistor
m=1
savecurrent=true}
C {res.sym} 645 -730 0 0 {name=R4
value=25
footprint=1206
device=resistor
m=1}
C {gnd.sym} 645 -610 0 0 {name=l15 lab=0}
C {gnd.sym} 540 -605 0 0 {name=l16 lab=0}
C {vsource.sym} 540 -655 0 0 {name=Vl1 value=0.0 savecurrent=true
}
C {vsource.sym} 645 -660 0 0 {name=Vl2 value=0.0 savecurrent=true
}
C {lab_pin.sym} 540 -755 0 1 {name=p18 sig_type=std_logic lab=VoutP}
C {lab_pin.sym} 645 -760 0 1 {name=p19 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} -630 -555 2 0 {name=p2 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -630 -585 0 0 {name=VB3 value="0.0" savecurrent=true
}
C {lab_pin.sym} -525 -555 2 0 {name=p8 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {code_shown.sym} -875 -1075 0 0 {name=s5 only_toplevel=false value=".param fs=0.5G fe=4G Tsw=15ns Vhi=3.3 Vlo=0
Bphase phase 0 V = (fs*Tsw/ln(fe/fs)) * ((fe/fs)^(time/Tsw) - 1)
BpulseP pulseP 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vhi : Vlo
BpulseN pulseN 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vlo : Vhi
Bfghz  fghz  0 V = (fs * (fe/fs)^(time/Tsw)) / 1e9

"}
C {lab_pin.sym} -630 -370 2 0 {name=p33 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -630 -400 0 0 {name=VB6 value="0.0" savecurrent=true
}
C {vsource.sym} -525 -400 0 0 {name=VB7 value="0.0" savecurrent=true
}
C {vsource.sym} -525 -585 0 0 {name=VB8 value="0.0" savecurrent=true
}
C {lab_pin.sym} -525 -370 2 0 {name=p37 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {lab_pin.sym} -630 -430 2 0 {name=p41 sig_type=std_logic lab=VU0bufP
value="DC 3.3"
}
C {lab_pin.sym} -525 -615 2 0 {name=p42 sig_type=std_logic lab=VB3bufN
value="DC 3.3"
}
C {lab_pin.sym} -525 -430 2 0 {name=p45 sig_type=std_logic lab=VU0bufN
value="DC 3.3"
}
C {lab_pin.sym} -630 -615 2 0 {name=p7 sig_type=std_logic lab=VB3bufP}
C {lab_pin.sym} -630 -645 2 0 {name=p50 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -630 -675 0 0 {name=VB1 value="0.0" savecurrent=true
}
C {lab_pin.sym} -525 -645 2 0 {name=p53 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {vsource.sym} -525 -675 0 0 {name=VB13 value="0.0" savecurrent=true
}
C {lab_pin.sym} -525 -705 2 0 {name=p56 sig_type=std_logic lab=VB2bufN
value="DC 3.3"
}
C {lab_pin.sym} -630 -705 2 0 {name=p58 sig_type=std_logic lab=VB2bufP}
C {lab_pin.sym} -630 -465 2 0 {name=p60 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -630 -495 0 0 {name=VB16 value="0.0" savecurrent=true
}
C {lab_pin.sym} -525 -465 2 0 {name=p63 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {vsource.sym} -525 -495 0 0 {name=VB18 value="0.0" savecurrent=true
}
C {lab_pin.sym} -525 -525 2 0 {name=p66 sig_type=std_logic lab=VB4bufN
value="DC 3.3"
}
C {lab_pin.sym} -630 -525 2 0 {name=p68 sig_type=std_logic lab=VB4bufP}
C {lab_pin.sym} -630 -735 2 0 {name=p84 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -630 -765 0 0 {name=VB21 value="0.0" savecurrent=true
}
C {lab_pin.sym} -525 -735 2 0 {name=p87 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {vsource.sym} -525 -765 0 0 {name=VB23 value="0.0" savecurrent=true
}
C {lab_pin.sym} -525 -795 2 0 {name=p93 sig_type=std_logic lab=VB1bufN
value="DC 3.3"
}
C {lab_pin.sym} -630 -795 2 0 {name=p95 sig_type=std_logic lab=VB1bufP}
C {lab_pin.sym} -630 -825 2 0 {name=p5 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -630 -855 0 0 {name=VB2 value="0.0" savecurrent=true
}
C {lab_pin.sym} -525 -825 2 0 {name=p6 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {vsource.sym} -525 -855 0 0 {name=VB4 value="0.0" savecurrent=true
}
C {lab_pin.sym} -525 -885 2 0 {name=p9 sig_type=std_logic lab=VB0bufN
value="DC 3.3"
}
C {lab_pin.sym} -630 -885 2 0 {name=p10 sig_type=std_logic lab=VB0bufP}
C {lab_pin.sym} -21.25 158.75 2 1 {name=p293 sig_type=std_logic lab=VB3bufP}
C {lab_pin.sym} -21.25 178.75 2 1 {name=p294 sig_type=std_logic lab=VB3bufN}
C {lab_pin.sym} 443.125 -316.25 2 1 {name=p295 sig_type=std_logic lab=VU0bufP}
C {lab_pin.sym} 443.125 -296.25 2 1 {name=p296 sig_type=std_logic lab=VU0bufN}
C {lab_pin.sym} -21.25 333.75 2 1 {name=p297 sig_type=std_logic lab=VB4bufN}
C {lab_pin.sym} -21.25 3.75 2 1 {name=p298 sig_type=std_logic lab=VB2bufP}
C {lab_pin.sym} -21.25 23.75 2 1 {name=p299 sig_type=std_logic lab=VB2bufN}
C {lab_pin.sym} -21.25 -156.25 2 1 {name=p300 sig_type=std_logic lab=VB1bufP}
C {lab_pin.sym} -21.25 -136.25 2 1 {name=p301 sig_type=std_logic lab=VB1bufN}
C {lab_pin.sym} -21.25 313.75 2 1 {name=p302 sig_type=std_logic lab=VB4bufP}
C {lab_pin.sym} -21.25 -311.25 2 1 {name=p303 sig_type=std_logic lab=VB0bufP}
C {lab_pin.sym} -21.25 -291.25 2 1 {name=p304 sig_type=std_logic lab=VB0bufN}
C {cellv9/dac_cell_160ua_v9.sym} 78.75 363.75 0 0 {name=x38}
C {cellv9/dac_cell_80ua_v9.sym} 78.75 208.75 0 0 {name=x40}
C {cellv9/dac_cell_20ua_v9.sym} 78.75 -106.25 0 0 {name=x41}
C {cellv9/dac_cell_40ua_v9.sym} 78.75 53.75 0 0 {name=x42}
C {cellv9/dac_cell_10ua_v9.sym} 78.75 -261.25 0 0 {name=x43}
C {lab_pin.sym} -21.25 -211.25 2 1 {name=p305 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -21.25 -231.25 2 1 {name=p306 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -21.25 -251.25 2 1 {name=p307 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -21.25 -271.25 2 1 {name=p308 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} -21.25 -56.25 2 1 {name=p309 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -21.25 -76.25 2 1 {name=p310 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -21.25 -96.25 2 1 {name=p311 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -21.25 -116.25 2 1 {name=p312 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} -21.25 103.75 2 1 {name=p313 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -21.25 83.75 2 1 {name=p314 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -21.25 63.75 2 1 {name=p315 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -21.25 43.75 2 1 {name=p316 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} -21.25 258.75 2 1 {name=p317 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -21.25 238.75 2 1 {name=p318 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -21.25 218.75 2 1 {name=p319 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -21.25 198.75 2 1 {name=p320 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} -21.25 413.75 2 1 {name=p321 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -21.25 393.75 2 1 {name=p322 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -21.25 373.75 2 1 {name=p323 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -21.25 353.75 2 1 {name=p324 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} 238.75 178.75 0 1 {name=p329 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 238.75 158.75 0 1 {name=p330 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 208.75 158.75 3 0 {name=VB3P savecurrent=true spice_ignore=0}
C {ammeter.sym} 208.75 178.75 3 0 {name=VB3N savecurrent=true spice_ignore=0}
C {lab_pin.sym} 238.75 333.75 0 1 {name=p331 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 238.75 313.75 0 1 {name=p332 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 208.75 313.75 3 0 {name=VB4P savecurrent=true spice_ignore=0}
C {ammeter.sym} 208.75 333.75 3 0 {name=VB4N savecurrent=true spice_ignore=0}
C {lab_pin.sym} 238.75 -136.25 0 1 {name=p335 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 238.75 -156.25 0 1 {name=p336 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 208.75 -156.25 3 0 {name=VB1P savecurrent=true spice_ignore=0}
C {ammeter.sym} 208.75 -136.25 3 0 {name=VB1N savecurrent=true spice_ignore=0}
C {lab_pin.sym} 238.75 -291.25 0 1 {name=p337 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 238.75 -311.25 0 1 {name=p338 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 208.75 -311.25 3 0 {name=VB0P savecurrent=true spice_ignore=0}
C {ammeter.sym} 208.75 -291.25 3 0 {name=VB0N savecurrent=true spice_ignore=0}
C {lab_pin.sym} 238.75 23.75 0 1 {name=p339 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 238.75 3.75 0 1 {name=p340 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 208.75 3.75 3 0 {name=VB2P savecurrent=true spice_ignore=0}
C {ammeter.sym} 208.75 23.75 3 0 {name=VB2N savecurrent=true spice_ignore=0}
C {iref/dac_iref.sym} 40 -460 0 0 {name=x6}
C {lab_pin.sym} -60 -480 2 1 {name=p128 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 140 -480 0 1 {name=p129 sig_type=std_logic lab=VPCas[2:0]}
C {lab_pin.sym} 140 -460 0 1 {name=p130 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} 140 -440 0 1 {name=p131 sig_type=std_logic lab=VNCas}
C {cellv9/dac_cell_320ua_v9.sym} 543.125 -266.25 0 0 {name=x5[0..30]}
C {lab_pin.sym} 443.125 -216.25 2 1 {name=p438 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 443.125 -236.25 2 1 {name=p439 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} 443.125 -256.25 2 1 {name=p440 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} 443.125 -276.25 2 1 {name=p441 sig_type=std_logic lab=VPCas[1]}
C {lab_pin.sym} 703.125 -296.25 0 1 {name=p132 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 703.125 -316.25 0 1 {name=p133 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 673.125 -316.25 3 0 {name=VUP[0..30] savecurrent=true spice_ignore=0}
C {ammeter.sym} 673.125 -296.25 3 0 {name=VUN[0..30] savecurrent=true spice_ignore=0}
C {code_shown.sym} 620 -1670 0 0 {name=s3 only_toplevel=false value=
"
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical
"}
