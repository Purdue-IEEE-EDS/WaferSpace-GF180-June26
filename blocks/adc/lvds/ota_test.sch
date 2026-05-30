v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 437.5 -258.75 437.5 -238.75 {lab=0}
N 335 -675 335 -632.5 {lab=0}
N 230 -675 230 -635 {lab=0}
N 425 -675 425 -630 {lab=0}
N 510 -675 510 -630 {lab=0}
N 230 -767.5 230 -735 {lab=Vdd}
N 335 -760 335 -735 {lab=Vb1}
N 425 -760 425 -735 {lab=Vb2}
N 510 -760 510 -735 {lab=Vin_n}
N 610 -672.5 610 -627.5 {lab=0}
N 610 -757.5 610 -732.5 {lab=Vin_p}
N 390 -320 490 -320 {lab=Vout}
N 200 -430 200 -380 {lab=Vdd}
N 200 -260 200 -200 {lab=Vss}
N 20 -350 90 -350 {lab=Vb1}
N 20 -330 90 -330 {lab=Vb2}
N 30 -310 90 -310 {lab=Vin_p}
N 20 -310 30 -310 {lab=Vin_p}
N 20 -290 90 -290 {lab=Vin_n}
N 140 -675 140 -635 {lab=0}
N 140 -767.5 140 -735 {lab=Vss}
C {code.sym} 770 -880 0 0 {name=s1 only_toplevel=false value="
.param VDD=3.3
.param VSS=0
.param VCM=1.2
.param VB1=0
.param VB2=0
.param CL=100f

.control
save all
set wr_vecnames
set wr_singlescale

dc V2 0 2.5 0.01 V3 0 2.5 0.01

* XM1
let xm1_id    = @m.x1.xm1.m0[id]
let xm1_vgs   = @m.x1.xm1.m0[vgs]
let xm1_vds   = @m.x1.xm1.m0[vds]
let xm1_vth   = @m.x1.xm1.m0[vth]
let xm1_vdsat = @m.x1.xm1.m0[vdsat]
let xm1_gm    = @m.x1.xm1.m0[gm]
let xm1_gds   = @m.x1.xm1.m0[gds]

* XM2
let xm2_id    = @m.x1.xm2.m0[id]
let xm2_vgs   = @m.x1.xm2.m0[vgs]
let xm2_vds   = @m.x1.xm2.m0[vds]
let xm2_vth   = @m.x1.xm2.m0[vth]
let xm2_vdsat = @m.x1.xm2.m0[vdsat]
let xm2_gm    = @m.x1.xm2.m0[gm]
let xm2_gds   = @m.x1.xm2.m0[gds]

* XM3
let xm3_id    = @m.x1.xm3.m0[id]
let xm3_vgs   = @m.x1.xm3.m0[vgs]
let xm3_vds   = @m.x1.xm3.m0[vds]
let xm3_vth   = @m.x1.xm3.m0[vth]
let xm3_vdsat = @m.x1.xm3.m0[vdsat]
let xm3_gm    = @m.x1.xm3.m0[gm]
let xm3_gds   = @m.x1.xm3.m0[gds]

* XM4
let xm4_id    = @m.x1.xm4.m0[id]
let xm4_vgs   = @m.x1.xm4.m0[vgs]
let xm4_vds   = @m.x1.xm4.m0[vds]
let xm4_vth   = @m.x1.xm4.m0[vth]
let xm4_vdsat = @m.x1.xm4.m0[vdsat]
let xm4_gm    = @m.x1.xm4.m0[gm]
let xm4_gds   = @m.x1.xm4.m0[gds]

* XM5
let xm5_id    = @m.x1.xm5.m0[id]
let xm5_vgs   = @m.x1.xm5.m0[vgs]
let xm5_vds   = @m.x1.xm5.m0[vds]
let xm5_vth   = @m.x1.xm5.m0[vth]
let xm5_vdsat = @m.x1.xm5.m0[vdsat]
let xm5_gm    = @m.x1.xm5.m0[gm]
let xm5_gds   = @m.x1.xm5.m0[gds]

* XM6
let xm6_id    = @m.x1.xm6.m0[id]
let xm6_vgs   = @m.x1.xm6.m0[vgs]
let xm6_vds   = @m.x1.xm6.m0[vds]
let xm6_vth   = @m.x1.xm6.m0[vth]
let xm6_vdsat = @m.x1.xm6.m0[vdsat]
let xm6_gm    = @m.x1.xm6.m0[gm]
let xm6_gds   = @m.x1.xm6.m0[gds]

* XM7
let xm7_id    = @m.x1.xm7.m0[id]
let xm7_vgs   = @m.x1.xm7.m0[vgs]
let xm7_vds   = @m.x1.xm7.m0[vds]
let xm7_vth   = @m.x1.xm7.m0[vth]
let xm7_vdsat = @m.x1.xm7.m0[vdsat]
let xm7_gm    = @m.x1.xm7.m0[gm]
let xm7_gds   = @m.x1.xm7.m0[gds]

* XM8
let xm8_id    = @m.x1.xm8.m0[id]
let xm8_vgs   = @m.x1.xm8.m0[vgs]
let xm8_vds   = @m.x1.xm8.m0[vds]
let xm8_vth   = @m.x1.xm8.m0[vth]
let xm8_vdsat = @m.x1.xm8.m0[vdsat]
let xm8_gm    = @m.x1.xm8.m0[gm]
let xm8_gds   = @m.x1.xm8.m0[gds]

* XM9
let xm9_id    = @m.x1.xm9.m0[id]
let xm9_vgs   = @m.x1.xm9.m0[vgs]
let xm9_vds   = @m.x1.xm9.m0[vds]
let xm9_vth   = @m.x1.xm9.m0[vth]
let xm9_vdsat = @m.x1.xm9.m0[vdsat]
let xm9_gm    = @m.x1.xm9.m0[gm]
let xm9_gds   = @m.x1.xm9.m0[gds]

* XM10
let xm10_id    = @m.x1.xm10.m0[id]
let xm10_vgs   = @m.x1.xm10.m0[vgs]
let xm10_vds   = @m.x1.xm10.m0[vds]
let xm10_vth   = @m.x1.xm10.m0[vth]
let xm10_vdsat = @m.x1.xm10.m0[vdsat]
let xm10_gm    = @m.x1.xm10.m0[gm]
let xm10_gds   = @m.x1.xm10.m0[gds]

* XM11
let xm11_id    = @m.x1.xm11.m0[id]
let xm11_vgs   = @m.x1.xm11.m0[vgs]
let xm11_vds   = @m.x1.xm11.m0[vds]
let xm11_vth   = @m.x1.xm11.m0[vth]
let xm11_vdsat = @m.x1.xm11.m0[vdsat]
let xm11_gm    = @m.x1.xm11.m0[gm]
let xm11_gds   = @m.x1.xm11.m0[gds]

* XM12
let xm12_id    = @m.x1.xm12.m0[id]
let xm12_vgs   = @m.x1.xm12.m0[vgs]
let xm12_vds   = @m.x1.xm12.m0[vds]
let xm12_vth   = @m.x1.xm12.m0[vth]
let xm12_vdsat = @m.x1.xm12.m0[vdsat]
let xm12_gm    = @m.x1.xm12.m0[gm]
let xm12_gds   = @m.x1.xm12.m0[gds]

* XM13
let xm13_id    = @m.x1.xm13.m0[id]
let xm13_vgs   = @m.x1.xm13.m0[vgs]
let xm13_vds   = @m.x1.xm13.m0[vds]
let xm13_vth   = @m.x1.xm13.m0[vth]
let xm13_vdsat = @m.x1.xm13.m0[vdsat]
let xm13_gm    = @m.x1.xm13.m0[gm]
let xm13_gds   = @m.x1.xm13.m0[gds]

* XM14
let xm14_id    = @m.x1.xm14.m0[id]
let xm14_vgs   = @m.x1.xm14.m0[vgs]
let xm14_vds   = @m.x1.xm14.m0[vds]
let xm14_vth   = @m.x1.xm14.m0[vth]
let xm14_vdsat = @m.x1.xm14.m0[vdsat]
let xm14_gm    = @m.x1.xm14.m0[gm]
let xm14_gds   = @m.x1.xm14.m0[gds]

* Check that vectors exist
display

wrdata /foss/designs/trans_testing/ota_testing/ota_bias_device_data.txt v(vb1) v(vb2) v(vout) xm1_id xm1_vgs xm1_vds xm1_vth xm1_vdsat xm1_gm xm1_gds xm2_id xm2_vgs xm2_vds xm2_vth xm2_vdsat xm2_gm xm2_gds xm3_id xm3_vgs xm3_vds xm3_vth xm3_vdsat xm3_gm xm3_gds xm4_id xm4_vgs xm4_vds xm4_vth xm4_vdsat xm4_gm xm4_gds xm5_id xm5_vgs xm5_vds xm5_vth xm5_vdsat xm5_gm xm5_gds xm6_id xm6_vgs xm6_vds xm6_vth xm6_vdsat xm6_gm xm6_gds xm7_id xm7_vgs xm7_vds xm7_vth xm7_vdsat xm7_gm xm7_gds xm8_id xm8_vgs xm8_vds xm8_vth xm8_vdsat xm8_gm xm8_gds xm9_id xm9_vgs xm9_vds xm9_vth xm9_vdsat xm9_gm xm9_gds xm10_id xm10_vgs xm10_vds xm10_vth xm10_vdsat xm10_gm xm10_gds xm11_id xm11_vgs xm11_vds xm11_vth xm11_vdsat xm11_gm xm11_gds xm12_id xm12_vgs xm12_vds xm12_vth xm12_vdsat xm12_gm xm12_gds xm13_id xm13_vgs xm13_vds xm13_vth xm13_vdsat xm13_gm xm13_gds xm14_id xm14_vgs xm14_vds xm14_vth xm14_vdsat xm14_gm xm14_gds

.endc
"}
C {capa.sym} 437.5 -288.75 0 0 {name=C1
m=1
value=\{CL\}
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 437.5 -238.75 0 0 {name=l1 lab=0}
C {devices/code_shown.sym} 70 -940 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {vsource.sym} 230 -705 0 0 {name=V1 value=\{VDD\} savecurrent=false}
C {vsource.sym} 335 -705 0 0 {name=V2 value=\{VB1\} savecurrent=false}
C {vsource.sym} 425 -705 0 0 {name=V3 value=\{VB2\} savecurrent=false}
C {vsource.sym} 510 -705 0 0 {name=V4 value=\{VCM\} savecurrent=false}
C {gnd.sym} 230 -635 0 0 {name=l2 lab=0}
C {gnd.sym} 335 -632.5 0 0 {name=l3 lab=0}
C {gnd.sym} 425 -630 0 0 {name=l4 lab=0}
C {gnd.sym} 510 -630 0 0 {name=l5 lab=0}
C {lab_wire.sym} 230 -767.5 0 0 {name=p6 sig_type=std_logic lab=Vdd}
C {vsource.sym} 610 -702.5 0 0 {name=V5 value=\{VCM\} savecurrent=false}
C {gnd.sym} 610 -627.5 0 0 {name=l6 lab=0}
C {lab_wire.sym} 335 -760 0 0 {name=p7 sig_type=std_logic lab=Vb1}
C {lab_wire.sym} 425 -760 0 0 {name=p8 sig_type=std_logic lab=Vb2}
C {lab_wire.sym} 510 -757.5 0 0 {name=p9 sig_type=std_logic lab=Vin_n}
C {lab_wire.sym} 610 -757.5 0 0 {name=p10 sig_type=std_logic lab=Vin_p}
C {op_amp.sym} 240 -320 0 0 {name=x1}
C {lab_wire.sym} 490 -320 0 1 {name=p1 sig_type=std_logic lab=Vout}
C {lab_wire.sym} 200 -430 3 1 {name=p2 sig_type=std_logic lab=Vdd}
C {lab_wire.sym} 200 -200 3 0 {name=p3 sig_type=std_logic lab=Vss}
C {vsource.sym} 140 -705 0 0 {name=V6 value=\{VSS\} savecurrent=false}
C {gnd.sym} 140 -635 0 0 {name=l7 lab=0}
C {lab_wire.sym} 140 -767.5 0 0 {name=p4 sig_type=std_logic lab=Vss}
C {lab_wire.sym} 20 -350 0 0 {name=p5 sig_type=std_logic lab=Vb1}
C {lab_wire.sym} 20 -330 0 0 {name=p11 sig_type=std_logic lab=Vb2}
C {lab_wire.sym} 20 -310 0 0 {name=p12 sig_type=std_logic lab=Vin_p}
C {lab_wire.sym} 20 -290 0 0 {name=p13 sig_type=std_logic lab=Vin_n}
