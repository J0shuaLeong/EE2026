`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////

parameter [15:0] green = 16'h07E0;
parameter [15:0] red = 16'hF800;
parameter [15:0] black = 16'h0000;
parameter [15:0] white = 16'hFFFF;

module Top_Student (
    // Delete this comment and include Basys3 inputs and outputs here
    input clock,
    inout ps2clk,
    input [14:0] sw,
    input sw15,
    inout ps2data,
    input J_MIC_Pin3,
    input btnD, btnU, btnC,
    output J_MIC_Pin1,
    output J_MIC_Pin4,
    output [7:0] JC,
    output [14:0] led,
    output led15,
    output [3:0] an,
    output [6:0] seg, 
    output dp
    
    );
    
    //outputs of MouseCtl 
    wire left, middle, right, newevent;
    wire [11:0] xpos; wire [11:0] ypos; wire [3:0] zpos;
    //audio input
    wire count_20khz;
    wire count_6_25MHz;
    wire count_0_16s;
    wire count_100hz;
    wire [11:0] MIC_IN; 
    wire [3:0] volume;
    wire [3:0] seg_status;
    wire [3:0] seg_num1;
    wire [1:0] seg_num2;
    //Retrieving pixel_index for oled
    wire [12:0] pixel_index;
    wire [7:0] x;
    wire [7:0] y;
    wire [15:0] oled_data;
    wire [15:0] oled_data1;
    wire [15:0] oled_data2;
    wire [15:0] oled_data3;
    wire [15:0] oled_data4;
    wire [15:0] oled_data5;
    wire [15:0] oled_data6;
    wire [15:0] oled_data7;
    wire [11:0] nxpos;
    wire [11:0] nypos;
    //outputs of Oled_Display module
    wire frame_begin, sending_pixels, sample_pixel, cs, sdin, sclk, d_cn, resn, vccen, pmoden;
    //6.25MHz clk input for Oled
    wire clk6p25m; 
    //Whack a mole
    wire reset_n, Q;
    wire score;
    
    //inputs of MouseCtl -- Setting default values
    reg [11:0] defaultvalue = 0;
    reg setx = 0, sety = 0, setmax_x = 0, setmax_y = 0;
    
    //Menu
    reg [2:0] main_menu_option = 0;
    reg [2:0] current_option = 5;
    reg [2:0] task_option = 0;
    reg [31:0] scroll_count = 0;
    reg game_reset = 0;
    always @ (posedge count_100hz) begin
        if (btnU) begin
            scroll_count <= (scroll_count == 0) ? 0 : scroll_count - 1;
        end
        else if (btnD) begin
            scroll_count <= (scroll_count == 64)? 64 : scroll_count + 1;
        end
    end
    wire [6:0] dispseg;
    assign seg = (current_option == 4 || task_option == 1) ? dispseg : 7'b1111111;
    always @ (posedge clock) begin
        if (sw[14]) begin
                main_menu_option = 0; //display main menu
                current_option = 0; //display task
                task_option = 0;
                game_reset = 0;
        end 
        if (nxpos >= 10 && nxpos <= 84 && (nypos >= 16 - scroll_count) && (nypos <= 30 - scroll_count) && main_menu_option == 0) begin
            current_option = left ? 1 : current_option; //Joshua
        end
        else if (nxpos >= 10 && nxpos <= 84 && (nypos >= 32 - scroll_count) && (nypos <= 46 - scroll_count) && main_menu_option == 0) begin
            current_option = left ? 2 : current_option; //Naychi
        end
        else if (nxpos >= 10 && nxpos <= 84 && (nypos >= 48 - scroll_count) && (nypos <= 62 - scroll_count) && main_menu_option == 0) begin
            current_option = left ? 3 : current_option; //Shanice
        end
        if (nxpos >= 10 && nxpos <= 84 && (nypos >= 68 - scroll_count) && (nypos <= 93 - scroll_count) && main_menu_option == 0) begin
            current_option = left ? 4 : current_option; //Group task
        end
        if (nxpos >= 10 && nxpos <= 84 && (nypos >= 97 - scroll_count) && (nypos <= 122 - scroll_count) && main_menu_option == 0) begin
            current_option = left ? 5 : current_option; //game
        end
        
            
        if (current_option == 1) begin //Joshua
            main_menu_option = 1;
            if (nxpos >= 10 && nxpos <= 84 && nypos >= 5 && nypos <= 29) begin
                task_option = left ? 1 : task_option; //mic task
            end
            else if (nxpos >= 10 && nxpos <= 84 && nypos >= 35 && nypos <= 59) begin
                task_option = left ? 2 : task_option; //mic improvement
            end
        end
        else if (current_option == 2) begin //Naychi 
            main_menu_option = 1;
        end
        else if (current_option == 3) begin //Shanice
            main_menu_option = 1;
        end
        else if (current_option == 4) begin //Group task
            main_menu_option = 1;
        end
        else if (current_option == 5) begin //group improvement
            main_menu_option = 1;
        end
    end
    
     clk_variable clk20k (clock, 2499, count_20khz); //clk for mic
     clk_variable clk2 (clock, 7, count_6_25MHz); 
     clk_variable clk3 (clock, 7999999, count_0_16s); //slow clk for menu animation
     clk_variable clk100 (clock, 499999, count_100hz);
     
    //mic individual task
    Audio_Input ai (clock, count_20khz, J_MIC_Pin3, J_MIC_Pin1, J_MIC_Pin4, MIC_IN);
    audio_level_calc lvl (clock, MIC_IN, volume);
    display_led dl (volume, current_option, task_option, led); //display led
    
    //Mic improvement
    //mic_wave mw (clock, volume, pixel_index, task_option, btnC, nxpos, nypos, x, y, oled_data3, led, left);   
    
    //instantiation of MouseCtl
    MouseCtl mouse(.clk(clock), .rst(0), .value(defaultvalue), .setx(setx), .sety(sety), .setmax_x(setmax_x), .setmax_y(setmax_y),
    .xpos(xpos), .ypos(ypos), .zpos(zpos), .left(left), .middle(middle), .right(right), .new_event(newevent),
    .ps2_clk(ps2clk), .ps2_data(ps2data)
    );
    xycoordinate xy (.pixel_index(pixel_index), .x(x), .y(y), .xpos(xpos), .ypos(ypos), .nxpos(nxpos), .nypos(nypos));
    //mouse individual task
    //mouse_task mouseTask(.x(x),.y(y), .xpos(nxpos), .ypos(nypos), .middle(middle), .current_option(current_option), .pixel_color(oled_data4));
   
    //group task
    //grp_task_module oledGrpTask(.x(x), .y(y), .pixel_color(oled_data6),.xpos(nxpos), .ypos(nypos), .right(right), .left(left), 
                                //.sw15(sw15), .sw3(sw[3]), .current_option(current_option), .led15(led15), .seg_num1(seg_num1), .seg_num2(seg_num2));
    //display_seg ds (clock, dispseg, an, volume, dp, seg_num1, seg_num2, current_option, task_option);
   
    
    //Oled
    Oled_Display oled (.clk(count_6_25MHz), .reset(0), .frame_begin(frame_begin), .sending_pixels(sending_pixels), 
    .sample_pixel(sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_data), 
    .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7]));
    //Oled individual task
    //oled_indiv_task oledTask(.x(x), .y(y), .sw(sw), .current_option(current_option), .pixel_color(oled_data5));
    
    assign oled_data = current_option == 1 ? task_option == 2 ? oled_data3 : oled_data2 : current_option == 2 ? oled_data4 : current_option == 3 ? oled_data5 : current_option == 4 ? oled_data6 : current_option == 5 ? oled_data7 : oled_data1;

    //menu
    //menu_display (count_6_25MHz, count_0_16s, main_menu_option, pixel_index, current_option, btnD, btnU, nxpos, nypos, x, y, scroll_count, oled_data1);
    //menu_2 (clock, count_6_25MHz, pixel_index, current_option, nxpos, nypos, x, y, oled_data2);
    //meow
    //imagemodule img(clock, pixel_index, display_setting, oled_data1);
    
    //Whack a mole
    whack_a_mole wm (.x(x), .y(y), .pixel_color(oled_data7), .pixel_index(pixel_index),.x_pos(nxpos), .y_pos(nypos), .left(left), .clk(clock), .current_option(current_option), .score(score), .rst(game_reset));
    //random_generator rg (clock, reset_n, Q);
    
endmodule