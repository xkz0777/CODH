`timescale 1ns / 1ps

module imm_gen(
        input [24:0] imm,
        input [6:0] opcode,
        output reg [31:0] extended_imm
    );

    parameter R_TYPE = 7'b0110011; // ADD, SUB
    parameter I_TYPE = 7'b0010011; // ADDI
    parameter I_JALR = 7'b1100111; // JALR
    parameter I_LOAD = 7'b0000011; // LW
    parameter S_TYPE = 7'b0100011; // SW
    parameter B_TYPE = 7'b1100011; // BEQ, BLT
    parameter U_TYPE = 7'b0010111; // AUIPC
    parameter UJ_JAL = 7'b1101111; // JAL

    always @(*) begin
        case(opcode)
            R_TYPE:
                extended_imm = 0;
            I_TYPE:
                extended_imm = {{20{imm[24]}}, imm[24:13]};
            I_JALR:
                extended_imm = {{20{imm[24]}}, imm[24:13]};
            I_LOAD:
                extended_imm = {{20{imm[24]}}, imm[24:13]};
            S_TYPE:
                extended_imm = {{20{imm[24]}}, imm[24:18], imm[4:0]};
            B_TYPE:
                extended_imm = {{20{imm[24]}}, imm[24], imm[0], imm[23:18], imm[4:1]};
            U_TYPE:
                extended_imm = {imm[24:5], 12'b0};
            UJ_JAL:
                extended_imm = {{12{imm[24]}}, imm[24], imm[12:5], imm[13], imm[23:14]};
            default:
                extended_imm = 0;
        endcase
    end
endmodule
