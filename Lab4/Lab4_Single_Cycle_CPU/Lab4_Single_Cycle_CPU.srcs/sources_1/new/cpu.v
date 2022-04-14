`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/04/12 15:48:52
// Design Name:
// Module Name: cpu
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////io////////////////////////////////////////////////////////////


module cpu (
        input clk, rstn,
        // IO_BUS
        output [7:0] io_addr, // 外设地址
        output [31:0] io_dout, // 向外设输出的数据
        output io_we, // 向外设输出数据时的写使能信号
        output io_rd, // 从外设输入数据时的读使能信号
        input [31:0] io_din, // 来自外设输入的数据
        // Debug_BUS
        output [31:0] next_pc, // 当前执行指令地址
        input [15:0] chk_addr, // 数据通路状态的编码地址
        output [31:0] chk_data // 数据通路状态的数据
    );

    // parse instruction
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [24:0] imm;
    wire [4:0] inst_rs1, inst_rs2, inst_rd;

    assign opcode = ir[6:0];
    assign inst_rd = ir[11:7];
    assign funct3 = ir[14:12];
    assign inst_rs1 = ir[19:15];
    assign inst_rs2 = ir[24:20];
    assign funct7 = ir[31:25];
    assign imm = ir[31:7];

    // control signal
    wire mem_write;
    wire reg_write;
    wire [1:0] reg_write_sel;
    wire alu_src;
    wire branch;
    wire [1:0] pc_ctrl;
    wire [2:0] alu_op;

    wire [31:0] ctrl;
    assign ctrl[20:0] = {mem_write, reg_write, reg_write_sel, alu_src, branch, pc_ctrl, alu_op, io_we, io_addr, io_rd};

    // PC part
    reg [31:0] pc;
    wire [31:0] npc;
    wire [31:0] ir;

    // rf part
    wire [4:0] rf_ra0, rf_ra1, rf_ra2;
    wire [4:0] rf_wa;

    assign rf_ra0 = inst_rs1;
    assign rf_ra1 = inst_rs2;
    assign rf_ra2 = chk_addr[4:0];
    assign rf_wa = inst_rd;

    wire [31:0] rf_rd0, rf_rd1, rf_rd2;
    wire [31:0] rf_wd;

    // ALU part
    wire [31:0] alu_in0, alu_in1, alu_out;
    wire [31:0] extended_imm;
    wire [2:0] cc; // cc: condition code

    assign alu_in0 = rf_rd0;
    assign alu_in1 = alu_src ? extended_imm : rf_rd1;

    // data memory part
    wire [7:0] dm_ra0;
    wire [7:0] dm_ra1;
    wire [31:0] dm_rd0;
    wire [31:0] dm_rd1;
    wire [31:0] dm_wd;
    assign dm_ra1 = chk_addr[7:0];
    assign dm_ra0 = alu_out[9:2]; // MMIO start at 0
    assign dm_wd = rf_rd1;

    register_file rf_inst(clk, rf_ra0, rf_ra1, rf_ra2, rf_rd0, rf_rd1, rf_rd2, rf_wa, rf_wd, reg_write);
    rf_control rf_control_inst(io_rd, io_din, reg_write_sel, alu_out, pc, dm_rd0, extended_imm, rf_wd);
    alu alu_inst(alu_in0, alu_in1, alu_op, alu_out, cc);
    alu_control alu_control_inst(opcode, funct3, funct7, alu_op);
    imm_gen imm_gen_inst(imm, opcode, extended_imm);
    pc_control pc_control_inst(pc, pc_ctrl, branch, alu_out, extended_imm, npc);
    control control_inst(opcode, cc, funct3, branch, reg_write_sel, pc_ctrl, mem_write, alu_src, reg_write);
    chk_control chk_control_inst(chk_addr, npc, pc, ir, ctrl, rf_rd0, rf_rd1, rf_rd2, extended_imm, alu_out, dm_rd0, dm_rd1, chk_data);
    io_control io_control_inst(dm_wd, alu_out, opcode, io_addr, io_we, io_rd, io_dout);
    data_mem data_mem_inst(.a(dm_ra0), .d(dm_wd), .dpra(dm_ra1), .clk(clk), .we(mem_write), .spo(dm_rd0), .dpo(dm_rd1));
    inst_mem inst_mem_inst(.a((pc[9:2])), .spo(ir));

    always@(posedge clk or negedge rstn) begin
        if (~rstn) begin
            pc <= 32'h00003000;
        end
        else begin
            pc <= npc;
        end
    end

    assign next_pc = pc;
endmodule
