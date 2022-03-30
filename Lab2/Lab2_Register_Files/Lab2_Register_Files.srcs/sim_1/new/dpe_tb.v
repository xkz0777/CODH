`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/29 22:51:01
// Design Name:
// Module Name: dpe_tb
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


module dpe_tb();
    reg [15:0] x;
    reg clk, rstn;
    wire [3:0] h;
    wire p;

    dpe #(.CYCLE(1)) dpe_inst(clk, rstn, x, p, h);

    initial begin
        x = 0;
        rstn = 1;
        #20 x = 16'h0008;
        #20 x = 16'h0082;
        #20 x = 16'h0080;
        #20 x = 16'h0180;
        #10 rstn = 0;
        #10 x = 16'h0080;
        #20 $finish;
    end

    initial begin
        clk = 0;
        forever
            #5 clk = ~clk;
    end
endmodule
