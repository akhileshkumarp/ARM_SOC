; ARM Cortex M0 Assembly Code for SoC Project
; NIELIT Workshop - Mini Project
; Compatible with Keil uVision IDE
; Author: Workshop Participant

; Memory-mapped peripheral addresses (based on SoC design)
TIMER_BASE          EQU     0x40000000      ; Timer peripheral base
TIMER_DATA_REG      EQU     0x40000000      ; Timer data register
TIMER_CONTROL_REG   EQU     0x40000004      ; Timer control register
TIMER_STATUS_REG    EQU     0x40000008      ; Timer status register
TIMER_CLEAR_REG     EQU     0x4000000C      ; Timer interrupt clear

LED_BASE            EQU     0x40010000      ; LED/GPIO peripheral base
LED_DATA_REG        EQU     0x40010000      ; LED data register
LED_DIR_REG         EQU     0x40010004      ; LED direction register
LED_INPUT_REG       EQU     0x40010008      ; LED input register

RAM_BASE            EQU     0x20000000      ; RAM base address
STACK_TOP           EQU     0x20001000      ; Stack pointer initial value

; System Control Block (SCB) for interrupt control
SCB_BASE            EQU     0xE000E000
NVIC_ISER           EQU     0xE000E100      ; Interrupt Set Enable Register
NVIC_ICER           EQU     0xE000E180      ; Interrupt Clear Enable Register

                PRESERVE8
                THUMB

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors
                EXPORT  __Vectors_End
                EXPORT  __Vectors_Size

; Vector Table for Cortex M0
__Vectors       DCD     STACK_TOP               ; Top of Stack
                DCD     Reset_Handler           ; Reset Handler
                DCD     NMI_Handler             ; NMI Handler
                DCD     HardFault_Handler       ; Hard Fault Handler
                DCD     0                       ; Reserved
                DCD     0                       ; Reserved
                DCD     0                       ; Reserved
                DCD     0                       ; Reserved
                DCD     0                       ; Reserved
                DCD     0                       ; Reserved
                DCD     0                       ; Reserved
                DCD     SVC_Handler             ; SVCall Handler
                DCD     0                       ; Reserved
                DCD     0                       ; Reserved
                DCD     PendSV_Handler          ; PendSV Handler
                DCD     SysTick_Handler         ; SysTick Handler
                
                ; External Interrupts
                DCD     Timer_IRQHandler        ; Timer Interrupt Handler
                DCD     GPIO_IRQHandler         ; GPIO Interrupt Handler

__Vectors_End
__Vectors_Size  EQU  __Vectors_End - __Vectors

                AREA    |.text|, CODE, READONLY

; Reset Handler - Entry point after reset
Reset_Handler   PROC
                EXPORT  Reset_Handler       [WEAK]
                IMPORT  SystemInit
                IMPORT  __main
                
                ; Initialize system clock and peripherals
                BL      SystemInit
                
                ; Initialize our SoC peripherals
                BL      SoC_Init
                
                ; Jump to main application
                BL      __main
                BX      LR
                ENDP

; System Initialization for SoC
SoC_Init        PROC
                EXPORT  SoC_Init
                
                ; Initialize LED GPIO peripheral
                BL      LED_Init
                
                ; Initialize Timer peripheral
                BL      Timer_Init
                
                ; Initialize RAM with test pattern
                BL      RAM_Init
                
                ; Enable interrupts
                CPSIE   I                   ; Enable interrupts globally
                
                BX      LR
                ENDP

; LED/GPIO Initialization
LED_Init        PROC
                ; Set LED direction register (all pins as outputs)
                LDR     R0, =LED_DIR_REG
                MOV     R1, #0xFF           ; All pins as outputs
                STR     R1, [R0]
                
                ; Clear LED data register (all LEDs off)
                LDR     R0, =LED_DATA_REG
                MOV     R1, #0x00
                STR     R1, [R0]
                
                BX      LR
                ENDP

; Timer Initialization
Timer_Init      PROC
                ; Load timer with initial value (0x0F)
                LDR     R0, =TIMER_DATA_REG
                MOV     R1, #0x0F
                STR     R1, [R0]
                
                ; Enable timer and interrupts
                LDR     R0, =TIMER_CONTROL_REG
                MOV     R1, #0x03           ; Enable timer and interrupt
                STR     R1, [R0]
                
                ; Enable timer interrupt in NVIC
                LDR     R0, =NVIC_ISER
                MOV     R1, #0x01           ; Enable IRQ0 (Timer)
                STR     R1, [R0]
                
                BX      LR
                ENDP

; RAM Initialization
RAM_Init        PROC
                ; Initialize first few RAM locations with test data
                LDR     R0, =RAM_BASE
                MOV     R1, #0x00
                STR     R1, [R0]            ; Clear first location
                
                MOV     R1, #0xDEADBEEF
                STR     R1, [R0, #4]        ; Test pattern at offset 4
                
                MOV     R1, #0x12345678
                STR     R1, [R0, #8]        ; Test pattern at offset 8
                
                BX      LR
                ENDP

; Timer Interrupt Handler
Timer_IRQHandler PROC
                EXPORT  Timer_IRQHandler
                
                ; Save context
                PUSH    {R0-R3, LR}
                
                ; Step 1: Turn on all LEDs (write 0xFF)
                LDR     R0, =LED_DATA_REG
                MOV     R1, #0xFF
                STR     R1, [R0]
                
                ; Step 2: Write test pattern to RAM first location
                LDR     R0, =RAM_BASE
                MOV     R1, #0x55AA55AA
                STR     R1, [R0]
                
                ; Step 3: Software delay
                MOV     R2, #5000           ; Delay counter
delay_loop      
                SUBS    R2, R2, #1
                BNE     delay_loop
                
                ; Step 4: Turn off all LEDs (write 0x00)
                LDR     R0, =LED_DATA_REG
                MOV     R1, #0x00
                STR     R1, [R0]
                
                ; Step 5: Clear RAM first location
                LDR     R0, =RAM_BASE
                MOV     R1, #0x00
                STR     R1, [R0]
                
                ; Step 6: Clear timer interrupt
                LDR     R0, =TIMER_CLEAR_REG
                MOV     R1, #0x01
                STR     R1, [R0]
                
                ; Restore context and return
                POP     {R0-R3, PC}
                ENDP

; Main Application Loop
main            PROC
                EXPORT  main
                
main_loop       
                ; Main application tasks
                BL      check_system_status
                
                ; Wait for interrupt
                WFI
                
                ; Continue main loop
                B       main_loop
                ENDP

; Check system status
check_system_status PROC
                ; Read timer status
                LDR     R0, =TIMER_STATUS_REG
                LDR     R1, [R0]
                
                ; Read LED status
                LDR     R0, =LED_DATA_REG
                LDR     R2, [R0]
                
                ; Read RAM first location
                LDR     R0, =RAM_BASE
                LDR     R3, [R0]
                
                ; Status values are now in R1, R2, R3
                ; Can be used for debugging or further processing
                
                BX      LR
                ENDP

; LED Control Functions
LED_On          PROC
                EXPORT  LED_On
                LDR     R0, =LED_DATA_REG
                MOV     R1, #0xFF
                STR     R1, [R0]
                BX      LR
                ENDP

LED_Off         PROC
                EXPORT  LED_Off
                LDR     R0, =LED_DATA_REG
                MOV     R1, #0x00
                STR     R1, [R0]
                BX      LR
                ENDP

LED_Pattern     PROC
                EXPORT  LED_Pattern
                ; R0 contains the pattern to write
                LDR     R1, =LED_DATA_REG
                STR     R0, [R1]
                BX      LR
                ENDP

; Memory Test Functions
Memory_Write    PROC
                EXPORT  Memory_Write
                ; R0 = address offset from RAM_BASE
                ; R1 = data to write
                LDR     R2, =RAM_BASE
                STR     R1, [R2, R0]
                BX      LR
                ENDP

Memory_Read     PROC
                EXPORT  Memory_Read
                ; R0 = address offset from RAM_BASE
                ; Returns data in R0
                LDR     R1, =RAM_BASE
                LDR     R0, [R1, R0]
                BX      LR
                ENDP

; Default Exception Handlers
NMI_Handler     PROC
                EXPORT  NMI_Handler         [WEAK]
                B       .
                ENDP

HardFault_Handler PROC
                EXPORT  HardFault_Handler   [WEAK]
                B       .
                ENDP

SVC_Handler     PROC
                EXPORT  SVC_Handler         [WEAK]
                B       .
                ENDP

PendSV_Handler  PROC
                EXPORT  PendSV_Handler      [WEAK]
                B       .
                ENDP

SysTick_Handler PROC
                EXPORT  SysTick_Handler     [WEAK]
                B       .
                ENDP

GPIO_IRQHandler PROC
                EXPORT  GPIO_IRQHandler     [WEAK]
                B       .
                ENDP

; System Initialization (weak definition)
SystemInit      PROC
                EXPORT  SystemInit          [WEAK]
                BX      LR
                ENDP

                ALIGN
                END
