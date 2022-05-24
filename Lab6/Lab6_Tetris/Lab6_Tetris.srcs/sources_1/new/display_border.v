`timescale 1ns / 1ps
// 边界显示模块，到时候只需要修改一下参数就可以了
module display_border(
        input clk,
        input rst_n,
        input[10:0] col_addr_sig,
        input[10:0] row_addr_sig,
        output enable_black_border);

    // 修改 h_start 和 v_start
    parameter h_start = 11'd41;
    parameter v_start = 11'd31;
    parameter border_width = 11'd10;

    reg enable_black_out_h;
    reg enable_black_out_v;

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            enable_black_out_h <= 1'b0;
        else if(col_addr_sig == h_start)
            enable_black_out_h <= 1'b1;
        else if(col_addr_sig == h_start + 11'd220)
            enable_black_out_h <= 1'b0;
        else
            enable_black_out_h <= enable_black_out_h;
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            enable_black_out_v <= 1'b0;
        else if(row_addr_sig == v_start)
            enable_black_out_v <= 1'b1;
        else if(row_addr_sig == v_start + 11'd420)
            enable_black_out_v <= 1'b0;
        else
            enable_black_out_v <= enable_black_out_v;
    end

    reg enable_black_in_h;
    reg enable_black_in_v;

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            enable_black_in_h <= 1'b0;
        else if(col_addr_sig == h_start + border_width)
            enable_black_in_h <= 1'b1;
        else if(col_addr_sig == h_start + 11'd210)
            enable_black_in_h <= 1'b0;
        else
            enable_black_in_h <= enable_black_in_h;
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            enable_black_in_v <= 1'b0;
        else if(row_addr_sig == v_start + border_width)
            enable_black_in_v <= 1'b1;
        else if(row_addr_sig == v_start + 11'd410)
            enable_black_in_v <= 1'b0;
        else
            enable_black_in_v <= enable_black_in_v;
    end

    reg rblack_border;

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            rblack_border <= 1'b0;
        else
            rblack_border <= (enable_black_out_h && enable_black_out_v) && (!(enable_black_in_h && enable_black_in_v));
    end

    assign enable_black_border = rblack_border;

endmodule
