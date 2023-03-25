`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2023 11:43:21
// Design Name: 
// Module Name: frequency_display
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

module frequency_display(input clk, input [11:0] mic_input, output reg [8:0] leds);

  reg [11:0] buffer [0:999];
  integer pointer = 0;
  integer i;
  integer f;
  integer freq_detected;

  always @(posedge clk) begin
    buffer[pointer] <= mic_input;
    pointer <= pointer + 1;
    if (pointer == 1000) begin
      pointer <= 0;
      f = 0;
      for (i = 1; i < 1000; i = i + 1) begin
        f = f + buffer[i] - buffer[i-1];
      end
      freq_detected = 100000000/(125*f);
      if (freq_detected >= 20 && freq_detected <= 200) begin
        leds <= 1;
      end else if (freq_detected > 200 && freq_detected <= 400) begin
        leds <= 3;
      end else if (freq_detected > 400 && freq_detected <= 600) begin
        leds <= 7;
      end else if (freq_detected > 600 && freq_detected <= 800) begin
        leds <= 15;
      end else if (freq_detected > 800 && freq_detected <= 1000) begin
        leds <= 31;
      end else if (freq_detected > 1000 && freq_detected <= 1200) begin
        leds <= 63;
      end else if (freq_detected > 1200 && freq_detected <= 1400) begin
        leds <= 127;
      end else if (freq_detected > 1400 && freq_detected <= 1600) begin
        leds <= 255;
      end else if (freq_detected > 1600) begin
        leds <= 511;
      end else begin
        leds <= 0;
      end
    end
  end

endmodule

