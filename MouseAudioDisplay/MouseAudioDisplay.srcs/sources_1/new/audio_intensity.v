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
    input [2:0] current_option,
    input [2:0] task_option,
    output reg [15:0] led
    );
    always @(*) begin
        if (task_option == 1 || current_option == 4) begin
        //an = 4'b1110;
        //dp <= 1;
        case(volume)
            4'd0: begin led = 0; end
            4'd1: begin led = {1{1'b1}} ; end
            4'd2: begin led = {2{1'b1}}; end
            4'd3: begin led = {3{1'b1}}; end
            4'd4: begin led = {4{1'b1}}; end
            4'd5: begin led = {5{1'b1}}; end
            4'd6: begin led = {6{1'b1}}; end
            4'd7: begin led = {7{1'b1}}; end
            4'd8: begin led = {8{1'b1}}; end
            4'd9: begin led = {9{1'b1}}; end
        endcase
        end
    end
    
endmodule
