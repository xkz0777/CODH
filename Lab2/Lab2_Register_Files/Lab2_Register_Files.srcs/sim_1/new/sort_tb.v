`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/30 18:16:16
// Design Name:
// Module Name: sort_tb
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


module sort_tb();
    reg clk, rstn, del, addr, data, chk, run;
    reg [15:0] x;
    wire [7:0] an;
    wire [6:0] seg;
    wire busy;
    wire [15:0] cnt;

    sort #(.CYCLE(1)) sort_inst(clk, rstn, x, del, addr, data, chk, run, an, seg, busy, cnt);

    initial begin
        clk = 0;
        forever
            #2 clk = ~clk;
    end

    initial begin
        rstn = 0;
        #5 rstn = 1;
    end

    initial begin
        run = 0;
        #10 run = 1;
        #10 run = 0;
    end

    initial begin
        #10000 $finish;
    end
endmodule
