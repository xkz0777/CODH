`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/21 17:11:11
// Design Name:
// Module Name: fls_tb
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


module fls_tb();
    reg clk, rstn, en;
    reg [15:0] d;
    wire [15:0] f;

    initial begin
        clk = 0;
        forever
            #5 clk = clk + 1;
    end

    initial begin
        rstn = 0;
        #8 rstn = 1;
    end

    initial begin
        en = 0;
        #12 en = 1;
        #9 en = 0;
        #21 en = 1;
        #10 en = 0;
        #10 en = 1;
        #10 en = 0;
        #10 en = 1;
        #10 en = 0;
        #5 $finish;
    end

    initial begin
        d = 2;
        #32 d = 3;
        #20 d = 4;
    end

    fls fls_inst(clk, rstn, en, d, f);
endmodule
