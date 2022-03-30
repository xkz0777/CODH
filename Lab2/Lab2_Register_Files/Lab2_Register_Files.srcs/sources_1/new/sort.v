`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/29 19:09:27
// Design Name:
// Module Name: sort
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


module sort #(parameter CYCLE=25) (
        input clk,
        input rstn,
        input [15:0] x,	   // 输入 1 位十六进制数字
        input del,		   // 删除 1 位十六进制数字, btnl
        input addr,		   // 设置地址, btnu
        input data,		   // 修改数据, btnc
        input chk,		   // 查看下一项, btnr
        input run,		   // 启动排序, btnd

        output [7:0] an,   // 数码管显示存储器地址和数据
        output [6:0] seg,
        output reg busy,	   // 1—正在排序，0—排序结束
        output reg [15:0] cnt  // 排序耗费时钟周期数
    );


    // 输入部分
    wire del_p, addr_p, data_p, chk_p;
    reg [7:0] a;
    wire [15:0] spo, dpo;

    reg s;
    reg [15:0] d;
    wire p;
    wire [3:0] h;

    reg input_en; // 输入使能
    initial
        input_en = 1;

    wire [7:0] dpra;
    assign dpra = a + 1;

    reg we_en;
    reg we_sort_en;

    always@(*) begin
        if (input_en)
            we_en = data_p;
        else
            we_en = we_sort_en;
    end

    dist_mem_gen_1 dm(.a(a), .dpra(dpra), .clk(clk), .d(d), .spo(spo), .dpo(dpo), .we(we_en));
    dpe #(.CYCLE(CYCLE)) dpe_inst(clk, rstn, x, p, h);
    dp #(.CYCLE(CYCLE)) dp_inst(clk, rstn, chk, del, data, addr, chk_p, del_p, data_p, addr_p);

    parameter S0 = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3, S4 = 3'd4, S5 = 3'd5;
    reg [2:0] state, next_state;
    reg [7:0] i;
    reg sorted, swaped;

    initial
        i = 254;

    always@(*)
        sorted = !i;

    wire larger;
    reg sel;
    wire [15:0] true_spo;
    assign true_spo = sel ? d : spo;
    assign larger = (true_spo > dpo) ? 1 : 0;

    reg [15:0] tmp;

    always@(posedge clk) begin
        if (input_en) begin // 输入
            if (~rstn) begin
                a <= 0;
                d <= 0;
                s <= 0;
            end

            else if (chk_p) begin
                a <= a + 1;
                s <= 0;
            end

            else if (p) begin
                d <= {d[11:0], h};
                s <= 1;
            end

            else if (del_p) begin
                d = d[15:4];
                s <= 1;
            end

            else if (data_p) begin
                d <= 0;
                a <= a + 1;
                s <= 0;
            end

            else if (addr_p) begin
                a <= d[7:0];
                d <= 0;
                s <= 0;
            end
        end

        else begin // 排序
            case (state)
                S0: begin // default state
                    busy <= 0;
                end

                S1: begin // init
                    busy <= 1;
                    cnt <= 0;
                    i <= 254;
                    we_sort_en <= 0;
                    sel = 0;
                end

                S2: begin // judge
                    i <= i - 1;
                    a <= 0;
                    swaped <= 1;
                    cnt <= cnt + 1;
                end

                S3: begin // finish
                    busy <= 0;
                    a <= 0;
                end

                S4: begin // cmp and swap1
                    we_sort_en <= 0;
                    sel <= 0;
                    if (larger) begin
                        swaped <= 1;
                        we_sort_en <= 1;
                        d <= dpo;
                        tmp <= true_spo;
                    end
                    else begin
                        a <= a + 1;
                    end
                    cnt <= cnt + 1;
                end

                S5: begin // swap2
                    d <= tmp;
                    a <= a + 1;
                    cnt <= cnt + 1;
                    sel <= 1;
                end
            endcase
        end
    end

    // 输出部分
    wire [15:0] seg_data;
    assign seg_data = s ? d : spo;
    display display_inst(clk, a, seg_data, an, seg);

    // 状态机
    always@(*) begin
        case (state)
            S0: begin
                if (run) begin
                    next_state = S1;
                    input_en = 0;
                end
                else begin
                    next_state = S0;
                    input_en = 1;
                end
            end
            S1:
                next_state = S2;
            S2: begin
                if (sorted | ~swaped)
                    next_state = S3;
                else
                    next_state = S4;
            end
            S3: begin
                next_state = S0;
            end
            S4: begin
                if (a == i)
                    next_state = S2;
                else if (larger)
                    next_state = S5;
                else
                    next_state = S4;
            end
            S5: begin
                next_state = S4;
            end
        endcase
    end

    // 状态转移
    always@(posedge clk) begin
        if (rstn)
            state <= next_state;
        else
            state <= S0;
    end

endmodule
