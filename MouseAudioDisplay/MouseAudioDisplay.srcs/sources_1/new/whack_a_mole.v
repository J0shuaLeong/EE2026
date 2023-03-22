`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2023 10:14:59 AM
// Design Name: 
// Module Name: whack_a_mole
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


module whack_a_mole(
    input [7:0] x, y, 
    output reg [15:0] pixel_color,
    input [11:0] x_pos, 
    input [11:0] y_pos, 
    input left,
    output reg [15:0] score = 0
    );
    
    parameter [15:0] green = 16'h07E0;
    parameter [15:0] red = 16'hF800;
    parameter [15:0] black = 16'h0000;
    parameter [15:0] white = 16'hFFFF;
    parameter [15:0] blue = 16'h001F;
    //parameter [15:0] brown = 16'h;
   
    //display game
    wire sky, ground, hole, mole, cursor;      
        assign sky = (x >= 0 && x <= 95 && y >= 0 && y <= 38 );
        assign ground = (x >= 0 && x <= 95 && y >= 39 && y <= 63);
        assign hole = (x >= 10 && x <= 28 && y >= 52 && y <= 57);
        assign mole = (x >= 11 && x <= 27 && y >= 40 && y <= 55) || (x >= 12 && x <= 26 && y == 39) || (x >= 13 && x <= 25 && y == 38) || (x >= 14 && x <= 24 && y == 37) || (x >= 16 && x <= 22 && y == 36)  ;
        assign cursor = ( x <= ((x_pos%96) + 3) && x >= (x_pos%96) && (y <= (y_pos%64) + 3) && y >= (y_pos%64));
    
    wire mole_pos;
    //if cursor is on mole
    assign mole_pos = (x_pos >= 11 && x_pos <= 27 && y_pos >= 40 && y_pos <= 55) || (x_pos >= 12 && x_pos <= 26 && y_pos == 39) || (x_pos >= 13 && x_pos <= 25 && y_pos == 38) || (x_pos >= 14 && x_pos <= 24 && y_pos == 37) || (x_pos >= 16 && x_pos <= 22 && y_pos == 36);
    
    reg mole_down;
    
    always @ (*) begin
        if (left) begin
            //if mole is clicked
            if (mole_pos) begin
                mole_down = 1;
                score <= score + 1;
            end

        end
         
        if (sky) pixel_color = blue;
        if (ground) pixel_color = green;
        if (hole) pixel_color = black;
        if (mole && !mole_down) pixel_color = red;
        if (cursor) pixel_color = white;
    end
    
    //if 
    
endmodule
