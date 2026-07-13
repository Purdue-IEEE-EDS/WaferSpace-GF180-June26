v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 360 -120 440 -120 {lab=V_out}
N 20 -160 60 -160 {lab=GND}
N -140 -140 60 -140 {lab=#net1}
N -140 -120 60 -120 {lab=#net2}
N -60 -80 60 -80 {lab=V_up}
N 40 -60 60 -60 {lab=V_down}
N 20 -100 60 -100 {lab=GND}
C {blocks/pll/cpump.sym} 210 -120 0 0 {name=x1}
C {lab_wire.sym} 440 -120 0 1 {name=p1 sig_type=std_logic lab=V_out}
C {code_shown.sym} 110 170 0 0 {name=simcode only_toplevel=true spice_ignore=false lvs_ignore=false
value=".include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice bjt_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice diode_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice moscap_typical
.option method = gear

.control
    set temp = 25

    let amp = 0.5
    let freq = 50meg
    let pers = 50
    let persteps = 20

    alter @v2[sin] = [ 1.65 $&amp $&freq 0 0 0 ]
    alter @v3[sin] = [ 1.65 $&amp $&freq 0 0 0 ]

    let tper = 1 / freq
    let tfin = tper * pers
    let tstep = tper / persteps
    let tplotst = tfin - 2 * tper

    tran $&tstep $&tfin
    write cpump.raw

    plot V_out V_up V_down xlimit 0 $&tfin
.endc
"}
C {vsource.sym} -280 -170 0 0 {name=V1 value=3.3 savecurrent=false}
C {gnd.sym} -280 -140 0 0 {name=l1 lab=GND}
C {lab_wire.sym} -280 -200 0 0 {name=p2 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 60 -180 0 0 {name=p3 sig_type=std_logic lab=VDD}
C {gnd.sym} 20 -160 0 1 {name=l2 lab=GND}
C {isource.sym} -140 -170 0 0 {name=I0 value=20u}
C {isource.sym} -140 -90 0 0 {name=I1 value=20u}
C {lab_wire.sym} -140 -200 0 0 {name=p4 sig_type=std_logic lab=VDD}
C {gnd.sym} -140 -60 0 0 {name=l3 lab=GND}
C {vsource.sym} -60 -50 0 0 {name=V2 value=3.3 savecurrent=false}
C {vsource.sym} 40 -30 0 0 {name=V3 value=3.3 savecurrent=false}
C {gnd.sym} -60 -20 0 0 {name=l4 lab=GND}
C {gnd.sym} 40 0 0 0 {name=l5 lab=GND}
C {gnd.sym} 20 -100 0 1 {name=l6 lab=GND}
C {lab_wire.sym} -60 -80 0 0 {name=p5 sig_type=std_logic lab=V_up}
C {lab_wire.sym} 40 -60 0 0 {name=p6 sig_type=std_logic lab=V_down}
