`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.02.2023 14:01:49
// Design Name: 
// Module Name: my_contol_module_simulation
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


module my_contol_module_simulation(
    );
    
     reg [6:0]A;
     reg [6:0] B;
     reg btnL;
    
    wire [6:0]seg;
    wire [3:0]an;
    wire [15:12]led;
    wire [6:0]SUM;
    
    my_control_module module_alias(btnL, A , B, seg, an, led, SUM);
    
    initial begin
    
       A = 7'b0000011; B = 7'b0000001; btnL = 0; #10;
       A = 7'b0010011; B = 7'b0000101; btnL = 0; #10;
       A = 7'b0100100; B = 7'b0011001; btnL = 0; #10;
       A = 7'b1001011; B = 7'b0100001; btnL = 1; #10;
       A = 7'b0010010; B = 7'b0010101; btnL = 1; #10;
       A = 7'b0101101; B = 7'b1100011; btnL = 1; #10;
       
    end
endmodule
