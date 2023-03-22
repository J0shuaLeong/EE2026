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
    output reg [8:0] led,
    output reg [3:0] seg_status
    );
    
    always @ (posedge CLK) begin
        if (maxvalue < 2048) begin led <= 9'h0000; seg_status = 0; end
        else if (maxvalue >= 2048 && maxvalue < 2300) begin led <= 9'h0001; seg_status = 1; end
        else if (maxvalue >= 2300 && maxvalue < 2450) begin led <= 9'h0003; seg_status = 2; end
        else if (maxvalue >= 2450 && maxvalue < 2550) begin led <= 9'h000F; seg_status = 3; end
        else if (maxvalue >= 2550 && maxvalue < 2660) begin led <= 9'h001F; seg_status = 4; end
        else if (maxvalue >= 2660 && maxvalue < 2780) begin led <= 9'h003F; seg_status = 5; end
        else if (maxvalue >= 2780 && maxvalue < 2890) begin led <= 9'h007F; seg_status = 6; end
        else if (maxvalue >= 2890 && maxvalue < 3010) begin led <= 9'h00FF; seg_status = 7; end
        else if (maxvalue >= 3010) begin led <= 9'h01FF; seg_status = 8; end
    end
    
endmodule
