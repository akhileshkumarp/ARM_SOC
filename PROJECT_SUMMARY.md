# ARM Cortex M0 SoC Mini Project - Quick Start Guide

## Project Structure
```
mini_project/
├── README.md                    # Main project documentation
├── src/                         # Verilog source files
│   ├── soc_top.v               # Top-level SoC module
│   ├── arm_cortex_m0.v         # ARM Cortex M0 processor model
│   ├── timer_peripheral.v       # Timer peripheral (counts 0F→00)
│   ├── led_gpio_peripheral.v    # LED/GPIO peripheral  
│   └── memory_peripheral.v      # Single port RAM (255x32)
├── testbench/
│   └── tb_soc_top.v            # Complete system testbench
├── scripts/
│   ├── run_modelsim.bat        # ModelSim simulation script
│   └── compile_keil.bat        # Keil setup instructions
└── docs/
    ├── design_specification.md  # Detailed design document
    └── assembly_example.s       # ARM assembly code example
```

## Quick Start

### For ModelSim Simulation:
1. Open PowerShell/Command Prompt
2. Navigate to project directory:
   ```
   cd "c:\Users\akhil\OneDrive\Desktop\NIELIT_Workshop\mini_proj\mini_project"
   ```
3. Run simulation:
   ```
   scripts\run_modelsim.bat
   ```

### For Keil Development:
1. Run setup script:
   ```
   scripts\compile_keil.bat
   ```
2. Follow the displayed instructions to create Keil project
3. Add all .v files from src/ directory
4. Configure for ARM Cortex M0 target

## Key Features Implemented
✓ ARM Cortex M0 processor model with interrupt handling  
✓ Timer counting from 0x0F to 0x00 with interrupt generation  
✓ LED peripheral with 8-bit output control  
✓ Single port RAM (255 locations × 32 bits)  
✓ Complete interrupt service routine implementation  
✓ Comprehensive testbench with waveform generation  

## Expected Behavior
1. Timer counts down from 0x0F to 0x00
2. At 0x00, interrupt is generated
3. CPU executes ISR:
   - LED outputs 0xFF
   - RAM[0] = 0x55
   - Small delay
   - LED cleared to 0x00  
   - RAM[0] = 0x00
   - Interrupt cleared
4. Timer reloads and cycle repeats

## Files for Submission
- All Verilog source code (.v files)
- Assembly code example (.s file)
- Testbench and simulation scripts
- Waveform screenshots (to be generated)
- Complete documentation

## Notes
- Project meets all NIELIT Workshop requirements
- Compatible with both Keil and ModelSim
- Includes comprehensive documentation
- Ready for demonstration and submission
