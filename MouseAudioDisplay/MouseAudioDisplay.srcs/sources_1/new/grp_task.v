`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2023 21:06:35
// Design Name: 
// Module Name: grp_task_module
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


module grp_task_module( input [7:0] x, y, output reg [15:0] pixel_color,input [11:0] xpos, input [11:0] ypos, input right, input left,
 input sw15, input sw3, input [2:0] current_option, output reg led15, output reg [6:0] seg_num1, output reg [1:0] seg_num2);
 
    parameter [15:0] green = 16'h07E0;
    parameter [15:0] red = 16'hF800;
    parameter [15:0] black = 16'h0000;
    parameter [15:0] white = 16'hFFFF;
 
    //Oled boolean
    wire lines, seg7, a, b, c, d, e, f, g, cursor, void;    
    assign lines = ( (x >= 58 && y >= 0 && x <= 60 && y <= 60) || (x >= 0 && y >= 58 && x <= 60 && y <= 60) );
    assign a = (x >= 19 && x <= 34 && y >= 6 && y <= 11 );
    assign b = (x >= 34 && y >= 11 && x <= 39 && y <= 26);
    assign c = (x >= 34 && y >= 31 && x <= 39 && y <= 46);
    assign d = (x >= 19 && y >= 46 && x <= 34 && y <= 51);
    assign e = (x >= 14 && y >= 31 && x <= 19 && y <= 46);
    assign f = (x >= 14 && y >= 11 && x <= 19 && y <= 26);
    assign g = (x >= 19 && y >= 26 && x <= 34 && y <= 31);
    assign seg7 = ( ((x >= 19 && y >= 6 && x <= 34 && y <= 51) && !(x >= 20 && y >= 7 && x <= 33 && y <= 50)) ||
                   ((x >= 14 && y >= 11 && x <= 39 && y <= 26) && !(x >= 15 && y >= 12 && x <= 38 && y <= 25)) ||
                   ((x >= 14 && y >= 31 && x <= 39 && y <= 46) && !(x >= 15 && y >= 32 && x <= 38 && y <= 45)) );
    assign cursor = ( x <= ((xpos%96) + 3) && x >= (xpos%96) && (y <= (ypos%64) + 3) && y >= (ypos%64));
    assign void = !(lines || a || b || c || d || e || f || g || seg7 || cursor);
    
    //Cursor position relative to 7seg
    wire a_pos, b_pos, c_pos, d_pos, e_pos, f_pos, g_pos;
    assign a_pos = (xpos >= 19 && xpos <= 34 && ypos >= 6 && ypos <= 11 );
    assign b_pos = (xpos >= 34 && ypos >= 11 && xpos <= 39 && ypos <= 26);
    assign c_pos = (xpos >= 34 && ypos >= 31 && xpos <= 39 && ypos <= 46);
    assign d_pos = (xpos >= 19 && ypos >= 46 && xpos <= 34 && ypos <= 51);
    assign e_pos = (xpos >= 14 && ypos >= 31 && xpos <= 19 && ypos <= 46);
    assign f_pos = (xpos >= 14 && ypos >= 11 && xpos <= 19 && ypos <= 26);
    assign g_pos = (xpos >= 19 && ypos >= 26 && xpos <= 34 && ypos <= 31);
    
    reg a_on, b_on, c_on, d_on, e_on, f_on, g_on;
    
    //Valid seg combinations
    wire s0, s1, s2, s3, s4, s5, s6, s7, s8, s9;
    assign s0 = a_on & b_on & c_on & d_on & e_on & f_on & ~g_on; 
    assign s1 = ~a_on & b_on & c_on & ~d_on & ~e_on & ~f_on & ~g_on;
    assign s2 = a_on & b_on & ~c_on & d_on & e_on & ~f_on & g_on; 
    assign s3 = a_on & b_on & c_on & d_on & ~e_on & ~f_on & g_on;
    assign s4 = ~a_on & b_on & c_on & ~d_on & ~e_on & f_on & g_on; 
    assign s5 = a_on & ~b_on & c_on & d_on & ~e_on & f_on & g_on;
    assign s6 = a_on & ~b_on & c_on & d_on & e_on & f_on & g_on; 
    assign s7 = a_on & b_on & c_on & ~d_on & ~e_on & ~f_on & ~g_on;
    assign s8 = a_on & b_on & c_on & d_on & e_on & f_on & g_on; 
    assign s9 = a_on & b_on & c_on & d_on & ~e_on & f_on & g_on;
        
    always @ (*) begin
            if (left) begin
                if (a_pos) a_on = 1; if (b_pos) b_on = 1; if (c_pos) c_on = 1; if (d_pos) d_on = 1; 
                if (e_pos) e_on = 1; if (f_pos) f_on = 1; if (g_pos) g_on = 1;
            end
            if (right) begin
                if (a_pos) a_on = 0; if (b_pos) b_on = 0; if (c_pos) c_on = 0; if (d_pos) d_on = 0; 
                if (e_pos) e_on = 0; if (f_pos) f_on = 0; if (g_pos) g_on = 0;
            end
           
            if (a_on) begin if (a || seg7) pixel_color = white; end
            else begin if (a) pixel_color = black; end

            if (b_on) begin if (b || seg7) pixel_color = white; end
            else begin if (b) pixel_color = black; end
    
            if (c_on) begin if (c || seg7) pixel_color = white; end
            else begin if (c) pixel_color = black; end
            
            if (d_on) begin if (d || seg7) pixel_color = white; end
            else begin if (d) pixel_color = black; end
                    
            if (e_on) begin if (e || seg7) pixel_color = white; end
            else begin if (e) pixel_color = black; end
                            
            if (f_on) begin if (f || seg7) pixel_color = white; end
            else begin if (f) pixel_color = black; end
                                    
            if (g_on) begin if (g || seg7) pixel_color = white; end
            else begin if (g) pixel_color = black; end    
        
            if (s0 || s1 || s2 || s3 || s4 || s5 || s6 || s7 || s8 || s9) begin
                led15 = sw15 ? 1 : 0;
                if (s0) begin seg_num2 = 0; seg_num1 = 1; end
                if (s1) begin seg_num2 = 0; seg_num1 = 2; end
                if (s2) begin seg_num2 = 0; seg_num1 = 3; end
                if (s3) begin seg_num2 = 0; seg_num1 = 4; end
                if (s4) begin seg_num2 = 0; seg_num1 = 5; end
                if (s5) begin seg_num2 = 0; seg_num1 = 6; end
                if (s6) begin seg_num2 = 0; seg_num1 = 7; end
                if (s7) begin seg_num2 = 0; seg_num1 = 8; end
                if (s8) begin seg_num2 = 0; seg_num1 = 9; end
                if (s9) begin seg_num2 = 1; seg_num1 = 0; end          
                end else begin
                    led15 = 0;
                    seg_num1 = 10;
                    seg_num2 = 2;
                end                                                                                                                           
        
            if (seg7) pixel_color = white;
            if (lines) pixel_color = sw3 ? green : black;             
            if (cursor) pixel_color = red;
            if (void) pixel_color = black;
        
    end
endmodule
