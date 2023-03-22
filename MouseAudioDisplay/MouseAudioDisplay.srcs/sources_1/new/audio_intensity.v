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


module audio_intensity(
    input CLK,
    input [11:0] maxvalue,
    output reg led_status, seg_status
    );
    
    always @ (posedge CLK) begin
        if (maxvalue < 2048) begin led_status = 0; seg_status = 0; end
        else if (maxvalue >= 2048 && maxvalue < 2300) begin led_status = 1; seg_status = 1; end
        else if (maxvalue >= 2300 && maxvalue < 2450) begin led_status = 2; seg_status = 2; end
        else if (maxvalue >= 2450 && maxvalue < 2550) begin led_status = 3; seg_status = 3; end
        else if (maxvalue >= 2550 && maxvalue < 2660) begin led_status = 4; seg_status = 4; end
        else if (maxvalue >= 2660 && maxvalue < 2780) begin led_status = 5; seg_status = 5; end
        else if (maxvalue >= 2780 && maxvalue < 2890) begin led_status = 6; seg_status = 6; end
        else if (maxvalue >= 2890 && maxvalue < 3010) begin led_status = 7; seg_status = 7; end
        else if (maxvalue >= 3010 && maxvalue < 3130) begin led_status = 8; seg_status = 8; end
        else if (maxvalue >= 3130) begin led_status = 9; seg_status = 9; end
    end
    
endmodule
