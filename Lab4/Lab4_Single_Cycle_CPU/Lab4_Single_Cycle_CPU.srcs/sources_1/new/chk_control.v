`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/04/13 17:22:33
// Design Name:
// Module Name: chk_control
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


module chk_control(
        input [15:0] chk_addr,
        input [31:0] npc,
        input [31:0] pc,
        input [31:0] ir,
        input [31:0] ctrl,
        input [31:0] rf_rd0,
        input [31:0] rf_rd1,
        input [31:0] rf_rd2,
        input [31:0] extended_imm,
        input [31:0] alu_out,
        input [31:0] dm_rd0,
        input [31:0] dm_rd1,
        output reg [31:0] chk_data
    );
    always@(*) begin
        case(chk_addr[15:12])
            0: begin
                case (chk_addr[3:0])
                    4'h0:
                        chk_data = npc;
                    4'h1:
                        chk_data = pc;
                    4'h2:
                        chk_data = ir;
                    4'h3:
                        chk_data = ctrl;
                    4'h4:
                        chk_data = rf_rd0;
                    4'h5:
                        chk_data = rf_rd1;
                    4'h6:
                        chk_data = extended_imm;
                    4'h7:
                        chk_data = alu_out;
                    4'h8:
                        chk_data = dm_rd0;
                    default:
                        chk_data = 0;
                endcase
            end
            1: begin
                chk_data = rf_rd2;
            end
            2: begin
                chk_data = dm_rd1;
            end
            default:
                chk_data = 0;
        endcase
    end
endmodule
