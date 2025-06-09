// Traffic Light Controller Testbench
// Based on SystemVerilog version

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
    wire [6:0] count; // Assuming 7 bits for count 0-99
    
    // Clock parameters - REDUCED FOR FASTER SIMULATION
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
        // Assuming we need about 4000 cycles to see a complete cycle
        #(4000*CLK_PERIOD)
        
        // Finish simulation
        $finish;
    end
    
endmodule
