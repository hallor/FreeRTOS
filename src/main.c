#include <lpc134x.h>

unsigned int SystemCoreClock=12000000;

static inline void __NOP(void)
{
  asm volatile ("nop");
}


int main(void)
{
  while (1)
  {
    __NOP();
  }
}
