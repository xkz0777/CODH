`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/04/12 17:17:38
// Design Name:
// Module Name: control
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
//////////////////////////////////////////////////////////////////////////////////


module control(
        input [6:0] opcode,
        input [2:0] cc,
        input [2:0] funct3,
        output branch,
        output reg [1:0] reg_write_sel,
        output reg [1:0] pc_ctrl,
        output reg mem_write,
        output reg alu_src,
        output reg reg_write
    );
    parameter R_TYPE = 7'b0110011; // ADD, SUB
    parameter I_TYPE = 7'b0010011; // ADDI
    parameter I_JALR = 7'b1100111; // JALR
    parameter I_LOAD = 7'b0000011; // LW
    parameter S_TYPE = 7'b0100011; // SW
    parameter B_TYPE = 7'b1100011; // BEQ, BLT
    parameter U_TYPE = 7'b0010111; // AUIPC
    parameter UJ_JAL = 7'b1101111; // JAL

    reg b;

    always @(*) begin
        case(opcode)
            R_TYPE: begin
                b = 0;
                reg_write_sel = 0; // alu
                pc_ctrl = 2; // pc + 4
                mem_write = 0;
                alu_src = 0;
                reg_write = 1;
            end
            I_TYPE: begin
                b = 0;
                reg_write_sel = 0; // alu
                pc_ctrl = 2; // pc + 4
                mem_write = 0;
                alu_src = 1;
                reg_write = 1;
            end
            I_JALR: begin
                b = 0;
                reg_write_sel = 1; // pc + 4
                pc_ctrl = 1; // alu_out, rs1 + imm
                mem_write = 0;
                alu_src = 1;
                reg_write = 1;
            end
            I_LOAD: begin
                b = 0;
                reg_write_sel = 2; // mem
                pc_ctrl = 2; // pc + 4
                mem_write = 0;
                alu_src = 1;
                reg_write = 1;
            end
            S_TYPE: begin
                b = 0;
                reg_write_sel = 2; // mem
                pc_ctrl = 2; // pc + 4
                mem_write = 1;
                alu_src = 1;
                reg_write = 0;
            end
            B_TYPE: begin
                b = 1;
                reg_write_sel = 0; // alu
                pc_ctrl = 0; // branch ? pc + imm
                mem_write = 0;
                alu_src = 0;
                reg_write = 0;
            end
            U_TYPE: begin
                b = 0;
                reg_write_sel = 3; // pc + imm
                pc_ctrl = 2; // pc + 4
                mem_write = 0;
                alu_src = 0;
                reg_write = 1;
            end
            UJ_JAL: begin
                b = 0;
                reg_write_sel = 1; // pc + 4
                pc_ctrl = 3; // pc + imm
                mem_write = 0;
                alu_src = 1;
                reg_write = 1;
            end
            default: begin
                b = 0;
                reg_write_sel = 0;
                pc_ctrl = 0;
                mem_write = 0;
                alu_src = 0;
                reg_write = 0;
            end
        endcase
    end

    branch_control branch_control_inst(b, cc, funct3, branch);

endmodule
