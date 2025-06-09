// Light Counter module in Verilog
`timescale 1ns/1ps

module Light_Counter #(
  parameter pGREEN_INIT_VAL = 14,
  parameter pYELLOW_INIT_VAL = 2,
  parameter pRED_INIT_VAL = 17,
  parameter pCNT_WIDTH = 5, // $clog2(pRED_INIT_VAL+1) = 5 for pRED_INIT_VAL=17
  parameter pINIT_WIDTH = 3
)
(
  input wire clk,
  input wire en,
  input wire rst_n,
  input wire [pINIT_WIDTH-1:0] init,
  output wire last,
  output reg [pCNT_WIDTH-1:0] cnt_out
);
  
  // Light indices
  parameter pGREEN_IDX = 0;
  parameter pYELLOW_IDX = 1;
  parameter pRED_IDX = 2;
  
  // Initialize counter to handle X at simulation start
  initial begin
    cnt_out = pYELLOW_INIT_VAL;
  end
  
  // Counter process
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      cnt_out <= pYELLOW_INIT_VAL;
    end
    else if(init[pGREEN_IDX]) begin
      cnt_out <= pGREEN_INIT_VAL;
    end
    else if(init[pYELLOW_IDX]) begin
      cnt_out <= pYELLOW_INIT_VAL;
    end
    else if(init[pRED_IDX]) begin
      cnt_out <= pRED_INIT_VAL;
    end 
    else if(en) begin
      if(cnt_out != 0) begin
        cnt_out <= cnt_out - 1;
      end
    end
  end
  
  // Output logic
  assign last = (cnt_out == 0) ? 1'b1 : 1'b0;
  
endmodule
