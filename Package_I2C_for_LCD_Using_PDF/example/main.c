#include <mega32.h>
#include <lcd_i2c_cvavr.h>
#include <delay.h>
#include <stdio.h>

#define S0 PORTD.4
#define S1 PORTD.5
#define S2 PORTD.6
#define S3 PORTD.7
// Declare your global variables here
unsigned int count=0;
bit ok=0;
unsigned long int R, G, B;
int colors[3][6];

void initColor()
{
colors[0][0] = 26;//Min R 14
colors[0][1] = 28;//Max R 18
colors[0][2] = 18;//Min G 17
colors[0][3] = 21;//Max G 23
colors[0][4] = 26;//Min B 27
colors[0][5] = 28;//Max B 32
//---------------------------
colors[1][0] = 78;//R
colors[1][1] = 81;
colors[1][2] = 70;///G
colors[1][3] = 73;
colors[1][4] = 78;//B
colors[1][5] = 100;
//---------------------------
colors[2][0] = 50;//R
colors[2][1] = 55;
colors[2][2] = 30;///G
colors[2][3] = 48;
colors[2][4] = 58;//B
colors[2][5] = 62;
}



// External Interrupt 0 service routine

void red_select(void)
{
    S2=0;
    S3=0;
}
void green_select(void)
{
    S2=1;
    S3=1;
}
void blue_select(void)
{
    S2=0;
    S3=1;
}

interrupt [EXT_INT0] void ext_int0_isr(void)
{
    if(ok==1){count++;}
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    ok=0;
}

unsigned long int do_f(void)
{
    unsigned  int f;   
    unsigned int temp; 

    ok=1;    
    TCNT0=0x44;
    TIMSK=0x01;
    TCCR0=0x03; 
    GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2);   
    count=0;
    while(ok==1);
    TIMSK=0x00;
    TCCR0=0x00; 
    GICR|=(0<<INT1) | (0<<INT0) | (0<<INT2);  
    temp=count;
    f =(unsigned int)temp;
    return f;
}

int read_color(void)
{
    int i,j;
    R=0;  
    G=0; 
    B=0; 
    for (j=0;j<5;j++)
    {
        red_select();
        R += do_f();
        delay_ms(10);     
        green_select();
        G += do_f();
        delay_ms(10);
        blue_select();
        B += do_f();
        delay_ms(10);
    }    
    R=R/5;
    G=G/5;
    G=G/5;
    for(i=0; i< 3; i++){
        if(R >= colors[i][0] && R <= colors[i][1] &&
        G >= colors[i][2] && G <= colors[i][3] &&
        B >= colors[i][4] && B <= colors[i][5])
        {
            return i;
        }  
    } 
    return 5;
}


void main(void)
{
// Declare your local variables here
char str[16];
int color;
// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 187.500 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
// Timer Period: 1.0027 ms
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
TCNT0=0x44;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: Off
// INT2: Off
GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2);
MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(0<<INTF1) | (1<<INTF0) | (0<<INTF2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

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
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

S0=1;
S1=1;
initColor();
// Global enable interrupts
#asm("sei")
lcd_begin(0x27,16,2);
while (1)
      {
        color = read_color();
        sprintf(str,"R:%2d G:%2d B:%2d  ",R,G,B);
        lcd_gotoxy(0,0);
        lcd_puts(str);
        lcd_gotoxy(0,1);
        switch(color)
        {
            case 0: 
            {        
                sprintf(str,"    Mau den     ");
                lcd_puts(str);
                break;
            }  
            case 1: 
            {     
                sprintf(str,"  Mau xanh la   ");
                lcd_puts(str);
                break;
            }
            case 2: 
            {    
                sprintf(str,"    Mau do      ");
                lcd_puts(str);
                break;
            }  
            case 5:
            {       
                sprintf(str," Khong xac dinh ");
                lcd_puts(str);
                break;                
            }
        } 
            delay_ms(1000); 
      }
}