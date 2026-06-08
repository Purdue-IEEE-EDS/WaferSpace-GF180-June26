v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 510 -1375 510 -1355 {lab=Vdd}
N 18.125 -1357.5 18.125 -1347.5 {lab=CMOS250M}
N 1721.25 -621.25 1721.25 -601.25 {lab=0}
N 1576.25 -626.25 1576.25 -606.25 {lab=0}
N 1576.25 -696.25 1576.25 -686.25 {lab=#net1}
N 1721.25 -691.25 1721.25 -681.25 {lab=#net2}
N 1721.25 -781.25 1721.25 -751.25 {lab=VoutN}
N 1576.25 -781.25 1576.25 -756.25 {lab=VoutP}
N 94.375 -1028.125 94.375 -980.625 {lab=dac_i_p[0..35]}
N 75 -1014.25 75.625 -1014.375 {lab=dac_i_p[0..35]}
N 74.375 -1013.125 75 -1014.25 {lab=dac_i_p[0..35]}
N 74.375 -1013.125 74.375 -1012.625 {lab=dac_i_p[0..35]}
N 73.125 -1012.5 74.375 -1012.625 {lab=dac_i_p[0..35]}
N 73.75 -1014.375 74.375 -1012.625 {lab=dac_i_p[0..35]}
N 74.375 -998.75 74.375 -998.125 {lab=dac_i_n[0..35]}
N 74.375 -998.75 75.625 -998.125 {lab=dac_i_n[0..35]}
N 73.75 -998.75 74.375 -998.625 {lab=dac_i_n[0..35]}
N 73.125 -1012.5 74.375 -1013.125 {lab=dac_i_p[0..35]}
N 73.75 -1023.75 73.75 -1014.375 {lab=dac_i_p[0..35]}
N 73.75 -1023.75 101.25 -1023.75 {lab=dac_i_p[0..35]}
N 101.25 -1023.75 101.875 -1024.375 {lab=dac_i_p[0..35]}
N 91.25 -1023.75 94.375 -1028.125 {lab=dac_i_p[0..35]}
N 101.25 -1025 101.25 -1023.75 {lab=dac_i_p[0..35]}
N 73.75 -1015 75.625 -1014.375 {lab=dac_i_p[0..35]}
N 190.625 -999.375 190.625 -951.875 {lab=dac_i_n[0..35]}
N 170 -995 197.5 -995 {lab=dac_i_n[0..35]}
N 197.5 -995 198.125 -995.625 {lab=dac_i_n[0..35]}
N 187.5 -995 190.625 -999.375 {lab=dac_i_n[0..35]}
N 197.5 -996.25 197.5 -995 {lab=dac_i_n[0..35]}
N 83.75 -995 170 -995 {lab=dac_i_n[0..35]}
N 83.75 -998.75 83.75 -995 {lab=dac_i_n[0..35]}
N 74.375 -998.75 83.75 -998.75 {lab=dac_i_n[0..35]}
C {simulator_commands_shown.sym} 630 -1475 0 0 {name=COMMANDS1
simulator=ngspice
only_toplevel=false 
value="
.save all

.param VCC=3.3
.control

pre_set auto_bridge_d_out = 
+ ( \\".model auto_dac dac_bridge(out_low=0.0 out_high=3.3 out_undef=1.8 input_load=1E-15 t_rise=50p t_fall=50p)\\" 
+ \\"auto_bridge%d [ %s ] [ %s ] auto_dac\\" )

tran 10p 600ns

plot i(Vl1)-i(Vl2)
let diff = i(Vl1)-i(Vl2)
plot dac_i0 dac_i_p0 dac_i_n0 dac_i_p1 dac_i_p2 dac_i_p33

.endc
"}
C {code_shown.sym} 390 -1515 0 0 {name=s1 only_toplevel=false value="
.op
.save all
"}
C {gnd.sym} 510 -1295 0 0 {name=l4 lab=0}
C {vsource.sym} 510 -1325 0 0 {name=Vdd value=3.3 savecurrent=true}
C {lab_pin.sym} 510 -1375 1 0 {name=p13 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 18.125 -1357.5 1 0 {name=p88 sig_type=std_logic lab=CMOS250M}
C {gnd.sym} 18.125 -1287.5 0 0 {name=l7 lab=0
spice_ignore=short}
C {vsource.sym} 18.125 -1317.5 0 0 {name=VClkP value="PULSE(0.0 3.3 0 30ps 30ps \{T*0.5\} \{T\})" savecurrent=true
}
C {res.sym} 1576.25 -726.25 0 0 {name=R3
value=25
footprint=1206
device=resistor
m=1
savecurrent=true}
C {res.sym} 1721.25 -721.25 0 0 {name=R4
value=25
footprint=1206
device=resistor
m=1}
C {gnd.sym} 1721.25 -601.25 0 0 {name=l15 lab=0}
C {gnd.sym} 1576.25 -606.25 0 0 {name=l16 lab=0}
C {vsource.sym} 1576.25 -656.25 0 0 {name=Vl1 value=0.0 savecurrent=true
}
C {vsource.sym} 1721.25 -651.25 0 0 {name=Vl2 value=0.0 savecurrent=true
}
C {lab_pin.sym} 1576.25 -781.25 0 1 {name=p18 sig_type=std_logic lab=VoutP}
C {lab_pin.sym} 1721.25 -781.25 0 1 {name=p19 sig_type=std_logic lab=VoutN}
C {opin.sym} 101.875 -1024.375 0 0 {name=p97 lab=dac_i_p[0..35]}
C {parax_cap.sym} 94.375 -970.625 0 0 {name=C0[0..35] gnd=0 value=1p m=1}
C {ams/main_dac_codegen.sym} -5.625 -990.625 0 0 {device_model=".model main_dac_codegen d_cosim simulation=\\"/foss/designs/dac/ams/main_dac_codegen.so\\""}
C {ipin.sym} -85.625 -990.625 0 0 {name=p96 lab=CMOS250M}
C {param.sym} -2.5 -1481.875 0 0 {name=s3 value="T=2500ps"}
C {iref/dac_iref.sym} 558.75 -818.125 0 0 {name=x3}
C {lab_pin.sym} 458.75 -838.125 2 1 {name=p1 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 658.75 -838.125 0 1 {name=p36 sig_type=std_logic lab=VPCas[2:0]}
C {lab_pin.sym} 658.75 -818.125 0 1 {name=p38 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} 658.75 -798.125 0 1 {name=p39 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} 474.375 -319.375 2 1 {name=p26 sig_type=std_logic lab=dac_i_p3}
C {lab_pin.sym} 474.375 -299.375 2 1 {name=p27 sig_type=std_logic lab=dac_i_n3}
C {lab_pin.sym} 474.375 -164.375 2 1 {name=p30 sig_type=std_logic lab=dac_i_n4}
C {lab_pin.sym} 474.375 -454.375 2 1 {name=p72 sig_type=std_logic lab=dac_i_p2}
C {lab_pin.sym} 474.375 -434.375 2 1 {name=p73 sig_type=std_logic lab=dac_i_n2}
C {lab_pin.sym} 474.375 -584.375 2 1 {name=p79 sig_type=std_logic lab=dac_i_p1}
C {lab_pin.sym} 474.375 -564.375 2 1 {name=p80 sig_type=std_logic lab=dac_i_n1}
C {lab_pin.sym} 474.375 -184.375 2 1 {name=p8 sig_type=std_logic lab=dac_i_p4}
C {lab_pin.sym} 474.375 -719.375 2 1 {name=p99 sig_type=std_logic lab=dac_i_p0}
C {lab_pin.sym} 474.375 -699.375 2 1 {name=p100 sig_type=std_logic lab=dac_i_n0}
C {cellv9/dac_cell_160ua_v9.sym} 574.375 -134.375 0 0 {name=x1}
C {cellv9/dac_cell_80ua_v9.sym} 574.375 -269.375 0 0 {name=x4}
C {cellv9/dac_cell_20ua_v9.sym} 574.375 -534.375 0 0 {name=x5}
C {cellv9/dac_cell_40ua_v9.sym} 574.375 -404.375 0 0 {name=x6}
C {cellv9/dac_cell_10ua_v9.sym} 574.375 -669.375 0 0 {name=x7}
C {lab_pin.sym} 474.375 -619.375 2 1 {name=p11 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 474.375 -639.375 2 1 {name=p25 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} 474.375 -659.375 2 1 {name=p12 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} 474.375 -679.375 2 1 {name=p14 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} 474.375 -484.375 2 1 {name=p17 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 474.375 -504.375 2 1 {name=p21 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} 474.375 -524.375 2 1 {name=p22 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} 474.375 -544.375 2 1 {name=p23 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} 474.375 -354.375 2 1 {name=p24 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 474.375 -374.375 2 1 {name=p28 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} 474.375 -394.375 2 1 {name=p32 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} 474.375 -414.375 2 1 {name=p46 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} 474.375 -219.375 2 1 {name=p47 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 474.375 -239.375 2 1 {name=p48 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} 474.375 -259.375 2 1 {name=p59 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} 474.375 -279.375 2 1 {name=p69 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} 474.375 -84.375 2 1 {name=p90 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 474.375 -104.375 2 1 {name=p70 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} 474.375 -124.375 2 1 {name=p71 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} 474.375 -144.375 2 1 {name=p74 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} 734.375 -299.375 0 1 {name=p81 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 734.375 -319.375 0 1 {name=p82 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 704.375 -319.375 3 0 {name=VB3P savecurrent=true spice_ignore=0}
C {ammeter.sym} 704.375 -299.375 3 0 {name=VB3N savecurrent=true spice_ignore=0}
C {lab_pin.sym} 734.375 -164.375 0 1 {name=p84 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 734.375 -184.375 0 1 {name=p98 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 704.375 -184.375 3 0 {name=VB4P savecurrent=true spice_ignore=0}
C {ammeter.sym} 704.375 -164.375 3 0 {name=VB4N savecurrent=true spice_ignore=0}
C {lab_pin.sym} 734.375 -564.375 0 1 {name=p128 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 734.375 -584.375 0 1 {name=p129 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 704.375 -584.375 3 0 {name=VB1P savecurrent=true spice_ignore=0}
C {ammeter.sym} 704.375 -564.375 3 0 {name=VB1N savecurrent=true spice_ignore=0}
C {lab_pin.sym} 734.375 -699.375 0 1 {name=p130 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 734.375 -719.375 0 1 {name=p131 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 704.375 -719.375 3 0 {name=VB0P savecurrent=true spice_ignore=0}
C {ammeter.sym} 704.375 -699.375 3 0 {name=VB0N savecurrent=true spice_ignore=0}
C {lab_pin.sym} 734.375 -434.375 0 1 {name=p132 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 734.375 -454.375 0 1 {name=p133 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 704.375 -454.375 3 0 {name=VB2P savecurrent=true spice_ignore=0}
C {ammeter.sym} 704.375 -434.375 3 0 {name=VB2N savecurrent=true spice_ignore=0}
C {lab_pin.sym} 1007.5 -745.625 2 1 {name=p437 sig_type=std_logic lab=dac_i_p[5..35]}
C {cellv9/dac_cell_320ua_v9.sym} 1107.5 -695.625 0 0 {name=x2[0..30]}
C {lab_pin.sym} 1007.5 -645.625 2 1 {name=p438 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 1007.5 -665.625 2 1 {name=p439 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} 1007.5 -685.625 2 1 {name=p440 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} 1007.5 -705.625 2 1 {name=p441 sig_type=std_logic lab=VPCas[1]}
C {lab_pin.sym} 1007.5 -725.625 2 1 {name=p444 sig_type=std_logic lab=dac_i_n[5..35]}
C {lab_pin.sym} 1267.5 -725.625 0 1 {name=p2 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 1267.5 -745.625 0 1 {name=p3 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 1237.5 -745.625 3 0 {name=VUP[0..30] savecurrent=true spice_ignore=0}
C {ammeter.sym} 1237.5 -725.625 3 0 {name=VUN[0..30] savecurrent=true spice_ignore=0}
C {opin.sym} 198.125 -995.625 0 0 {name=p5 lab=dac_i_n[0..35]}
C {parax_cap.sym} 190.625 -941.875 0 0 {name=C1[0..35] gnd=0 value=1p m=1}
C {code_shown.sym} 607.5 -1673.75 0 0 {name=s2 only_toplevel=false value=
"
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical
"}
