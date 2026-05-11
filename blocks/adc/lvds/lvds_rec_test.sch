v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 180 -40 230 -40 {lab=#net1}
N -180 -40 -120 -40 {lab=Vdd}
N -180 20 -120 20 {lab=Vbias}
N -240 -20 -170 -20 {lab=#net2}
N -240 0 -170 -0 {lab=#net3}
N -160 -260 -160 -45 {lab=Vdd}
N -575 -260 -160 -260 {lab=Vdd}
N -575 -260 -575 -45 {lab=Vdd}
N -575 -45 -575 -35 {lab=Vdd}
N -575 -35 -530 -35 {lab=Vdd}
N -160 -45 -160 -40 {lab=Vdd}
N -595 125 -595 185 {lab=vref}
N -595 245 -595 295 {lab=GND}
N -595 145 -575 145 {lab=vref}
N -575 25 -575 145 {lab=vref}
N -575 25 -530 25 {lab=vref}
N -1060 25 -1060 85 {lab=vin-}
N -1060 145 -1060 195 {lab=GND}
N -840 25 -840 85 {lab=vin+}
N -840 145 -840 195 {lab=GND}
N -840 55 -740 55 {lab=vin+}
N -740 10 -740 55 {lab=vin+}
N -740 5 -740 10 {lab=vin+}
N -740 5 -530 5 {lab=vin+}
N -1005 -20 -1005 50 {lab=vin-}
N -1060 50 -1005 50 {lab=vin-}
N -1005 -15 -530 -15 {lab=vin-}
N -170 -20 -120 -20 {lab=#net2}
N -170 -0 -120 0 {lab=#net3}
N -165 20 -165 105 {lab=Vbias}
N -165 165 -165 205 {lab=GND}
N -657.5 -70 -657.5 -55 {lab=GND}
N -165 205 -165 210 {lab=GND}
N -657.5 -130 -575 -130 {lab=Vdd}
C {code_shown.sym} 150 -540 0 0 {name=s1 only_toplevel=false value="
.param VDD=3.3
.param VCM=1.2
.param VDIFF=0.3
.param FREQ=1G
.param VBIAS=1.65

Vdd   Vdd   0 \{VDD\}
Vbias Vbias 0 \{VBIAS\}


.tran 1p 5n
.save all

.control 
run 
plot v(net1) v(net2) v(net3)
plot v(net2) v(net3)
.endc
"}
C {lab_pin.sym} -180 20 0 0 {name=p2 sig_type=std_logic lab=Vbias
}
C {lab_pin.sym} -180 -40 0 0 {name=p3 sig_type=std_logic lab=Vdd}
C {/foss/designs/adc_lvds/lvds_v3.sym} -380 -5 0 0 {name=x2}
C {vsource.sym} -595 215 0 0 {name=V2 value=1.65 savecurrent=false}
C {gnd.sym} -595 295 0 0 {name=l10 lab=GND}
C {lab_wire.sym} -595 125 0 0 {name=p16 sig_type=std_logic lab=vref}
C {gnd.sym} -1060 195 0 0 {name=l11 lab=GND}
C {lab_wire.sym} -1060 25 0 0 {name=p18 sig_type=std_logic lab=vin-}
C {gnd.sym} -840 195 0 0 {name=l12 lab=GND}
C {lab_wire.sym} -840 25 0 0 {name=p19 sig_type=std_logic lab=vin+
}
C {vsource.sym} -1060 115 0 0 {name=V3 value="pulse(3.3 0 0 10p 10p 240p 500p)" savecurrent=false}
C {vsource.sym} -840 115 0 0 {name=V4 value="pulse(0 3.3 0 10p 10p 240p 500p)" savecurrent=false}
C {devices/code_shown.sym} -580 -580 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
* .lib $::180MCU_MODELS/sm141064.ngspice res_statistical
"}
C {lvds_rec_v2.sym} 30 -10 0 0 {name=x1}
C {vsource.sym} -165 135 0 0 {name=V1 value=1.65 savecurrent=false}
C {gnd.sym} -165 207.5 0 0 {name=l1 lab=GND}
C {vsource.sym} -657.5 -100 0 0 {name=V5 value=3.3 savecurrent=false}
C {gnd.sym} -657.5 -57.5 0 0 {name=l2 lab=GND}
