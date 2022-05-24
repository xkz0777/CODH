`timescale 1ns / 1ps
module display_score_img(
        input clk,
        input rst_n,
        input[10:0] col_addr_sig,
        input[10:0] row_addr_sig,
        input levelup_sig,
        output score_out_c);

    parameter bling = 26'd12_500_000;

    reg[14:0] addra;
    wire next;
    wire next_sp;
    reg next_c;
    assign score_out_c=next_c;

    reg show;
    reg[25:0] count_down;

    always@(posedge clk or negedge rst_n) begin

        if(!rst_n) begin
            count_down	<=	26'd0;
            show <= 0;
        end
        else if(count_down >= bling) begin
            count_down	<=	26'd0;
            show <= ~show;
        end
        else
            count_down	<=	count_down + 1'b1;
    end

    // 坐标改动位置
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            addra <= 0;
        end
        else begin
            if (col_addr_sig >= 12'd360 && col_addr_sig < 12'd600 && row_addr_sig >= 12'd240 && row_addr_sig < 12'd360) begin
                addra <= (row_addr_sig - 12'd240) * 240 + col_addr_sig - 12'd360;
            end
            else
                addra <= 0;
        end
    end

    // 坐标改动位置
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            next_c <= 0;
        end
        else begin
            if (col_addr_sig >= 12'd360 && col_addr_sig < 12'd600 && row_addr_sig >= 12'd240 && row_addr_sig < 12'd360) begin
                if (levelup_sig && show)
                    next_c <= next_sp;
                else
                    next_c <= next;
            end
            else
                next_c <= 0;
        end
    end

    score score (
              .clka(clk), // input clka
              .addra(addra), // input [14 : 0] addra
              .douta(next) // output [0 : 0] douta
          );

    spscore spscore (
                .clka(clk), // input clka
                .addra(addra), // input [14 : 0] addra
                .douta(next_sp) // output [0 : 0] douta
            );

endmodule
