`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2023 01:45:27
// Design Name: 
// Module Name: xycoordinate
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


module xycoordinate (input [12:0] pixel_index, output [7:0] x, [7:0] y, input [11:0] xpos, [11:0] ypos, output [11:0] nxpos, [11:0] nypos);
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
    assign nxpos = (xpos > 92) ? 92 : xpos;
    assign nypos = (ypos > 60) ? 60 : ypos;
endmodule
