// Second Counter module in Verilog - Fixed version
`timescale 1ns/1ps

module Second_counter #(
    parameter pSECOND_CNT_VALUE=99,
    parameter pMAX_VAL=pSECOND_CNT_VALUE
)
(
    input wire clk,  
    input wire en,
    input wire rst_n,
    output wire last,
    output wire pre_last,
    output reg [6:0] count // debug variable, 7 bits for values up to 127
);
  
  // Counter register with optimized width based on pMAX_VAL
  reg [6:0] int_count;
  
  // Initialize variables to avoid X values at simulation start
  initial begin
    int_count = pMAX_VAL;
    count = pMAX_VAL;
  end
  
  // Sequential logic for counter - optimized for clarity and efficiency
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      // Reset condition
      int_count <= pMAX_VAL;
      count <= pMAX_VAL;
    end
    else if(en) begin
      if(int_count > 0) begin
        // Normal counting
        int_count <= int_count - 1;
        count <= int_count - 1;
      end
      else begin
        // Wrap around when reached zero
        int_count <= pMAX_VAL;
        count <= pMAX_VAL;
      end
    end
    // Keep existing value when not enabled
  end
  
  // Optimized combinational logic for outputs - using assign for wire outputs
  assign last = (int_count == 0) ? 1'b1 : 1'b0;    // Explicit ternary to avoid X
  assign pre_last = (int_count == 1) ? 1'b1 : 1'b0; // Explicit ternary to avoid X
  
endmodule