; ARM Cortex M0 Assembly Code Example
; NIELIT Workshop - Mini Project
; Timer Interrupt Service Routine

; Memory-mapped peripheral addresses
TIMER_BASE      EQU     0x40000000
TIMER_CLEAR     EQU     0x40000004
LED_BASE        EQU     0x40010000  
RAM_BASE        EQU     0x20000000

                AREA    |.text|, CODE, READONLY
                THUMB
                
; Vector Table
                DCD     0x20001000          ; Initial Stack Pointer
                DCD     Reset_Handler       ; Reset Handler
                DCD     0                   ; NMI Handler
                DCD     0                   ; Hard Fault Handler
                SPACE   (16-4)*4           ; Reserved
                DCD     Timer_IRQHandler    ; Timer IRQ Handler

; Reset Handler
Reset_Handler   PROC
                EXPORT  Reset_Handler
                
                ; Initialize system
                BL      SystemInit
                
                ; Main program loop
main_loop       
                WFI                         ; Wait for interrupt
                B       main_loop
                
                ENDP

; System Initialization
SystemInit      PROC
                ; Initialize timer (auto-enabled in hardware)
                ; Initialize LED GPIO (auto-configured)
                ; Enable interrupts
                CPSIE   I                   ; Enable interrupts globally
                BX      LR
                ENDP

; Timer Interrupt Handler
Timer_IRQHandler PROC
                EXPORT  Timer_IRQHandler
                
                ; Save context
                PUSH    {R0-R3, LR}
                
                ; Step 1: Write 0xFF to LED
                LDR     R0, =LED_BASE
                MOV     R1, #0xFF
                STR     R1, [R0]
                
                ; Step 2: Write 0x55 to RAM first location
                LDR     R0, =RAM_BASE  
                MOV     R1, #0x55
                STR     R1, [R0]
                
                ; Step 3: Small delay
                MOV     R2, #10000         ; Delay counter
delay_loop      
                SUBS    R2, R2, #1
                BNE     delay_loop
                
                ; Step 4: Clear LED (write 0x00)
                LDR     R0, =LED_BASE
                MOV     R1, #0x00
                STR     R1, [R0]
                
                ; Step 5: Write 0x00 to RAM first location
                LDR     R0, =RAM_BASE
                MOV     R1, #0x00
                STR     R1, [R0]
                
                ; Step 6: Clear timer interrupt
                LDR     R0, =TIMER_CLEAR
                MOV     R1, #0x01
                STR     R1, [R0]
                
                ; Restore context and return
                POP     {R0-R3, PC}
                
                ENDP

; Main Application Code (C-callable)
                EXPORT  main
main            PROC
                
                ; Application-specific initialization
                BL      app_init
                
                ; Main application loop
app_loop        
                ; Application tasks can be added here
                ; System will respond to timer interrupts automatically
                
                ; Check for other events
                BL      process_events
                
                ; Continue loop
                B       app_loop
                
                ENDP

; Application initialization
app_init        PROC
                ; Add any application-specific initialization here
                ; GPIO configuration, peripheral setup, etc.
                BX      LR
                ENDP

; Process other system events
process_events  PROC
                ; Add event processing code here
                ; Handle user inputs, communication, etc.
                BX      LR
                ENDP

                ALIGN
                END

; Example C code integration:
;
; extern void main(void);
; extern void SystemInit(void);
;
; int main(void) {
;     SystemInit();
;     
;     while(1) {
;         // Main application code
;         // Timer interrupt will handle LED and RAM operations
;         __WFI(); // Wait for interrupt
;     }
; }
;
; // Timer interrupt handler (if using C)
; void Timer_IRQHandler(void) {
;     // Write 0xFF to LED
;     *(volatile uint32_t*)0x40010000 = 0xFF;
;     
;     // Write 0x55 to RAM
;     *(volatile uint32_t*)0x20000000 = 0x55;
;     
;     // Delay
;     for(volatile int i = 0; i < 10000; i++);
;     
;     // Clear LED
;     *(volatile uint32_t*)0x40010000 = 0x00;
;     
;     // Clear RAM
;     *(volatile uint32_t*)0x20000000 = 0x00;
;     
;     // Clear interrupt
;     *(volatile uint32_t*)0x40000004 = 0x01;
; }
