`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2023 01:41:13
// Design Name: 
// Module Name: oled_indiv_task
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


module oled_indiv_task (input [7:0] x, y, input [3:0] sw, input [2:0] current_option, output reg [15:0] pixel_color);
    parameter [15:0] green = 16'h07E0;
    parameter [15:0] black = 16'h0000;
    parameter [15:0] white = 16'hFFFF;
    
    //boolean for display, OR (||) to combine, AND (&&!) unselect within selected area
    wire lines, zero, one, two;
    assign lines = ( (x > 57 && x < 61 && y < 61) || (x < 61 && y > 57 && y < 61) );
    assign zero = ( (x >= 14 && x <= 42 && y >= 9 && y <= 47) && !(x >= 20 && x <= 36 && y >= 15 && y <= 41) );
    assign one = ( (x >= 19 && x <= 31 && y >= 9 && y <= 14) || (x >= 25 && x <= 31 && y >= 15 && y <= 42) || (x >= 14 && x <= 42 && y >= 42 && y <= 47) );
    assign two = ( (x >= 14 && x <= 42 && y >= 9 && y <= 47) && !(x >= 14 && x <= 36 && y >= 15 && y <= 25) && !(x >= 20 && x <= 42 && y >= 31 && y <= 41) );
    
    always @ (x,y) begin
        if (current_option == 3) begin            
            if (sw[0])
                pixel_color = zero ? white : black;
            else if (sw[1])
                pixel_color = one ? white : black;
            else if (sw[2])
                pixel_color = two ? white : black;
            else            
                pixel_color = black;
                
            if (lines) pixel_color = sw[3] ? green : black;
        end     
    end
endmodule
