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
    output [3:0] an,
    input [3:0] seg_status,
    output reg dp,
    input [3:0] seg_num1, 
    input [1:0] seg_num2
    );
    
    wire clk200;
    clock_200(CLK, clk200);
    
    reg [3:0] an_on = 4'b0001;
    assign an = ~an_on;//4'b1110; //for mic

    
    always @(posedge CLK) begin
    
        if (an_on == 4'b0001) begin
            dp <= 1;
            case(seg_status)
                0: begin seg <= 7'b1000000; end
                1: begin seg <= 7'b1111001; end
                2: begin seg <= 7'b0100100; end
                3: begin seg <= 7'b0110000; end
                4: begin seg <= 7'b0011001; end
                5: begin seg <= 7'b0010010; end
                6: begin seg <= 7'b0000010; end
                7: begin seg <= 7'b1111000; end
                8: begin seg <= 7'b0000000; end
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

//200Hz
module clock_200 (input CLOCK, output two_hund_Hz); 
    reg [18:0] COUNT = 0;
    reg SLOW_CLOCK = 0;
    
    assign two_hund_Hz = SLOW_CLOCK;
    
    always @ (posedge CLOCK) begin
        COUNT <= (COUNT == 19'd250_000) ? 0 : COUNT + 1;      
        SLOW_CLOCK <= (COUNT == 0) ? ~SLOW_CLOCK : SLOW_CLOCK;
    end
endmodule
