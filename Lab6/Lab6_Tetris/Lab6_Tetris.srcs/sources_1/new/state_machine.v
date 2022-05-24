`timescale 1ns / 1ps
// 状态机控制模块
module state_machine(
        input clk,
        input rst_n,
        input over,
        output reg start_sig,
        output reg gameready_sig,
        output reg over_sig);

    // 3 个状态
    parameter ready = 2'b00, game = 2'b01, game_over = 2'b10;
    // 5s 是这么多个时钟周期，这里 clk 已四分频
    parameter T5S = 30'd125_000_000;
    reg[29:0] count_T5S;
    reg start;

    always@(posedge clk or negedge rst_n) begin // 展示 logo 计时
        if(!rst_n) begin
            start <= 0;
            count_T5S <= 0;
        end
        else begin
            if(count_T5S < T5S) begin
                count_T5S <= count_T5S + 1'b1;
                start <= 0;
            end
            else if(count_T5S == T5S) begin
                count_T5S <= 0;
                start <= 1;
            end
            else begin
                count_T5S <= 0;
                start <= 0;
            end
        end
    end

    reg[1:0] game_current_state;
    reg[1:0] game_next_state;

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            game_current_state <= ready; // 复位
        else
            game_current_state <= game_next_state;
    end

    always@(game_current_state or start or over) begin
        case(game_current_state)
            ready: begin
                {gameready_sig, start_sig, over_sig} = 3'b100;
                if(start)
                    game_next_state = game;
                else
                    game_next_state = ready;
            end
            game: begin
                {gameready_sig, start_sig, over_sig} = 3'b010;
                if(over)
                    game_next_state = game_over;
                else
                    game_next_state = game;
            end
            game_over: begin
                {gameready_sig, start_sig, over_sig} = 3'b001;
                game_next_state = game_over;
            end
            default: begin
                {gameready_sig, start_sig, over_sig} = 3'b100;
                game_next_state = ready;
            end
        endcase
    end

endmodule
