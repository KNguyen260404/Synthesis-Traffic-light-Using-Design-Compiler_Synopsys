###################################################################

# Created by write_script -format dctcl on Thu Jul  3 16:02:58 2025

###################################################################

# Set the current_design #
current_design Traffic_light

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current uA
set_operating_conditions -max ff0p88v125c -max_library saed14rvt_ff0p88v125c\
                         -min ss0p72vm40c -min_library saed14rvt_ss0p72vm40c
remove_wire_load_model
set_multibit_options -mode non_timing_driven
set_local_link_library                                                         \
{/home/Khach123/Documents/Nguyen/me_labs/liberty/saed14rvt_ff0p88v125c.db,/home/Khach123/Documents/Nguyen/me_labs/liberty/saed14rvt_ss0p72vm40c.db,/home/Khach123/Documents/Nguyen/me_labs/liberty/saed14rvt_tt0p8v25c.db}
create_clock [get_ports clk]  -period 10  -waveform {0 5}
set_clock_uncertainty 0.2  [get_clocks clk]
set compile_inbound_cell_optimization false
set compile_inbound_max_cell_percentage 10.0
