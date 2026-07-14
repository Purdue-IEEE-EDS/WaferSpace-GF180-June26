v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Master IREF=10uA} -1.25 -752.5 0 0 0.2 0.2 {}
N 510 -1375 510 -1355 {lab=Vdd}
N 18.125 -1357.5 18.125 -1347.5 {lab=CLK}
N 905 -1023.75 905 -993.75 {lab=VOUT_I_N}
N 772.5 -1022.5 772.5 -997.5 {lab=VOUT_I_P}
N 94.375 -1028.125 94.375 -980.625 {lab=dac_i_p[35..0]}
N 75 -1014.25 75.625 -1014.375 {lab=dac_i_p[35..0]}
N 74.375 -1013.125 75 -1014.25 {lab=dac_i_p[35..0]}
N 74.375 -1013.125 74.375 -1012.625 {lab=dac_i_p[35..0]}
N 73.125 -1012.5 74.375 -1012.625 {lab=dac_i_p[35..0]}
N 73.75 -1014.375 74.375 -1012.625 {lab=dac_i_p[35..0]}
N 74.375 -998.75 74.375 -998.125 {lab=dac_i_n[35..0]}
N 74.375 -998.75 75.625 -998.125 {lab=dac_i_n[35..0]}
N 73.75 -998.75 74.375 -998.625 {lab=dac_i_n[35..0]}
N 73.125 -1012.5 74.375 -1013.125 {lab=dac_i_p[35..0]}
N 73.75 -1023.75 73.75 -1014.375 {lab=dac_i_p[35..0]}
N 73.75 -1023.75 101.25 -1023.75 {lab=dac_i_p[35..0]}
N 101.25 -1023.75 101.875 -1024.375 {lab=dac_i_p[35..0]}
N 91.25 -1023.75 94.375 -1028.125 {lab=dac_i_p[35..0]}
N 101.25 -1025 101.25 -1023.75 {lab=dac_i_p[35..0]}
N 73.75 -1015 75.625 -1014.375 {lab=dac_i_p[35..0]}
N 190.625 -999.375 190.625 -951.875 {lab=dac_i_n[35..0]}
N 170 -995 197.5 -995 {lab=dac_i_n[35..0]}
N 197.5 -995 198.125 -995.625 {lab=dac_i_n[35..0]}
N 187.5 -995 190.625 -999.375 {lab=dac_i_n[35..0]}
N 197.5 -996.25 197.5 -995 {lab=dac_i_n[35..0]}
N 83.75 -995 170 -995 {lab=dac_i_n[35..0]}
N 83.75 -998.75 83.75 -995 {lab=dac_i_n[35..0]}
N 74.375 -998.75 83.75 -998.75 {lab=dac_i_n[35..0]}
N 74.375 -982.625 107.5 -1095 {lab=dac_q_p[35..0]}
N 107.5 -1095 111.875 -1094.375 {lab=dac_q_p[35..0]}
N 111.875 -1094.375 112.5 -1095 {lab=dac_q_p[35..0]}
N 71.25 -982.5 74.375 -982.625 {lab=dac_q_p[35..0]}
N 74.375 -982.625 75 -983.75 {lab=dac_q_p[35..0]}
N 111.875 -1141.875 111.875 -1094.375 {lab=dac_q_p[35..0]}
N 900 -820 900 -790 {lab=VOUT_Q_N}
N 773.75 -817.5 773.75 -792.5 {lab=VOUT_Q_P}
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

tran 50p 600ns

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
C {lab_pin.sym} 18.125 -1357.5 1 0 {name=p88 sig_type=std_logic lab=CLK}
C {gnd.sym} 18.125 -1287.5 0 0 {name=l7 lab=0
spice_ignore=short}
C {vsource.sym} 18.125 -1317.5 0 0 {name=VClkP value="PULSE(0.0 3.3 0 30ps 30ps \{T*0.5\} \{T\})" savecurrent=true
}
C {res.sym} 772.5 -967.5 0 0 {name=R3
value=25
footprint=1206
device=resistor
m=1
savecurrent=true}
C {res.sym} 905 -963.75 0 0 {name=R4
value=25
footprint=1206
device=resistor
m=1}
C {gnd.sym} 905 -873.75 0 0 {name=l15 lab=0}
C {gnd.sym} 772.5 -877.5 0 0 {name=l16 lab=0}
C {lab_pin.sym} 772.5 -1022.5 0 1 {name=p18 sig_type=std_logic lab=VOUT_I_P}
C {lab_pin.sym} 905 -1023.75 0 1 {name=p19 sig_type=std_logic lab=VOUT_I_N}
C {opin.sym} 101.875 -1024.375 0 0 {name=p97 lab=dac_i_p[35..0]}
C {parax_cap.sym} 94.375 -970.625 0 0 {name=C0[35..0] gnd=0 value=1p m=1}
C {ams/main_dac_codegen.sym} -5.625 -990.625 0 0 {device_model=".model main_dac_codegen d_cosim simulation=\\"/foss/designs/dac/ams/main_dac_codegen.so\\""}
C {ipin.sym} -85.625 -990.625 0 0 {name=p96 lab=CLK}
C {param.sym} -2.5 -1481.875 0 0 {name=s3 value="T=1000ps"}
C {opin.sym} 198.125 -995.625 0 0 {name=p5 lab=dac_i_n[35..0]}
C {parax_cap.sym} 190.625 -941.875 0 0 {name=C1[35..0] gnd=0 value=1p m=1}
C {code_shown.sym} 607.5 -1673.75 0 0 {name=s2 only_toplevel=false value=
"
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical
"}
C {dac.sym} 440 -770 0 0 {name=x1}
C {lab_pin.sym} 340 -730 2 1 {name=p1 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 340 -810 2 1 {name=p3 sig_type=std_logic lab=dac_i_p[35:0]}
C {lab_pin.sym} 340 -790 2 1 {name=p4 sig_type=std_logic lab=dac_q_p[35:0]}
C {opin.sym} 111.875 -1094.375 0 0 {name=p2 lab=dac_q_p[35..0]}
C {parax_cap.sym} 111.875 -1151.875 2 0 {name=C2[35..0] gnd=0 value=1p m=1}
C {isource.sym} -17.5 -777.5 0 0 {name=Iref2 value="DC 10uA AC 0"}
C {gnd.sym} -17.5 -747.5 0 0 {name=l1 lab=0}
C {lab_pin.sym} -17.5 -807.5 2 1 {name=p6 sig_type=std_logic lab=IREF_MASTER_10UA}
C {lab_pin.sym} 340 -750 2 1 {name=p7 sig_type=std_logic lab=IREF_MASTER_10UA}
C {lab_pin.sym} 340 -770 2 1 {name=p8 sig_type=std_logic lab=CLK}
C {lab_pin.sym} 540 -770 0 1 {name=p9 sig_type=std_logic lab=VOUT_Q_P}
C {lab_pin.sym} 540 -750 0 1 {name=p10 sig_type=std_logic lab=VOUT_Q_N}
C {lab_pin.sym} 540 -790 0 1 {name=p20 sig_type=std_logic lab=VOUT_I_N}
C {lab_pin.sym} 540 -810 0 1 {name=p16 sig_type=std_logic lab=VOUT_I_P}
C {lab_pin.sym} 773.75 -817.5 0 1 {name=p11 sig_type=std_logic lab=VOUT_Q_P}
C {lab_pin.sym} 900 -820 0 1 {name=p12 sig_type=std_logic lab=VOUT_Q_N}
C {ammeter.sym} 772.5 -907.5 0 0 {name=VoIP savecurrent=true spice_ignore=0}
C {ammeter.sym} 905 -903.75 0 0 {name=VoIN savecurrent=true spice_ignore=0}
C {res.sym} 773.75 -762.5 0 0 {name=R1
value=25
footprint=1206
device=resistor
m=1
savecurrent=true}
C {res.sym} 900 -760 0 0 {name=R2
value=25
footprint=1206
device=resistor
m=1}
C {gnd.sym} 900 -670 0 0 {name=l2 lab=0}
C {gnd.sym} 773.75 -672.5 0 0 {name=l3 lab=0}
C {ammeter.sym} 773.75 -702.5 0 0 {name=VoIP1 savecurrent=true spice_ignore=0}
C {ammeter.sym} 900 -700 0 0 {name=VoIN1 savecurrent=true spice_ignore=0}
