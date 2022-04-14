// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Thu Mar 31 18:57:41 2022
// Host        : yoga14s-ubuntu running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/xkz/Courses/COD_Lab/Lab2/Lab2_Register_Files/Lab2_Register_Files.srcs/sources_1/ip/dist_mem_gen_1/dist_mem_gen_1_stub.v
// Design      : dist_mem_gen_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_13,Vivado 2019.1" *)
module dist_mem_gen_1(a, d, dpra, clk, we, spo, dpo)
/* synthesis syn_black_box black_box_pad_pin="a[7:0],d[15:0],dpra[7:0],clk,we,spo[15:0],dpo[15:0]" */;
  input [7:0]a;
  input [15:0]d;
  input [7:0]dpra;
  input clk;
  input we;
  output [15:0]spo;
  output [15:0]dpo;
endmodule
