// Traffic Light Controller Verilog Implementation
// Based on SystemVerilog version

module Traffic_light #(
    parameter pSECOND_CNT_VALUE = 99,
    parameter pGREEN_INIT_VAL = 14,
    parameter pYELLOW_INIT_VAL = 2,
    parameter pRED_INIT_VAL = 17
)(
    input wire clk,
    input wire en,
    input wire rst_n,
    output wire green_light,
    output wire yellow_light,
    output wire red_light,
    output wire [6:0] count // assuming 7 bits are enough for 0-99
);

    // Parameters
    parameter pNUMBER_WIDTH = 5;
    parameter pLED_WIDTH = 8;
    parameter pLED_NO = 2;
    
    parameter pGREEN_IDX = 0;
    parameter pYELLOW_IDX = 1;
    parameter pRED_IDX = 2;
    parameter pLIGHT_CNT_WIDTH = 5; // log2(pRED_INIT_VAL+1)
    parameter pINIT_WIDTH = 3;
    parameter pSECOND_CNT_WIDTH = 7; // log2(pSECOND_CNT_VALUE+1)
    parameter LIGHT_STATE_WIDTH = 3;
    
    // Internal signals
    wire second_cnt_last, second_cnt_pre_last;
    
    wire [pINIT_WIDTH-1:0] light_cnt_init;
    wire light_cnt_last;
    wire [pLIGHT_CNT_WIDTH-1:0] light_cnt_out;
    wire light_cnt_en;
    wire [LIGHT_STATE_WIDTH-1:0] light;
    
    wire [pLED_WIDTH-1:0] display_led_dozens;
    wire [pLED_WIDTH-1:0] display_led_unit;
    
    // Second counter module
    Second_counter #(
        .pMAX_VAL(pSECOND_CNT_VALUE)
    ) second_cnt (
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .last(second_cnt_last),
        .pre_last(second_cnt_pre_last),
        .count(count)
    );
    
    // Light counter enable
    assign light_cnt_en = en & second_cnt_last;
    
    // Light counter module
    Light_Counter #(
        .pGREEN_INIT_VAL(pGREEN_INIT_VAL),
        .pYELLOW_INIT_VAL(pYELLOW_INIT_VAL),
        .pRED_INIT_VAL(pRED_INIT_VAL),
        .pCNT_WIDTH(pLIGHT_CNT_WIDTH),
        .pINIT_WIDTH(pINIT_WIDTH)
    ) dut1 (
        .clk(clk),
        .en(light_cnt_en),
        .rst_n(rst_n),
        .init(light_cnt_init),
        .last(light_cnt_last),
        .cnt_out(light_cnt_out)
    );
    
    // Counter decoder module
    Counter_decoder #(
        .pNUMBER_WIDTH(pNUMBER_WIDTH),
        .pLED_WIDTH(pLED_WIDTH),
        .pLED_NO(pLED_NO)
    ) dut2 (
        .clk(clk),
        .en(en),
        .number(light_cnt_out),
        .display_led({display_led_dozens, display_led_unit})
    );
    
    // Light FSM module
    Light_FSM #(
        .LIGHT_STATE_WIDTH(LIGHT_STATE_WIDTH)
    ) dut3 (
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .light_cnt_last(light_cnt_last),
        .second_cnt_pre_last(second_cnt_pre_last),
        .light(light),
        .light_cnt_init(light_cnt_init)
    );
    
    // Light outputs
    assign green_light = light[pGREEN_IDX];
    assign yellow_light = light[pYELLOW_IDX];
    assign red_light = light[pRED_IDX];

endmodule

// Second counter module
module Second_counter #(
    parameter pMAX_VAL = 99
)(
    input wire clk,
    input wire en,
    input wire rst_n,
    output wire last,
    output wire pre_last,
    output wire [6:0] count // for 0-99
);
    
    // Internal counter
    reg [6:0] int_count;
    
    // Counter process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            int_count <= pMAX_VAL;
        end
        else if (en) begin
            if (|int_count) begin
                int_count <= int_count - 1;
            end
            else begin
                int_count <= pMAX_VAL;
            end
        end
        else begin
            int_count <= pMAX_VAL;
        end
    end
    
    // Output assignments
    assign last = (int_count == 0) ? 1'b1 : 1'b0;
    assign pre_last = (int_count == 1) ? 1'b1 : 1'b0;
    assign count = int_count;

endmodule

// Light counter module
module Light_Counter #(
    parameter pGREEN_INIT_VAL = 14,
    parameter pYELLOW_INIT_VAL = 2,
    parameter pRED_INIT_VAL = 17,
    parameter pCNT_WIDTH = 5, // log2(pRED_INIT_VAL+1)
    parameter pINIT_WIDTH = 3
)(
    input wire clk,
    input wire en,
    input wire rst_n,
    input wire [pINIT_WIDTH-1:0] init,
    output wire last,
    output wire [pCNT_WIDTH-1:0] cnt_out
);
    
    // Local parameters
    parameter pGREEN_IDX = 0;
    parameter pYELLOW_IDX = 1;
    parameter pRED_IDX = 2;
    
    // Counter register
    reg [pCNT_WIDTH-1:0] count;
    
    // Counter process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= pGREEN_INIT_VAL;
        end
        else if (init[pGREEN_IDX]) begin
            count <= pGREEN_INIT_VAL;
        end
        else if (init[pYELLOW_IDX]) begin
            count <= pYELLOW_INIT_VAL;
        end
        else if (init[pRED_IDX]) begin
            count <= pRED_INIT_VAL;
        end
        else if (en) begin
            count <= count - 1;
        end
    end
    
    // Output assignments
    assign last = (count == 0) ? 1'b1 : 1'b0;
    assign cnt_out = count;

endmodule

// Counter decoder module
module Counter_decoder #(
    parameter pNUMBER_WIDTH = 5,
    parameter pLED_WIDTH = 8,
    parameter pLED_NO = 2
)(
    input wire clk,
    input wire en,
    input wire [pNUMBER_WIDTH-1:0] number,
    output wire [pLED_WIDTH*pLED_NO-1:0] display_led
);
    
    // Internal registers
    reg [7:0] dozens;
    reg [7:0] unit;
    
    // Decoder process
    always @(*) begin
        if (en) begin
            case (number)
                5'd0: begin
                    dozens = 8'h3F;
                    unit = 8'h3F;
                end
                5'd1: begin
                    dozens = 8'h3F;
                    unit = 8'h06;
                end
                5'd2: begin
                    dozens = 8'h3F;
                    unit = 8'h5B;
                end
                5'd3: begin
                    dozens = 8'h3F;
                    unit = 8'h4F;
                end
                5'd4: begin
                    dozens = 8'h3F;
                    unit = 8'h66;
                end
                5'd5: begin
                    dozens = 8'h3F;
                    unit = 8'h6D;
                end
                5'd6: begin
                    dozens = 8'h3F;
                    unit = 8'h7D;
                end
                5'd7: begin
                    dozens = 8'h3F;
                    unit = 8'h07;
                end
                5'd8: begin
                    dozens = 8'h3F;
                    unit = 8'h7F;
                end
                5'd9: begin
                    dozens = 8'h3F;
                    unit = 8'h6F;
                end
                5'd10: begin
                    dozens = 8'h06;
                    unit = 8'h3F;
                end
                5'd11: begin
                    dozens = 8'h06;
                    unit = 8'h06;
                end
                5'd12: begin
                    dozens = 8'h06;
                    unit = 8'h5B;
                end
                5'd13: begin
                    dozens = 8'h06;
                    unit = 8'h4F;
                end
                5'd14: begin
                    dozens = 8'h06;
                    unit = 8'h66;
                end
                5'd15: begin
                    dozens = 8'h06;
                    unit = 8'h6D;
                end
                5'd16: begin
                    dozens = 8'h06;
                    unit = 8'h7D;
                end
                5'd17: begin
                    dozens = 8'h06;
                    unit = 8'h07;
                end
                5'd18: begin
                    dozens = 8'h06;
                    unit = 8'h7F;
                end
                5'd19: begin
                    dozens = 8'h06;
                    unit = 8'h6F;
                end
                default: begin
                    dozens = 8'h00;
                    unit = 8'h00;
                end
            endcase
        end
        else begin
            dozens = 8'h00;
            unit = 8'h00;
        end
    end
    
    // Output assignment
    assign display_led = {dozens, unit};

endmodule

// Light FSM module
module Light_FSM #(
    parameter LIGHT_STATE_WIDTH = 3
)(
    input wire clk,
    input wire en,
    input wire rst_n,
    input wire light_cnt_last,
    input wire second_cnt_pre_last,
    output wire [LIGHT_STATE_WIDTH-1:0] light,
    output wire [LIGHT_STATE_WIDTH-1:0] light_cnt_init
);
    
    // Local parameters
    parameter pGREEN_IDX = 0;
    parameter pYELLOW_IDX = 1;
    parameter pRED_IDX = 2;
    
    // State encoding
    parameter [1:0] IDLE = 2'b00;
    parameter [1:0] GREEN = 2'b01;
    parameter [1:0] YELLOW = 2'b10;
    parameter [1:0] RED = 2'b11;
    
    // State and output registers
    reg [1:0] light_current_state, light_next_state;
    reg [LIGHT_STATE_WIDTH-1:0] signal_light;
    reg [LIGHT_STATE_WIDTH-1:0] signal_light_cnt_init;
    
    // Last count signal
    wire last_cnt;
    assign last_cnt = light_cnt_last & second_cnt_pre_last;
    
    // State register process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            light_current_state <= IDLE;
        end
        else if (en) begin
            light_current_state <= light_next_state;
        end
        else begin
            light_current_state <= IDLE;
        end
    end
    
    // Next state and output logic
    always @(*) begin
        // Default values
        light_next_state = IDLE;
        signal_light = 3'b000;
        signal_light_cnt_init = 3'b000;
        
        case (light_current_state)
            IDLE: begin
                if (en) begin
                    light_next_state = GREEN;
                    signal_light[pGREEN_IDX] = 1'b1;
                end
                else begin
                    light_next_state = IDLE;
                    signal_light = 3'b000;
                    signal_light_cnt_init = 3'b000;
                end
            end
            
            GREEN: begin
                if (last_cnt) begin
                    light_next_state = YELLOW;
                    signal_light[pYELLOW_IDX] = 1'b1;
                    signal_light_cnt_init[pYELLOW_IDX] = 1'b1;
                end
                else begin
                    light_next_state = GREEN;
                    signal_light[pGREEN_IDX] = 1'b1;
                end
            end
            
            YELLOW: begin
                if (last_cnt) begin
                    light_next_state = RED;
                    signal_light[pRED_IDX] = 1'b1;
                    signal_light_cnt_init[pRED_IDX] = 1'b1;
                end
                else begin
                    light_next_state = YELLOW;
                    signal_light[pYELLOW_IDX] = 1'b1;
                end
            end
            
            RED: begin
                if (last_cnt) begin
                    light_next_state = GREEN;
                    signal_light[pGREEN_IDX] = 1'b1;
                    signal_light_cnt_init[pGREEN_IDX] = 1'b1;
                end
                else begin
                    light_next_state = RED;
                    signal_light[pRED_IDX] = 1'b1;
                end
            end
        endcase
    end
    
    // Output assignments
    assign light = signal_light;
    assign light_cnt_init = signal_light_cnt_init;

endmodule
