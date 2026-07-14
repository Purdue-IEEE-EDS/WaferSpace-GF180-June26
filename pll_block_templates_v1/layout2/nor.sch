v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 210 -150 260 -150 {lab=GND}
N 370 -150 420 -150 {lab=GND}
N 210 -240 260 -240 {lab=VDD}
N 210 -340 260 -340 {lab=VDD}
N 210 -210 210 -180 {lab=Z}
N 210 -200 450 -200 {lab=Z}
N 370 -200 370 -180 {lab=Z}
N 210 -310 210 -270 {lab=#net1}
N 330 -190 330 -150 {lab=B}
N 170 -190 330 -190 {lab=B}
N 170 -240 170 -190 {lab=B}
N 70 -240 170 -240 {lab=B}
N 70 -340 170 -340 {lab=A}
N 110 -150 170 -150 {lab=A}
N 110 -340 110 -150 {lab=A}
N 210 -410 210 -370 {lab=VDD}
N 260 -340 260 -240 {lab=VDD}
N 260 -390 260 -340 {lab=VDD}
N 210 -390 260 -390 {lab=VDD}
N 210 -120 370 -120 {lab=GND}
N 260 -150 260 -120 {lab=GND}
N 420 -150 420 -120 {lab=GND}
N 370 -120 420 -120 {lab=GND}
C {symbols/nfet_03v3.sym} 190 -150 0 0 {name=M1
L=0.28u
W=0.3u
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
C {symbols/pfet_03v3.sym} 190 -240 0 0 {name=M2
L=0.28u
W=2.1u
nf=1
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
C {symbols/nfet_03v3.sym} 350 -150 0 0 {name=M3
L=0.28u
W=0.3u
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
C {symbols/pfet_03v3.sym} 190 -340 0 0 {name=M4
L=0.28u
W=2.1u
nf=1
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
C {ipin.sym} 70 -340 0 0 {name=p7 lab=A}
C {ipin.sym} 70 -240 0 0 {name=p3 lab=B}
C {opin.sym} 450 -200 0 0 {name=p1 lab=Z}
C {iopin.sym} 310 -120 1 0 {name=p2 lab=GND}
C {iopin.sym} 210 -410 3 0 {name=p4 lab=VDD}
C {devices/code_shown.sym} -120 -660 0 0 {name=MODELS only_toplevel=true lvs_ignore=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
* .lib $::180MCU_MODELS/sm141064.ngspice res_statistical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
"}
