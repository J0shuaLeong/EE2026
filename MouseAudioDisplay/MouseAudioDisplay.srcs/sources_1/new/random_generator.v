`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.03.2023 22:15:39
// Design Name: 
// Module Name: random_generator
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


module random_generator 
    #(parameter N = 3) (
    input clk, 
    input reset_n, 
    output [1:N] Q
);
    reg [1:N] Q_reg, Q_next;
    wire taps;
    initial Q_reg = 'd1;
    always @ (posedge clk, negedge reset_n) begin
        if (~reset_n) Q_reg <= 'd1;
        else Q_reg <= Q_next;
    end
    always @ (taps, Q_reg) begin
        Q_next = {taps, Q_reg[1:N-1]};
    end
    assign Q = Q_reg;
    assign taps = Q_reg[3]^Q_reg[2];
endmodule