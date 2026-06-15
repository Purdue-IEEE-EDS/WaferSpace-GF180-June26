v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 437.5 -258.75 437.5 -238.75 {lab=0}
N 400 -675 400 -635 {lab=0}
N 510 -675 510 -630 {lab=0}
N 400 -767.5 400 -735 {lab=Vdd}
N 510 -760 510 -735 {lab=Vin_n}
N 610 -672.5 610 -627.5 {lab=0}
N 610 -757.5 610 -732.5 {lab=Vin_p}
N 390 -320 490 -320 {lab=Vout}
N 200 -430 200 -380 {lab=Vdd}
N 30 -320 90 -320 {lab=Vin_p}
N 20 -320 30 -320 {lab=Vin_p}
N 20 -340 90 -340 {lab=Vin_n}
C {code.sym} 770 -870 0 0 {name=s1 only_toplevel=false value="
.param VDD=3.3
.param VCM=1.2
.param VB1=0
.param VB2=0
.param CL=10f

.control
* ============================================================
* Output file
* ============================================================
let vb1_start = 0
let vb1_step  = 0.1
let vb1_n     = 33

let vb2_start = 0
let vb2_step  = 0.1
let vb2_n     = 33


shell rm /foss/designs/trans_testing/ota_testing/ota_bias_op_loop.txt

set appendwrite
set wr_singlescale

* ============================================================
* Main VB1 / VB2 operating-point loop
* ============================================================


  let i = 0

  while i le vb1_n

    let vb1_val = vb1_start + i*vb1_step
    let j = 0

    echo Starting VB1 = $&vb1_val

    while j le vb2_n

      let vb2_val = vb2_start + j*vb2_step

      alter V2 = $&vb1_val
      alter V3 = $&vb2_val

      op

      let vb1_save = vb1_val
      let vb2_save = vb2_val
      let vout_save = v(vout)

      let xm1_type  = 1
      let xm1_id    = @m.x1.xm1.m0[id]
      let xm1_vgs   = @m.x1.xm1.m0[vgs]
      let xm1_vds   = @m.x1.xm1.m0[vds]
      let xm1_vth   = @m.x1.xm1.m0[vth]
      let xm1_vdsat = @m.x1.xm1.m0[vdsat]
      let xm1_gm    = @m.x1.xm1.m0[gm]
      let xm1_gds   = @m.x1.xm1.m0[gds]

      let xm2_type  = 1
      let xm2_id    = @m.x1.xm2.m0[id]
      let xm2_vgs   = @m.x1.xm2.m0[vgs]
      let xm2_vds   = @m.x1.xm2.m0[vds]
      let xm2_vth   = @m.x1.xm2.m0[vth]
      let xm2_vdsat = @m.x1.xm2.m0[vdsat]
      let xm2_gm    = @m.x1.xm2.m0[gm]
      let xm2_gds   = @m.x1.xm2.m0[gds]

      let xm3_type  = 1
      let xm3_id    = @m.x1.xm3.m0[id]
      let xm3_vgs   = @m.x1.xm3.m0[vgs]
      let xm3_vds   = @m.x1.xm3.m0[vds]
      let xm3_vth   = @m.x1.xm3.m0[vth]
      let xm3_vdsat = @m.x1.xm3.m0[vdsat]
      let xm3_gm    = @m.x1.xm3.m0[gm]
      let xm3_gds   = @m.x1.xm3.m0[gds]

      let xm4_type  = 1
      let xm4_id    = @m.x1.xm4.m0[id]
      let xm4_vgs   = @m.x1.xm4.m0[vgs]
      let xm4_vds   = @m.x1.xm4.m0[vds]
      let xm4_vth   = @m.x1.xm4.m0[vth]
      let xm4_vdsat = @m.x1.xm4.m0[vdsat]
      let xm4_gm    = @m.x1.xm4.m0[gm]
      let xm4_gds   = @m.x1.xm4.m0[gds]

      let xm5_type  = 0
      let xm5_id    = @m.x1.xm5.m0[id]
      let xm5_vgs   = @m.x1.xm5.m0[vgs]
      let xm5_vds   = @m.x1.xm5.m0[vds]
      let xm5_vth   = @m.x1.xm5.m0[vth]
      let xm5_vdsat = @m.x1.xm5.m0[vdsat]
      let xm5_gm    = @m.x1.xm5.m0[gm]
      let xm5_gds   = @m.x1.xm5.m0[gds]

      let xm6_type  = 0
      let xm6_id    = @m.x1.xm6.m0[id]
      let xm6_vgs   = @m.x1.xm6.m0[vgs]
      let xm6_vds   = @m.x1.xm6.m0[vds]
      let xm6_vth   = @m.x1.xm6.m0[vth]
      let xm6_vdsat = @m.x1.xm6.m0[vdsat]
      let xm6_gm    = @m.x1.xm6.m0[gm]
      let xm6_gds   = @m.x1.xm6.m0[gds]

      let xm7_type  = 1
      let xm7_id    = @m.x1.xm7.m0[id]
      let xm7_vgs   = @m.x1.xm7.m0[vgs]
      let xm7_vds   = @m.x1.xm7.m0[vds]
      let xm7_vth   = @m.x1.xm7.m0[vth]
      let xm7_vdsat = @m.x1.xm7.m0[vdsat]
      let xm7_gm    = @m.x1.xm7.m0[gm]
      let xm7_gds   = @m.x1.xm7.m0[gds]

      let xm8_type  = 1
      let xm8_id    = @m.x1.xm8.m0[id]
      let xm8_vgs   = @m.x1.xm8.m0[vgs]
      let xm8_vds   = @m.x1.xm8.m0[vds]
      let xm8_vth   = @m.x1.xm8.m0[vth]
      let xm8_vdsat = @m.x1.xm8.m0[vdsat]
      let xm8_gm    = @m.x1.xm8.m0[gm]
      let xm8_gds   = @m.x1.xm8.m0[gds]

      let xm9_type  = 1
      let xm9_id    = @m.x1.xm9.m0[id]
      let xm9_vgs   = @m.x1.xm9.m0[vgs]
      let xm9_vds   = @m.x1.xm9.m0[vds]
      let xm9_vth   = @m.x1.xm9.m0[vth]
      let xm9_vdsat = @m.x1.xm9.m0[vdsat]
      let xm9_gm    = @m.x1.xm9.m0[gm]
      let xm9_gds   = @m.x1.xm9.m0[gds]

      let xm10_type  = 1
      let xm10_id    = @m.x1.xm10.m0[id]
      let xm10_vgs   = @m.x1.xm10.m0[vgs]
      let xm10_vds   = @m.x1.xm10.m0[vds]
      let xm10_vth   = @m.x1.xm10.m0[vth]
      let xm10_vdsat = @m.x1.xm10.m0[vdsat]
      let xm10_gm    = @m.x1.xm10.m0[gm]
      let xm10_gds   = @m.x1.xm10.m0[gds]

      let xm11_type  = 0
      let xm11_id    = @m.x1.xm11.m0[id]
      let xm11_vgs   = @m.x1.xm11.m0[vgs]
      let xm11_vds   = @m.x1.xm11.m0[vds]
      let xm11_vth   = @m.x1.xm11.m0[vth]
      let xm11_vdsat = @m.x1.xm11.m0[vdsat]
      let xm11_gm    = @m.x1.xm11.m0[gm]
      let xm11_gds   = @m.x1.xm11.m0[gds]

      let xm12_type  = 0
      let xm12_id    = @m.x1.xm12.m0[id]
      let xm12_vgs   = @m.x1.xm12.m0[vgs]
      let xm12_vds   = @m.x1.xm12.m0[vds]
      let xm12_vth   = @m.x1.xm12.m0[vth]
      let xm12_vdsat = @m.x1.xm12.m0[vdsat]
      let xm12_gm    = @m.x1.xm12.m0[gm]
      let xm12_gds   = @m.x1.xm12.m0[gds]

      let xm13_type  = 0
      let xm13_id    = @m.x1.xm13.m0[id]
      let xm13_vgs   = @m.x1.xm13.m0[vgs]
      let xm13_vds   = @m.x1.xm13.m0[vds]
      let xm13_vth   = @m.x1.xm13.m0[vth]
      let xm13_vdsat = @m.x1.xm13.m0[vdsat]
      let xm13_gm    = @m.x1.xm13.m0[gm]
      let xm13_gds   = @m.x1.xm13.m0[gds]

      let xm14_type  = 0
      let xm14_id    = @m.x1.xm14.m0[id]
      let xm14_vgs   = @m.x1.xm14.m0[vgs]
      let xm14_vds   = @m.x1.xm14.m0[vds]
      let xm14_vth   = @m.x1.xm14.m0[vth]
      let xm14_vdsat = @m.x1.xm14.m0[vdsat]
      let xm14_gm    = @m.x1.xm14.m0[gm]
      let xm14_gds   = @m.x1.xm14.m0[gds]

	wrdata /foss/designs/trans_testing/ota_testing/ota_bias_op_loop.txt vb1_save vb2_save vout_save xm1_type xm1_id xm1_vgs xm1_vds xm1_vth xm1_vdsat xm1_gm xm1_gds xm2_type xm2_id xm2_vgs xm2_vds xm2_vth xm2_vdsat xm2_gm xm2_gds xm3_type xm3_id xm3_vgs xm3_vds xm3_vth xm3_vdsat xm3_gm xm3_gds xm4_type xm4_id xm4_vgs xm4_vds xm4_vth xm4_vdsat xm4_gm xm4_gds xm5_type xm5_id xm5_vgs xm5_vds xm5_vth xm5_vdsat xm5_gm xm5_gds xm6_type xm6_id xm6_vgs xm6_vds xm6_vth xm6_vdsat xm6_gm xm6_gds xm7_type xm7_id xm7_vgs xm7_vds xm7_vth xm7_vdsat xm7_gm xm7_gds xm8_type xm8_id xm8_vgs xm8_vds xm8_vth xm8_vdsat xm8_gm xm8_gds xm9_type xm9_id xm9_vgs xm9_vds xm9_vth xm9_vdsat xm9_gm xm9_gds xm10_type xm10_id xm10_vgs xm10_vds xm10_vth xm10_vdsat xm10_gm xm10_gds xm11_type xm11_id xm11_vgs xm11_vds xm11_vth xm11_vdsat xm11_gm xm11_gds xm12_type xm12_id xm12_vgs xm12_vds xm12_vth xm12_vdsat xm12_gm xm12_gds xm13_type xm13_id xm13_vgs xm13_vds xm13_vth xm13_vdsat xm13_gm xm13_gds xm14_type xm14_id xm14_vgs xm14_vds xm14_vth xm14_vdsat xm14_gm xm14_gds
      let j = j + 1

    end

    let i = i + 1

  end


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
C {vsource.sym} 400 -705 0 0 {name=V1 value=\{VDD\} savecurrent=false}
C {vsource.sym} 510 -705 0 0 {name=V4 value=\{VCM\} savecurrent=false}
C {gnd.sym} 400 -635 0 0 {name=l2 lab=0}
C {gnd.sym} 510 -630 0 0 {name=l5 lab=0}
C {lab_wire.sym} 400 -767.5 0 0 {name=p6 sig_type=std_logic lab=Vdd}
C {vsource.sym} 610 -702.5 0 0 {name=V5 value=\{VCM\} savecurrent=false}
C {gnd.sym} 610 -627.5 0 0 {name=l6 lab=0}
C {lab_wire.sym} 510 -757.5 0 0 {name=p9 sig_type=std_logic lab=Vin_n}
C {lab_wire.sym} 610 -757.5 0 0 {name=p10 sig_type=std_logic lab=Vin_p}
C {op_amp.sym} 240 -320 0 0 {name=x1}
C {lab_wire.sym} 490 -320 0 1 {name=p1 sig_type=std_logic lab=Vout}
C {lab_wire.sym} 200 -430 3 1 {name=p2 sig_type=std_logic lab=Vdd}
C {lab_wire.sym} 20 -320 0 0 {name=p12 sig_type=std_logic lab=Vin_p}
C {lab_wire.sym} 20 -340 0 0 {name=p13 sig_type=std_logic lab=Vin_n}
