
  ******************************************************************************
  * Chu Y        :   Phai dinh nghia cac chan su dung cho DHT11 vao file main.h
  *                Vi Du:
                                PIC       AVR       8051
#define         DHT_DATA_IN     PINB0     PINB.0    P2_0
#define         DHT_DATA_OUT    PORTB0    PORTB.0   P2_0
               Voi PIC va AVR can dinh nghia them huong du lieu.
                                PIC       AVR       8051
#define         DHT_DDR_DATA    DDRB0     DDRB.0    P2_0              
  ******************************************************************************
**/

/*********************************** VI DU ************************************
    uint8_t dht_nhiet_do,dht_do_am,dht_Ok;
    dht_Ok = DHT_GetTemHumi(&dht_nhiet_do,&dht_do_am);
*******************************************************************************/
#include "dht11_cvavr1.h"

 /*******************************************************************************
Noi Dung    :   MCU gui yeu cau chuyen doi den DHT11.
Tham Bien   :   Khong.
Tra Ve      :   Khong.
********************************************************************************/
unsigned char DHT_GetTemHumi (unsigned char *tem,unsigned char *humi)
{
    unsigned char buffer[5]={0,0,0,0,0};
    unsigned char ii,i,checksum;
	
    DHT_DDR_DATA=DDROUT;   // set la cong ra
    DHT_DATA_OUT=1;
    delay_us(60);
    DHT_DATA_OUT=0;
    delay_ms(25); // it nhat 18ms
    DHT_DATA_OUT=1;
    DHT_DDR_DATA=DDRIN;
    delay_us(60);
    if(DHT_DATA_IN)return DHT_ER ;
    else while(!(DHT_DATA_IN));	//Doi DaTa len 1
    delay_us(60);
    if(!DHT_DATA_IN)return DHT_ER;
    else while((DHT_DATA_IN));	 //Doi Data ve 0
    //Bat dau doc du lieu
    for(i=0;i<5;i++)
    {
        for(ii=0;ii<8;ii++)
        {	
        while((!DHT_DATA_IN));//Doi Data len 1
        delay_us(50);
        if(DHT_DATA_IN)
            {
            buffer[i]|=(1<<(7-ii));
            while((DHT_DATA_IN));//Doi Data xuong 0
            }
        }
    }
	//Tinh toan check sum
    checksum=buffer[0]+buffer[1]+buffer[2]+buffer[3];
	//Kiem tra check sum
    if((checksum)!=buffer[4])return DHT_ER;
	//Lay du lieu
    *tem  =   buffer[2];
    *humi =   buffer[0];
    return DHT_OK;
}
/******************************KET THUC FILE******************************

