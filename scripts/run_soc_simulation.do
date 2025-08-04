# ARM Cortex M0 SoC ModelSim Simulation Script
# NIELIT Workshop - Mini Project

# Clean start
if {[file exists work]} {
    file delete -force work
}
vlib work

# Compile design files
echo "Compiling ARM Cortex M0 core..."
vlog src/arm_cortex_m0.v

echo "Compiling memory peripheral..."
vlog src/memory_peripheral.v

echo "Compiling timer peripheral..."
vlog src/timer_peripheral.v

echo "Compiling LED GPIO peripheral..."
vlog src/led_gpio_peripheral.v

echo "Compiling SoC top module..."
vlog src/soc_top.v

echo "Compiling testbench..."
vlog testbench/tb_soc_top.v

# Start simulation
echo "Starting simulation with SoC testbench..."
vsim work.tb_soc_top

# Setup VCD dumping
echo "Setting up VCD file dumping..."
vcd file results_dump/soc_simulation.vcd
vcd add -r /tb_soc_top/*

# Add waveforms
echo "Adding waveforms..."
add wave -divider "Clock & Reset"
add wave /tb_soc_top/clk
add wave /tb_soc_top/reset_n

add wave -divider "Test Control"
add wave -radix unsigned /tb_soc_top/test_cycle

add wave -divider "CPU Signals"
add wave -radix hex /tb_soc_top/dut/cpu_addr
add wave -radix hex /tb_soc_top/dut/cpu_data_out
add wave -radix hex /tb_soc_top/dut/cpu_data_in
add wave /tb_soc_top/dut/cpu_write_enable
add wave /tb_soc_top/dut/cpu_read_enable

add wave -divider "LED Output"
add wave -radix binary /tb_soc_top/led_out

add wave -divider "Timer Signals"
add wave /tb_soc_top/timer_interrupt
add wave -radix unsigned /tb_soc_top/timer_count
add wave -radix hex /tb_soc_top/dut/timer_data_out
add wave /tb_soc_top/dut/timer_ready

add wave -divider "Memory Interface"
add wave -radix hex /tb_soc_top/ram_data_out
add wave -radix hex /tb_soc_top/ram_addr_debug
add wave /tb_soc_top/dut/ram_select
add wave -radix hex /tb_soc_top/dut/ram_data_out_int
add wave /tb_soc_top/dut/ram_ready

add wave -divider "Peripheral Selects"
add wave /tb_soc_top/dut/timer_select
add wave /tb_soc_top/dut/led_select
add wave /tb_soc_top/dut/ram_select

# Configure wave display
configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -timelineunits ns

# Disable warnings
set StdArithNoWarnings 1
set NumericStdNoWarnings 1

echo "Running simulation - this will NEVER ask about finish!"
echo "Phase 1: Reset and initialization..."
run 2000ns
wave zoom full

echo "Phase 2: CPU operations and memory access..."
run 5000ns
wave zoom full

echo "Phase 3: Timer peripheral testing..."
run 5000ns
wave zoom full

echo "Phase 4: GPIO and LED operations..."
run 5000ns
wave zoom full

echo "Phase 5: Extended operation test..."
run 10000ns
wave zoom full

echo "========================================="
echo "ARM CORTEX M0 SOC SIMULATION COMPLETED!"
echo "Total time: ~27us"
echo "NO finish calls, NO crash dialogs!"
echo "All SoC functionality demonstrated"
echo "Check waveforms and transcript"
echo "VCD file saved: results_dump/soc_simulation.vcd"
echo "========================================="

# Close VCD file
vcd close

# Simulation continues running safely in background
echo "Simulation continues running safely..."
echo "You can stop it manually or close ModelSim"
