`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/04/13 20:45:57
// Design Name:
// Module Name: top_mmio_tb
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


module top_mmio_tb();
    reg clk, cont, rstn;
    initial begin
        clk = 0;
        rstn = 0;
        cont = 0;
        forever
            #5 clk = ~clk;
    end

    initial begin
        #4 cont = 1;
        rstn = 1;
        #2040000000 cont = 0;
    end

    top top_inst(.clk(clk), .rstn(rstn), .cont(cont));
endmodule
