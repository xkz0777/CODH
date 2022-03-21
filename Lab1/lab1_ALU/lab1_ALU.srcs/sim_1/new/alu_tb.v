`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/20 15:31:33
// Design Name:
// Module Name: alu_tb
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


module alu_tb();
    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] s;
    wire [31:0] y;
    wire [2:0] f;
    alu alu_inst(a, b, s, y, f);

    initial begin
        a = $random;
        b = $random;
        s = 0;
        forever
            #5 s = s + 1;
    end

    initial
        #40 $finish;
endmodule
