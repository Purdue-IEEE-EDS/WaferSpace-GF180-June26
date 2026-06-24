v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 280 -345 280 -305 {lab=0}
N 390 -355 390 -310 {lab=0}
N 280 -437.5 280 -405 {lab=Vdd}
N 390 -440 390 -415 {lab=Vin_n}
N 280 -172.5 280 -127.5 {lab=0}
N 280 -257.5 280 -232.5 {lab=Vin_p}
N 30 -240 70 -240 {lab=Vout}
N -330 -240 -270 -240 {lab=Vdd}
N -320 -200 -270 -200 {lab=Vin_p}
N 50 -240 50 -200 {lab=Vout}
N 50 -140 50 -110 {lab=0}
N -400 -180 -280 -180 {lab=#net1}
N -280 -180 -270 -180 {lab=#net1}
N -490 -180 -460 -180 {lab=0}
N -320 -220 -270 -220 {lab=Vin_n}
C {vsource.sym} 280 -375 0 0 {name=V1 value=\{VDD\} savecurrent=false}
C {vsource.sym} 390 -385 0 0 {name=V4 value="DC \{VCM\} AC -0.5 PULSE(\{VCM+50m\} \{VCM-50m\} 1n 10p 10p 20n 50n)" savecurrent=false}
C {gnd.sym} 280 -305 0 0 {name=l2 lab=0}
C {gnd.sym} 390 -310 0 0 {name=l5 lab=0}
C {lab_wire.sym} 280 -437.5 0 0 {name=p6 sig_type=std_logic lab=Vdd}
C {vsource.sym} 280 -202.5 0 0 {name=V5 value="DC \{VCM\} AC 0.5 PULSE(\{VCM-50m\} \{VCM+50m\} 1n 10p 10p 20n 50n)" savecurrent=false}
C {gnd.sym} 280 -127.5 0 0 {name=l6 lab=0}
C {lab_wire.sym} 390 -437.5 0 0 {name=p9 sig_type=std_logic lab=Vin_n}
C {lab_wire.sym} 280 -257.5 0 0 {name=p10 sig_type=std_logic lab=Vin_p}
C {code_shown.sym} 1040 -560 0 0 {name=s1 only_toplevel=false value="
.param VDD=3.3
.param VSS=0
.param VCM=1.2
.param VB1=0.0
.param VB2=1.65
.param CL=100f
.options temp=125

.control
save all
set filetype=ascii
set wr_singlescale
shell rm /foss/designs/trans_testing/ota_testing/ota_ac.txt
shell rm /foss/designs/trans_testing/ota_testing/ota_tran.txt

op


* AC gain
ac dec 1000 1 500G
let vin_diff_ac = v(Vin_p)-v(Vin_n)
let gain = v(Vout)/vin_diff_ac
wrdata /foss/designs/trans_testing/ota_testing/ota_ac.txt frequency db(gain) real(gain) imag(gain)
plot v(Vout)

* Transient slew rate
tran 1p 100n
let vin_diff = v(Vin_p)-v(Vin_n)
let slew = deriv(v(Vout))
plot v(Vout)

wrdata /foss/designs/trans_testing/ota_testing/ota_tran.txt time v(Vin_p) v(Vin_n) vin_diff v(Vout) slew

.endc
"}
C {devices/code_shown.sym} 220 -600 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice ss
"}
C {lab_wire.sym} 70 -240 0 1 {name=p1 sig_type=std_logic lab=Vout}
C {lab_wire.sym} -330 -240 0 0 {name=p2 sig_type=std_logic lab=Vdd}
C {lab_wire.sym} -320 -200 0 0 {name=p12 sig_type=std_logic lab=Vin_p}
C {capa.sym} 50 -170 0 0 {name=C1
m=1
value=\{CL\}
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 50 -110 0 0 {name=l1 lab=0}
C {isource.sym} -430 -180 1 0 {name=I0 value=100u}
C {gnd.sym} -490 -180 0 0 {name=l3 lab=0}
C {lvds_rec_v3.sym} -120 -210 0 0 {name=x2}
C {lab_wire.sym} -320 -220 0 0 {name=p3 sig_type=std_logic lab=Vin_n}
