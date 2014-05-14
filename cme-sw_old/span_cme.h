#ifndef _VGA_LED_H
#define _VGA_LED_H

#include <linux/ioctl.h>
//#include <stdio.h>
//#include <unistd.h>
#define VGA_LED_DIGITS 8
#define DATA_LENGTH 29

typedef struct {
  //unsigned char digit;    /* 0, 1, .. , VGA_LED_DIGITS - 1 */
  //unsigned char segments; /* LSB is segment a, MSB is decimal point */
	short input[DATA_LENGTH];
	short output;
  //  int16_t data[DATA_LENGTH];
} vga_led_arg_t;



#define VGA_LED_MAGIC 'q'

/* ioctls and their arguments */
#define VGA_LED_WRITE_DIGIT _IOW(VGA_LED_MAGIC, 1, vga_led_arg_t *)
#define VGA_LED_READ_DIGIT  _IOWR(VGA_LED_MAGIC, 2, vga_led_arg_t *)

#endif
