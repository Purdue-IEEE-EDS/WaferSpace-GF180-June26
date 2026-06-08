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

tran 1p 20ns
* plot VU1syncP+6 VU1syncN+6 VU2syncP+6 VU2syncN+6 VgN+12 VgP Dm ClkP+18 ClkN+18 i(Vl1)*5E4-6 i(Vl2)*5E4-6 (i(Vl1)-i(Vl2))*5E4-12
* plot ClkP+6 ClkN+6 VU0in VB1in VU0syncP-6 VU0syncN-12 VB1syncP-6 VB1syncN-12
* plot Vout1P+15E-3 Vout1N+15E-3 Vout1P-Vout1N
plot ClkP+5 ClkN+5 VB3bufP-5 VB3bufN-5 x1.Vg1P-10 x1.Vg1N-10 x2.Vg1P-15 x2.Vg1N-15

plot i(VB3P)-i(VB3N) i(VU0P)-i(VU0N) i(VB4P)-i(VB4N) i(VB2P)-i(VB2N) i(VB1P)-i(VB1N)

let diff = i(Vl1)-i(Vl2)

let imax = 630E-6
let imin = -630E-6
plot pulseP \{diff/\{imax\}\}*5 fghz

plot VoutP VoutN pulseP+5 pulseN+5

plot i(Vl1)-i(Vl2) imax imin fghz*100E-6
plot i(Vdd)

plot i(VU0P) i(VU0N)
plot i(VU0P)-i(VU0N)

* plot i(VoutB3P)+100E-6 i(VoutB3N)+100E-6 i(VoutB3P)-i(VoutB3N) i(VoutB3N)+i(VoutB3P) i(v.x1.Vcrr1)-200E-6 i(v.x1.Vcrr2)-200E-6
* plot i(Vl1) VB1in/5E4+200E-6 VU0in/5E4+200E-6
* wrdata /foss/designs/dds/dac_isource_unary_pmos_80ua_v4_tt_500ps.csv ClkP ClkN Din VdsyncP VdsyncN i(Vl1) i(Vl2) 
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
C {lab_pin.sym} -721.25 -541.25 2 0 {name=p2 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -721.25 -571.25 0 0 {name=VB3 value="0.0" savecurrent=true
}
C {lab_pin.sym} -616.25 -541.25 2 0 {name=p8 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {code_shown.sym} -96.25 -1696.25 0 0 {name=s5 only_toplevel=false value=".param fs=0.5G fe=4G Tsw=20ns Vhi=3.3 Vlo=0
Bphase phase 0 V = (fs*Tsw/ln(fe/fs)) * ((fe/fs)^(time/Tsw) - 1)
BpulseP pulseP 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vhi : Vlo
BpulseN pulseN 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vlo : Vhi
Bfghz  fghz  0 V = (fs * (fe/fs)^(time/Tsw)) / 1e9

"}
C {lab_pin.sym} -721.25 -356.25 2 0 {name=p33 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -721.25 -386.25 0 0 {name=VB6 value="0.0" savecurrent=true
}
C {vsource.sym} -616.25 -386.25 0 0 {name=VB7 value="0.0" savecurrent=true
}
C {vsource.sym} -616.25 -571.25 0 0 {name=VB8 value="0.0" savecurrent=true
}
C {lab_pin.sym} -616.25 -356.25 2 0 {name=p37 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {lab_pin.sym} -721.25 -416.25 2 0 {name=p41 sig_type=std_logic lab=VU0bufP
value="DC 3.3"
}
C {lab_pin.sym} -616.25 -601.25 2 0 {name=p42 sig_type=std_logic lab=VB3bufN
value="DC 3.3"
}
C {lab_pin.sym} -616.25 -416.25 2 0 {name=p45 sig_type=std_logic lab=VU0bufN
value="DC 3.3"
}
C {lab_pin.sym} -721.25 -601.25 2 0 {name=p7 sig_type=std_logic lab=VB3bufP}
C {lab_pin.sym} -721.25 -631.25 2 0 {name=p50 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -721.25 -661.25 0 0 {name=VB1 value="0.0" savecurrent=true
}
C {lab_pin.sym} -616.25 -631.25 2 0 {name=p53 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {vsource.sym} -616.25 -661.25 0 0 {name=VB13 value="0.0" savecurrent=true
}
C {lab_pin.sym} -616.25 -691.25 2 0 {name=p56 sig_type=std_logic lab=VB2bufN
value="DC 3.3"
}
C {lab_pin.sym} -721.25 -691.25 2 0 {name=p58 sig_type=std_logic lab=VB2bufP}
C {lab_pin.sym} -721.25 -451.25 2 0 {name=p60 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -721.25 -481.25 0 0 {name=VB16 value="0.0" savecurrent=true
}
C {lab_pin.sym} -616.25 -451.25 2 0 {name=p63 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {vsource.sym} -616.25 -481.25 0 0 {name=VB18 value="0.0" savecurrent=true
}
C {lab_pin.sym} -616.25 -511.25 2 0 {name=p66 sig_type=std_logic lab=VB4bufN
value="DC 3.3"
}
C {lab_pin.sym} -721.25 -511.25 2 0 {name=p68 sig_type=std_logic lab=VB4bufP}
C {lab_pin.sym} -721.25 -721.25 2 0 {name=p84 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -721.25 -751.25 0 0 {name=VB21 value="0.0" savecurrent=true
}
C {lab_pin.sym} -616.25 -721.25 2 0 {name=p87 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {vsource.sym} -616.25 -751.25 0 0 {name=VB23 value="0.0" savecurrent=true
}
C {lab_pin.sym} -616.25 -781.25 2 0 {name=p93 sig_type=std_logic lab=VB1bufN
value="DC 3.3"
}
C {lab_pin.sym} -721.25 -781.25 2 0 {name=p95 sig_type=std_logic lab=VB1bufP}
C {lab_pin.sym} -211.25 -521.25 2 1 {name=p26 sig_type=std_logic lab=VB3bufP}
C {lab_pin.sym} -211.25 -501.25 2 1 {name=p27 sig_type=std_logic lab=VB3bufN}
C {lab_pin.sym} -211.25 -251.25 2 1 {name=p15 sig_type=std_logic lab=VU0bufP}
C {lab_pin.sym} -211.25 -231.25 2 1 {name=p16 sig_type=std_logic lab=VU0bufN}
C {lab_pin.sym} -211.25 -366.25 2 1 {name=p30 sig_type=std_logic lab=VB4bufN}
C {lab_pin.sym} -211.25 -656.25 2 1 {name=p72 sig_type=std_logic lab=VB2bufP}
C {lab_pin.sym} -211.25 -636.25 2 1 {name=p73 sig_type=std_logic lab=VB2bufN}
C {lab_pin.sym} -211.25 -786.25 2 1 {name=p79 sig_type=std_logic lab=VB1bufP}
C {lab_pin.sym} -211.25 -766.25 2 1 {name=p80 sig_type=std_logic lab=VB1bufN}
C {lab_pin.sym} -211.25 -386.25 2 1 {name=p4 sig_type=std_logic lab=VB4bufP}
C {lab_pin.sym} -211.25 -921.25 2 1 {name=p99 sig_type=std_logic lab=VB0bufP}
C {lab_pin.sym} -211.25 -901.25 2 1 {name=p100 sig_type=std_logic lab=VB0bufN}
C {lab_pin.sym} -721.25 -811.25 2 0 {name=p5 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -721.25 -841.25 0 0 {name=VB2 value="0.0" savecurrent=true
}
C {lab_pin.sym} -616.25 -811.25 2 0 {name=p6 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {vsource.sym} -616.25 -841.25 0 0 {name=VB4 value="0.0" savecurrent=true
}
C {lab_pin.sym} -616.25 -871.25 2 0 {name=p9 sig_type=std_logic lab=VB0bufN
value="DC 3.3"
}
C {lab_pin.sym} -721.25 -871.25 2 0 {name=p10 sig_type=std_logic lab=VB0bufP}
C {cellv9/dac_cell_160ua_v9.sym} -111.25 -336.25 0 0 {name=x8}
C {cellv9/dac_cell_320ua_v9.sym} -111.25 -201.25 0 0 {name=x9}
C {cellv9/dac_cell_80ua_v9.sym} -111.25 -471.25 0 0 {name=x3}
C {cellv9/dac_cell_20ua_v9.sym} -111.25 -736.25 0 0 {name=x11}
C {cellv9/dac_cell_40ua_v9.sym} -111.25 -606.25 0 0 {name=x1}
C {cellv9/dac_cell_10ua_v9.sym} -111.25 -871.25 0 0 {name=x2}
C {lab_pin.sym} -211.25 -821.25 2 1 {name=p1 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -211.25 -841.25 2 1 {name=p25 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -211.25 -861.25 2 1 {name=p31 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -211.25 -881.25 2 1 {name=p34 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} -211.25 -686.25 2 1 {name=p35 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -211.25 -706.25 2 1 {name=p40 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -211.25 -726.25 2 1 {name=p43 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -211.25 -746.25 2 1 {name=p44 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} -211.25 -556.25 2 1 {name=p49 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -211.25 -576.25 2 1 {name=p51 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -211.25 -596.25 2 1 {name=p52 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -211.25 -616.25 2 1 {name=p54 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} -211.25 -421.25 2 1 {name=p55 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -211.25 -441.25 2 1 {name=p57 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -211.25 -461.25 2 1 {name=p61 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -211.25 -481.25 2 1 {name=p62 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} -211.25 -286.25 2 1 {name=p90 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -211.25 -306.25 2 1 {name=p91 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -211.25 -326.25 2 1 {name=p92 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -211.25 -346.25 2 1 {name=p94 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} -211.25 -151.25 2 1 {name=p96 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -211.25 -171.25 2 1 {name=p97 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -211.25 -191.25 2 1 {name=p103 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -211.25 -211.25 2 1 {name=p104 sig_type=std_logic lab=VPCas[1]}
C {lab_pin.sym} 48.75 -501.25 0 1 {name=p11 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 48.75 -521.25 0 1 {name=p12 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 18.75 -521.25 3 0 {name=VB3P savecurrent=true spice_ignore=0}
C {ammeter.sym} 18.75 -501.25 3 0 {name=VB3N savecurrent=true spice_ignore=0}
C {lab_pin.sym} 48.75 -366.25 0 1 {name=p3 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 48.75 -386.25 0 1 {name=p14 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 18.75 -386.25 3 0 {name=VB4P savecurrent=true spice_ignore=0}
C {ammeter.sym} 18.75 -366.25 3 0 {name=VB4N savecurrent=true spice_ignore=0}
C {lab_pin.sym} 48.75 -231.25 0 1 {name=p17 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 48.75 -251.25 0 1 {name=p20 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 18.75 -251.25 3 0 {name=VU0P savecurrent=true spice_ignore=0}
C {ammeter.sym} 18.75 -231.25 3 0 {name=VU0N savecurrent=true spice_ignore=0}
C {lab_pin.sym} 48.75 -766.25 0 1 {name=p21 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 48.75 -786.25 0 1 {name=p22 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 18.75 -786.25 3 0 {name=VB1P savecurrent=true spice_ignore=0}
C {ammeter.sym} 18.75 -766.25 3 0 {name=VB1N savecurrent=true spice_ignore=0}
C {lab_pin.sym} 48.75 -901.25 0 1 {name=p23 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 48.75 -921.25 0 1 {name=p24 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 18.75 -921.25 3 0 {name=VB0P savecurrent=true spice_ignore=0}
C {ammeter.sym} 18.75 -901.25 3 0 {name=VB0N savecurrent=true spice_ignore=0}
C {lab_pin.sym} 48.75 -636.25 0 1 {name=p28 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 48.75 -656.25 0 1 {name=p29 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 18.75 -656.25 3 0 {name=VB2P savecurrent=true spice_ignore=0}
C {ammeter.sym} 18.75 -636.25 3 0 {name=VB2N savecurrent=true spice_ignore=0}
C {iref/dac_iref.sym} -120 -1040 0 0 {name=x4}
C {lab_pin.sym} -220 -1060 2 1 {name=p32 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -20 -1040 0 1 {name=p38 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -20 -1020 0 1 {name=p39 sig_type=std_logic lab=VNCas}
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
C {lab_pin.sym} -20 -1060 0 1 {name=p65 sig_type=std_logic lab=VPCas[2:0]}
