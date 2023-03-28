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

parameter N = 3;

module whack_a_mole(
    input [7:0] x, y, 
    output reg [15:0] pixel_color,
    input [11:0] x_pos, 
    input [11:0] y_pos, 
    input left,
    input clk,
    input [2:0] current_option,
    output reg [15:0] score = 0
    );
    
    parameter [15:0] green = 16'h07E0;
    parameter [15:0] red = 16'hF800;
    parameter [15:0] black = 16'h0000;
    parameter [15:0] white = 16'hFFFF;
    parameter [15:0] blue = 16'h001F;
    //parameter [15:0] brown = 16'h;
    
    //display game
    wire sky, ground, hole1, hole2, hole3, mole1, mole2, mole3, cursor;      
    assign sky = (x >= 0 && x <= 95 && y >= 0 && y <= 38 );
    assign ground = (x >= 0 && x <= 95 && y >= 39 && y <= 63);
    assign hole1 = (x >= 10 && x <= 28 && y >= 52 && y <= 57);
    assign hole2 = (x >= 38 && x <= 56 && y >= 43 && y <= 47);
    assign hole3 = (x >= 67 && x <= 85 && y >= 52 && y <= 57);
    assign mole1 = (x >= 11 && x <= 27 && y >= 40 && y <= 55) || (x >= 12 && x <= 26 && y == 39) || (x >= 13 && x <= 25 && y == 38) || (x >= 14 && x <= 24 && y == 37) || (x >= 16 && x <= 22 && y == 36)  ;
    assign mole2 = (x >= 39 && x <= 55 && y >= 30 && y <= 45) || (x >= 40 && x <= 54 && y == 29) || (x >= 41 && x <= 53 && y == 28) || (x >= 42 && x <= 52 && y == 27) || (x >= 44 && x <= 50 && y == 26)  ;
    assign mole3 = (x >= 68 && x <= 84 && y >= 40 && y <= 55) || (x >= 69 && x <= 83 && y == 39) || (x >= 70 && x <= 82 && y == 38) || (x >= 71 && x <= 81 && y == 37) || (x >= 73 && x <= 79 && y == 36)  ;
    assign cursor = ( x <= ((x_pos%96) + 3) && x >= (x_pos%96) && (y <= (y_pos%64) + 3) && y >= (y_pos%64));
    
    wire mole_pos1, mole_pos2, mole_pos3;
    //if cursor is on mole
    assign mole_pos1 = (x_pos >= 11 && x_pos <= 27 && y_pos >= 40 && y_pos <= 55) || (x_pos >= 12 && x_pos <= 26 && y_pos == 39) || (x_pos >= 13 && x_pos <= 25 && y_pos == 38) || (x_pos >= 14 && x_pos <= 24 && y_pos == 37) || (x_pos >= 16 && x_pos <= 22 && y_pos == 36);
    assign mole_pos2 = (x_pos >= 39 && x_pos <= 55 && y_pos >= 30 && y_pos <= 45) || (x_pos >= 40 && x_pos <= 54 && y_pos == 29) || (x_pos >= 41 && x_pos <= 53 && y_pos == 28) || (x_pos >= 42 && x_pos <= 52 && y_pos == 27) || (x_pos >= 44 && x_pos <= 50 && y_pos == 26)  ;
    assign mole_pos3 = (x_pos >= 68 && x_pos <= 84 && y_pos >= 40 && y_pos <= 55) || (x_pos >= 69 && x_pos <= 83 && y_pos == 39) || (x_pos >= 70 && x_pos <= 82 && y_pos == 38) || (x_pos >= 71 && x_pos <= 81 && y_pos == 37) || (x_pos >= 73 && x_pos <= 79 && y_pos == 36)  ;
    
    reg mole_down1 = 1, mole_down2 = 1, mole_down3 = 1;
    
    
    reg [25:0] COUNT1 = -1; integer whichmole = 0; wire [3:1] which_mole;
    
    wire one_hz; 
    clk_variable clk1hz(clk, 49000000, one_hz);
    random_generator test_rand(one_hz, 1, which_mole);
    
    always @ (*) begin
        if (current_option == 5) begin
            whichmole = (which_mole[3] * 1 + which_mole[2] * 2 + which_mole[1] * 4);
            case(whichmole)
                1:begin
                    mole_down1 <= 1;
                    mole_down2 <= 1;
                    mole_down3 <= 1;
                end
                2:begin
                    mole_down1 <= 0;
                    mole_down2 <= 1;
                    mole_down3 <= 1;
                end
                3:begin
                    mole_down1 <= 1;
                    mole_down2 <= 0;
                    mole_down3 <= 1;
                end
                4:begin
                    mole_down1 <= 1;
                    mole_down2 <= 1;
                    mole_down3 <= 0;
                end
                5:begin
                    mole_down1 <= 0;
                    mole_down2 <= 1;
                    mole_down3 <= 0;
                end
                6:begin
                    mole_down1 <= 1;
                    mole_down2 <= 0;
                    mole_down3 <= 0;
                end
                7:begin
                    mole_down1 <= 0;
                    mole_down2 <= 0;
                    mole_down3 <= 0;
                end
                default: begin
                    mole_down1 <= 1;
                    mole_down2 <= 1;
                    mole_down3 <= 1;
                end
            endcase
            if (left) begin
                //if mole is clicked
                if (mole_pos1) begin
                    mole_down1 <= 1;
                    score <= score + 1;
                    whichmole <= 8;
                end
                if (mole_pos2) begin
                    mole_down2 <= 1;
                    score <= score + 1;
                    whichmole <= 8;
                end
                if (mole_pos3) begin
                    mole_down3 <= 1;
                    score <= score + 1;
                    whichmole <= 8;
                end

            end
         
            if (sky) pixel_color = blue;
            if (ground) pixel_color = green;
            if (hole1) pixel_color = black;
            if (hole2) pixel_color = black;
            if (hole3) pixel_color = black;
            if (mole1 && !mole_down1) pixel_color = red;
            if (mole2 && !mole_down2) pixel_color = red;
            if (mole3 && !mole_down3) pixel_color = red;
            if (cursor) pixel_color = white;
        end
    end
    
endmodule
