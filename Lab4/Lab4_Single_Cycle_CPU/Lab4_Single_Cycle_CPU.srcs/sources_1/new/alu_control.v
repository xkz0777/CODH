`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/04/12 16:34:58
// Design Name:
// Module Name: alu_control
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


module alu_control(
        input [6:0] opcode,
        input [2:0] funct3,
        input [6:0] funct7,
        output reg [2:0] alu_op);

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
