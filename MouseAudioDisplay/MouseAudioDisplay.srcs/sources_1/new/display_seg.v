`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2023 11:57:11
// Design Name: 
// Module Name: display_seg
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


module display_seg(
    input CLK,
    output reg [6:0] seg,
    output reg [3:0] an,
    input [3:0] volume,
    output reg dp,
    input [6:0] seg_num1, 
    input [1:0] seg_num2,
    input reset_n,
    input [2:0] current_option,
    input [2:0] task_option
    );
    
    wire clk200;
    clk_variable clk200hz(CLK, 249000, clk200);
    
    reg [3:0] an_on = 4'b0001;
    
    always @(*) begin
            an <= ~an_on;
            if (an_on == 4'b0001) begin
                dp <= 1;
                case(volume)
                    4'd0: begin seg <= 7'b1000000; end
                    4'd1: begin seg <= 7'b1111001; end
                    4'd2: begin seg <= 7'b0100100; end
                    4'd3: begin seg <= 7'b0110000; end
                    4'd4: begin seg <= 7'b0011001; end
                    4'd5: begin seg <= 7'b0010010; end
                    4'd6: begin seg <= 7'b0000010; end
                    4'd7: begin seg <= 7'b1111000; end
                    4'd8: begin seg <= 7'b0000000; end
                    4'd9: begin seg <= 7'b0011000; end
                endcase
            end else if (an_on == 4'b0010) begin
                dp <= 1;
                seg <= 7'b1111111;
            end else if (an_on == 4'b0100) begin
                dp <= 1;
                case (seg_num1)
                    0: begin seg <= 7'b1000000; end
                    1: begin seg <= 7'b1111001; end
                    2: begin seg <= 7'b0100100; end
                    3: begin seg <= 7'b0110000; end
                    4: begin seg <= 7'b0011001; end
                    5: begin seg <= 7'b0010010; end
                    6: begin seg <= 7'b0000010; end
                    7: begin seg <= 7'b1111000; end
                    8: begin seg <= 7'b0000000; end
                    9: begin seg <= 7'b0010000; end
                    default: begin seg <= 7'b1111111; end
                endcase
            end else begin
                dp <= (seg_num2 == 2) ? 1 : 0;
                case (seg_num2)
                    0: begin seg <= 7'b1000000; end
                    1: begin seg <= 7'b1111001; end
                    default: begin seg <= 7'b1111111; end
                endcase
            end 
    end
    
    
    always @ (posedge clk200) begin
        an_on <= (an_on == 4'b1000) ? 4'b0001 : an_on << 1;
    end
    
endmodule

