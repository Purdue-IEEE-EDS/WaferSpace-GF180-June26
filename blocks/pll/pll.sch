v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 720 -350 810 -350 {lab=#net1}
N 720 -330 810 -330 {lab=#net2}
N 760 -390 810 -390 {lab=#net3}
N 760 -520 760 -390 {lab=#net3}
N 740 -370 810 -370 {lab=#net4}
N 740 -520 740 -370 {lab=#net4}
N 400 -340 420 -340 {lab=V_swap}
N 400 -360 420 -360 {lab=VSS}
N 400 -380 420 -380 {lab=VDD}
N 1460 -410 1500 -410 {lab=V_out}
N 1500 -410 1500 -230 {lab=V_out}
N 1420 -230 1500 -230 {lab=V_out}
N 1460 -390 1480 -390 {lab=V_out_n}
N 1480 -390 1480 -250 {lab=V_out_n}
N 1420 -250 1480 -250 {lab=V_out_n}
N 740 -190 780 -190 {lab=#net5}
N 740 -170 780 -170 {lab=#net6}
N 700 -190 740 -190 {lab=#net5}
N 700 -170 740 -170 {lab=#net6}
N 740 -150 790 -150 {lab=#net7}
N 790 -150 790 -50 {lab=#net7}
N 1080 -180 1130 -180 {lab=#net8}
N 1130 -180 1130 -80 {lab=#net8}
N 1420 -210 1470 -210 {lab=#net9}
N 1470 -210 1470 -110 {lab=#net9}
N 620 -490 620 -460 {lab=VSS}
N 620 -520 740 -520 {lab=#net4}
N 520 -490 580 -490 {lab=Vbias_n}
N 520 -520 520 -490 {lab=Vbias_n}
N 480 -520 520 -520 {lab=Vbias_n}
N 480 -490 480 -460 {lab=VSS}
N -10 -280 10 -280 {lab=V_cryst}
N 310 -320 420 -320 {lab=#net10}
N 310 -300 420 -300 {lab=#net11}
N 1080 -220 1120 -220 {lab=Vdiv_out_n}
N 1080 -200 1120 -200 {lab=Vdiv_out}
N -320 0 80 0 {lab=#net12}
N 80 -150 80 0 {lab=#net12}
N 40 -150 80 -150 {lab=#net12}
N -260 -260 -260 -90 {lab=VSS}
N -260 -260 10 -260 {lab=VSS}
N -350 -110 -350 -70 {lab=#net12}
N -310 -140 -310 -40 {lab=VSS}
N -350 -40 -350 -10 {lab=VSS}
N -350 -170 -350 -140 {lab=VDD}
N -310 -90 -260 -90 {lab=VSS}
N -400 -90 -350 -90 {lab=#net12}
N -400 -90 -400 60 {lab=#net12}
N -400 60 -320 60 {lab=#net12}
N -320 -0 -320 60 {lab=#net12}
N 40 -130 40 -110 {lab=VSS}
C {blocks/pll/cpump.sym} 960 -380 0 0 {name=x1}
C {blocks/pll/mux.sym} 570 -340 0 0 {name=x2}
C {ipin.sym} 400 -380 0 0 {name=p1 lab=VDD}
C {ipin.sym} 400 -360 0 0 {name=p2 lab=VSS}
C {lab_pin.sym} 810 -430 0 0 {name=p3 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 810 -410 0 0 {name=p4 sig_type=std_logic lab=VSS}
C {ipin.sym} 400 -340 0 0 {name=p5 lab=V_swap}
C {ipin.sym} -10 -280 0 0 {name=p6 lab=V_cryst}
C {blocks/pll/pfd.sym} 160 -290 0 0 {name=x3}
C {lab_pin.sym} 10 -320 0 0 {name=p7 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 10 -300 0 0 {name=p8 sig_type=std_logic lab=VSS}
C {blocks/pll/vco.sym} 1310 -400 0 0 {name=x4}
C {lab_pin.sym} 1160 -420 0 0 {name=p9 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1160 -400 0 0 {name=p10 sig_type=std_logic lab=VSS}
C {blocks/pll/cml_div.sym} 1270 -210 2 0 {name=x5}
C {lab_pin.sym} 1420 -170 0 1 {name=p11 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1420 -190 0 1 {name=p12 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 1080 -140 0 1 {name=p13 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1080 -160 0 1 {name=p14 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 740 -110 0 1 {name=p15 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 740 -130 0 1 {name=p16 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 600 -490 0 0 {name=M7
L=1u
W=12u
nf=3
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 620 -460 0 1 {name=p37 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 580 -490 1 0 {name=p38 sig_type=std_logic lab=Vbias_n}
C {symbols/nfet_03v3.sym} 500 -490 0 1 {name=M8
L=1u
W=12u
nf=3
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 480 -460 0 0 {name=p39 sig_type=std_logic lab=VSS}
C {isource.sym} 480 -550 0 0 {name=I0 value=20u}
C {lab_pin.sym} 480 -580 0 0 {name=p40 sig_type=std_logic lab=VDD}
C {isource.sym} 760 -550 0 0 {name=I1 value=20u}
C {lab_pin.sym} 760 -580 0 0 {name=p41 sig_type=std_logic lab=VDD}
C {code_shown.sym} -570 -1040 0 0 {name=simcode only_toplevel=true spice_ignore=false lvs_ignore=true

value=".include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice bjt_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice diode_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice moscap_typical

.option method = gear

V_VDD   VDD     0 DC 3.3
V_VSS   VSS     0 DC 0
V_SWP   V_swap  0 DC 0
V_CRYST V_cryst 0 SIN(1.65 1.65 50meg 0 0 0)

.control
    set temp = 25

    let freq = 1250meg
    let pers = 150
    let persteps = 80

    let tper = 1 / freq
    let tfin = tper * pers
    let tstep = tper / persteps
    let tplotst = tfin - 2 * tper

    tran $&tstep $&tfin
    write pll_toplevel.raw

    plot V_out vdiv_out net6 xlimit $&tplotst $&tfin
.endc
"}
C {opin.sym} 1500 -410 0 0 {name=p42 lab=V_out}
C {isource.sym} 790 -20 2 0 {name=I5 value=20u}
C {lab_pin.sym} 790 10 0 0 {name=p28 sig_type=std_logic lab=VDD}
C {isource.sym} 1130 -50 2 0 {name=I6 value=20u}
C {lab_pin.sym} 1130 -20 0 0 {name=p29 sig_type=std_logic lab=VDD}
C {isource.sym} 1470 -80 2 0 {name=I7 value=20u}
C {lab_pin.sym} 1470 -50 0 0 {name=p30 sig_type=std_logic lab=VDD}
C {blocks/adc/encoder/sym/dff_encoder.sym} -110 -130 2 0 {name=x8}
C {lab_pin.sym} 40 -170 0 1 {name=p19 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 40 -90 0 1 {name=p20 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 40 -110 0 1 {name=p21 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} -330 -40 0 1 {name=M5
L=1u
W=1u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} -330 -140 2 0 {name=M6
L=1u
W=4u
nf=4
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_pin.sym} -350 -170 1 0 {name=p22 sig_type=std_logic lab=VDD}
C {lab_pin.sym} -350 -10 1 1 {name=p23 sig_type=std_logic lab=VSS}
C {blocks/pll/cml_div_2.sym} 930 -180 2 0 {name=x7}
C {lab_pin.sym} -260 -210 0 1 {name=p17 sig_type=std_logic lab=VSS}
C {opin.sym} 1480 -250 0 0 {name=p18 lab=V_out_n}
C {opin.sym} 1120 -220 3 0 {name=p24 lab=Vdiv_out_n}
C {opin.sym} 1090 -200 3 0 {name=p25 lab=Vdiv_out}
C {vsource.sym} 1160 -350 0 0 {name=V1 value=0.1 savecurrent=false}
C {lab_pin.sym} 1160 -320 0 0 {name=p31 sig_type=std_logic lab=VSS}
C {capa-2.sym} 700 -140 0 0 {name=C1
m=1
value=13.2f
footprint=1206
device=polarized_capacitor}
C {capa-2.sym} 700 -220 2 0 {name=C2
m=1
value=13.2f
footprint=1206
device=polarized_capacitor}
C {lab_pin.sym} 700 -110 0 1 {name=p26 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 700 -250 0 1 {name=p27 sig_type=std_logic lab=VSS}
