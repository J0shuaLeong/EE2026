`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2023 01:43:27
// Design Name: 
// Module Name: mouse_task
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


module mouse_task (input [7:0] x, y, input middle, input [11:0] xpos, input [11:0] ypos, input [2:0] current_option, output reg [15:0] pixel_color);
    /*Part b*/
    parameter [15:0] red = 16'hF800;
    parameter [15:0] black = 16'h0000;
    
    wire cursor1, cursor2;
    assign cursor1 = ((x>40 && x<51 && y>30 && y<35));
    assign cursor2 = ((x>30 && x<55 && y>25 && y<40));
  
    always @ (*) begin
       if (current_option == 2) begin
           if (middle)
               pixel_color = ( x <= ((xpos%96) + 3) && x >= (xpos%96) && (y <= (ypos%64) + 3) && y >= (ypos%64))? red : black;
           else
               pixel_color = ( x <= ((xpos%96) + 5) && x >= (xpos%96) && (y <= (ypos%64) + 5) && y >= (ypos%64))? red : black;
       end
    end
endmodule
