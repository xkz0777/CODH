`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/29 19:22:21
// Design Name:
// Module Name: dpe
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


module dpe #(parameter CYCLE=25) ( // 去抖动、取双边沿、编码
        input clk, rstn,
        input [15:0] x,
        output reg p,
        output reg [3:0] h
    );

    wire [15:0] db_x, edge_x;
    generate
        genvar i;
        for (i = 0; i < 16; i = i + 1) begin: DPE_BLOCK
            db #(.CYCLE(CYCLE)) db_inst(clk, x[i], rstn, db_x[i]);
            double_edge edge_inst(clk, db_x[i], edge_x[i]);
        end
    endgenerate

    wire tmp_p;
    reg [15:0] tmp_h; // 寄存，使得 h 脉冲能持续多周期

    assign tmp_p = |edge_x;
    always@(posedge clk) begin
        p <= tmp_p;
    end

    always@(posedge clk)
        if (~rstn)
            tmp_h <= 0;
        else if (tmp_p)
            tmp_h <= edge_x;

    always@(*) begin
        case (tmp_h)
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
endmodule
