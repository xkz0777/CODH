`timescale 1ns / 1ps

module cpu (
        input clk, rstn,
        // IO_BUS
        output [7:0] io_addr, // 外设地址
        output [31:0] io_dout, // 向外设输出的数据
        output io_we, // 向外设输出数据时的写使能信号
        output io_rd, // 从外设输入数据时的读使能信号
        input [31:0] io_din, // 来自外设输入的数据
        // Debug_BUS
        output [31:0] chk_pc, // 当前执行指令地址
        input [15:0] chk_addr, // 数据通路状态的编码地址
        output [31:0] chk_data // 数据通路状态的数据
    );

    // IF 段
    wire [31:0] if_npc; // 由 pc_control 生成
    reg [31:0] if_pc; // if 取指的 pc
    wire [31:0] if_ir; // 取指得到的 ir
    wire stall, if_flush, id_flush;

    always@(posedge clk or negedge rstn) begin
        if (!rstn)
            if_pc <= 32'h00003000;
        else if (!stall)
            if_pc <= if_npc;
    end

    assign chk_pc = if_pc;

    inst_mem inst_mem_inst(.clk(clk), .d(0), .we(0), .a((if_pc[9:2])), .spo(if_ir));

    // ID
    // 段间寄存器
    reg [31:0] id_pc;
    reg [31:0] id_ir;

    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            id_pc <= 32'h00003000;
            id_ir <= 0;
        end
        else begin
            if (!stall) begin
                if (!if_flush) begin
                    id_pc <= if_pc;
                    id_ir <= if_ir;
                end
                else begin
                    id_pc <= 32'h00003000;
                    id_ir <= 0;
                end
            end
        end
    end

    // 译码
    wire [6:0] id_opcode;
    wire [2:0] id_funct3;
    wire [6:0] id_funct7;
    wire [24:0] id_imm;
    wire [4:0] id_rs1;
    wire [4:0] id_rs2;
    wire [4:0] id_rd;

    assign id_opcode = id_ir[6:0];
    assign id_rd = id_ir[11:7];
    assign id_funct3 = id_ir[14:12];
    assign id_rs1 = id_ir[19:15];
    assign id_rs2 = id_ir[24:20];
    assign id_funct7 = id_ir[31:25];
    assign id_imm = id_ir[31:7];

    // 立即数生成
    wire [31:0] id_extended_imm;
    imm_gen imm_gen_inst(id_imm, id_opcode, id_extended_imm);

    // register file
    wire [4:0] rf_ra0, rf_ra1, rf_ra2;
    wire [4:0] rf_wa;
    wire [31:0] rf_rd0, rf_rd1, rf_rd2;

    assign rf_ra0 = id_rs1;
    assign rf_ra1 = id_rs2;
    assign rf_ra2 = chk_addr[4:0];
    assign rf_wa = id_rd;

    // 生成控制信号
    wire [2:0] id_alu_op;
    wire [1:0] id_alu_src;
    wire id_is_branch;
    wire id_mem_write;
    wire [1:0] id_pc_src;
    wire id_reg_write;
    wire [1:0] id_mem_to_reg;
    control control_inst(id_opcode, id_funct3, id_funct7, id_mem_write, id_reg_write, id_mem_to_reg, id_alu_src, id_is_branch, id_pc_src, id_alu_op);

    // EX
    wire [31:0] ex_a, ex_b;
    wire [31:0] alu_in0, alu_in1; // forwarding unit 生成
    wire [2:0] ex_cc;
    wire [31:0] ex_alu_out;
    reg [31:0] ex_rf_rd0, ex_rf_rd1;

    // 段间寄存器
    reg [31:0] ex_pc;
    reg [31:0] ex_ir;
    reg [4:0] ex_rs1;
    reg [4:0] ex_rs2;
    reg [4:0] ex_rd;
    reg [2:0] ex_funct3;
    reg [6:0] ex_opcode;
    reg [31:0] ex_extended_imm;

    reg [2:0] ex_alu_op;
    reg [1:0] ex_alu_src;
    reg ex_is_branch;
    reg ex_mem_write;
    reg [1:0] ex_pc_src;
    reg [1:0] ex_mem_to_reg;
    reg ex_reg_write;
    reg [4:0] ex_rf_wa;

    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            ex_pc <= 32'h00003000;
            ex_ir <= 0;
            ex_rs1 <= 0;
            ex_rs2 <= 0;
            ex_rd <= 0;
            ex_funct3 <= 0;
            ex_opcode <= 0;
            ex_extended_imm <= 0;
            ex_alu_op <= 0;
            ex_alu_src <= 0;
            ex_is_branch <= 0;
            ex_mem_write <= 0;
            ex_pc_src <= 0;
            ex_mem_to_reg <= 0;
            ex_reg_write <= 0;
            ex_rf_rd0 <= 0;
            ex_rf_rd1 <= 0;
            ex_rf_wa <= 0;
        end

        else begin
            if(!id_flush && !stall) begin
                ex_pc <= id_pc;
                ex_ir <= id_ir;
                ex_rs1 <= id_rs1;
                ex_rs2 <= id_rs2;
                ex_rd <= id_rd;
                ex_funct3 <= id_funct3;
                ex_opcode <= id_opcode;
                ex_extended_imm <= id_extended_imm;
                ex_alu_op <= id_alu_op;
                ex_alu_src <= id_alu_src;
                ex_is_branch <= id_is_branch;
                ex_mem_write <= id_mem_write;
                ex_pc_src <= id_pc_src;
                ex_mem_to_reg <= id_mem_to_reg;
                ex_reg_write <= id_reg_write;
                ex_rf_rd0 <= rf_rd0;
                ex_rf_rd1 <= rf_rd1;
                ex_rf_wa <= rf_wa;
            end
            else begin
                ex_pc <= 32'h00003000;
                ex_ir <= 0;
                ex_rs1 <= 0;
                ex_rs2 <= 0;
                ex_rd <= 0;
                ex_funct3 <= 0;
                ex_opcode <= 0;
                ex_extended_imm <= 0;
                ex_alu_op <= 0;
                ex_alu_src <= 0;
                ex_is_branch <= 0;
                ex_mem_write <= 0;
                ex_pc_src <= 0;
                ex_mem_to_reg <= 0;
                ex_reg_write <= 0;
                ex_rf_rd0 <= 0;
                ex_rf_rd1 <= 0;
            end
        end
    end

    assign alu_in0 = ex_alu_src[1] ? ex_pc : ex_a;
    assign alu_in1 = ex_alu_src[0] ? ex_extended_imm : ex_b;

    alu alu_inst(alu_in0, alu_in1, ex_alu_op, ex_alu_out, ex_cc);

    wire ex_branch;
    branch_control branch_control_inst(ex_is_branch, ex_cc, ex_funct3, ex_branch);
    hazard hazard_inst(ex_branch, ex_opcode, ex_rd, id_rs1, id_rs2, stall, if_flush, id_flush);
    pc_control pc_control_inst(if_pc, ex_pc_src, ex_funct3, ex_branch, ex_alu_out, ex_extended_imm, if_npc);

    // MEM
    reg [31:0] mem_pc;
    reg [31:0] mem_alu_out;
    reg [31:0] mem_ir;
    reg [4:0] mem_rd;
    reg [31:0] mem_b;
    reg [6:0] mem_opcode;
    reg [4:0] mem_rf_wa;
    reg [31:0] mem_extended_imm;

    reg mem_branch;
    reg mem_mem_write;
    reg [1:0] mem_mem_to_reg;
    reg [1:0] mem_pc_src;
    reg mem_reg_write;

    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            mem_pc <= 32'h00003000;
            mem_alu_out <= 0;
            mem_ir <= 0;
            mem_extended_imm <= 0;
            mem_rd <= 0;
            mem_b <= 0;
            mem_opcode <= 0;
            mem_branch <= 0;
            mem_mem_write <= 0;
            mem_mem_to_reg <= 0;
            mem_pc_src <= 0;
            mem_reg_write <= 0;
            mem_rf_wa <= 0;
        end

        else begin
            mem_pc <= ex_pc;
            mem_alu_out <= ex_alu_out;
            mem_ir <= ex_ir;
            mem_rd <= ex_rd;
            mem_extended_imm <= ex_extended_imm;
            mem_b <= ex_b;
            mem_opcode <= ex_opcode;
            mem_branch <= ex_branch;
            mem_mem_write <= ex_mem_write;
            mem_mem_to_reg <= ex_mem_to_reg;
            mem_pc_src <= ex_pc_src;
            mem_reg_write <= ex_reg_write;
            mem_rf_wa <= ex_rf_wa;
        end
    end

    wire [7:0] dm_ra0, dm_ra1;
    wire [31:0] dm_wd;
    wire [31:0] dm_rd0, dm_rd1;
    reg [31:0] wb_dm_rd0;
    assign dm_ra1 = chk_addr[7:0];
    assign dm_ra0 = mem_alu_out[9:2]; // MMIO start at 0
    assign dm_wd = mem_b;

    data_mem data_mem_inst(.a(dm_ra0), .d(dm_wd), .dpra(dm_ra1), .clk(clk), .we(mem_mem_write), .spo(dm_rd0), .dpo(dm_rd1));
    io_control io_control_inst(dm_wd, mem_alu_out, mem_opcode, io_addr, io_we, io_rd, io_dout);

    // WB
    reg [4:0] wb_rd;
    reg [31:0] wb_pc;
    reg [31:0] wb_alu_out;
    reg [31:0] wb_extended_imm;
    reg [1:0] wb_mem_to_reg;
    reg wb_reg_write;
    reg [4:0] wb_rf_wa;
    reg [31:0] wb_io_din;
    reg wb_io_rd;

    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            wb_rd <= 0;
            wb_pc <= 0;
            wb_extended_imm <= 0;
            wb_alu_out <= 0;
            wb_dm_rd0 <= 0;
            wb_reg_write <= 0;
            wb_rf_wa <= 0;
            wb_mem_to_reg <= 0;
            wb_io_din <= 0;
            wb_io_rd <= 0;
        end

        else begin
            wb_rd <= mem_rd;
            wb_pc <= mem_pc;
            wb_extended_imm <= mem_extended_imm;
            wb_alu_out <= mem_alu_out;
            wb_dm_rd0 <= dm_rd0;
            wb_reg_write <= mem_reg_write;
            wb_rf_wa <= mem_rf_wa;
            wb_mem_to_reg <= mem_mem_to_reg;
            wb_io_din <= io_din;
            wb_io_rd <= io_rd;
        end
    end

    wire [31:0] wb_rf_wd;

    rf_control rf_control_inst(wb_io_rd, wb_io_din, wb_mem_to_reg, wb_alu_out, wb_pc, wb_dm_rd0, wb_extended_imm, wb_rf_wd);
    register_file rf_inst(clk, rf_ra0, rf_ra1, rf_ra2, rf_rd0, rf_rd1, rf_rd2, wb_rf_wa, wb_rf_wd, wb_reg_write);
    forwarding forwarding_inst(ex_rs1, ex_rs2, mem_rd, wb_rd, mem_reg_write, wb_reg_write, ex_rf_rd0, ex_rf_rd1, mem_alu_out, wb_rf_wd, ex_a, ex_b);

    wire [31:0] id_ctrl, mem_ctrl, wb_ctrl;
    assign id_ctrl[11:0] = {id_alu_op, id_alu_src, id_is_branch, id_mem_write, id_pc_src, id_reg_write, id_mem_to_reg};
    assign mem_ctrl[3:0] = {mem_mem_write, mem_reg_write, mem_mem_to_reg};
    assign wb_ctrl[2:0] = {wb_reg_write, wb_mem_to_reg};
    chk_control chk_control_inst(chk_addr, if_npc, if_pc, if_ir, id_ctrl, rf_rd0, rf_rd1, id_extended_imm, ex_alu_out, dm_rd0, dm_rd1, chk_data);

endmodule
