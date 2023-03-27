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
    input [15:0] sw,
    inout ps2data,
    input J_MIC_Pin3,
    input btnD, btnU,
    output J_MIC_Pin1,
    output J_MIC_Pin4,
    output [7:0] JC,
    output [15:0] led,
    output [3:0] an,
    output [6:0] seg, 
    output dp
    
    );
    
    wire score;
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
    wire [11:0] nxpos;
    wire [11:0] nypos;
    //outputs of Oled_Display module
    wire frame_begin, sending_pixels, sample_pixel, cs, sdin, sclk, d_cn, resn, vccen, pmoden;
    //6.25MHz clk input for Oled
    wire clk6p25m; 
    //Whack a mole
    wire reset_n, Q;
    
    //inputs of MouseCtl -- Setting default values
    reg [11:0] defaultvalue = 0;
    reg setx = 0, sety = 0, setmax_x = 0, setmax_y = 0;
    //Menu
    reg [2:0] main_menu_option = 0;
    reg [2:0] current_option = 0;
    integer scroll_count = 0;
    always @ (posedge count_100hz) begin
        if (btnU) begin
            scroll_count <= (scroll_count == 0) ? 0 : scroll_count - 1;
        end
        else if (btnD) begin
            scroll_count <= (scroll_count == 64)? 64 : scroll_count + 1;
        end
    end
    
    always @ (posedge clock) begin
        if (sw[15]) begin
                main_menu_option = 0; //display menu
                current_option = 0;
        end 
        if (nxpos >= 10 && nxpos <= 84 && (nypos >= 16 + scroll_count) && (nypos <= 30 + scroll_count)) begin
            main_menu_option = 1; //Joshua
                if (left) begin
                    current_option = 1;
                end
        end
        if (nxpos >= 10 && nxpos <= 84 && (nypos >= 32 + scroll_count) && (nypos <= 46 + scroll_count)) begin
            main_menu_option = 2; //Naychi
        end
        if (nxpos >= 10 && nxpos <= 84 && (nypos >= 48 + scroll_count) && (nypos <= 62 + scroll_count)) begin
            main_menu_option = 3; //Shanice
        end
        if (nxpos >= 10 && nxpos <= 84 && (nypos >= 68 + scroll_count) && (nypos <= 93 + scroll_count)) begin
            main_menu_option = 4; //Group task
        end
        if (nxpos >= 10 && nxpos <= 84 && (nypos >= 97 + scroll_count) && (nypos <= 122 + scroll_count)) begin
            main_menu_option = 5; //game
        end
    end
    
     clk_variable clk20k (clock, 2499, count_20khz);
     clk_variable clk2 (clock, 7, count_6_25MHz); 
     clk_variable clk3 (clock, 7999999, count_0_16s); //slow clk for menu animation
     Clk625 clk(clock, clk6p25m);
     clk_variable clk100 (clock, 500000, count_100hz);
     
    //mic
    Audio_Input ai (clock, count_20khz, J_MIC_Pin3, J_MIC_Pin1, J_MIC_Pin4, MIC_IN);
    audio_level_calc lvl (clock, MIC_IN, volume);
    display_led dl (volume, led);
    display_seg ds (clock, seg, an, volume, dp, seg_num1, seg_num2, score, sw[0]);
    
    //Mic improvement
    mic_wave mw (clock, volume, pixel_index, current_option, oled_data2);   
    
    //instantiation of MouseCtl
    MouseCtl mouse(.clk(clock), .rst(0), .value(defaultvalue), .setx(setx), .sety(sety), .setmax_x(setmax_x), .setmax_y(setmax_y),
    .xpos(xpos), .ypos(ypos), .zpos(zpos), .left(left), .middle(middle), .right(right), .new_event(newevent),
    .ps2_clk(ps2clk), .ps2_data(ps2data)
    );
    xycoordinate xy (.pixel_index(pixel_index), .x(x), .y(y), .xpos(xpos), .ypos(ypos), .nxpos(nxpos), .nypos(nypos));
    //oled_indiv_task oledTask(.x(x), .y(y), .sw(sw), .pixel_color(oled_data));
   
    //grp_task_module oledGrpTask(.x(x), .y(y), .pixel_color(oled_data),.xpos(nxpos), .ypos(nypos), .right(right), .left(left), 
                               // .sw(sw), .led15(led[15]), .seg_num1(seg_num1), .seg_num2(seg_num2));
    //mouse_task mouseTask(.x(x),.y(y), .xpos(nxpos), .ypos(nypos), .middle(middle), .pixel_color(oled_data));
    
    Oled_Display oled (.clk(clk6p25m), .reset(0), .frame_begin(frame_begin), .sending_pixels(sending_pixels), 
    .sample_pixel(sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_data), 
    .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7]));
    
    assign oled_data = current_option == 0 ? oled_data1 : current_option == 1 ? oled_data2 : oled_data3;
    
    //menu
    menu_display (count_6_25MHz, count_0_16s, main_menu_option, pixel_index, current_option, btnD, btnU, nxpos, nypos, x, y, oled_data1);
    
    //meow
    //imagemodule img(clock, pixel_index, display_setting, oled_data1);
    
    //mouse_scroll ms(.z_pos(zpos), .led(led));
    //assign led = zpos;
    
    //Whack a mole
    //whack_a_mole wm (.x(x), .y(y), .pixel_color(oled_data),.x_pos(nxpos), .y_pos(nypos), .left(left), .score(score), .clk(clock));
    //random_generator rg (clock, reset_n, Q);
    
endmodule

module mouse_task (input [7:0] x, y, input middle, input [11:0] xpos, input [11:0] ypos, output reg [15:0] pixel_color);
    /*Part b*/
//    wire cursor1, cursor2;
//    assign cursor1 = ((x>40 && x<51 && y>30 && y<35));
//    assign cursor2 = ((x>30 && x<55 && y>25 && y<40));
  
//    always @ (*) begin
//       if (middle)
//       pixel_color = (cursor1)? green: black; //oled_data
//       else
//       pixel_color = (cursor2)? red : black;
//    end
    
    always @ (*) begin
           pixel_color = ( x <= ((xpos%96) + 3) && x >= (xpos%96) && (y <= (ypos%64) + 3) && y >= (ypos%64))? red : black;
    end
endmodule

module Clk625 (input CLOCK, output clk6p25m);
    reg SLOW_CLOCK;
    reg [3:0] COUNT = 4'b0000;
    
    assign clk6p25m = SLOW_CLOCK;
    
    always @ (posedge CLOCK) begin
        COUNT <= COUNT + 1;
        SLOW_CLOCK <= (COUNT == 4'b0000) ? ~SLOW_CLOCK : SLOW_CLOCK;
    end
endmodule

module xycoordinate (input [12:0] pixel_index, output [7:0] x, [7:0] y, input [11:0] xpos, [11:0] ypos, output [11:0] nxpos, [11:0] nypos);
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
    assign nxpos = (xpos > 92) ? 92 : xpos;
    assign nypos = (ypos > 60) ? 60 : ypos;
endmodule

module oled_indiv_task (input [7:0] x, y, input [2:0] sw, output reg [15:0] pixel_color);

    //boolean for display, OR (||) to combine, AND (&&!) unselect within selected area
    wire lines, zero, one, two;
    assign lines = ( (x > 57 && x < 61 && y < 61) || (x < 61 && y > 57 && y < 61) );
    assign zero = ( (x >= 14 && x <= 42 && y >= 9 && y <= 47) && !(x >= 20 && x <= 36 && y >= 15 && y <= 41) );
    assign one = ( (x >= 19 && x <= 31 && y >= 9 && y <= 14) || (x >= 25 && x <= 31 && y >= 15 && y <= 42) || (x >= 14 && x <= 42 && y >= 42 && y <= 47) );
    assign two = ( (x >= 14 && x <= 42 && y >= 9 && y <= 47) && !(x >= 14 && x <= 36 && y >= 15 && y <= 25) && !(x >= 20 && x <= 42 && y >= 31 && y <= 41) );
    
    always @ (x,y) begin
        //pixel_color <= sw4 ? red : green;
        if (sw[0])
            pixel_color = lines ? green : zero ? white : black;
        else if (sw[1])
            pixel_color = lines ? green : one ? white : black;
        else if (sw[2])
            pixel_color = lines ? green : two ? white : black;   
        else
            pixel_color = black;     
    end
endmodule