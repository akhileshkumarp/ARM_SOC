/**
 * @file     system_cortexm0.h
 * @brief    CMSIS Device System Header File for
 *           ARM Cortex M0 SoC Project
 * @version  V1.0.0
 * @date     01. August 2025
 *
 * NIELIT Workshop - Mini Project
 */

#ifndef SYSTEM_CORTEXM0_H
#define SYSTEM_CORTEXM0_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

extern uint32_t SystemCoreClock;     /*!< System Clock Frequency (Core Clock)  */

/**
 * Initialize the system
 *
 * @param  none
 * @return none
 *
 * @brief  Setup the microcontroller system.
 *         Initialize the System and update the SystemCoreClock variable.
 */
extern void SystemInit (void);

/**
 * Update SystemCoreClock variable
 *
 * @param  none
 * @return none
 *
 * @brief  Updates the SystemCoreClock with current core Clock 
 *         retrieved from cpu registers.
 */
extern void SystemCoreClockUpdate (void);

/* Memory Map */
#define TIMER_BASE          (0x40000000UL)    /*!< Timer Base Address */
#define LED_BASE            (0x40010000UL)    /*!< LED/GPIO Base Address */
#define RAM_BASE            (0x20000000UL)    /*!< RAM Base Address */

/* Timer Peripheral Registers */
#define TIMER_DATA_REG      (*(volatile uint32_t *)(TIMER_BASE + 0x00))
#define TIMER_CONTROL_REG   (*(volatile uint32_t *)(TIMER_BASE + 0x04))
#define TIMER_STATUS_REG    (*(volatile uint32_t *)(TIMER_BASE + 0x08))
#define TIMER_CLEAR_REG     (*(volatile uint32_t *)(TIMER_BASE + 0x0C))

/* LED/GPIO Peripheral Registers */
#define LED_DATA_REG        (*(volatile uint32_t *)(LED_BASE + 0x00))
#define LED_DIR_REG         (*(volatile uint32_t *)(LED_BASE + 0x04))
#define LED_INPUT_REG       (*(volatile uint32_t *)(LED_BASE + 0x08))

/* Function Prototypes from Assembly */
extern void SoC_Init(void);
extern void LED_On(void);
extern void LED_Off(void);
extern void LED_Pattern(uint32_t pattern);
extern void Memory_Write(uint32_t offset, uint32_t data);
extern uint32_t Memory_Read(uint32_t offset);

#ifdef __cplusplus
}
#endif

#endif /* SYSTEM_CORTEXM0_H */
