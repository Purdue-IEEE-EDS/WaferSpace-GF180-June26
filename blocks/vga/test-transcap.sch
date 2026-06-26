v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 80 -380 80 -350 {lab=vout}
N 80 -290 80 -260 {lab=GND}
N 80 -380 280 -360 {lab=vout}
N 80 -260 250 -320 {lab=GND}
N 250 -320 330 -320 {lab=GND}
N 330 -320 360 -320 {lab=GND}
N 280 -360 360 -440 {lab=vout}
N 360 -440 380 -380 {lab=vout}
N 360 -320 380 -320 {lab=GND}
N 360 -350 360 -320 {lab=GND}
N 380 -380 480 -380 {lab=vout}
N 380 -320 480 -320 {lab=GND}
N 460 -350 460 -320 {lab=GND}
N 480 -320 540 -320 {lab=GND}
N 480 -380 510 -360 {lab=vout}
N 280 -350 280 -320 {lab=GND}
C {code_shown.sym} 10 30 0 0 {name=s1 only_toplevel=false value="
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice bjt_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice diode_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice moscap_typical
.option method=gear

.control
set temp = 27
ac lin 727 1meg 2.5G
let imag = mag(i(v1))

* For a resistor, Z = V/I
let resistannnnn = 3.3 / imag / 2

* For a capacitor, Z = 1/(jwC) = V/I -> C = (I/V) * 1/(jw)
*let resistannnnn = mag((i(v1) / (3.3, 0)) / (0, 6.28 * frequency))

*plot resistannnnn ylimit 0 100f
plot resistannnnn ylimit 0 10k
print mean(resistannnnn)
.endc
"
}
C {gnd.sym} 80 -260 0 0 {name=l3 lab=GND}
C {lab_wire.sym} 80 -380 0 0 {name=p1 sig_type=std_logic lab=vout
}
C {vsource.sym} 80 -320 0 0 {name=V1 value="dc 1.65 ac 1.65 0" savecurrent=true}
C {symbols/ppolyf_u_1k.sym} 860 -500 0 0 {name=R1
W=1e-6
L=2.3e-6
model=ppolyf_u_1k
spiceprefix=X
m=1
spice_ignore=true}
C {symbols/ppolyf_u_3k.sym} 730 -500 0 0 {name=R2
W=1e-6
L=.6e-6
model=ppolyf_u_3k
spiceprefix=X
m=1
spice_ignore=true}
C {symbols/ppolyf_u_3k.sym} 730 -400 0 0 {name=R3
W=1e-6
L=5e-6
model=ppolyf_u_3k
spiceprefix=X
m=1
spice_ignore=true}
C {symbols/ppolyf_u_1k.sym} 860 -400 0 0 {name=R4
W=1e-6
L=7.8e-6
model=ppolyf_u_1k
spiceprefix=X
m=1
spice_ignore=true}
C {symbols/ppolyf_u_1k.sym} 870 -380 0 0 {name=R5
W=1e-6
L=7.8e-6
model=ppolyf_u_1k
spiceprefix=X
m=1
spice_ignore=true}
C {symbols/ppolyf_u_2k.sym} 730 -300 0 0 {name=R_wtf
W=1e-6
L=1e-6
model=ppolyf_u_2k
spiceprefix=X
m=1
spice_ignore=true}
C {symbols/ppolyf_u_1k.sym} 860 -300 0 0 {name=R6
W=1e-6
L=2.3e-6
model=ppolyf_u_1k
spiceprefix=X
m=1
spice_ignore=true}
C {symbols/ppolyf_u_3k.sym} 730 -200 0 0 {name=R7
W=1e-6
L=0.8e-6
model=ppolyf_u_3k
spiceprefix=X
m=1
spice_ignore=true}
C {symbols/ppolyf_u_1k.sym} 860 -200 0 0 {name=R8
W=1e-6
L=2.9e-6
model=ppolyf_u_1k
spiceprefix=X
m=1
spice_ignore=true}
C {symbols/ppolyf_u_3k.sym} 730 -100 0 0 {name=R9
W=1e-6
L=1.6e-6
model=ppolyf_u_3k
spiceprefix=X
m=1
spice_ignore=true}
C {symbols/ppolyf_u_1k.sym} 860 -100 0 0 {name=R10
W=1e-6
L=5.3e-6
model=ppolyf_u_1k
spiceprefix=X
m=1
spice_ignore=true}
C {symbols/cap_mim_analog.sym} 480 -180 0 0 {name=C1
w=1e-6
l=1e-6
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1
spice_ignore=true}
C {symbols/cap_mim_2f0fF.sym} 310 -180 0 0 {name=C2
W=1e-6
L=1e-6
model=cap_mim_2f0fF
spiceprefix=X
m=1
spice_ignore=true}
C {symbols/nwell.sym} 380 -350 0 0 {name=R11
W=2e-6
L=2e-5
model=nwell
spiceprefix=X
m=1
spice_ignore=true}
C {symbols/nfet_03v3.sym} 510 -340 1 0 {name=M28
L=0.56u
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
spice_ignore=true}
C {symbols/cap_nmos_03v3.sym} 400 -350 0 0 {name=C4
W=4u
L=2u
model=cap_nmos_03v3
spiceprefix=X
m=1
spice_ignore=true}
C {symbols/ppolyf_u_1k.sym} 300 -350 0 0 {name=R12
W=1e-6
L=3e-6
model=ppolyf_u_1k
spiceprefix=X
m=1
spice_ignore=false}
