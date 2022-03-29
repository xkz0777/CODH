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


module mem_tb();
    reg clk, we;
    reg [7:0] a;
    reg [15:0] dina;
    wire [15:0] spo, rf_douta, wf_douta;

    dist_mem_gen_0 dm_inst(.a(a), .d(dina), .clk(clk), .we(we), .spo(spo));
    blk_mem_gen_0 rfbm_inst(.addra(a), .dina(dina), .clka(clk), .wea(we), .douta(rf_douta), .ena(1));
    blk_mem_gen_1 wfbm_inst(.addra(a), .dina(dina), .clka(clk), .wea(we), .douta(wf_douta), .ena(1));

    initial begin
        clk = 1;
        forever
            #10 clk = ~clk;
    end

    initial begin
        we = 0;
        #32 we = 1;
        #40 we = 0;
    end

    initial begin
        #32 dina = 16'h1111;
        #20 dina = 16'h2222;
        #20 dina = 16'h3333;
    end

    initial begin
        #15 a = 8'haa;
        #20 a = 8'hbb;
        #20 a = 8'hcc;
        #20 a = 8'hdd;
    end

    initial begin
        #100 $finish;
    end

endmodule
