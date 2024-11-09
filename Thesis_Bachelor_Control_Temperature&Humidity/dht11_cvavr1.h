#ifndef __DHT11_H
#define __DHT11_H

#include <mega8.h> // tuy xem chip la gi thi chinh o day
#include <delay.h>

#pragma used+

// khai bao chan ket noi voi DHT11
#define         DHT_DATA_IN       PINB.0  
#define         DHT_DATA_OUT      PORTB.0 
#define         DHT_DDR_DATA      DDRB.0   

#define DDROUT        1
#define DDRIN        0
#define DHT_ER       0
#define DHT_OK       1

unsigned char DHT_GetTemHumi (unsigned char *tem,unsigned char *humi);
#pragma used-

#pragma library dht11_cvavr1.lib

#endif
