# =============================================
# Formality Equivalence Check TCL Script: COUNTER
# =============================================

file mkdir ./reports
# 0. Load SVF from Design Compiler
set_svf ./outputs/traffic_light_formality.svf

# 1. Load the RTL design (container "r")
read_verilog -container r -libname WORK -01 { ./rtl/Traffic_light.v }
set_top r:/WORK/Traffic_light

# 2. Load the synthesized netlist (container "i")
read_verilog -container i -libname WORK -01 { ./outputs/traffic_light_synth.v }

# 3. Load the standard cell library
read_db {/home/Khach123/Documents/Nguyen/me_labs/liberty/saed14rvt_ff0p88v125c.db }

# 4. Set the top module for netlist
set_top i:/WORK/Traffic_light

# 5. Match RTL vs Netlist
match

# 6. Formal verification
verify

# 7. Reports

#report_verification_results > ./reports/verify_report.txt
report_compare_points > ./reports/compare_points.txt
report_black_boxes > ./reports/black_boxes.txt
report_unmatched_points > ./reports/unmatched_points.txt
report_passing_points > ./reports/passing_points.txt
report_failing_points > ./reports/failing_points.txt
report_aborted_points > ./reports/aborted_points.txt


