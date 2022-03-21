`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/21 19:08:13
// Design Name:
// Module Name: fls_top
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


module fls_top (
        input clk,
        input rstn,
        input en,
        input [15:0] sw,
        output [15:0] led
    );

    wire out;
    en_edge inst(en, clk, out);
    fls fls_inst(clk, rstn, out, sw, led);
endmodule
