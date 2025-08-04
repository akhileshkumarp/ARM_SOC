# ARM Cortex M0 SoC Design Specification

## Overview
This document provides the detailed design specification for the ARM Cortex M0 based System on Chip (SoC) implementation for the NIELIT Workshop Mini Project.

## System Architecture

### Block Diagram
```
    ┌─────────────────┐
    │   ARM Cortex    │
    │      M0         │
    │   Processor     │
    └─────────┬───────┘
              │ AHB Bus
    ┌─────────┴───────┐
    │   Bus Matrix    │
    └─┬─────┬─────┬───┘
      │     │     │
   ┌──▼──┐ ┌▼──┐ ┌▼─────┐
   │Timer│ │LED│ │Memory│
   │Peri │ │GPIO││ Peri │
   │     │ │Peri│ │      │
   └─────┘ └───┘ └──────┘
```

### Memory Map
| Peripheral | Base Address | Size  | Description |
|------------|-------------|--------|-------------|
| Timer      | 0x40000000  | 64KB  | Timer peripheral registers |
| LED/GPIO   | 0x40010000  | 64KB  | LED/GPIO control registers |
| RAM        | 0x20000000  | 1KB   | Single port RAM (255x32) |

## Functional Requirements

### Timer Peripheral (0x40000000)
The timer peripheral implements a down-counter that:
- Counts from 0x0F to 0x00
- Generates interrupt when reaching 0x00
- Automatically reloads to 0x0F after interrupt
- Provides interrupt clear mechanism

#### Register Map
| Offset | Register | Access | Description |
|--------|----------|--------|-------------|
| 0x0000 | COUNT    | RO     | Current timer count value |
| 0x0004 | LOAD     | RW     | Timer load value (default 0x0F) |
| 0x0008 | CTRL     | RW     | Control register [1:0] = {INT_EN, TMR_EN} |
| 0x000C | CLEAR    | WO     | Interrupt clear register |
| 0x0010 | STATUS   | RO     | Status register [0] = INT_FLAG |

### LED/GPIO Peripheral (0x40010000)
Controls 8-bit LED output with the following functionality:
- Supports 8 GPIO pins
- Configurable direction (input/output)
- Direct data register control

#### Register Map
| Offset | Register | Access | Description |
|--------|----------|--------|-------------|
| 0x0000 | DATA     | RW     | GPIO data register |
| 0x0004 | DIR      | RW     | Direction register (1=output, 0=input) |
| 0x0008 | INPUT    | RO     | Input pin status |

### Memory Peripheral (0x20000000)
Single port RAM implementation:
- 255 locations × 32 bits
- Word-aligned addressing
- Synchronous read/write operations

## Interrupt Service Routine Behavior

When timer interrupt is generated:

1. **Interrupt Recognition**: CPU acknowledges timer interrupt
2. **LED Control**: Write 0xFF to LED data register
3. **RAM Write**: Write 0x55 to RAM location 0x00
4. **Delay**: Small delay for visibility
5. **LED Clear**: Write 0x00 to LED data register  
6. **RAM Clear**: Write 0x00 to RAM location 0x00
7. **Interrupt Clear**: Clear timer interrupt flag
8. **Return**: Resume normal execution

## Timing Specifications

### Clock Requirements
- System Clock: 50 MHz (20ns period)
- Timer Prescaler: Configurable (default: 256 cycles)
- Interrupt Response: < 10 clock cycles

### Timer Timing
- Count Period: (Prescaler + 1) × Clock Period
- Default Count Time: 256 × 20ns = 5.12μs per count
- Full Cycle Time: 16 × 5.12μs = 81.92μs (0x0F to 0x00)

## Verification Strategy

### Testbench Coverage
1. **Reset Functionality**: Verify proper initialization
2. **Timer Countdown**: Confirm 0x0F to 0x00 counting
3. **Interrupt Generation**: Verify interrupt at count 0x00
4. **ISR Execution**: Confirm proper interrupt service routine
5. **LED Control**: Verify 0xFF and 0x00 LED states
6. **RAM Operations**: Confirm 0x55 and 0x00 writes
7. **Interrupt Clearing**: Verify interrupt acknowledgment

### Expected Waveforms
- Timer count: Sawtooth from 0x0F to 0x00
- Interrupt: Pulse at each timer expiry
- LED output: 0xFF during interrupt service, 0x00 otherwise
- RAM data: 0x55 during interrupt, 0x00 after clearing

## Implementation Notes

### ARM Cortex M0 Model
This implementation uses a simplified Cortex M0 model focusing on:
- Basic instruction fetch/decode/execute cycle
- Interrupt handling capability
- Memory-mapped peripheral access
- Register file and program counter

### Synthesis Considerations
- All registers are synchronously clocked
- Reset is asynchronous, active-low
- Critical paths are minimized
- Area optimization for FPGA implementation

### Debug Features
- All major signals available for observation
- Memory contents visible in simulation
- Interrupt flags and timer states accessible
- LED outputs directly observable

## Testing Instructions

### ModelSim Simulation
1. Navigate to project directory
2. Run `scripts\run_modelsim.bat`
3. Observe waveforms in generated VCD file
4. Verify timing and functionality

### Keil Development
1. Run `scripts\compile_keil.bat` for setup instructions
2. Create new Keil project
3. Add Verilog source files
4. Configure for ARM Cortex M0 target
5. Build and debug

## Success Criteria
✓ Timer counts from 0x0F to 0x00 continuously  
✓ Interrupt generated at timer expiry  
✓ LED outputs 0xFF during interrupt service  
✓ RAM location 0 written with 0x55 during interrupt  
✓ LED cleared to 0x00 after delay  
✓ RAM location 0 cleared to 0x00 after delay  
✓ Interrupt properly cleared and cycle repeats
