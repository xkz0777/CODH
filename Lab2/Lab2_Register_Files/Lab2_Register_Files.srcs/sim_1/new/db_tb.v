`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/30 10:46:06
// Design Name:
// Module Name: db_tb
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


module db_tb();
    reg clk, btn;
    wire out;

    db #(.CYCLE(1)) db_inst(clk, btn, 1, out);

    initial begin
        clk = 0;
        forever
            #5 clk = ~clk;
    end

    initial begin
        btn = 0;
        forever
            #20 btn = ~btn;
    end

    initial begin
        #200 $finish;
    end
endmodule
