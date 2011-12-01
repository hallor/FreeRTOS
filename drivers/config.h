#ifndef CONFIG_H
#define CONFIG_H
// Config for compatibility with lpccodebase - copy-paste algorithm
#include <stdint.h>
#include <stdbool.h>

typedef volatile uint8_t REG8;
typedef volatile uint16_t REG16;
typedef volatile uint32_t REG32;
typedef unsigned char byte_t;

#define pREG8  (REG8 *)
#define pREG16 (REG16 *)
#define pREG32 (REG32 *)

#include <lpc134x.h>

#endif
