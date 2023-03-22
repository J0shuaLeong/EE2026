`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2023 11:46:02
// Design Name: 
// Module Name: clk_variable
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


module clk_variable(
    input CLK,
    input [31:0] count_value,
    output reg clk_out = 0
    );
    
    reg [31:0] count = 0;
    
    always @ (posedge CLK) begin
        count <= (count >= count_value) ? 0 : count + 1;
        clk_out <= (count == 0) ? ~clk_out : clk_out;
    end
    
endmodule
