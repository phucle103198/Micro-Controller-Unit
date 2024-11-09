/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 26/08/2020
Author  : 
Company : 
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega8.h>
#include <alcd.h>
#include <delay.h>
#include <math.h>
#include <stdlib.h>
#include <dht11_cvavr1.h>

#define nn_mode PIND.4
#define nn_up PIND.3
#define nn_down PIND.2

// Standard Input/Output functions
#include <stdio.h>

bit nn_trung_gian_up=0,nn_trung_gian_down=0,nn_trung_gian_mode=0;
bit up_danhan=0,down_danhan=0,mode_danhan=0;
int tocdo=0;
char str[20];
unsigned char I_RH, I_TEMP;
unsigned char i_timer_2=0;
char state=1;
float fuzzy_temp_lanh=0,fuzzy_temp_vua=0,fuzzy_temp_nong=0,fuzzy_am=0,fuzzy_thuong=0,fuzzy_kho=0;
char heso[3][3];
char hesothuc[3][3]={{0,10,30},{25,50,75},{50,75,100}};
char hang[3];
char cot[3];
char c;
char Data[16];
char index=0;
char ok=0;
// Standard Input/Output functions
#include <stdio.h>

//--------------------------------------------------------------//


void mode_button(void)
{
    if(nn_mode==0&&nn_trung_gian_mode==0)
    {nn_trung_gian_mode=1;delay_ms(10);}     
    if(nn_mode==1&&nn_trung_gian_mode==1)
    {        
        nn_trung_gian_mode=0;
        mode_danhan=1;
        if(mode_danhan==1&&state==1)
        {   
            lcd_clear();
            state=2;
            mode_danhan=0;
        }    
        if(mode_danhan==1&&state==2)
        {    
            lcd_clear();
            state=3;
            mode_danhan=0;
        }   
        if(mode_danhan==1&&state==3)
        {    
            lcd_clear();
            state=1;
            mode_danhan=0;
        } 
    }
}

void up_button(void)
{
    if(nn_up==0&&nn_trung_gian_up==0)
    {nn_trung_gian_up=1;delay_ms(10);}     
    if(nn_up==1&&nn_trung_gian_up==1)
    {        
        nn_trung_gian_up=0;
        up_danhan=1;
        if(up_danhan==1&&state==1)
        {
            tocdo=tocdo+10;
            if(tocdo>100)
            {
                tocdo=100;
            } 
            up_danhan=0;
        }      
    }
}

void down_button(void)
{
    if(nn_down==0&&nn_trung_gian_down==0)
    {nn_trung_gian_down=1;delay_ms(10);}     
    if(nn_down==1&&nn_trung_gian_down==1)
    {        
        nn_trung_gian_down=0;
        down_danhan=1;
        if(down_danhan==1&&state==1)
        {
            tocdo=tocdo-10; 
            if(tocdo<0)
            {
                tocdo=0;
            }
            down_danhan=0;
        }   
    }
}


//--------------------------------------------------------------//
void lanh(void)
{
  if (I_TEMP < 15){fuzzy_temp_lanh = 1;}
  else if (I_TEMP >= 15 && I_TEMP <= 20){fuzzy_temp_lanh =((float)20-(float)I_TEMP)/(float)5;}
  else if (I_TEMP > 20){fuzzy_temp_lanh = 0;}
}
 
void vua (void)
{
  if (I_TEMP < 15){fuzzy_temp_vua = 0;}
  else if (I_TEMP >= 15 && I_TEMP < 20){fuzzy_temp_vua = ((float)I_TEMP-(float)15)/(float)5;}  
  else if (I_TEMP >= 20 && I_TEMP <= 25){fuzzy_temp_vua = ((float)25-(float)I_TEMP)/(float)5;}
  else if (I_TEMP > 25){fuzzy_temp_vua = 0;}
}
 
void nong (void)
{
  if (I_TEMP > 25){fuzzy_temp_nong = 1;}
  else if (I_TEMP >= 20 && I_TEMP <= 25){fuzzy_temp_nong = ((float)I_TEMP-25)/(float)5;}
  else if (I_TEMP < 20){fuzzy_temp_nong = 0;}
}

void kho(void)
{
  if (I_RH < 60){fuzzy_kho = 1;}
  else if (I_RH >= 60 && I_RH <= 70){fuzzy_kho = ((float)70-(float)I_RH)/(float)10;}
  else if (I_RH > 70){fuzzy_kho = 0;}
}
 
void thuong(void)
{
  if (I_RH < 60){fuzzy_thuong = 0;}
  else if (I_RH >= 60 && I_RH < 70){fuzzy_thuong = ((float)I_RH-(float)60)/(float)10;}  
  else if (I_RH >= 70 && I_RH <= 80){fuzzy_thuong = ((float)80-(float)I_RH)/(float)10;}
  else if (I_RH > 80){fuzzy_thuong = 0;}
}
 
void am(void)
{
  if (I_RH > 80){fuzzy_am = 1;}
  else if (I_RH >= 70 && I_RH <= 80){fuzzy_am = ((float)I_RH-(float)70)/(float)10;}
  else if (I_RH < 70){fuzzy_am = 0;}
}

void normal(void)
{
    if(fuzzy_temp_lanh==0){cot[0]=0;} 
    if(fuzzy_temp_lanh!=0){cot[0]=1;} 
    
    if(fuzzy_temp_vua==0){cot[1]=0;} 
    if(fuzzy_temp_vua!=0){cot[1]=1;}
    
    if(fuzzy_temp_nong==0){cot[2]=0;} 
    if(fuzzy_temp_nong!=0){cot[2]=1;}
    
    if(fuzzy_am==0){hang[0]=0;} 
    if(fuzzy_am!=0){hang[0]=1;}
    
    if(fuzzy_thuong==0){hang[1]=0;} 
    if(fuzzy_thuong!=0){hang[1]=1;}
    
    if(fuzzy_kho==0){hang[2]=0;} 
    if(fuzzy_kho!=0){hang[2]=1;}
}


void setup(void)
{
    char i1,j1;
    for(i1=0;i1<3;i1++)
    {   
        for(j1=0;j1<3;j1++)
        {
            heso[i1][j1]=hang[i1]+cot[j1];            
        }
    }  
    
}

float min_max(float a,float b)
{
    if(a==1&b==0)
    {
        return 0;
    }    
    if(b==1&a==0)
    {
        return 0;
    }
    else if(a>0&&b>0)
    {
        if(a<=b)
        {
            return a;
        }
        else
        {
            return b;
        }
    }   
    else if(a>0&&b==0)
    {
        return a;
    }  
    else if(b>0&&a==0)
    {
        return b;
    }   
    else if(b==0&&a==0)
    {
        return 0;
    } 
    
    
}

void tu_dong(void)
{
    float a=0,b=0,c=0;
    char temp[3];
    char t; 
    char i1,j1;
    float tocdo1;
    a= (float)min_max(fuzzy_temp_lanh,fuzzy_am);
    b= (float)min_max(fuzzy_temp_vua,fuzzy_thuong);   
    c= (float)min_max(fuzzy_temp_nong,fuzzy_kho);  
    t=0; 
    for(i1=0;i1<3;i1++)
    {   
        for(j1=0;j1<3;j1++)
        {   
            if(heso[i1][j1]==2)
            {   
                temp[t]= hesothuc[i1][j1] ;
                t++;
            }    
        }
    }  
    if(t==1)
    {
        tocdo1=(float)temp[0];
    }
    else if(t==2)
    {
        if(a==0&&b!=0&&c!=0)
        {
            tocdo1= (float)((float)b*(float)temp[0]+(float)c*(float)temp[1])/(float)((float)b+(float)c);
        }  
        if(b==0&&a!=0&&c!=0)
        {
            tocdo1= (float)((float)a*(float)temp[0]+(float)c*(float)temp[1])/(float)((float)a+(float)c);
        }
        if(c==0&&a!=0&&b!=0)
        {
            tocdo1= (float)((float)a*(float)temp[0]+(float)b*(float)temp[1])/(float)((float)a+(float)b);
        }    
    }
    else if(t==3)
    {
        if(c!=0&&a!=0&&b!=0)
        {
            tocdo1= (float)((float)temp[0]*(float)a+(float)temp[1]*(float)b+(float)temp[2]*(float)c)/(float)((float)a+(float)b+(float)c); 
        }    
    }   
    
    tocdo = floor(tocdo1);
}

void xu_ly_fuzzy(void)
{
    lanh();
    nong();
    vua();
    am();
    thuong();
    kho();  
    normal();
    setup();
    tu_dong();   
}
//------------------------------------------------//
// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
    c=UDR;
    if(c!='.')
    {
        Data[index]=c;
        index++;
        if(index>=16)
        {
            index=0;
        }
    }
    else
    {
       ok=1;
    }
}

void xu_ly_chuoi()
{
    char i=0;
    if(ok==1)
    {
        for(i=0;i<16;i++)
        {
            if(Data[i]=='1')
            { 
                nn_trung_gian_up=1;    
            }   
            else if(Data[i]=='2')
            { 
                nn_trung_gian_down=1;    
            } 
            else if(Data[i]=='4')
            { 
                state=1;    
            }  
            else if(Data[i]=='5')
            { 
                state=2;    
            }  
            else if(Data[i]=='9')
            { 
                state=3;    
            }
        }
        for(i=0;i<16;i++)
        {
            Data[i]='\0';
        }
        index=0;
        ok=0;
    }
}

void send_to_app(void)
{
    if(state==2)
    {
        sprintf(str,"T= %2doC   H= %2d%%",I_TEMP,I_RH);
        lcd_gotoxy(0,0);
        lcd_puts(str);        
        xu_ly_fuzzy(); 
        if(tocdo<0)
            {tocdo=0;}
        sprintf(str,"Toc do : %3d",tocdo);
        lcd_gotoxy(0,1);
        lcd_puts(str); 
        lcd_puts("%");
    }
    sprintf(str,"%2d;%2d;%2d;",I_TEMP,I_RH,tocdo);
    puts(str);    
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)     //10ms
{
    TCNT0=0xB2;
    up_button();
    down_button();
    mode_button();
    i_timer_2++; 
   
    if(i_timer_2>49)
    {
        DHT_GetTemHumi(&I_TEMP,&I_RH); 
        send_to_app();
        i_timer_2=0;
    }       
}

// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)     //10ms
{
    // Reinitialize Timer2 value
    TCNT2=0xB2;
}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (1<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 7.813 kHz
TCCR0=(1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0xB2;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 125.000 kHz
// Mode: Fast PWM top=ICR1
// OC1A output: Inverted PWM
// OC1B output: Inverted PWM
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 0.1 s
// Output Pulse(s):
// OC1A Period: 0.1 s Width: 0 us
// OC1B Period: 0.1 s Width: 0 us
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(1<<COM1A1) | (1<<COM1A0) | (1<<COM1B1) | (1<<COM1B0) | (1<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (1<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x30;   //12500
ICR1L=0xD3;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;


// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 7.813 kHz
// Mode: Normal top=0xFF
// OC2 output: Disconnected
// Timer Period: 9.984 ms
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (1<<CS22) | (1<<CS21) | (1<<CS20);
TCNT2=0xB2;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 5
// RD - PORTD Bit 7
// EN - PORTC Bit 4
// D4 - PORTC Bit 3
// D5 - PORTC Bit 2
// D6 - PORTC Bit 1
// D7 - PORTC Bit 0
// Characters/line: 16
lcd_init(16);
lcd_puts("DO AN TOT NGHIEP");
delay_ms(1000);
// Global enable interrupts
#asm("sei")

while (1)
      {                    
        OCR1A=OCR1B=tocdo*125; 
        switch (state)
        {
            case 1: //thu cong
            {   
                lcd_gotoxy(0,0);
                lcd_puts("Che do thu cong ");
                sprintf(str,"Toc do : %3d%%    ",tocdo);
                lcd_gotoxy(0,1);
                lcd_puts(str); 
                lcd_puts("%");
                break;
            } 
            
            case 2: // tu dong
            {   

                break;
            }    
            
            case 3:
            {   
                lcd_gotoxy(0,0);
                lcd_puts("     Stop       "); 
                lcd_gotoxy(0,1);
                lcd_puts("                ");
                tocdo=0;
                break;    
            }
        } 
        xu_ly_chuoi();
      }
}
