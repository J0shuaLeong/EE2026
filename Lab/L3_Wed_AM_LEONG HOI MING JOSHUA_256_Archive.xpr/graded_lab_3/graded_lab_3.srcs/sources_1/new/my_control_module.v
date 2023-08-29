`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.02.2023 12:37:09
// Design Name: 
// Module Name: my_control_module
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

module my_control_module (
    input CLOCK,
    input [2:0]sw,
    input SW15,
    input btnD, btnL, btnR,
    output reg led15 = 0,
    output reg [8:0] led = 9'd0,
    output reg [3:0]an = 4'b1111,
    output reg [6:0]seg = 7'b1111111
    );
 
    wire B, C, D;
    reg [31:0] count_interval = 0;
    integer init_count = 0, led_num = 0, count = 0, btn_mode = 0, unlocked = 0, sw_mode = 0;
   
    always @(posedge CLOCK) begin
        //subtask A 1.11 sec interval
        count_interval <= (count_interval == 32'd111000000)? 0 : count_interval + 1;
        led_num <= (count_interval == 0) ? led_num + 1 : led_num;
    
        if (SW15 == 1) begin
            //wait 3 seconds
            init_count <= (init_count >= 300000000) ? init_count : init_count + 1;
        end
        else begin
            //reset 3sec count
            init_count = 0;
        end
        if (init_count >= 300000000) begin
            //turn on led 4, 5, 8, 6 and display r on all seg
            led15 <= 0;
            led <= 9'b101110000;
            an <= 4'b0000;
            seg <= 7'b0101111;
        end
        else begin 
                //Subtask A led interval
                case (led_num)
                    0: begin led <= 9'b000000000; end
                    1: begin led <= 9'b000000001; end
                    2: begin led <= 9'b000000011; end
                    3: begin led <= 9'b000000111; end
                    4: begin led <= 9'b000001111; end
                    5: begin led <= 9'b000011111; end
                    6: begin led <= 9'b000111111; end
                    7: begin led <= 9'b001111111; end
                    8: begin led <= 9'b011111111; end
                    9: begin led <= 9'b111111111; end
                    default: begin led_num <= 9; end
                endcase
               
                //if max led is on, proceed
                if (led[8]) begin
                    //if any of switch 0,1 or 2 is on
                    if (sw[2])
                        begin
                            //led2 blink at 100hz
                            count <= (count >= 500000) ? 0 : count + 1;
                            led[0] <= 1;
                            led[1] <= 1;
                            led[2] <= (count == 0) ? ~led[2] : led[2];
                            sw_mode <= (count == 0) ? sw_mode + 1 : sw_mode; //for 7seg 
                        end 
                    else if (sw[1])
                        begin
                            //led1 blink at 10hz
                            count <= (count >= 5000000) ? 0 : count + 1;
                            led[0] <= 1;
                            led[1] <= (count == 0) ? ~led[1] : led[1];
                            sw_mode <= (count == 0) ? sw_mode + 1 : sw_mode; //for 7seg
                        end
                    else if (sw[0])
                        begin
                            //led0 blink at 1hz
                            count <= (count >= 50000000) ? 0 : count + 1;
                            led[0] <= (count == 0) ? ~led[0] : led[0];
                            sw_mode <= (count == 0) ? sw_mode + 1 : sw_mode; //for 7seg
                        end
                //subtask B
                //locked
                if (unlocked == 0) begin   
                    if (btn_mode == 0) begin   
                        an <= 4'b1110;
                        seg <= 7'b0100001; //display d
                        if (btnD == 1) begin
                            btn_mode = 1;
                        end
                    end
                    else if (btn_mode == 1) begin
                        an <= 4'b1101;
                        seg <= 7'b1001111; //display l
                        if (btnL == 1) begin 
                            btn_mode = 2;
                        end
                    end
                    else if (btn_mode == 2) begin
                        an <= 4'b1011;
                        seg <= 7'b0101111; //display r
                        if (btnR == 1) begin
                            unlocked = 1;
                            sw_mode = 0;
                        end
                    end
                end
                //subtask C
                //unlocked
                else begin 
                        led15 <= 1;   
                        //if switch 0,1 or 2 is on
                        case(sw_mode)
                            0:
                            begin
                                an <= 4'b1110;
                                seg <= 7'b0100001; //d
                            end
                            1:
                            begin
                                an <= 4'b1101;
                                seg <= 7'b1001111; //l
                            end
                            2:
                            begin
                                an <= 4'b1011;
                                seg <= 7'b0101111; //r
                            end
                            default: begin sw_mode <= 0; end
                        endcase
                    end
                end                                
        end
    end   
endmodule 