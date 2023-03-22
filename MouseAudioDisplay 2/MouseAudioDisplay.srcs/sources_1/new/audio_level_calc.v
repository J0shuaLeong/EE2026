`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2023 11:58:42
// Design Name: 
// Module Name: audio_level_calc
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


module audio_level_calc(
    input CLK,
    input [11:0] MIC_IN,
    output reg [11:0] maxvalue
    );
    
    reg [15:0] max;
    reg [22:0] count = 0;
    
    always @ (posedge CLK) begin
        count <= (count >= 4999999) ? 0 : count + 1;
        if (MIC_IN > max) begin
            max <= MIC_IN;
        end
        if (count == 0) begin
            maxvalue <= max;
            max <= 0;
        end   
    end
    
endmodule
