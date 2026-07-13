v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 730 -930 1530 -530 {flags=graph
y1=-0.06
y2=3.4
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=7.7065405e-11
x2=5.0770649e-09
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="d
q"
color="4 10"
dataset=-1
unitx=1
logx=0
logy=0
}
B 2 730 -1330 1530 -930 {flags=graph
y1=0
y2=3.4
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=7.7065405e-11
x2=5.0770649e-09
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
legend=1
color=10
node=clk}
N 1600 -290 1600 -240 {lab=GND}
N 1600 -380 1600 -350 {lab=Q}
N 1480 -380 1610 -380 {lab=Q}
N 1140 -380 1180 -380 {lab=VDD}
N 1140 -360 1180 -360 {lab=RST}
N 1140 -340 1180 -340 {lab=CLK}
N 1140 -320 1180 -320 {lab=D}
N 1140 -300 1180 -300 {lab=GND}
N 1620 -550 1620 -520 {lab=VDD}
N 1620 -460 1620 -440 {lab=GND}
C {code_shown.sym} 1735 -545 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice ff
"}
C {code_shown.sym} 1755 -375 0 0 {name=SPICE only_toplevel=false value="
.include /foss/designs/encoder/layout/dff/dff_encoder_sim.spice

V_CLK CLK 0 pulse(0 3.3 260p 10p 10p 290p 500p)
V_D D 0 pwl(0 0 150p 0 160p 3.3 400p 3.3 410p 0 1100p 0 1110p 3.3 1400p 3.3 1410p 0 2100p 0 2110p 3.3 2400p 3.3 2410p 0 3100p 0 3110p 3.3 3400p 3.3 3410p 0 4100p 0 4110p 3.3 4400p 3.3 4410p 0 5n 0))
V_RST RST 0 pulse(0 3.3 150p 10p 10p 5n 10n)
.control
  
  save CLK D RST Q
  run
  write tspc_dff_layout_test.raw
.endc
.tran 1p 5n
"}
C {opin.sym} 1610 -380 0 0 {name=p20 lab=Q}
C {lab_wire.sym} 1600 -250 0 0 {name=p22 sig_type=std_logic lab=GND}
C {capa.sym} 1600 -320 0 0 {name=C2
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {ipin.sym} 1140 -320 0 0 {name=p21 lab=D}
C {ipin.sym} 1140 -380 0 0 {name=p61 lab=VDD
m=8}
C {ipin.sym} 1140 -300 0 0 {name=p62 lab=GND
m=3}
C {ipin.sym} 1140 -360 0 0 {name=p1 lab=RST
m=8}
C {ipin.sym} 1140 -340 0 0 {name=p2 lab=CLK
m=8}
C {launcher.sym} 1010 -500 0 0 {name=h5
descr="load waves"
tclcommand="xschem raw_read $netlist_dir/dff_postlayout_tb.raw tran"
}
C {dff_encoder.sym} 1330 -340 0 0 {name=x1}
C {vsource.sym} 1620 -490 0 0 {name=V1 value=3.3 savecurrent=false}
C {vdd.sym} 1620 -550 0 0 {name=l3 lab=VDD}
C {gnd.sym} 1620 -440 0 1 {name=l4 lab=GND
}
