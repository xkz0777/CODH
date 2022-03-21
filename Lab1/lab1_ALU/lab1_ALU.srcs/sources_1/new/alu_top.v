`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/20 16:56:18
// Design Name:
// Module Name: alu_download
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


module alu_top(
        input [15:0] sw,
        input en, rstn, clk,
        output [15:13] ledf,
        output [5:0] ledy
    );

    wire [5:0] a, b, y;
    wire [2:0] s, f;

    register #(.WIDTH(3)) s1(sw[15:13], en, rstn, clk, s);
    register #(.WIDTH(3)) s2(f, 1'b1, rstn, clk, ledf);
    register s3(sw[11:6], en, rstn, clk, a);
    register s4(sw[5:0], en, rstn, clk, b);
    register s5(y, 1'b1, rstn, clk, ledy);

    alu #(.WIDTH(6)) alu_inst(a, b, s, y, f);

endmodule
