`timescale 1ns / 1ps
// 四分频，640*480 的 VGA 显示需要 25MHZ 的时钟
module div_clk(
        input rst_n,
        input sys_clk,
        output reg clk);

    reg[1:0] h;

    always@(posedge sys_clk) begin
        if(!rst_n) begin
            h <= 0;
            clk <= 0;
        end

        else begin
            if(h == 2'b00) begin
                clk <= 0;
                h <= h + 1;
            end
            else if(h == 2'b01) begin
                clk <= 0;
                h <= h + 1;
            end
            else if(h == 2'b10) begin
                clk <= 1'b1;
                h <= h + 1;
            end
            else begin
                clk <= 1'b1;
                h <= h + 1;
            end
        end
    end
endmodule
