#include <cpu.h>
#include <gpio.h>
#include <lpc134x.h>
#include <FreeRTOS.h>
#include <task.h>

unsigned int SystemCoreClock=12000000;

static inline void __NOP(void)
{
  asm volatile ("nop");
}


int main(void)
{
  cpuInit();
  gpioInit();

  int i=0;
  for (i=0; i<4; ++i)
  {
    gpioSetDir(2, i, gpioDirection_Output);
    gpioSetValue(2, i, 0);
  }

  gpioSetValue(2,1,1);

  vTaskStartScheduler();


  // This code should never be reached
  gpioSetValue(2,2,1);
  while (1)
  {
    __NOP();
  }
}
