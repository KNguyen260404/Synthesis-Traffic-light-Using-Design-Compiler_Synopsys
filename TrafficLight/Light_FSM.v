// Light FSM module in Verilog
`timescale 1ns/1ps

module Light_FSM #(parameter LIGHT_STATE_WIDTH=3)(
  input wire clk,
  input wire en,
  input wire rst_n,
  input wire light_cnt_last,
  input wire second_cnt_pre_last,
  output wire [LIGHT_STATE_WIDTH-1:0] light,
  output wire [LIGHT_STATE_WIDTH-1:0] light_cnt_init
);
  // State definitions
  parameter IDLE = 2'b00;
  parameter GREEN = 2'b01;
  parameter YELLOW = 2'b10;
  parameter RED = 2'b11;
  
  // Light indices
  parameter pGREEN_IDX = 0;
  parameter pYELLOW_IDX = 1;
  parameter pRED_IDX = 2;
  
  // State registers
  reg [1:0] light_current_state, light_next_state;
  
  // Output signals
  reg [LIGHT_STATE_WIDTH-1:0] signal_current_light;
  reg [LIGHT_STATE_WIDTH-1:0] signal_current_init;
  reg [LIGHT_STATE_WIDTH-1:0] signal_next_light;
  reg [LIGHT_STATE_WIDTH-1:0] signal_next_init;
  
  // Last count signal
  wire last_cnt;
  
  // Assign outputs
  assign last_cnt = light_cnt_last & second_cnt_pre_last;
  assign light = signal_current_light;
  assign light_cnt_init = signal_current_init;
  
  // Sequential logic for state transitions
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      light_current_state <= IDLE;
      signal_current_light <= 0;
      signal_current_init <= 0;
    end
    else if(en) begin
      light_current_state <= light_next_state;
      signal_current_light <= signal_next_light;
      signal_current_init <= signal_next_init;
    end
    else begin
      light_current_state <= IDLE;
      signal_current_light <= 0;
      signal_current_init <= 0;
    end
  end
  
  // Combinational logic for next state and outputs
  always @(*) begin
    // Default values
    light_next_state = IDLE;
    signal_next_light = 0;
    signal_next_init = 0;
    
    case(light_current_state)
      IDLE: begin 
        if(en) begin
          light_next_state = GREEN;
          signal_next_light[pGREEN_IDX] = 1'b1;
          signal_next_init[pGREEN_IDX] = 1'b1;
        end
        else begin
          light_next_state = IDLE;
          signal_next_light = 0;
          signal_next_init = 0;
        end
      end
      
      GREEN: begin
        if(last_cnt) begin
          light_next_state = YELLOW;
          signal_next_light[pYELLOW_IDX] = 1'b1;
          signal_next_init[pYELLOW_IDX] = 1'b1;
        end
        else begin
          light_next_state = GREEN;
          signal_next_light[pGREEN_IDX] = 1'b1;
          signal_next_init[pGREEN_IDX] = 1'b1;
        end
      end
      
      YELLOW: begin 
        if(last_cnt) begin
          light_next_state = RED;
          signal_next_light[pRED_IDX] = 1'b1;
          signal_next_init[pRED_IDX] = 1'b1;
        end
        else begin
          light_next_state = YELLOW;
          signal_next_light[pYELLOW_IDX] = 1'b1;
          signal_next_init[pYELLOW_IDX] = 1'b1;
        end
      end
      
      RED: begin 
        if(last_cnt) begin
          light_next_state = GREEN;
          signal_next_light[pGREEN_IDX] = 1'b1;
          signal_next_init[pGREEN_IDX] = 1'b1;
        end
        else begin
          light_next_state = RED;
          signal_next_light[pRED_IDX] = 1'b1;
          signal_next_init[pRED_IDX] = 1'b1;
        end
      end
    endcase
  end
  
endmodule
