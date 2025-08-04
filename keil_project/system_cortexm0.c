/**
 * @file     system_cortexm0.c
 * @brief    CMSIS Device System Source File for
 *           ARM Cortex M0 SoC Project
 * @version  V1.0.0
 * @date     01. August 2025
 *
 * NIELIT Workshop - Mini Project
 */

#include <stdint.h>

/*----------------------------------------------------------------------------
  Define clocks
 *----------------------------------------------------------------------------*/
#define __HSI             (16000000UL)    /* High Speed Internal Clock */
#define __SYSTEM_CLOCK    (__HSI)

/*----------------------------------------------------------------------------
  System Core Clock Variable
 *----------------------------------------------------------------------------*/
uint32_t SystemCoreClock = __SYSTEM_CLOCK;

/*----------------------------------------------------------------------------
  Clock functions
 *----------------------------------------------------------------------------*/
void SystemCoreClockUpdate (void)            /* Get Core Clock Frequency      */
{
  SystemCoreClock = __SYSTEM_CLOCK;
}

/**
 * Initialize the system
 *
 * @param  none
 * @return none
 *
 * @brief  Setup the microcontroller system.
 *         Initialize the System and update the SystemCoreClock variable.
 */
void SystemInit (void)
{
  SystemCoreClock = __SYSTEM_CLOCK;
  
  /* Configure system for our SoC */
  /* Add any additional system initialization here */
}
