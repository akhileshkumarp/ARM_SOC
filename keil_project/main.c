/**
 * @file     main.c
 * @brief    Main application file for ARM Cortex M0 SoC Project
 * @version  V1.0.0
 * @date     01. August 2025
 *
 * NIELIT Workshop - Mini Project
 * This file works in conjunction with main.s (assembly code)
 */

#include "system_cortexm0.h"

/**
 * @brief  Main function
 * @param  None
 * @retval int
 */
int main(void)
{
    /* System initialization is handled in assembly startup */
    /* SoC_Init() is called from Reset_Handler in main.s */
    
    /* Main application loop */
    while (1)
    {
        /* The main application logic is handled in assembly */
        /* Timer interrupt will automatically handle LED and RAM operations */
        
        /* You can add C code here for additional functionality */
        
        /* Wait for interrupt (assembly function will handle this) */
        __WFI();
    }
}

/**
 * @brief  System Clock Configuration
 * @param  None
 * @retval None
 */
void SystemClock_Config(void)
{
    /* System clock is configured in assembly startup */
    /* Clock frequency is set to 16MHz (HSI) */
}

/**
 * @brief  Application-specific initialization
 * @param  None
 * @retval None
 */
void app_init(void)
{
    /* This function is called from assembly code */
    /* Add any C-based initialization here */
}

/**
 * @brief  Process system events
 * @param  None
 * @retval None
 */
void process_events(void)
{
    /* This function is called from assembly code */
    /* Add event processing logic here */
}

/**
 * @brief  Example function to test LED control from C
 * @param  None
 * @retval None
 */
void test_led_sequence(void)
{
    /* Turn on all LEDs */
    LED_On();
    
    /* Small delay */
    for (volatile int i = 0; i < 100000; i++);
    
    /* Turn off all LEDs */
    LED_Off();
    
    /* Test patterns */
    LED_Pattern(0x55);  /* Alternating pattern */
    for (volatile int i = 0; i < 100000; i++);
    
    LED_Pattern(0xAA);  /* Opposite alternating pattern */
    for (volatile int i = 0; i < 100000; i++);
    
    LED_Off();
}

/**
 * @brief  Example function to test memory operations from C
 * @param  None
 * @retval None
 */
void test_memory_operations(void)
{
    uint32_t test_data = 0x12345678;
    uint32_t read_data;
    
    /* Write test data to RAM */
    Memory_Write(0x10, test_data);  /* Write to offset 0x10 */
    
    /* Read back the data */
    read_data = Memory_Read(0x10);
    
    /* Verify data integrity */
    if (read_data == test_data)
    {
        /* Memory test passed - flash LEDs twice */
        for (int i = 0; i < 2; i++)
        {
            LED_On();
            for (volatile int j = 0; j < 50000; j++);
            LED_Off();
            for (volatile int j = 0; j < 50000; j++);
        }
    }
}

/* Error handler */
void Error_Handler(void)
{
    /* User can add their own implementation to report the HAL error return state */
    while(1)
    {
        /* Flash LEDs rapidly to indicate error */
        LED_Pattern(0xFF);
        for (volatile int i = 0; i < 10000; i++);
        LED_Pattern(0x00);
        for (volatile int i = 0; i < 10000; i++);
    }
}
