v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 1300 -1750 2100 -1350 {flags=graph
y1=0
y2=3.3
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=5e-09
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node=clk
color=4
dataset=-1
unitx=1
logx=0
logy=0
}
B 2 1300 -1350 2100 -950 {flags=graph
y1=-0.048
y2=3.4
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=5e-09
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node=out
color=4
dataset=-1
unitx=1
logx=0
logy=0
}
N 790 -1050 840 -1050 {lab=RST}
N 790 -1030 840 -1030 {lab=VDD}
N 790 -1010 840 -1010 {lab=GND}
N 790 -990 840 -990 {lab=CLK}
N 1140 -1050 1180 -1050 {lab=out}
C {code_shown.sym} 1395 -885 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {code_shown.sym} 1415 -715 0 0 {name=SPICE only_toplevel=false value="

V_VDD VDD 0 3.3
V_CLK CLK 0 pulse(0 3.3 0s 20p 20p 0.78n 1.5625n)
V_RST RST 0 pwl(0 0 2n 0 2.02n 3.3 20n 3.3)

.control
  save CLK RST out
  tran 10p 50n
  write ring_counter_test.raw
.endc
.tran 10p 50n

"}
C {j_counter.sym} 990 -1020 0 0 {name=x1}
C {ipin.sym} 790 -1030 0 0 {name=p4 lab=VDD}
C {ipin.sym} 790 -1050 0 0 {name=p5 lab=RST}
C {ipin.sym} 790 -1010 0 0 {name=p7 lab=GND}
C {ipin.sym} 790 -990 0 0 {name=p1 lab=CLK}
C {opin.sym} 1180 -1050 0 0 {name=p10 lab=out}
C {launcher.sym} 2210 -1320 0 0 {name=h5
descr="load waves"
tclcommand="xschem raw_read $netlist_dir/j_counter_tb.raw tran"
}
