`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:04:27 12/04/2023 
// Design Name: 
// Module Name:    asynchronous fifo 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module asynchronous_fifo (
  input wire clk,
  input wire rst,
  input wire write_en,
  input wire read_en,
  input wire [7:0] data_in,
  output wire [7:0] data_out
);

  parameter DEPTH = 36 * 1024;
  parameter WIDTH = 8;

  reg [WIDTH-1:0] fifo [0:DEPTH-1];
  reg [WIDTH-1:0] read_ptr, write_ptr;
  reg [WIDTH-1:0] read_ptr_gray, write_ptr_gray;

  
  always @(posedge clk or posedge rst) 
	begin
    if (rst) 
	  begin
      read_ptr <= 0;
      write_ptr <= 0;
    end 
		else 
		  begin
      read_ptr <= read_ptr_gray;
      write_ptr <= write_ptr_gray;
    end
  end

  always @(posedge clk) 
	begin
    write_ptr_gray <= binary_to_gray(write_ptr);
  end

  always @(posedge clk) 
	begin
    read_ptr_gray <= binary_to_gray(read_ptr);
  end

  function [WIDTH-1:0] binary_to_gray;
    input [WIDTH-1:0] bin;
    reg [WIDTH-1:0] gray;

    gray = bin ^ (bin >> 1);

    return gray;
  endfunction

  function [WIDTH-1:0] gray_to_binary;
    input [WIDTH-1:0] gray;
    reg [WIDTH-1:0] bin;

    for (int i = WIDTH - 1; i > 0; i = i - 1) 
		begin
      bin[i] = gray[i] ^ gray[i-1];
    end
    bin[0] = gray[0];

    return bin;
  endfunction

  always @(posedge clk) 
	begin
    if (write_en) 
		begin
      fifo[write_ptr] <= data_in;
      write_ptr <= write_ptr + 1;
    end
  end

  always @(posedge clk) 
	begin
    if (read_en)
		begin
      data_out <= fifo[read_ptr];
      read_ptr <= read_ptr + 1;
    end
  end

endmodule


