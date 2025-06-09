// Optimized testbench for Second_counter module - Fixed version
`timescale 1ns/1ps

module Second_counter_tb;
    // Define parameters
    parameter pSECOND_CNT_VALUE = 99;
    parameter pMAX_VAL = pSECOND_CNT_VALUE;
    parameter CLK_PERIOD = 4; // Clock period in ns
    
    // Testbench signals
    reg clk;  
    reg en;
    reg rst_n;
    wire last;
    wire pre_last;
    wire [6:0] count;
  
    // Instantiate the Unit Under Test (UUT)
    Second_counter #(
        .pSECOND_CNT_VALUE(pSECOND_CNT_VALUE),
        .pMAX_VAL(pMAX_VAL)
    ) uut (
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .last(last),
        .pre_last(pre_last),
        .count(count)
    );
    
    // Initialize all signals to avoid X values
    initial begin
        clk = 0;
        en = 0;
        rst_n = 1;
    end
    
    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;
    
    // Dump waveform to file
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, Second_counter_tb);
    end
  
    // Test sequence
    initial begin
        // Start with reset to ensure deterministic state
        #(CLK_PERIOD*2) rst_n = 0;
        #(CLK_PERIOD*2) rst_n = 1;
        
        // Enable counter and monitor - use %d for decimal display of count
        #(CLK_PERIOD) en = 1;
        $monitor("Time=%0t, clk=%b, rst_n=%b, en=%b, count=%d, last=%b, pre_last=%b", 
                 $time, clk, rst_n, en, count, last, pre_last);
        
        // Run for a full counter cycle plus a bit more to see wrap-around
        #(CLK_PERIOD * (pMAX_VAL + 10)) $finish;
    end
  
endmodule
