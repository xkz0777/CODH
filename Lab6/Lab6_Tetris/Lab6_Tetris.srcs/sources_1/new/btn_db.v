`timescale 1ns / 1ps
module btn_db #(parameter CYCLE=20) (
        input clk, btn, rstn,
        output out
    );

    reg [CYCLE-1:0] cnt;

    always@(posedge clk) begin
        if (~rstn | ~btn)
            cnt <= 0;
        else if (cnt < {1'b1, {(CYCLE-1){1'b0}}})
            cnt <= cnt + 1;
    end

    assign out = cnt[CYCLE-1];
endmodule
