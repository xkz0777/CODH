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
    reg clk;
    reg [3:0] h;
    reg rstn;
    wire p;

    wire [15:0] edge_x;
    generate
        genvar i;
        for (i = 0; i < 16; i = i + 1) begin: DPE_BLOCK
            double_edge edge_inst(clk, x[i], edge_x[i]);
        end
    endgenerate

    assign p = |edge_x;

    reg [15:0] tmp;
    always@(posedge clk) begin
        if (~rstn)
            tmp <= 0;
        if (p)
            tmp <= edge_x; // 寄存 edge_x，使得产生的 h 信号能够持续
    end

    always@(*) begin
        case (tmp)
            16'h0001:
                h = 0;
            16'h0002:
                h = 1;
            16'h0004:
                h = 2;
            16'h0008:
                h = 3;
            16'h0010:
                h = 4;
            16'h0020:
                h = 5;
            16'h0040:
                h = 6;
            16'h0080:
                h = 7;
            16'h0100:
                h = 8;
            16'h0200:
                h = 9;
            16'h0400:
                h = 10;
            16'h0800:
                h = 11;
            16'h1000:
                h = 12;
            16'h2000:
                h = 13;
            16'h4000:
                h = 14;
            16'h8000:
                h = 15;
            default:
                h = 0;
        endcase
    end

    initial begin
        x = 0;
        rstn = 0;
        #9 rstn = 1;
        #1 x = 16'h0008;
        #10 x = 16'h0082;
        #10 x = 16'h0080;
        #10 x = 16'h0180;
        #10 $finish;
    end

    initial begin
        clk = 0;
        forever
            #1 clk = ~clk;
    end
endmodule
