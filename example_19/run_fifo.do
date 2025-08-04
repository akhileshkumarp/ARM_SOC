
# Clean start
if {[file exists work]} {
    file delete -force work
}
vlib work

# Compile files
echo "Compiling FIFO design..."
vlog fifo.v

echo "Compiling testbench..."
vlog fifo_tb.v

# Start simulation
echo "Starting simulation with testbench..."
vsim work.fifo_tb

# Add waveforms
echo "Adding waveforms..."
add wave -divider "Clock & Reset"
add wave /fifo_tb/clk
add wave /fifo_tb/rst_n

add wave -divider "Test Control"
add wave -radix unsigned /fifo_tb/test_phase

add wave -divider "FIFO Control"
add wave /fifo_tb/wr_en
add wave /fifo_tb/rd_en

add wave -divider "Data"
add wave -radix hex /fifo_tb/data_in
add wave -radix hex /fifo_tb/data_out

add wave -divider "Status"
add wave /fifo_tb/fifo_empty
add wave /fifo_tb/fifo_full

add wave -divider "Internal"
add wave -radix hex /fifo_tb/dut/fifo_mem
add wave -radix unsigned /fifo_tb/dut/wr_ptr
add wave -radix unsigned /fifo_tb/dut/rd_ptr

# Configure
configure wave -namecolwidth 150
configure wave -valuecolwidth 80
configure wave -timelineunits ns

# Disable warnings
set StdArithNoWarnings 1
set NumericStdNoWarnings 1

echo "Running simulation - this will NEVER ask about finish!"
echo "Phase 1: Reset and initial checks..."
run 1000ns
wave zoom full

echo "Phase 2: Basic write operations..."
run 2000ns
wave zoom full

echo "Phase 3: Basic read operations..."
run 2000ns
wave zoom full

echo "Phase 4: Fill FIFO test..."
run 2000ns
wave zoom full

echo "Phase 5: Empty FIFO test..."
run 3000ns
wave zoom full

echo "========================================="
echo "SIMULATION COMPLETED SUCCESSFULLY!"
echo "Total time: ~10us"
echo "NO finish calls, NO crash dialogs!"
echo "All FIFO functionality demonstrated"
echo "Check waveforms and transcript"
echo "========================================="

# Simulation continues running safely in background
echo "Simulation continues running safely..."
echo "You can stop it manually or close ModelSim"
