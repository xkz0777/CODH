`timescale 1ns / 1ps
module top(
        input sys_clk,
        input rst_n,
        input right,
        input left,
        input rotateR,
        input verticalspeed,
        output[3:0] green_out,
        output[3:0] red_out,
        output[3:0] blue_out,
        // output[10:0] led,
        output vsync,
        output hsync);

    wire [3:0] red;
    wire [3:0] green;
    wire [3:0] blue;
    wire clk;
    wire levelup_sig;

    div_clk div_clk(
                .rst_n(rst_n),
                .sys_clk(sys_clk),
                .clk(clk)
            );

    wire w_right;
    wire w_left;
    wire w_rotateR;
    wire w_rotateL;         // zsz added
    wire verticalspeed_out;

    btn_edge_db m_right(.clk(clk),.rstn(rst_n),.btn(right),.out(w_right));
    btn_edge_db m_left(.clk(clk),.rstn(rst_n),.btn(left),.out(w_left));
    btn_edge_db m_rotate(.clk(clk),.rstn(rst_n),.btn(rotateR),.out(w_rotateR));
    btn_db m_speed(.clk(clk),.rstn(rst_n),.btn(verticalspeed),.out(verticalspeed_out));

    wire over_out;
    wire start_sig;
    wire gameready_sig;
    wire over_sig;
    state_machine state_machine(
                      .clk(clk),
                      .rst_n(rst_n),
                      .over(over_out),
                      .start_sig(start_sig),
                      .gameready_sig(gameready_sig),
                      .over_sig(over_sig)
                  );

    wire[10:0] ready_col_addr_sig;
    wire[10:0] ready_row_addr_sig;

    wire ready_out_sig;

    vga_driver start_vga_driver(
                   .clk(clk),
                   .rst_n(rst_n),
                   .col_addr_sig(ready_col_addr_sig),
                   .row_addr_sig(ready_row_addr_sig),
                   .ready_sig(ready_out_sig)
               );

    wire[18:0] tetris_rom_addr;
    wire ready_red_sig;
    wire ready_green_sig;
    wire ready_blue_sig;
    wire[2:0] ready_tetris_rom_data;

    start start(
              .clk(clk),
              .rst_n(rst_n),
              .ready_col_addr_sig(ready_col_addr_sig),
              .ready_row_addr_sig(ready_row_addr_sig),
              .ready_sig(ready_out_sig),
              .gameready_sig(gameready_sig),
              .tetris_rom_data(ready_tetris_rom_data),
              .tetris_rom_addr(tetris_rom_addr),
              .ready_red_sig(ready_red_sig),
              .ready_green_sig(ready_green_sig),
              .ready_blue_sig(ready_blue_sig)
          );

    start_interface start_instance_name(
                        .clka(clk), // input clka
                        .addra(tetris_rom_addr), // input [18 : 0] addra
                        .douta(ready_tetris_rom_data) // output [2 : 0] douta
                    );

    wire[10:0] over_col_addr_sig;
    wire[10:0] over_row_addr_sig;
    wire over_out_sig;

    vga_driver over_vga_driver(
                   .clk(clk),
                   .rst_n(rst_n),
                   .col_addr_sig(over_col_addr_sig),
                   .row_addr_sig(over_row_addr_sig),
                   .ready_sig(over_out_sig)
               );

    wire[10:0] col_addr_sig;
    wire[10:0] row_addr_sig;
    wire ready_sig;

    vga_driver game_vga_driver(
                   .clk(clk),
                   .rst_n(rst_n),
                   .col_addr_sig(col_addr_sig),
                   .row_addr_sig(row_addr_sig),
                   .hsync(hsync),
                   .vsync(vsync),
                   .ready_sig(ready_sig)
               );

    // game_logic module
    wire[10:0] h;
    wire[10:0] v;
    wire[499:0] enable_little;
    wire[15:0] enable_moving;
    wire loading_square;
    wire[8:0] little_square_num;
    wire[15:0] score_out;

    game_logic game_logic(
                   .clk(clk),
                   .rst_n(rst_n),
                   .move_right(w_right),
                   .move_left(w_left),
                   .start_sig(start_sig),
                   .row_addr_sig(row_addr_sig),
                   .h(h),
                   .v(v),
                   .enable_little(enable_little),
                   .enable_moving(enable_moving),
                   .loading_square(loading_square),
                   .little_square_num(little_square_num),
                   .over_out(over_out),
                   .verticalspeed_out(verticalspeed_out),
                   .score_out(score_out),
                   .level_up(levelup_sig)
               );

    wire enable_black_border;

    display_border display_border(
                       .clk(clk),
                       .rst_n(rst_n),
                       .col_addr_sig(col_addr_sig),
                       .row_addr_sig(row_addr_sig),
                       .enable_black_border(enable_black_border)
                   );

    wire enable_blue_moving;

    display_moving_square display_moving_square(
                              .clk(clk),
                              .rst_n(rst_n),
                              .col_addr_sig(col_addr_sig),
                              .row_addr_sig(row_addr_sig),
                              .h(h),
                              .v(v),
                              .enable_blue_moving(enable_blue_moving),
                              .enable_moving(enable_moving)
                          );


    wire enable_blue_little_flag;

    display_square display_square(
                       .clk(clk),
                       .rst_n(rst_n),
                       .col_addr_sig(col_addr_sig),
                       .row_addr_sig(row_addr_sig),
                       .enable_little(enable_little),
                       .enable_blue_little_flag(enable_blue_little_flag)
                   );

    //square_gen
    wire[2:0] square_type_out;

    square_gen square_gen(
                   .clk(clk),
                   .rst_n(rst_n),
                   .enable_moving(enable_moving),
                   .rotate_r(w_rotateR),
                   .rotate_l(w_rotateL),
                   .loading_square(loading_square),
                   .little_square_num(little_square_num),
                   .enable_little(enable_little),
                   .square_type_out(square_type_out)
               );

    wire color_score_out;

    display_score display_score(
                      .clk(clk),
                      .rst_n(rst_n),
                      .col_addr_sig(col_addr_sig),
                      .row_addr_sig(row_addr_sig),
                      .score_out(score_out),
                      .color_score_out(color_score_out)
                  );

    wire next_yellow_display;

    display_next_square display_next_square(
                            .clk(clk),
                            .rst_n(rst_n),
                            .col_addr_sig(col_addr_sig),
                            .row_addr_sig(row_addr_sig),
                            .loading_square(loading_square),
                            .next_yellow_display(next_yellow_display),
                            .square_type_out(square_type_out)
                        );
    wire score_out_c;

    display_score_img display_score_img(
                          .clk(clk),
                          .rst_n(rst_n),
                          .col_addr_sig(col_addr_sig),
                          .row_addr_sig(row_addr_sig),
                          .levelup_sig(levelup_sig),
                          .score_out_c(score_out_c)
                      );

    wire next_c;
    game_display game_display(
                     .clk(clk),
                     .rst_n(rst_n),
                     .ready_sig(ready_sig),
                     .enable_black_border(enable_black_border),
                     //  .square_type(square_type_out),
                     .enable_blue_moving(enable_blue_moving),
                     .enable_blue_little_flag(enable_blue_little_flag),
                     .next_yellow_display(next_yellow_display),
                     .red(red),
                     .green(green),
                     .blue(blue),
                     .next_c(next_c),
                     .score_out_c(score_out_c),
                     .score(color_score_out)
                 );

    display_next display_next(
                     .clk(clk),
                     .rst_n(rst_n),
                     .col_addr_sig(col_addr_sig),
                     .row_addr_sig(row_addr_sig),
                     .next_c(next_c)
                 );

    wire hsync_out;
    wire vsync_out;

    color_select color_select(
                     .clk(clk),
                     .rst_n(rst_n),
                     .start_sig(start_sig),
                     .red(red),
                     .green(green),
                     .blue(blue),
                     .gameready_sig(gameready_sig),
                     .ready_red_sig(ready_red_sig),
                     .ready_green_sig(ready_green_sig),
                     .ready_blue_sig(ready_blue_sig),
                     .over_sig(over_sig),
                     .red_out(red_out),
                     .green_out(green_out),
                     .blue_out(blue_out)
                 );

    assign w_rotateL = 1'b1;

endmodule
