# ARM Cortex M0 Based SoC Design - Mini Project

## Project Overview
This project implements an ARM Cortex M0 based System on Chip (SoC) that interfaces with various peripherals including Timer, Memory (255x32 Single port RAM), and GPIO/LED peripherals.

## Project Requirements
Design and develop an ARM Cortex M0 based SoC by interfacing the peripherals:
- Timer
- Memory (255x32 Single port RAM) 
- GPIO/LED

## System Functionality
The SoC works as follows:

1. **Timer Operation**: Timer counts from '0F' to '00'. Once the count reaches the minimum value ('00'), an interrupt is generated and cleared (using clear register).

2. **Interrupt Handling**: Once timer interrupt becomes high:
   - a. LED peripheral outputs the value 'FF'
   - b. Single port RAM is written with data '55' in its first location
   - c. After a small delay, LED peripheral is cleared and the first location of single port RAM is written with value '00'

## Architecture
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│    TIMER    │◄──►│             │◄──►│    BRAM     │
│ PERIPHERAL  │    │             │    │ (PROGRAM    │
└─────────────┘    │             │    │  MEMORY)    │
                   │             │    └─────────────┘
┌─────────────┐    │ ARM CORTEX  │    
│ LED/GPIO    │◄──►│     M0      │    ┌─────────────┐
│ PERIPHERAL  │    │             │◄──►│   MEMORY    │
└─────────────┘    │             │    │ PERIPHERAL  │
                   └─────────────┘    └─────────────┘
```

## File Structure
```
mini_project/
├── README.md
├── src/
│   ├── soc_top.v           # Top-level SoC module
│   ├── arm_cortex_m0.v     # ARM Cortex M0 processor
│   ├── timer_peripheral.v   # Timer peripheral module
│   ├── led_gpio_peripheral.v # LED/GPIO peripheral module
│   ├── memory_peripheral.v  # Single port RAM module
│   └── interrupt_controller.v # Interrupt controller
├── testbench/
│   ├── tb_soc_top.v        # Top-level testbench
│   └── tb_*.v              # Individual module testbenches
├── scripts/
│   ├── compile_keil.bat    # Keil compilation script
│   └── run_modelsim.bat    # ModelSim simulation script
└── docs/
    └── design_specification.md
```

## Development Environment
- **Hardware Description Language**: Verilog
- **Synthesis Tool**: Keil uVision
- **Simulation Tool**: ModelSim
- **Target**: ARM Cortex M0 based SoC

## Getting Started

### Prerequisites
- Keil uVision IDE
- ModelSim simulator
- Basic knowledge of Verilog HDL and ARM architecture

### Building the Project

#### Using Keil:
1. Open Keil uVision
2. Create new project
3. Add all source files from `src/` directory
4. Configure for ARM Cortex M0 target
5. Build the project

#### Using ModelSim:
1. Open ModelSim
2. Navigate to project directory
3. Run the compilation script:
   ```
   scripts\run_modelsim.bat
   ```

### Running Simulations
1. Load the testbench in ModelSim
2. Run simulation to verify timer counting and interrupt generation
3. Observe LED output and RAM write operations
4. Verify interrupt clearing mechanism

## Key Features
- ARM Cortex M0 processor core
- Down-counting timer (0F to 00)
- Interrupt-driven LED control
- Single port RAM with 255x32 configuration
- GPIO/LED peripheral interface
- Interrupt controller for timer events

## Testing
The testbench verifies:
- Timer countdown operation
- Interrupt generation at timer expiry
- LED peripheral response to interrupts
- RAM write operations (data '55' and '00')
- Interrupt clearing mechanism

## Deliverables
As per assignment requirements, this project includes:
- Complete Verilog source code
- Assembly code for ARM Cortex M0
- Simulation waveforms screenshots
- Documentation and README

## Author
NIELIT Workshop - ARM Based SoC Design Batch 6
Assessment 1 - Mini Project

## License
Educational use only - NIELIT Workshop Assignment
