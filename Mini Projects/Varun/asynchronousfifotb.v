`timescale 1ns/1ns

module asynchronous_fifo_tb;

  reg clk;
  reg rst;
  reg write_en;
  reg read_en;
  reg [7:0] data_in;
  wire [7:0] data_out;

  asynchronous_fifo uut (
    .clk(clk),
    .rst(rst),
    .write_en(write_en),
    .read_en(read_en),
    .data_in(data_in),
    .data_out(data_out)
  );

  always 
	begin
    #5 clk = ~clk;
  end

  initial begin
    clk = 0;
    rst = 1;
    write_en = 0;
    read_en = 0;
    data_in = 8'h00;

    #10 rst = 0;

    #20 write_en = 1;
    data_in = 8'h0A;
    #10 write_en = 0;

    #30 read_en = 1;
    #10 read_en = 0;

    #10 $finish;
  end

endmodule

