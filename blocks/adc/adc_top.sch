v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 60 -280 80 -280 {lab=GND}
N 60 -300 80 -300 {lab=VDD}
N 60 -260 80 -260 {lab=Vin}
N 60 -240 80 -240 {lab=Vin_n}
N 60 -220 80 -220 {lab=Vcp_5}
N 60 -200 80 -200 {lab=Vcp_4}
N 60 -180 80 -180 {lab=Vcp_3}
N 60 -160 80 -160 {lab=Vcp_2}
N 60 -140 80 -140 {lab=Vcp_1}
N 60 -120 80 -120 {lab=Vcp_0}
N 1120 -220 1200 -220 {lab=enc_out[5:0]}
N 380 -300 380 -220 {lab=vga_out}
N 740 -180 820 -180 {lab=cmp_out[62:0]}
N 780 -280 780 -180 {lab=cmp_out[62:0]}
N 440 -160 460 -160 {lab=CLK}
N 440 -180 440 -160 {lab=CLK}
N 460 -160 820 -160 {lab=CLK}
N 440 -130 800 -130 {lab=RST}
N 800 -200 800 -130 {lab=RST}
N 800 -200 820 -200 {lab=RST}
N 390 -280 390 -200 {lab=vga_out_n}
N 380 -200 390 -200 {lab=vga_out_n}
N 380 -220 440 -220 {lab=vga_out}
C {blocks/adc/vga/vga.sym} 230 -220 0 0 {name=x1}
C {vsource.sym} -420 -190 0 1 {name=V1 value="dc 1.65 ac 10m 0" savecurrent=false}
C {gnd.sym} -420 -160 0 1 {name=l10 lab=GND}
C {vsource.sym} -260 -190 0 1 {name=V2 value="dc 1.65 ac 10m 180" savecurrent=false}
C {gnd.sym} -260 -160 0 1 {name=l23 lab=GND}
C {res.sym} -260 -250 2 1 {name=R14
value=50
footprint=1206
device=resistor
m=1}
C {res.sym} -420 -250 2 1 {name=R13
value=50
footprint=1206
device=resistor
m=1}
C {vsource.sym} -160 -190 0 0 {name=V3 value=3.3 savecurrent=false}
C {gnd.sym} -160 -160 0 1 {name=l1 lab=GND}
C {lab_wire.sym} -160 -220 0 0 {name=p1 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 60 -280 0 0 {name=p2 sig_type=std_logic lab=GND}
C {lab_wire.sym} 60 -300 0 0 {name=p3 sig_type=std_logic lab=VDD}
C {lab_wire.sym} -260 -280 0 0 {name=p4 sig_type=std_logic lab=Vin_n}
C {lab_wire.sym} -420 -280 0 0 {name=p5 sig_type=std_logic lab=Vin}
C {lab_wire.sym} 60 -240 0 0 {name=p6 sig_type=std_logic lab=Vin_n}
C {lab_wire.sym} 60 -260 0 0 {name=p7 sig_type=std_logic lab=Vin}
C {vsource.sym} -420 -70 0 0 {name=V4 value=3.3 savecurrent=false}
C {gnd.sym} -420 -40 0 1 {name=l2 lab=GND}
C {lab_wire.sym} -420 -100 0 0 {name=p8 sig_type=std_logic lab=Vcp_5}
C {vsource.sym} -350 -70 0 0 {name=V5 value=3.3 savecurrent=false}
C {gnd.sym} -350 -40 0 1 {name=l3 lab=GND}
C {lab_wire.sym} -350 -100 0 0 {name=p9 sig_type=std_logic lab=Vcp_4}
C {vsource.sym} -280 -70 0 0 {name=V6 value=3.3 savecurrent=false}
C {gnd.sym} -280 -40 0 1 {name=l4 lab=GND}
C {lab_wire.sym} -280 -100 0 0 {name=p10 sig_type=std_logic lab=Vcp_3}
C {vsource.sym} -210 -70 0 0 {name=V7 value=3.3 savecurrent=false}
C {gnd.sym} -210 -40 0 1 {name=l5 lab=GND}
C {lab_wire.sym} -210 -100 0 0 {name=p11 sig_type=std_logic lab=Vcp_2}
C {vsource.sym} -140 -70 0 0 {name=V8 value=3.3 savecurrent=false}
C {gnd.sym} -140 -40 0 1 {name=l6 lab=GND}
C {lab_wire.sym} -140 -100 0 0 {name=p12 sig_type=std_logic lab=Vcp_1}
C {vsource.sym} -70 -70 0 0 {name=V9 value=3.3 savecurrent=false}
C {gnd.sym} -70 -40 0 1 {name=l7 lab=GND}
C {lab_wire.sym} -70 -100 0 0 {name=p13 sig_type=std_logic lab=Vcp_0}
C {lab_wire.sym} 60 -220 0 0 {name=p14 sig_type=std_logic lab=Vcp_5}
C {lab_wire.sym} 60 -200 0 0 {name=p15 sig_type=std_logic lab=Vcp_4}
C {lab_wire.sym} 60 -180 0 0 {name=p16 sig_type=std_logic lab=Vcp_3}
C {lab_wire.sym} 60 -160 0 0 {name=p17 sig_type=std_logic lab=Vcp_2}
C {lab_wire.sym} 60 -140 0 0 {name=p18 sig_type=std_logic lab=Vcp_1}
C {lab_wire.sym} 60 -120 0 0 {name=p19 sig_type=std_logic lab=Vcp_0}
C {blocks/adc/comp-array/block_top.sym} 590 -200 0 0 {name=x3}
C {lab_wire.sym} 740 -220 0 1 {name=p20 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 740 -200 0 1 {name=p21 sig_type=std_logic lab=GND}
C {code_shown.sym} 60 80 0 0 {name=simcode only_toplevel=true spice_ignore=false lvs_ignore=false

value=".include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice bjt_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice diode_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice moscap_typical

.option method = gear

V_EVAL CLK 0 pulse(0 3.3 0 10p 10p 323.3p 666.7p)
V_RST  RST 0 pulse(3.3 3.3 0 10p 10p 323.3p 666.7p)

.control
    set temp = 25

    let amp = 10m
    let freq = 800meg
    let pers = 50
    let persteps = 20

    alter @v1[sin] = [ 1.65 $&amp $&freq 0 0 0 ]
    alter @v2[sin] = [ 1.65 $&amp $&freq 0 0 180 ]

    let tper = 1 / freq
    let tfin = tper * pers
    let tstep = tper / persteps
    let tplotst = tfin - 2 * tper

    tran $&tstep $&tfin
    write toplevel_1p5G.raw

    plot vga_out xlimit $&tplotst $&tfin
.endc
"}
C {blocks/adc/encoder/sym/encoder_final.sym} 970 -180 0 0 {name=x2}
C {lab_wire.sym} 970 -250 0 0 {name=p26 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 970 -110 0 0 {name=p27 sig_type=std_logic lab=GND}
C {lab_wire.sym} 380 -300 0 1 {name=p28 sig_type=std_logic lab=vga_out}
C {lab_wire.sym} 780 -280 0 0 {name=p29 sig_type=std_logic lab=cmp_out[62:0]}
C {lab_wire.sym} 1200 -220 0 1 {name=p30 sig_type=std_logic lab=enc_out[5:0]}
C {ipin.sym} 440 -160 0 0 {name=p31 lab=CLK}
C {ipin.sym} 440 -130 0 0 {name=p23 lab=RST}
C {lab_wire.sym} 390 -280 0 1 {name=p22 sig_type=std_logic lab=vga_out_n}
C {lab_wire.sym} 440 -200 2 1 {name=p24 sig_type=std_logic lab=GND}
