#/*
#    FreeRTOS V7.0.2 - Copyright (C) 2011 Real Time Engineers Ltd.
#	
#
#    ***************************************************************************
#     *                                                                       *
#     *    FreeRTOS tutorial books are available in pdf and paperback.        *
#     *    Complete, revised, and edited pdf reference manuals are also       *
#     *    available.                                                         *
#     *                                                                       *
#     *    Purchasing FreeRTOS documentation will not only help you, by       *
#     *    ensuring you get running as quickly as possible and with an        *
#     *    in-depth knowledge of how to use FreeRTOS, it will also help       *
#     *    the FreeRTOS project to continue with its mission of providing     *
#     *    professional grade, cross platform, de facto standard solutions    *
#     *    for microcontrollers - completely free of charge!                  *
#     *                                                                       *
#     *    >>> See http://www.FreeRTOS.org/Documentation for details. <<<     *
#     *                                                                       *
#     *    Thank you for using FreeRTOS, and thank you for your support!      *
#     *                                                                       *
#    ***************************************************************************
#
#
#    This file is part of the FreeRTOS distribution.
#
#    FreeRTOS is free software; you can redistribute it and/or modify it under
#    the terms of the GNU General Public License (version 2) as published by the
#    Free Software Foundation AND MODIFIED BY the FreeRTOS exception.
#    >>>NOTE<<< The modification to the GPL is included to allow you to
#    distribute a combined work that includes FreeRTOS without being obliged to
#    provide the source code for proprietary components outside of the FreeRTOS
#    kernel.  FreeRTOS is distributed in the hope that it will be useful, but
#    WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
#    or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#    more details. You should have received a copy of the GNU General Public
#    License and the FreeRTOS license exception along with FreeRTOS; if not it
#    can be viewed here: http://www.freertos.org/a00114.html and also obtained
#    by writing to Richard Barry, contact details for whom are available on the
#    FreeRTOS WEB site.
#
#    1 tab == 4 spaces!
#
#    http://www.FreeRTOS.org - Documentation, latest information, license and
#    contact details.
#
#    http://www.SafeRTOS.com - A version that is certified for use in safety
#    critical systems.
#
#    http://www.OpenRTOS.com - Commercial support, development, porting,
#    licensing and training services.
#*/
OPTIM=-O2
LDSCRIPT=memory.ld

CROSS_COMPILE=arm-none-eabi-

CC=$(CROSS_COMPILE)gcc
OBJCOPY=$(CROSS_COMPILE)objcopy
ARCH=$(CROSS_COMPILE)ar
LPCRC=lpcrc/lpcrc

TARGET=cortex-m3

WARNINGS=-Wall -Wextra -Wshadow -Wpointer-arith -Wbad-function-cast -Wcast-align -Wsign-compare \
		-Waggregate-return -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wunused

#
# CFLAGS common to both the THUMB and ARM mode builds
#
CFLAGS=$(WARNINGS) -D__NEWLIB__  $(DEBUG) -mcpu=$(TARGET) -T$(LDSCRIPT) \
		 $(OPTIM) -fomit-frame-pointer -fno-strict-aliasing -mthumb \
		 -Isrc -Ikernel/include -Ikernel/portable/GCC/ARM_CM3 -Idrivers


LINKER_FLAGS=-Xlinker -ortos.elf -Xlinker -M -Xlinker -Map=rtos.map

# Applications
SRC := src/main.c

# Kernel
SRC += kernel/croutine.c kernel/list.c kernel/queue.c kernel/tasks.c kernel/timers.c
SRC += kernel/portable/MemMang/heap_1.c # Malloc
SRC += kernel/portable/GCC/ARM_CM3/port.c # core support

# Drivers
SRC +=

# Boot files
SRC += boot/irqv.c boot/startup.c

OBJ = $(SRC:.c=.o)

all: rtos.bin

program: all
	mdel -i /dev/disk/by-id/usb-NXP_LPC134X_IFLASH_ISP000000000-0\:0 ::/firmware.bin
	mcopy -i /dev/disk/by-id/usb-NXP_LPC134X_IFLASH_ISP000000000-0\:0 rtosdemo.bin ::/
	eject /dev/disk/by-id/usb-NXP_LPC134X_IFLASH_ISP000000000-0\:0

rtos.bin : rtos.elf crc
	$(OBJCOPY) rtos.elf -O binary rtos.bin
	$(LPCRC) rtos.bin

crc: $(LPCRC)
	make -C lpcrc

rtos.elf : $(OBJ) Makefile
	$(CC) $(CFLAGS) $(OBJ) -nostartfiles $(LINKER_FLAGS)

$(ARM_OBJ) : %.o : %.c $(LDSCRIPT) Makefile
	$(CC) -c $(CFLAGS) $< -o $@

clean :
	rm -rf $(OBJ) rtos.bin rtos.elf rtos.map









	


