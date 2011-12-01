#include <FreeRTOS.h>
static inline void __NOP(void)
{ asm volatile ("nop"); }
int main(void)
{
    while (1)
    {
        __NOP();
    }
}
