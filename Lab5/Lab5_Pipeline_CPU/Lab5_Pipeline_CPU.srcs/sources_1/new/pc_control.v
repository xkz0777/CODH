`timescale 1ns / 1ps

module pc_control(
        input [31:0] if_pc,
        input [1:0] pc_src,
        input [2:0] funct3,
        input branch,
        input [31:0] ex_alu_out,
        input [31:0] extended_imm,
        output reg [31:0] next_pc);

    always@(*) begin
        case(pc_src)
            2'b00:
                next_pc = (branch) ? (if_pc - 8 + (extended_imm << 1)) : (if_pc + 4); // B type
            2'b01:
                next_pc = ex_alu_out;
            2'b10:
                next_pc = if_pc + 4;
            2'b11:
                next_pc = if_pc - 8 + (extended_imm << 1); // J type
            default:
                next_pc = if_pc + 4;
        endcase
    end
endmodule
