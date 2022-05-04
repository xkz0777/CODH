`timescale 1ns / 1ps

module control(
        input [6:0] opcode,
        input [2:0] funct3,
        input [6:0] funct7,
        output reg mem_write,
        output reg reg_write,
        output reg [1:0] mem_to_reg,
        output reg [1:0] alu_src,
        output reg branch,
        output reg [1:0] pc_src,
        output reg [2:0] alu_op
    );

    parameter R_TYPE = 7'b0110011; // ADD, SUB
    parameter I_TYPE = 7'b0010011; // ADDI
    parameter I_JALR = 7'b1100111; // JALR
    parameter I_LOAD = 7'b0000011; // LW
    parameter S_TYPE = 7'b0100011; // SW
    parameter B_TYPE = 7'b1100011; // BEQ, BLT
    parameter U_TYPE = 7'b0010111; // AUIPC
    parameter UJ_JAL = 7'b1101111; // JAL

    parameter ADD = 3'b001;
    parameter SUB = 3'b000;
    parameter SL = 3'b110;
    parameter XOR = 3'b100;
    parameter SRL = 3'b101;
    parameter SRA = 3'b111;
    parameter OR  = 3'b011;
    parameter AND = 3'b010;

    always @(*) begin
        case(opcode)
            R_TYPE: begin
                branch = 0;
                mem_to_reg = 0; // alu
                pc_src = 2; // pc + 4
                mem_write = 0;
                alu_src = 0; // rf + rf
                reg_write = 1;
            end
            I_TYPE: begin
                branch = 0;
                mem_to_reg = 0; // alu
                pc_src = 2; // pc + 4
                mem_write = 0;
                alu_src = 1; // rf + imm
                reg_write = 1;
            end
            I_JALR: begin
                branch = 0;
                mem_to_reg = 1; // pc + 4
                pc_src = 1; // alu_out, rs1 + imm
                mem_write = 0;
                alu_src = 1; // rf + imm
                reg_write = 1;
            end
            I_LOAD: begin
                branch = 0;
                mem_to_reg = 2; // mem
                pc_src = 2; // pc + 4
                mem_write = 0;
                alu_src = 1; // rf + imm
                reg_write = 1;
            end
            S_TYPE: begin
                branch = 0;
                mem_to_reg = 2; // mem
                pc_src = 2; // pc + 4
                mem_write = 1;
                alu_src = 1; // rf + imm
                reg_write = 0;
            end
            B_TYPE: begin
                branch = 1;
                mem_to_reg = 0; // alu
                pc_src = 0; // branch ? pc + imm
                mem_write = 0;
                alu_src = 0; // rf + rf
                reg_write = 0;
            end
            U_TYPE: begin
                branch = 0;
                mem_to_reg = 3; // pc + imm
                pc_src = 2; // pc + 4
                mem_write = 0;
                alu_src = 3; // pc + imm
                reg_write = 1;
            end
            UJ_JAL: begin
                branch = 0;
                mem_to_reg = 1; // pc + 4
                pc_src = 3; // pc + imm
                mem_write = 0;
                alu_src = 1; // pc + 4
                reg_write = 1;
            end
            default: begin
                branch = 0;
                mem_to_reg = 0;
                pc_src = 0;
                mem_write = 0;
                alu_src = 0;
                reg_write = 0;
            end
        endcase
    end

    always @(*) begin
        case(opcode)
            R_TYPE : begin
                case(funct3)
                    3'b000:
                        alu_op = (funct7 == 0) ? ADD : SUB;
                    3'b001:
                        alu_op = SL;
                    3'b010:
                        alu_op = SL;
                    3'b011:
                        alu_op = SL;
                    3'b100:
                        alu_op = XOR;
                    3'b101:
                        alu_op = funct7 == 0 ? SRL : SRA;
                    3'b110:
                        alu_op = OR;
                    3'b111:
                        alu_op = AND;
                endcase
            end
            I_TYPE: begin
                case(funct3)
                    3'b000:
                        alu_op = ADD;    // addi
                    3'b001:
                        alu_op = SL;    // slli
                    3'b010:
                        alu_op = SL;    // slti
                    3'b011:
                        alu_op = SL;   // sltiu
                    3'b100:
                        alu_op = XOR;    // xori
                    3'b101:
                        alu_op = (funct7 == 0) ? SRL : SRA; // srli, srai
                    3'b110:
                        alu_op = OR;     // or
                    3'b111:
                        alu_op = AND;    // andi
                endcase
            end
            B_TYPE:
                alu_op = SUB;
            default:
                alu_op = ADD;
        endcase
    end

endmodule
