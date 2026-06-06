module top_fifo(
  input clk,rst, input [7:0] data_in_top, output reg [7:0] data_out_top
);
  
  wire [7:0] data_out_a_temp;
  wire wr_en,rd_en;
  wire [7:0] data_out_fifo_temp;
  wire full,empty;
  
  mod_a mod1(data_in_top,clk,rst,data_out_a_temp,wr_en);
  fifo_8_8 fifo(clk,rst,wr_en,rd_en,data_out_a_temp,data_out_fifo_temp,full,empty);
  mod_b mod2(data_out_fifo_temp,clk,rst,data_out_top,rd_en);
  
endmodule

module fifo_8_8(
  input clk,rst,wr_en,rd_en,
  input [7:0] data_in_fifo, output reg [7:0] data_out_fifo,
  output reg full,empty
);
  
  reg [2:0] wr_ptr=0;
  reg [2:0] rd_ptr=0;
  reg [7:0] mem [0:7];
  integer i;
  
  always@(posedge clk)
    begin
      if(rst)
        begin
          for(i = 0;i < 7;i = i + 1)
            mem[i] <= 0;
        end
      if(wr_en && full == 0)
        begin
          mem[wr_ptr] <= data_in_fifo;
          wr_ptr <= wr_ptr + 1'b1;
        end
      if(rd_en && empty == 0)
        begin
          data_out_fifo <= mem[rd_ptr];
          rd_ptr <= rd_ptr + 1'b1;
        end
    end
  
  assign full = ((wr_ptr + 1'b1) == rd_ptr) ? 1'b1 : 1'b0;
  assign empty = wr_ptr == rd_ptr;

endmodule

module mod_a(
  input [7:0] data_in_a,input clk,rst,output reg [7:0] data_out_a,output reg wr_en
);
  
  always@(posedge clk)
    begin
      if(rst)
        begin
        data_out_a <= 0;
          wr_en <= 0;
        end
      else
        begin
        data_out_a <= data_in_a;
          wr_en <= 1;
        end
    end
endmodule

module mod_b(
  input [7:0] data_in_b,input clk,rst,output reg [7:0] data_out_b,output reg rd_en
);
  
  parameter idle = 2'b00;
  parameter s1 = 2'b01;
  parameter data_state = 2'b10;
  
  reg[1:0] ps,ns;
  
  always@(posedge clk)
    begin
      if(rst)
        begin
        ps <= idle;
        end
      else
        begin
        ps <= ns;
        end
    end
  always@(*)
    begin
      case(ps)
        idle : begin
          ns = s1;
          rd_en = 0;
        end
        s1 : begin
          ns = data_state;
        end
        data_state : begin
          ns = idle;
          rd_en = 1;
          data_out_b = data_in_b;
        end
      endcase
    end
endmodule
