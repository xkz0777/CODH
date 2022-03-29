`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/29 20:29:56
// Design Name:
// Module Name: rf_tb
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


module rf_tb();
    parameter AW = 5;
    parameter DW = 32;
    reg clk, we;
    reg [AW-1:0] ra0, ra1, wa;
    wire [DW-1:0] rd0, rd1;
    reg [DW-1:0] wd;

    register_file #(AW, DW) rf_inst(clk, ra0, ra1, rd0, rd1, wa, wd, we);

    initial begin
        clk = 1;
        forever
            #5 clk = ~clk;
    end

    initial begin
        we = 0;
        forever
            #10 we = ~we;
    end

    initial begin
        wa = 5'd0;
        #8 wa = 5'd3;
        #5 wa = 5'd10;
        #6 wa = 5'd17;
        #7 wa = 5'd20;
        #8 wa = 5'd18;
        #10 wa = 5'd14;
        #11 wa = 5'd11;
        #4 wa = 5'd17;
        #10 wa = 5'd0;
        #10 wa = 5'd1;
        #10 wa = 5'd2;
    end

    initial begin
        ra0 = 5'd0;
        #10 ra0 = 5'd3;
        #5 ra0 = 5'd10;
        #8 ra0 = 5'd17;
        #10 ra0 = 5'd20;
        #11 ra0 = 5'd18;
        #10 ra0 = 5'd14;
        #11 ra0 = 5'd11;
        #4 ra0 = 5'd17;
        #10 ra0 = 5'd1;
        #10 ra0 = 5'd2;
    end

    initial begin
        ra1 = 5'd0;
        #10 ra1 = 5'd10;
        #5 ra1 = 5'd17;
        #8 ra1 = 5'd11;
        #10 ra1 = 5'd20;
        #11 ra1 = 5'd11;
        #10 ra1 = 5'd14;
        #11 ra1 = 5'd11;
        #4 ra1 = 5'd17;
        #10 ra1 = 5'd1;
        #10 ra1 = 5'd2;
    end

    initial begin
        wd = 16'h1;
        #8 wd = 16'h2;
        #5 wd = 16'h3;
        #6 wd = 16'h4;
        #7 wd = 16'h5;
        #8 wd = 16'h6;
        #10 wd = 16'h7;
        #11 wd = 16'h8;
        #4 wd = 16'h9;
        #10 wd = 16'h10;
        #10 wd = 16'h11;
        #10 wd = 16'h12;
    end

    initial begin
        #100 $finish;
    end
endmodule
