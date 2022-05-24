`timescale 1ns / 1ps

module top_sim();
    reg clk;
    reg rst_n;

    top top(.sys_clk(clk), .rst_n(rst_n));
    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin
        rst_n = 0;
        #10 rst_n = 1;
    end

endmodule
