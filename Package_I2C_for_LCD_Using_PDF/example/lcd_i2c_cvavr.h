
/*ditulis oleh kang chaerul anam
*kunjungi web nya di www.anakkendali.com
* November 2018
*/



#ifndef _LCD_I2C_CVAVR_INCLUDED_
#define _LCD_I2C_CVAVR_INCLUDED_


#define SETBUSS 0x10
#define CONTROLCURSOR 0x80
#define LCD_CLEAR 0x01

#include <stdint.h>



#pragma used+


void i2c_begin (void);
unsigned char i2c_send_start (void);
void i2c_send_stop (void);

unsigned char i2c_send_add_rw (unsigned char address, unsigned char rw);
unsigned char i2c_send_byte (unsigned char byte);
unsigned char i2c_read_byte (void);
unsigned char i2c_get_inputs (unsigned char address);
void i2c_set_outputs (unsigned char address, unsigned char byte);

void lcd_send_cmd (char cmd);
void lcd_putchar (char data);
void lcd_begin (uint8_t address, uint8_t col, uint8_t row);
void lcd_clear(void);
void lcd_gotoxy (uint8_t col, uint8_t row);
void lcd_puts (char *str);

#pragma used-

#pragma library lcd_i2c_cvavr.lib

#endif