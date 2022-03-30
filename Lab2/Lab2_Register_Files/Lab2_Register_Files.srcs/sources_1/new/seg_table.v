`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/30 12:31:24
// Design Name:
// Module Name: seg_table
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


module seg_table( // 数码管数据查找表
        input [3:0] in,
        output reg [6:0] seg
    );
    always@(*) begin
        case (in)
            4'h0:
                seg = 7'h01;
            4'h1:
                seg = 7'h4f;
            4'h2:
                seg = 7'h12;
            4'h3:
                seg = 7'h06;
            4'h4:
                seg = 7'h4c;
            4'h5:
                seg = 7'h24;
            4'h6:
                seg = 7'h20;
            4'h7:
                seg = 7'h0f;
            4'h8:
                seg = 7'h00;
            4'h9:
                seg = 7'h04;
            4'ha:
                seg = 7'h08;
            4'hb:
                seg = 7'h60;
            4'hc:
                seg = 7'h31;
            4'hd:
                seg = 7'h42;
            4'he:
                seg = 7'h30;
            4'hf:
                seg = 7'h38;
        endcase
    end
endmodule
