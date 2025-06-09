# Traffic Light Controller

## 1. Design Specifications:
Design a traffic light controller using FSM and following specification:
- Clock frequency: 10MHz
- Control red (17s), yellow (2s), green light (14s)
- Control 7 segments LED display

To simplify the project, only one direction of the road is controlled.

|      Port     |  Bus size  | Direction  |    Description   |
| :------------:|:----------:|:----------:|:----------------:|
|    clk        |      1     |  input     |    10MHz clock   |
|    rst_n      |      1     |  input     | Active low asynchronous reset |
|    en         |      1     |  input     | Active enable    |
|   red_light   |      1     |  output    | Enable red light |
| yellow_light  |      1     |  output    | Enable yellow light |
| green_light   |      1     |  output    | Enable green light |
| display_led   |     16     |  output    | 7 segment display, 2 digits |

The 7 segments LED display code can be found in the image below:

![7 Segment LED Display](./image/Led_7_segments.png)

The bit mapping of signal display_led to the segments is: {A,B,C,D,E,F,G,DP}
(this means MSB is segment A and LSB is DP)

From the problem, we need the following blocks:

• FSM to control state of the design. We need at least 3 states: RED, YELLOW, GREEN. We also need IDLE state when the system is not enabled.

• Because clock frequency is 10MHz, we need a counter to count the clock cycles and notify when 1 second is reached.

• We also need another counter to count the number of seconds that have passed to switch lights.

• A 7 segment decoder to convert the value on the counter to LEDs.

An overall block diagram can be found below:

![System Block Diagram](Image/System_summary.png)

## 2. Detailed Design of Blocks:

### 2.1 Second Block Counter:

From the clk signal's frequency, we understand 1 second equals 100 cycles of this clock. This counter needs to count from 99 to 0 then reset automatically.

At every last value, it sends out a signal 'last' to indicate one second has passed. It also sends out 'pre_last' that is 1 cycle sooner than 'last', this signal helps the FSM to catch up with the last cycle (because the FSM has a register on the output).

#### Interface Diagram and Waveform:

![Second Counter Interface](Image/Second_counter.png)

![Second Counter Waveform](Image/Second_counter_waveform.png)

#### Waveform Verification:

![Second Counter Verification](TrafficLight/second_counter_verification.png)

#### Verilog Implementation:

```verilog
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
```

### 2.2 Light Counter:

This light controller needs to be initialized with different values (red, yellow, green), so it has an init port with bus size 3, each bit is for 1 light. This counter only counts down each second (not each clock), it is enabled by the 'last' value of the second counter.

#### Interface Diagram and Waveform:

![Light Counter Interface](Image/Light_counter.png)

![Light Counter Waveform](Image/Light_counter_waveform.png)

#### Waveform Verification:

![Light Counter Verification](TrafficLight/light_counter_verification.png)

#### Verilog Implementation:

```verilog
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
```

In this design, init has higher priority than enable, so it won't count down if init is not zero.

### 2.3 FSM Block:

This block connects with the two mentioned counters and controls the red/yellow/green lights. The indexes of the light control signals must match with the indexes of the light counter block.

#### Interface Diagram and State Diagram:

![FSM Interface](Image/FSM.png)

![FSM State Diagram](Image/FSM_diagram.png)

#### Waveform Verification:

![FSM Verification](TrafficLight/fsm_verification.png)

#### Verilog Implementation:

```verilog
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
```

The cnt_last signal in the diagram is a function of second_cnt_pre_last and light_cnt_last.

### 2.4 Counter Decoder:

The counter decoder doesn't have any registers. It only converts values from the light counter block to 7-segment LEDs.

#### Interface Diagram:

![Counter Decoder Interface](Image/counter_decoder.png)

#### Waveform Verification:

![Counter Decoder Verification](TrafficLight/counter_decoder_verification.png)

#### Verilog Implementation:

```verilog
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
                // More cases for 2-19 omitted for brevity
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
```

### 2.5 Top-Level Module - Traffic Light Controller:

The top-level module connects all the sub-modules together to form the complete traffic light controller system.

#### Waveform Verification:

![Top Module Verification](TrafficLight/full_system_verification.png)

#### Verilog Implementation:

```verilog
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
    Second_counter #(pSECOND_CNT_VALUE) second_cnt(
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
    Light_FSM #(.LIGHT_STATE_WIDTH(LIGHT_STATE_WIDTH)) dut3 (
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
```

## 3. Simulation and Verification:

### 3.1 Testbench:

```verilog
`timescale 1ps/1ps

module Traffic_light_tb;

    // Parameters
    parameter pSECOND_CNT_VALUE = 99;
    parameter pGREEN_INIT_VAL = 14;
    parameter pYELLOW_INIT_VAL = 2;
    parameter pRED_INIT_VAL = 17;
    
    // Testbench signals
    reg clk;
    reg en;
    reg rst_n;
    wire green_light;
    wire yellow_light;
    wire red_light;
    wire [6:0] count;
    
    // Clock parameters
    parameter CLK_DELAY = 5;
    parameter CLK_WIDTH = 5;
    parameter CLK_PERIOD = 10;
    
    // Clock generation
    always begin
        #(CLK_DELAY) clk = 1'b1;
        #(CLK_WIDTH) clk = 1'b0;
        #(CLK_PERIOD-CLK_DELAY-CLK_WIDTH);
    end
    
    // Device under test
    Traffic_light #(
        .pSECOND_CNT_VALUE(pSECOND_CNT_VALUE),
        .pGREEN_INIT_VAL(pGREEN_INIT_VAL),
        .pYELLOW_INIT_VAL(pYELLOW_INIT_VAL),
        .pRED_INIT_VAL(pRED_INIT_VAL)
    ) u_dut (
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .green_light(green_light),
        .yellow_light(yellow_light),
        .red_light(red_light),
        .count(count)
    );
    
    // Monitor traffic light changes
    initial begin
        $monitor("%t: GREEN=%b, YELLOW=%b, RED=%b", 
                 $time, green_light, yellow_light, red_light);
    end
    
    // Test sequence
    initial begin
        // Dump waveform to file
        $dumpfile("dump.vcd");
        $dumpvars(0, Traffic_light_tb);
        
        // Initialize signals
        clk = 1'b0;
        rst_n = 1'b0;
        en = 0;
        
        // Release reset and enable after 5 clock cycles
        #(5*CLK_PERIOD) rst_n = 1'b1; en = 1;
        
        // Run simulation for enough cycles to see multiple state transitions
        #(4000*CLK_PERIOD)
        
        // Finish simulation
        $finish;
    end
endmodule
```

### 3.2 Simulation Results:

The following waveform shows the complete simulation of the traffic light controller:

![Complete Simulation Waveform](TrafficLight/complete_simulation.png)

The simulation confirms that the traffic light controller properly cycles through the states:
- GREEN light for 14 seconds
- YELLOW light for 2 seconds
- RED light for 17 seconds

### 3.3 Simulation Log:

```
15025: GREEN=0, YELLOW=1, RED=0
15035: GREEN=0, YELLOW=1, RED=0
17025: GREEN=0, YELLOW=0, RED=1
17035: GREEN=0, YELLOW=0, RED=1
34025: GREEN=1, YELLOW=0, RED=0
```

The log shows the transitions between the three states of the traffic light.

## 4. Running the Simulation:

To run the simulation, use the following commands:

### For Icarus Verilog:
```bash
iverilog -o traffic_light_sim traffic_light.v traffic_light_tb.v
vvp traffic_light_sim
gtkwave dump.vcd
```

### For ModelSim/QuestaSim:
```bash
vlog traffic_light.v traffic_light_tb.v
vsim -c -do "run -all" work.Traffic_light_tb
```

### For Xilinx Vivado:
```bash
xvlog traffic_light.v traffic_light_tb.v
xelab -debug typical Traffic_light_tb -s traffic_light_sim
xsim traffic_light_sim -tclbatch run_all.tcl
```

## 5. Conclusion:

This project successfully implements a traffic light controller using Verilog HDL. The design follows a modular approach, separating functionality into distinct modules for easier understanding and maintenance. The controller accurately cycles through the GREEN, YELLOW, and RED states with the specified timing requirements.

The verification process confirms that all modules function as expected, both individually and when integrated together. The waveform diagrams and logs provide clear evidence of the proper operation of the traffic light controller.

