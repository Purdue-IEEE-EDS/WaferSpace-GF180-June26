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
N 280 -360 360 -380 {lab=vout}
N 330 -320 360 -320 {lab=GND}
N 340 -350 340 -320 {lab=GND}
C {code_shown.sym} 10 30 0 0 {name=s1 only_toplevel=false value="
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.option method=gear

.control
set temp = 27
ac lin 727 20meg 1.5G
let imag = mag(i(v1))

* For a resistor, Z = V/I
let resistannnnn = 3.3 / imag

* For a capacitor, Z = 1/(jwC) = V/I -> C = (I/V) * 1/(jw)
*let resistannnnn = mag((i(v1) / (3.3, 0)) / (0, 6.28 * frequency))

plot resistannnnn ylimit 0 3k
.endc
"
}
C {gnd.sym} 80 -260 0 0 {name=l3 lab=GND}
C {lab_wire.sym} 80 -380 0 0 {name=p1 sig_type=std_logic lab=vout
}
C {vsource.sym} 80 -320 0 0 {name=V1 value="dc 0 ac 3.3 0" savecurrent=true}
C {symbols/nfet_03v3.sym} 280 -340 1 0 {name=M2
L=0.28u
W=11u
nf=5
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
C {symbols/ppolyf_u_1k.sym} 360 -350 0 0 {name=R1
W=1e-6
L=2e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
