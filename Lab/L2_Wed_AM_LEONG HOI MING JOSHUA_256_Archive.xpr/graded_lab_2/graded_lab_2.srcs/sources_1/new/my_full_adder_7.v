`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2023 22:42:45
// Design Name: 
// Module Name: Graded Lab 2
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
// A0254586R
//////////////////////////////////////////////////////////////////////////////////



module my_control_module (input btnL, [6:0]A, [6:0]B, output [6:0]seg, [3:0]an, [15:12]led, [6:0]SUM);
    wire c1;
    wire [6:0] s1;
    
    //initialisation
    //2nd rightmost digit = 8
    assign an = 4'b1100; 
    assign seg = 7'b1101010;
    
    //subtask B    
    assign led[12] = btnL ? 1:0;
    assign led[13] = btnL ? 1:0;
    assign led[14] = btnL ? 1:0;
    assign led[15] = btnL ? 1:0;
    
    //subtask A
    //3rd rightmost digit = 5; 3 + 4 bit adder
    three_bit_adder least_significant_bits (A[2:0], B[2:0], s1[2:0], c1);
    four_bit_adder most_significant_bits (A[6:3], B[6:3], c1, s1[6:3]);
    
    //subtask C  
    //multiply by 4, shift two bits to the left  
    assign SUM[0] = btnL ? 0:s1[0];
    assign SUM[1] = btnL ? 0:s1[1];
    assign SUM[2] = btnL ? s1[0]:s1[2];
    assign SUM[3] = btnL ? s1[1]:s1[3];
    assign SUM[4] = btnL ? s1[2]:s1[4];
    assign SUM[5] = btnL ? s1[3]:s1[5];
    assign SUM[6] = btnL ? s1[4]:s1[6];
    
endmodule

module three_bit_adder (input [2:0] A, [2:0] B, output [2:0]SUM, output COUT);  

    wire c1, c2, c3;

    my_full_adder fa0 (A[0], B[0], c1, SUM[0], c2);
    my_full_adder fa1 (A[1], B[1], c2, SUM[1], c3);
    my_full_adder fa2 (A[2], B[2], c3, SUM[2], COUT);

endmodule

module four_bit_adder (input [3:0]A, [3:0]B, input CIN, output [3:0]SUM);     

    wire c1, c2, c3, c4;

    my_full_adder fa0 (A[0], B[0], CIN, SUM[0], c1);
    my_full_adder fa1 (A[1], B[1], c1, SUM[1], c2);
    my_full_adder fa2 (A[2], B[2], c2, SUM[2], c3);
    my_full_adder fa3 (A[3], B[3], c3, SUM[3], c4);
    
endmodule

module my_full_adder(input A, B, CIN, output SUM, COUT);  
    
    assign SUM = A^B^CIN;
    assign COUT = (A&B) | (CIN&(A^B));
 
endmodule 

