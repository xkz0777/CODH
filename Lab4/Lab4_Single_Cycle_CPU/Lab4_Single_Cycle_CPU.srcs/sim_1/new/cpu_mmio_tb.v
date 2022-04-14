`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/04/13 18:25:44
// Design Name:
// Module Name: cpu_mmio_tb
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


module cpu_mmio_tb();
    reg clk, cont, rstn;
    reg [31:0] io_din;
    initial begin
        clk = 0;
        rstn = 0;
        cont = 0;
        io_din = 32'h0000ab4c;
        forever
            #5 clk = ~clk;
    end

    initial begin
        rstn = 0;
        #10 rstn = 1;
    end

    wire [31:0] pc;
    wire [15:0] chk_addr;
    wire [31:0] chk_data;
    cpu cpu_inst(.clk(clk), .rstn(rstn), .pc(pc), .io_din(io_din), .chk_addr(chk_addr), .chk_data(chk_data));
endmodule
