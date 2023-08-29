`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.01.2023 21:36:05
// Design Name: 
// Module Name: Graded_lab_1
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
// Matriculation no. : A0254586R
// password: 54586 (switches 4, 5, 6, 8)
// 
//////////////////////////////////////////////////////////////////////////////////


module Graded_lab_1(
    input [9:0]sw, //switches 0 to 9
    output [3:0]an, //common anode 0 to 3
    output [6:0]seg, //7 LED segment in each display
    output [9:0]led, //ld0 to ld9
    output led15, 
    output dp
    );
    
     assign an[0] = 0; //common anode 0 is always on no matter correct or wrong password
     assign an[2] = (~(sw[4] & sw[5] & sw[6] & sw[8]) | (sw[0] | sw[1] | sw[2] | sw[3] | sw[7] | sw[9])); //only on when password is correct (switch 4,5,6,8), turns off otherwise
     assign an[3] = ((sw[4] & sw[5] & sw[6] & sw[8]) & ~(sw[0] | sw[1] | sw[2] | sw[3] | sw[7] | sw[9])); //off when only sw 4,5,6,8 on
     
     assign seg[3] = ((sw[4] & sw[5] & sw[6] & sw[8]) & ~(sw[0] | sw[1] | sw[2] | sw[3] | sw[7] | sw[9])); //off when only sw 4,5,6,8 on
     assign seg[4] = 0; //always on
     assign seg[5] = ((sw[4] & sw[5] & sw[6] & sw[8]) & ~(sw[0] | sw[1] | sw[2] | sw[3] | sw[7] | sw[9])); //off when only sw 4,5,6,8
     assign seg[6] = 0; //always on
     assign dp = 1; //off
          
     assign led[0] = sw[0];
     assign led[1] = sw[1];
     assign led[2] = sw[2];
     assign led[3] = sw[3];
     assign led[4] = sw[4];
     assign led[5] = sw[5];
     assign led[6] = sw[6];
     assign led[7] = sw[7];
     assign led[8] = sw[8];
     assign led[9] = sw[9];
     assign led15 = ((sw[4] & sw[5] & sw[6] & sw[8]) & ~(sw[0] | sw[1] | sw[2] | sw[3] | sw[7] | sw[9])); //only on when password is correct (switch 4,5,6,8), turns off otherwise
     
endmodule
