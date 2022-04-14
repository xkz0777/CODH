`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/04/12 23:07:29
// Design Name:
// Module Name: top_tb
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


module cpu_tb();
    reg clk, cont, rstn;
    initial begin
        clk = 0;
        rstn = 0;
        cont = 0;
        forever
            #5 clk = ~clk;
    end

    initial begin
        rstn = 0;
        #10 rstn = 1;
    end

    wire [31:0] pc;
    reg [15:0] chk_addr;

    initial begin
        chk_addr = 16'h2000;
    end


    wire [31:0] chk_data;
    cpu cpu_inst(.clk(clk), .rstn(rstn), .next_pc(pc), .chk_addr(chk_addr), .chk_data(chk_data));
endmodule
