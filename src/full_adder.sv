module full_adder(
    input logic a, b, cin, 
    output logic s, cout
);

assign s = a ^ b ^ cin; 
  Delay    Time   Description
---------------------------------------------------------
   0.00    0.00   clock clk (rise edge)
   2.26    2.26   clock network delay (propagated)
   0.00    2.26 ^ stages_gen_blk[6].stage/genblk1.even_stage.rot3/mult4/_435_/CLK (gf180mcu_fd_sc_mcu9t5v0__dffq_1)        
   0.97    3.23 v stages_gen_blk[6].stage/genblk1.even_stage.rot3/mult4/_435_/Q (gf180mcu_fd_sc_mcu9t5v0__dffq_1)
   1.43    4.67 v stages_gen_blk[6].stage/genblk1.even_stage.rot3/mult4/csa_s1_0/genblk1[0].fa/_6_/Z (gf180mcu_fd_sc_mcu9t5v0__xor3_1)
   1.92    6.58 v stages_gen_blk[6].stage/genblk1.even_stage.rot3/mult4/csa_s2_0/genblk1[0].fa/_6_/Z (gf180mcu_fd_sc_mcu9t5v0__xor3_1)
   1.70    8.28 v stages_gen_blk[6].stage/genblk1.even_stage.rot3/mult4/csa_s3_1/genblk1[0].fa/_6_/Z (gf180mcu_fd_sc_mcu9t5v0__xor3_1)
   0.00    8.28 v stages_gen_blk[6].stage/genblk1.even_stage.rot3/mult4/_596_/D (gf180mcu_fd_sc_mcu9t5v0__dffq_1)
           8.28   data arrival time

   6.25    6.25   clock clk (rise edge)
   2.27    8.52   clock network delay (propagated)
   0.00    8.52   clock reconvergence pessimism
           8.52 ^ stages_gen_blk[6].stage/genblk1.even_stage.rot3/mult4/_596_/CLK (gf180mcu_fd_sc_mcu9t5v0__dffq_1)        
  -0.46    8.06   library setup time
           8.06   data required time
---------------------------------------------------------
           8.06   data required time
          -8.28   data arrival time
---------------------------------------------------------
          -0.22   slack (VIOLATED)

endmodule