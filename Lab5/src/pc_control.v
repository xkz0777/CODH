`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/04/12 17:29:00
// Design Name:
// Module Name: pc_control
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


module pc_control(
        input [31:0] pc,
        input [1:0] pc_ctrl,
        input branch,
        input [31:0] alu_out,
        input [31:0] extended_imm,
        output reg [31:0] next_pc);
    always@(*) begin
        case(pc_ctrl)
            2'b00:
                next_pc = (branch) ? (pc + (extended_imm << 1)) : (pc + 4); // B type
            2'b01:
                next_pc = alu_out;
            2'b10:
                next_pc = pc + 4;
            2'b11:
                next_pc = pc + (extended_imm << 1); // J type
            default:
                next_pc = pc;
        endcase
    end
endmodule
