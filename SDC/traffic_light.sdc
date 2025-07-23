# SDC file for Traffic Light Controller
# Target frequency: 1GHz (1ns clock period)

# Clock definition
create_clock -name clk -period 1.0 [get_ports clk]

# Set clock uncertainty (jitter, skew)
set_clock_uncertainty 0.1 [get_clocks clk]

# Input delay constraints
# Assuming inputs can arrive with a delay of up to 30% of clock period
set_input_delay -max 0.3 -clock clk [get_ports {en rst_n}]

# Output delay constraints
# Assuming outputs need to be valid within 40% of clock period
set_output_delay -max 0.4 -clock clk [get_ports {green_light yellow_light red_light count[*]}]

# Load constraints
# Assuming standard load for outputs
set_load 0.1 [all_outputs]

# Driving cell for inputs
set_driving_cell -lib_cell INVX1 -library saed14rvt_ff0p88v125c [all_inputs]

# Set transition constraints
set_max_transition 0.1 [current_design]

# Set capacitance constraints
set_max_capacitance 0.5 [current_design]

# Set fanout constraints
set_max_fanout 20 [current_design]

# False paths
# Reset is asynchronous, so we can set it as a false path
set_false_path -from [get_ports rst_n]

# Multicycle paths
# For paths that don't need to meet single-cycle timing
# Example: paths from second counter to display logic
set_multicycle_path 2 -from [get_pins Second_counter/int_count*] -to [get_pins Counter_decoder/*]

# Operating conditions
set_operating_conditions -max "ff0p88v125c"

# Wire load model
set_wire_load_model -name "ForQA" -library saed14rvt_ff0p88v125c

# Disable timing for specific pins if needed
# set_disable_timing [get_pins some_pin]

# Timing exceptions
# Add any specific timing exceptions here

# Area constraints
# Uncomment if you want to set area constraints
# set_max_area 0

# Power optimization
set_leakage_optimization true
set_dynamic_optimization true

# Report settings
set_app_var report_default_significant_digits 3