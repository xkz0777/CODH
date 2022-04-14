`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/04/13 17:17:40
// Design Name:
// Module Name: rf_control
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


module rf_control(
        input io_rd,
        input [31:0] io_din,
        input [1:0] reg_write_sel,
        input [31:0] alu_out,
        input [31:0] pc,
        input [31:0] dm_rd0,
        input [31:0] extended_imm,
        output reg [31:0] rf_wd
    );
    always@(*) begin
        if(io_rd)
            rf_wd = io_din;
        else begin
            case (reg_write_sel)
                0:
                    rf_wd = alu_out;
                1:
                    rf_wd = pc + 4;
                2:
                    rf_wd = dm_rd0;
                3:
                    rf_wd = pc + extended_imm;
            endcase
        end
    end
endmodule
