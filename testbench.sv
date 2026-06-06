// Code your testbench here
// or browse Examples
module top_fifo_tb();
  reg clk,rst;
  reg [7:0]data_in;
  wire [7:0]data_out;
  
  top_fifo dut(clk,rst,data_in,data_out);
  
  initial
    begin
      {clk,rst,data_in} = 0;
    end
  
  always #5 clk = ~clk;
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
      rst=1;
      #10;
      rst=0;
      data_in=5;
      #10;
      data_in=10;
      #10;
      data_in=5;
      #100;
      $finish;
    end
endmodule