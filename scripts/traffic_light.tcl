# =============================================
# Design Compiler Synthesis Script for Counter
# =============================================

# Set technology libraries
set search_path [list . /home/Khach123/Documents/Nguyen/me_labs/liberty]
set link_library [list \
    /home/Khach123/Documents/Nguyen/me_labs/liberty/saed14rvt_ff0p88v125c.db \
    /home/Khach123/Documents/Nguyen/me_labs/liberty/saed14rvt_ss0p72vm40c.db \
    /home/Khach123/Documents/Nguyen/me_labs/liberty/saed14rvt_tt0p8v25c.db \
]
set target_library $link_library
set symbol_library ""


# Define working library
define_design_lib WORK -path ./work

# Read and analyze RTL files

analyze -library WORK -format verilog {/home/Khach123/Documents/Nguyen/Traffic-light-Verilog/rtl/Traffic_light.v}
elaborate Traffic_light -architecture verilog -library WORK


set_operating_conditions -min ss0p72vm40c -max ff0p88v125c

# Set constraints
create_clock -name clk -period 10 [get_ports clk] -waveform {0 5}
#set_input_delay 2 -clock clk [all_inputs]
#set_output_delay 2 -clock clk [all_outputs]
#set_max_fanout 8 [current_design]
set_max_transition 0.1 [get_designs counter]
set_clock_uncertainty 0.2 [get_clocks clk]

# Save synthesis session info for Formality
set_svf /home/Khach123/Documents/Nguyen/Traffic-light-Verilog/outputs/traffic_light_formality.svf

# Compile
#compile_ultra -retime
compile
check_design

# Reports

report_area > /home/Khach123/Documents/Nguyen/Traffic-light-Verilog/reports/area.rpt
report_timing > /home/Khach123/Documents/Nguyen/Traffic-light-Verilog/reports/timing.rpt
report_power > /home/Khach123/Documents/Nguyen/Traffic-light-Verilog/reports/power.rpt
report_qor > /home/Khach123/Documents/Nguyen/Traffic-light-Verilog/reports/qor.rpt
# Export netlist

write -format verilog -hierarchy -output /home/Khach123/Documents/Nguyen/Traffic-light-Verilog/outputs/traffic_light_synth.v
set_svf -off
write_sdf /home/Khach123/Documents/Nguyen/Traffic-light-Verilog/outputs/traffic_light_synth.sdf
# === Formality Preparation ===

# Export DDC (optional)
write -format ddc -hierarchy -output /home/Khach123/Documents/Nguyen/Traffic-light-Verilog/outputs/traffic_light_synth.ddc

# Export SDC constraints (optional but recommended)
write_sdc /home/Khach123/Documents/Nguyen/Traffic-light-Verilog/outputs/traffic_synth.sdc

# Export environment script for Formality
write_script -output /home/Khach123/Documents/Nguyen/Traffic-light-Verilog/outputs/traffic_light_env.tcl

# Turn off SVF recording
set_svf -off

# Optionally start GUI
gui_start

