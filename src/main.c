#include <cpu.h>
#include <gpio.h>
#include <lpc134x.h>
#include <FreeRTOS.h>
#include <task.h>

static void panic(void)
{
  int i;
  gpioSetValue(2,4,1);
  for (;;) {}
}


static portTASK_FUNCTION(leduj, pvParameters)
{
  while(1)
  {
    vTaskDelay(1000/portTICK_RATE_MS);
    gpioSetValue(2, 3, 1);
    vTaskDelay(1000/portTICK_RATE_MS);
    gpioSetValue(2, 3, 0);
  }
}

static portTASK_FUNCTION(leduj2, pvParameters)
{
  while(1)
  {
    vTaskDelay(600/portTICK_RATE_MS);
    gpioSetValue(2, 2, 1);
    vTaskDelay(600/portTICK_RATE_MS);
    gpioSetValue(2, 2, 0);
  }
}


int main(void)
{
  cpuInit();

  int i=0;
  for (i=1; i<5; ++i)
  {
    gpioSetDir(2, i, gpioDirection_Output);
    gpioSetValue(2, i, 0);
  }

  gpioSetValue(2,1,1); // System started

  xTaskCreate(leduj, "LEDx", configMINIMAL_STACK_SIZE, NULL, 1, NULL);
  gpioSetValue(2,1,1); // System started
  xTaskCreate(leduj2, "LEDy", configMINIMAL_STACK_SIZE, NULL, 1, NULL);

  vTaskStartScheduler();

  // This code should never be reached
  panic();
}
