#include <FreeRTOS.h>
#include "LPC13xx.h"
#include "core_cm3.h"
#include "system_LPC13xx.h"
#include <task.h>

void vParTestToggleLED( unsigned portBASE_TYPE uxLED )
{
  while(1)
  {
    __NOP();
  }
}

void vTask1(void * params)
{
  volatile uint32_t * d = (void*)0x50023FFC;
  while(1)
  {
    *d = (*d & ~0x2) | ( *d ^ 0x2 );
    vTaskDelay(500/portTICK_RATE_MS);
  }
}

void vTask2(void * params)
{
  volatile uint32_t * d = (void*)0x50023FFC;
  int ul;
  while(1)
  {
    for( ul = 0; ul < 0xfffff; ul++ )
    {
    }
    *d = (*d & ~0x4) | (*d ^ 0x4 );
//    vTaskDelay(900/portTICK_RATE_MS);
  }
}

int main(void)
{
  *((uint32_t *)(0x10000054)) = 0x0;

  SystemInit();
  SystemCoreClockUpdate();


  LPC_GPIO2->DIR |= (0x1 << 1);
  LPC_GPIO2->DIR |= (0x1 << 2);
  volatile uint32_t * d = (void*)0x50023FFC;
  *d = 0;
  *d |= (0x1 << 1);
//  *d |= (0x1 << 2);
//  LPC_GPIO2->DATA

//  xTaskCreate(vTask1, "Foo", 50, NULL, tskIDLE_PRIORITY, NULL);
//  xTaskCreate(vTask2, "Foo", 50, NULL, tskIDLE_PRIORITY, NULL);

//  vTaskStartScheduler();

  int i;
    while (1)
    {
      vTask2(NULL);
      for( i = 0; i < 0xfffff; i++ )
      {
      }
        __NOP();
    }
}
