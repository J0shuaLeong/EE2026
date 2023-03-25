`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2023 11:41:44
// Design Name: 
// Module Name: frequency_detector
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

module frequency_detector (
  input wire clk,
  input wire reset,
  input wire [11:0] mic_sample,
  output reg [8:0] led_output
);

  // Parameters for frequency ranges and LED mapping
  localparam integer NUM_LEDS = 9;
  localparam integer FREQ_MIN = 20;
  localparam integer FREQ_MAX = 20000;
  localparam integer FREQ_BIN_SIZE = (FREQ_MAX - FREQ_MIN) / NUM_LEDS;

  // Internal signals
  wire [11:0] fft_output;
  wire get_highest_bin;
  reg [3:0] detected_led;
  reg [4:0] highest_bin;

  // FFT module instantiation (not included)
  // Replace with your own FFT implementation or IP core
  FFT fft_inst (
    .clk(clk),
    .reset(reset),
    .data_input(mic_sample),
    .data_output(fft_output)
  );
    
 find_highest_bin highest_bin_inst (
    .fft_output(fft_output),
    .max_idx(get_highest_bin)
  );

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      detected_led <= 4'b0000;
      led_output <= 9'b000000000;
    end else begin
      // Find the highest magnitude frequency bin
      // (Assume you have a function 'find_highest_bin' that returns the index of the highest magnitude bin)
      highest_bin <= get_highest_bin;

      // Calculate the detected frequency and map it to an LED
      detected_led <= (highest_bin * FREQ_BIN_SIZE) / (FREQ_MAX - FREQ_MIN);

      // Turn on the corresponding LED
      led_output <= 9'b000000001 << detected_led;
    end
  end

endmodule

module FFT (
  input wire clk,
  input wire reset,
  input wire [11:0] data_input,
  output wire [11:0] data_output
);

  localparam integer FFT_SIZE = 1024;
  localparam integer FFT_STAGES = $clog2(FFT_SIZE);

  reg [11:0] input_data [0:FFT_SIZE-1];
  reg [11:0] output_data [0:FFT_SIZE-1];
  reg [11:0] twiddle_factors [0:FFT_SIZE/2-1];

  integer i, j, k, stage;

  // Bit-reversal function
  function [9:0] bit_reverse;
    input [9:0] index;
    integer l;
    begin
      bit_reverse = 0;
      for (l = 0; l < 10; l = l + 1)
        bit_reverse[l] = index[9 - l];
    end
  endfunction
  
  real angle;
  // Calculate twiddle factors
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      for (i = 0; i < FFT_SIZE/2; i = i + 1) begin
        angle = -2.0 * 3.1415926535 * i / FFT_SIZE;
        twiddle_factors[i] <= 12'b0;
        twiddle_factors[i][11:6] <= $rtoi($cos(angle) * 32); // Real part (cosine)
        twiddle_factors[i][5:0] <= $rtoi($sin(angle) * 32); // Imaginary part (sine)
      end
    end
  end

  // Load input data
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      input_data[0] <= data_input;
    end else begin
      for (i = 1; i < FFT_SIZE; i = i + 1)
        input_data[i] <= input_data[i - 1];
      input_data[0] <= data_input;
    end
  end
  
  integer twiddle_index, lower_index, upper_real, upper_imag, lower_real, lower_imag, twiddle_real, twiddle_imag, prod_real, prod_imag;
  // Radix-2 DIT FFT
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      for (i = 0; i < FFT_SIZE; i = i + 1)
        output_data[i] <= 12'b0;
    end else begin
      for (i = 0; i < FFT_SIZE; i = i + 1)
        output_data[bit_reverse(i)] <= input_data[i];
      for (stage = 0; stage < FFT_STAGES; stage = stage + 1) begin
        for (i = 0; i < FFT_SIZE; i = i + (2 << stage)) begin
          for (j = 0; j < (1 << stage); j = j + 1) begin
            k = (i + j) % FFT_SIZE;
            twiddle_index = j << (FFT_STAGES - stage - 1);
            lower_index = k + (1 << stage);

            // Butterfly computation
            upper_real = output_data[k][11:6];
            upper_imag = output_data[k][5:0];
            lower_real = output_data[lower_index][11:6];
            lower_imag = output_data[lower_index][5:0];

            twiddle_real = twiddle_factors[twiddle_index][11:6];
            twiddle_imag = twiddle_factors[twiddle_index][5:0];

            // Complex multiplication (twiddle * lower)
            prod_real = (twiddle_real * lower_real) - (twiddle_imag * lower_imag);
            prod_imag = (twiddle_real * lower_imag) + (twiddle_imag * lower_real);

            // Normalize product
            prod_real = prod_real >>> 5; // Divide by 32
            prod_imag = prod_imag >>> 5; // Divide by 32

            // Update data
            output_data[k] <= {upper_real - prod_real, upper_imag - prod_imag};
            output_data[lower_index] <= {upper_real + prod_real, upper_imag + prod_imag};
          end
        end
      end
    end
  end

  assign data_output = output_data[0];

endmodule

parameter N = 2048;           
module find_highest_bin (
  input [N-1:0] fft_output,
  output reg [$clog2(N)-1:0] max_idx
);
  
  integer i;
  real mag;
  real max_mag = 0.0;

  always @* begin
    max_mag = 0.0;
    max_idx = 0;
    // Find the bin with the highest magnitude
    for (i = 0; i < N; i = i + 1) begin
      mag = $abs(fft_output[i]);
      if (mag > max_mag) begin
        max_mag = mag;
        max_idx = i;
      end
    end
  end

endmodule

            
/*module fft_module(
    input clk,
    input reset,
    input [11:0] mic_sample,
    output [11:0] fft_output
);

parameter N = 256;
reg [N-1:0] real_input;
reg [N-1:0] imag_input;
reg [N-1:0] real_output;
reg [N-1:0] imag_output;

integer i;
integer k;
integer j;
integer L;
integer LE;
integer LE2;
integer ip;
integer n;
integer M;

assign fft_output = real_output[11:0];

// Initialize inputs to 0
initial begin
  real_input = 0;
  imag_input = 0;
end

// FFT algorithm
always @(posedge clk) begin
    if (reset) begin
        real_input <= 0;
        imag_input <= 0;
    end else begin
        real_input[0] <= mic_sample;
        imag_input[0] <= 0;
        
        // Bit-reverse reordering
        for (i=0; i<N-1; i=i+1) begin
            j = 0;
            for (k=0; k<$clog2(N); k=k+1) begin
                j = j + ((i>>k) & 1)<<($clog2(N)-1-k);
            end
            if (j > i) begin
                real_input[i] <= real_input[j];
                imag_input[i] <= imag_input[j];
                real_input[j] <= mic_sample;
                imag_input[j] <= 0;
            end
        end
        
        // Compute FFT
        L = 1;
        for (n=0; n<$clog2(N); n=n+1) begin
            LE = 2^L;
            LE2 = LE/2;
            for (j=0; j<LE2; j=j+1) begin
                M = 2^($clog2(N)-n-1)*j;
                for (i=j; i<N; i=i+LE) begin
                    ip = i+LE2;
                    real_output[i] = real_input[i] + real_input[ip]*$cos(2*3.14159*M/N) + imag_input[ip]*$sin(2*3.14159*M/N);
                    imag_output[i] = imag_input[i] - real_input[ip]*$sin(2*3.14159*M/N) + imag_input[ip]*$cos(2*3.14159*M/N);
                    real_output[ip] = real_input[i] - real_input[ip]*$cos(2*3.14159*M/N) - imag_input[ip]*$sin(2*3.14159*M/N);
                    imag_output[ip] = imag_input[i] + real_input[ip]*$sin(2*3.14159*M/N) - imag_input[ip]*$cos(2*3.14159*M/N);
                end
            end
            for (i=0; i<N; i=i+1) begin
                real_input[i] = real_output[i];
                imag_input[i] = imag_output[i];
            end
            L = L + 1;
        end
    end
end

endmodule


/*module frequency_detector(
    input clk,
    input [11:0] mic_sample,
    output reg [31:0] frequency
);

reg [31:0] phase_acc;
reg [31:0] phase_acc_prev;
reg [31:0] phase_inc;

reg [3:0] freq_est;
reg [3:0] freq_est_prev;
reg [2:0] freq_est_diff;

always @ (posedge clk) begin
    phase_acc_prev <= phase_acc;
    phase_acc <= phase_acc + phase_inc;
end

always @ (posedge clk) begin
    freq_est_prev <= freq_est;
    freq_est_diff <= freq_est - freq_est_prev;

    if (freq_est_diff < 0) begin
        freq_est_diff = -freq_est_diff;
    end
end

always @ (posedge clk) begin
    if (mic_sample > 0 && phase_acc > 0) begin
        freq_est <= freq_est + 1;
    end
    else if (mic_sample < 0 && phase_acc < 0) begin
        freq_est <= freq_est - 1;
    end
end

always @ (posedge clk) begin
    if (phase_acc_prev[31] != phase_acc[31]) begin
        frequency <= freq_est;
        freq_est <= 0;
        phase_inc <= phase_acc - phase_acc_prev;
    end
end

endmodule*/




