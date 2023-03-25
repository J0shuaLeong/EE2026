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
    output J_MIC_Pin1,
    output J_MIC_Pin4,
    output [7:0] JC,
    output [15:0] led,
    output [3:0] an,
    output [6:0] seg, 
    output dp
    
    );
    
    wire score;
    
    //Menu
    integer menu = 0;
    always @ (posedge clock) begin
        menu = sw[1] ? 1 : 0;
    end
    
    //inputs of MouseCtl -- Setting default values
    reg [11:0] defaultvalue = 0;
    reg setx = 0, sety = 0, setmax_x = 0, setmax_y = 0;
    //outputs of MouseCtl 
    wire left, middle, right, newevent;
    wire [11:0] xpos; wire [11:0] ypos; wire [3:0] zpos;
    //instantiation of MouseCtl
    MouseCtl mouse(.clk(clock), .rst(0), .value(defaultvalue), .setx(setx), .sety(sety), .setmax_x(setmax_x), .setmax_y(setmax_y),
    .xpos(xpos), .ypos(ypos), .zpos(zpos), .left(left), .middle(middle), .right(right), .new_event(newevent),
    .ps2_clk(ps2clk), .ps2_data(ps2data)
    );
    
    //audio input
    wire count_20khz;
    wire [11:0] MIC_IN, maxvalue; 
    wire [11:0] mic_led;
    wire [3:0] led_status;
    wire [3:0] seg_status;
    wire [3:0] seg_num1;
    wire [1:0] seg_num2;
   // wire [31:0] frequency;
    
    clk_variable clk20k (clock, 2499, count_20khz);
    audio_level_calc lvl (clock, MIC_IN, maxvalue);
    
    Audio_Input ai (clock, count_20khz, J_MIC_Pin3, J_MIC_Pin1, J_MIC_Pin4, MIC_IN);
    audio_intensity ait (clock, maxvalue, led, seg_status);
    display_seg ds (clock, seg, an, seg_status, dp, seg_num1, seg_num2, score, sw[0]);
    
    //Mic improvement
    //frequency_detector fd (clock, sw[1], MIC_IN, led);
    //frequency_display fdp (count_20khz, frequency, led);
    
    //assign led = (right)? 16'b1000_0000_0000_0000 : (middle)? 16'b0100_0000_0000_0000 : (left)? 16'b0010_0000_0000_0000 : 16'b0000_0000_0000_0000;
 
    //outputs of Oled_Display module
    wire frame_begin, sending_pixels, sample_pixel, cs, sdin, sclk, d_cn, resn, vccen, pmoden;
    
    //6.25MHz clk input for Oled
    wire clk6p25m; 
    Clk625 clk(clock, clk6p25m);
    
    //Retrieving pixel_index for oled
    wire [12:0] pixel_index;
    wire [7:0] x;
    wire [7:0] y;
    wire [15:0] oled_data;
    wire [11:0] nxpos;
    wire [11:0] nypos;
        
    
    xycoordinate xy (.pixel_index(pixel_index), .x(x), .y(y), .xpos(xpos), .ypos(ypos), .nxpos(nxpos), .nypos(nypos));
    //oled_indiv_task oledTask(.x(x), .y(y), .sw(sw), .pixel_color(oled_data));
   
    //grp_task_module oledGrpTask(.x(x), .y(y), .pixel_color(oled_data),.xpos(nxpos), .ypos(nypos), .right(right), .left(left), 
                               // .sw(sw), .led15(led[15]), .seg_num1(seg_num1), .seg_num2(seg_num2));
    //mouse_task mouseTask(.x(x),.y(y), .xpos(nxpos), .ypos(nypos), .middle(middle), .pixel_color(oled_data));
    
    
    Oled_Display oled (.clk(clk6p25m), .reset(0), .frame_begin(frame_begin), .sending_pixels(sending_pixels), 
    .sample_pixel(sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_data), 
    .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7]));
    
    //meow
    imagemodule img(clock, pixel_index, oled_data);
    
    //Whack a mole
    wire reset_n, Q;
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