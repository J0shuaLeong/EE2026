`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2023 11:59:02
// Design Name: 
// Module Name: audio_intensity
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


module display_led(
    input [3:0] volume,
    input [2:0] task_option,
    output reg [15:0] led,
    output reg [6:0] seg,
    output reg [3:0] an,
    output reg dp
    );
    always @(*) begin
        if (task_option == 1) begin
        an = 4'b1110;
        dp <= 1;
        case(volume)
            4'd0: begin led = 0; seg <= 7'b1000000; end
            4'd1: begin led = {1{1'b1}}; seg <= 7'b1111001; end
            4'd2: begin led = {2{1'b1}}; seg <= 7'b0100100; end
            4'd3: begin led = {3{1'b1}}; seg <= 7'b0110000; end
            4'd4: begin led = {4{1'b1}}; seg <= 7'b0011001; end
            4'd5: begin led = {5{1'b1}}; seg <= 7'b0010010; end
            4'd6: begin led = {6{1'b1}}; seg <= 7'b0000010; end
            4'd7: begin led = {7{1'b1}}; seg <= 7'b1111000; end
            4'd8: begin led = {8{1'b1}}; seg <= 7'b0000000; end
            4'd9: begin led = {9{1'b1}}; seg <= 7'b0010000; end
        endcase
        end
    end
    
endmodule
