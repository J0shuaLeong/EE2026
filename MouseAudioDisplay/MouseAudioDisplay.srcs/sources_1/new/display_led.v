`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2023 11:56:32
// Design Name: 
// Module Name: display_led
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
    input CLK,
    output reg [11:0] led,
    output reg led_status
    );
    
    always @ (posedge CLK) begin
        case (led_status)
            0: begin led <= 9'h0000; end
            1: begin led <= 9'h0001; end
            2: begin led <= 9'h0003; end
            3: begin led <= 9'h000F; end
            4: begin led <= 9'h001F; end
            5: begin led <= 9'h003F; end
            6: begin led <= 9'h007F; end
            7: begin led <= 9'h00FF; end
            8: begin led <= 9'h01FF; end
        endcase
    end
endmodule
