`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/30 12:13:57
// Design Name:
// Module Name: display
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


module display(
        input clk,
        input [7:0] a,
        input [15:0] d,
        output [7:0] an,
        output [6:0] seg
    );

    reg [5:0] an_eff;
    reg [3:0] seg_input;

    seg_table seg_table_inst(seg_input, seg);
    assign an[5:4] = 2'b11;
    assign {an[7:6], an[3:0]} = an_eff;

    reg [18:0] cnt; // 分时复用计数器
    always@(posedge clk) begin
        if (cnt >= 19'h6fff)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end

    wire [2:0] sel;
    assign sel = cnt[18:16];

    always@(*) begin
        an_eff = 6'b111111;

        case (sel)
            0: begin
                an_eff[0] = 0;
                seg_input = d[3:0];
            end

            1: begin
                an_eff[1] = 0;
                seg_input = d[7:4];
            end

            2: begin
                an_eff[2] = 0;
                seg_input = d[11:8];
            end

            3: begin
                an_eff[3] = 0;
                seg_input = d[15:12];
            end

            4: begin
                an_eff[4] = 0;
                seg_input = a[3:0];
            end

            5: begin
                an_eff[5] = 0;
                seg_input = a[7:4];
            end

            default:
                seg_input = 0;
        endcase
    end

endmodule
