# Keil uVision Project Setup Instructions
# ARM Cortex M0 SoC Project
# NIELIT Workshop - Mini Project

## Project Configuration

### 1. Create New Project
- Open Keil uVision IDE
- File -> New -> uVision Project
- Choose project location: keil_project folder
- Project name: cortex_m0_soc

### 2. Device Selection
- Select: ARM -> ARM Cortex M0 -> ARMCM0
- Or use Generic Cortex-M0 device

### 3. Add Source Files
Add the following files to your project:

#### Assembly Files:
- main.s (main assembly code with interrupt handlers)
- startup_cortexm0.s (startup and vector table)

#### C Files:
- main.c (main C application)
- system_cortexm0.c (system initialization)

#### Header Files:
- system_cortexm0.h (system definitions and prototypes)

### 4. Project Settings

#### Target Options:
- Device: ARM Cortex M0
- Clock: 16.0 MHz
- Memory Model: Small

#### C/C++ Settings:
- Language C: C99
- Optimization: Level 1 (-O1)
- Include Paths: Add project directory

#### ASM Settings:
- Assembler: ARM Assembler
- Include Paths: Add project directory

#### Linker Settings:
- Use Memory Layout from Target Dialog: Checked
- RAM: 0x20000000, Size: 0x2000 (8KB)
- ROM: 0x00000000, Size: 0x8000 (32KB)

#### Debug Settings:
- Debug Adapter: Use Simulator
- Initialization File: Not required for simulator

### 5. Memory Map (for reference)
```
0x00000000 - 0x00007FFF : ROM/Flash (32KB)
0x20000000 - 0x20001FFF : RAM (8KB)
0x40000000 - 0x4000FFFF : Timer Peripheral
0x40010000 - 0x4001FFFF : LED/GPIO Peripheral
```

### 6. Build Configuration
- Configuration: Debug
- Output: Create HEX File
- Listing: Assembly Listing

### 7. Simulation Setup
- Debug -> Start/Stop Debug Session
- View -> Watch Windows -> Watch 1
- Add variables: SystemCoreClock
- View -> Memory Windows -> Memory 1
- Set address: 0x20000000 (RAM)

### 8. Running the Project
1. Build Project (F7)
2. Start Debug Session (Ctrl+F5)
3. Run (F5)
4. Observe:
   - Timer interrupts occurring
   - LED outputs changing
   - RAM values being modified
   - Memory window updates

### 9. Key Features Demonstrated
- ARM Cortex M0 assembly programming
- Interrupt service routines
- Memory-mapped peripheral access
- Timer peripheral control
- LED/GPIO control
- RAM read/write operations
- Mixed C and Assembly programming

### 10. Testing Points
- Set breakpoints in Timer_IRQHandler
- Watch LED_DATA_REG changes
- Monitor RAM_BASE memory location
- Verify interrupt timing
- Check peripheral register values

## Troubleshooting
- Ensure all files are added to project
- Check memory addresses match SoC design
- Verify peripheral register definitions
- Use simulator for testing without hardware
