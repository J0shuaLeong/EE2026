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
   output reg [3:0] volume
   );
   wire  clk_20kHz,clk_display;
   reg [12:0] count_sample;
   clk_variable clk1(CLK, 2499, clk_20kHz); 
   reg [11:0] max_mic;
   
   initial begin
       count_sample = 0;
       volume = {2{1'b1}};
       max_mic = 0;
   end
   always @(posedge clk_20kHz) begin
       count_sample <= (count_sample == 12'd1999)? 0:count_sample + 1; //1999
       max_mic <= count_sample == 0 ? MIC_IN : (MIC_IN > max_mic ? MIC_IN : max_mic);    
       volume <= (count_sample == 0)?  max_mic[10:7] : volume;    
   end
   
   //Seven SEG and LED
   //display_volume d1(CLK,sw ,volume,seg,an);
   //display_led d2(volume,volume_led);
    
endmodule
