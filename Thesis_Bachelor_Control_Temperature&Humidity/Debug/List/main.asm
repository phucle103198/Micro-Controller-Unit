
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _tocdo=R4
	.DEF _tocdo_msb=R5
	.DEF _I_RH=R7
	.DEF _I_TEMP=R6
	.DEF _i_timer_2=R9
	.DEF _state=R8
	.DEF _c=R11
	.DEF _index=R10
	.DEF _ok=R13
	.DEF __lcd_x=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G104:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G104:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x1,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x0,0xA,0x1E,0x19,0x32,0x4B,0x32,0x4B
	.DB  0x64
_0x7F:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
_0x0:
	.DB  0x54,0x3D,0x20,0x25,0x32,0x64,0x6F,0x43
	.DB  0x20,0x20,0x20,0x48,0x3D,0x20,0x25,0x32
	.DB  0x64,0x25,0x25,0x0,0x54,0x6F,0x63,0x20
	.DB  0x64,0x6F,0x20,0x3A,0x20,0x25,0x33,0x64
	.DB  0x0,0x25,0x32,0x64,0x3B,0x25,0x32,0x64
	.DB  0x3B,0x25,0x32,0x64,0x3B,0x0,0x44,0x4F
	.DB  0x20,0x41,0x4E,0x20,0x54,0x4F,0x54,0x20
	.DB  0x4E,0x47,0x48,0x49,0x45,0x50,0x0,0x43
	.DB  0x68,0x65,0x20,0x64,0x6F,0x20,0x74,0x68
	.DB  0x75,0x20,0x63,0x6F,0x6E,0x67,0x20,0x0
	.DB  0x54,0x6F,0x63,0x20,0x64,0x6F,0x20,0x3A
	.DB  0x20,0x25,0x33,0x64,0x25,0x25,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x53,0x74,0x6F,0x70,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x09
	.DW  _hesothuc
	.DW  _0x3*2

	.DW  0x02
	.DW  _0xAD
	.DW  _0x0*2+18

	.DW  0x11
	.DW  _0xAF
	.DW  _0x0*2+46

	.DW  0x11
	.DW  _0xAF+17
	.DW  _0x0*2+63

	.DW  0x02
	.DW  _0xAF+34
	.DW  _0x0*2+18

	.DW  0x11
	.DW  _0xAF+36
	.DW  _0x0*2+99

	.DW  0x11
	.DW  _0xAF+53
	.DW  _0x0*2+116

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 26/08/2020
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <delay.h>
;#include <math.h>
;#include <stdlib.h>
;#include <dht11_cvavr1.h>
;
;#define nn_mode PIND.4
;#define nn_up PIND.3
;#define nn_down PIND.2
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;bit nn_trung_gian_up=0,nn_trung_gian_down=0,nn_trung_gian_mode=0;
;bit up_danhan=0,down_danhan=0,mode_danhan=0;
;int tocdo=0;
;char str[20];
;unsigned char I_RH, I_TEMP;
;unsigned char i_timer_2=0;
;char state=1;
;float fuzzy_temp_lanh=0,fuzzy_temp_vua=0,fuzzy_temp_nong=0,fuzzy_am=0,fuzzy_thuong=0,fuzzy_kho=0;
;char heso[3][3];
;char hesothuc[3][3]={{0,10,30},{25,50,75},{50,75,100}};

	.DSEG
;char hang[3];
;char cot[3];
;char c;
;char Data[16];
;char index=0;
;char ok=0;
;// Standard Input/Output functions
;#include <stdio.h>
;
;//--------------------------------------------------------------//
;
;
;void mode_button(void)
; 0000 003D {

	.CSEG
_mode_button:
; .FSTART _mode_button
; 0000 003E     if(nn_mode==0&&nn_trung_gian_mode==0)
	SBIC 0x10,4
	RJMP _0x5
	SBRS R2,2
	RJMP _0x6
_0x5:
	RJMP _0x4
_0x6:
; 0000 003F     {nn_trung_gian_mode=1;delay_ms(10);}
	SET
	BLD  R2,2
	RCALL SUBOPT_0x0
; 0000 0040     if(nn_mode==1&&nn_trung_gian_mode==1)
_0x4:
	SBIS 0x10,4
	RJMP _0x8
	SBRC R2,2
	RJMP _0x9
_0x8:
	RJMP _0x7
_0x9:
; 0000 0041     {
; 0000 0042         nn_trung_gian_mode=0;
	CLT
	BLD  R2,2
; 0000 0043         mode_danhan=1;
	SET
	BLD  R2,5
; 0000 0044         if(mode_danhan==1&&state==1)
	SBRS R2,5
	RJMP _0xB
	LDI  R30,LOW(1)
	CP   R30,R8
	BREQ _0xC
_0xB:
	RJMP _0xA
_0xC:
; 0000 0045         {
; 0000 0046             lcd_clear();
	RCALL _lcd_clear
; 0000 0047             state=2;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x1
; 0000 0048             mode_danhan=0;
; 0000 0049         }
; 0000 004A         if(mode_danhan==1&&state==2)
_0xA:
	SBRS R2,5
	RJMP _0xE
	LDI  R30,LOW(2)
	CP   R30,R8
	BREQ _0xF
_0xE:
	RJMP _0xD
_0xF:
; 0000 004B         {
; 0000 004C             lcd_clear();
	RCALL _lcd_clear
; 0000 004D             state=3;
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x1
; 0000 004E             mode_danhan=0;
; 0000 004F         }
; 0000 0050         if(mode_danhan==1&&state==3)
_0xD:
	SBRS R2,5
	RJMP _0x11
	LDI  R30,LOW(3)
	CP   R30,R8
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
; 0000 0051         {
; 0000 0052             lcd_clear();
	RCALL _lcd_clear
; 0000 0053             state=1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1
; 0000 0054             mode_danhan=0;
; 0000 0055         }
; 0000 0056     }
_0x10:
; 0000 0057 }
_0x7:
	RET
; .FEND
;
;void up_button(void)
; 0000 005A {
_up_button:
; .FSTART _up_button
; 0000 005B     if(nn_up==0&&nn_trung_gian_up==0)
	SBIC 0x10,3
	RJMP _0x14
	SBRS R2,0
	RJMP _0x15
_0x14:
	RJMP _0x13
_0x15:
; 0000 005C     {nn_trung_gian_up=1;delay_ms(10);}
	SET
	BLD  R2,0
	RCALL SUBOPT_0x0
; 0000 005D     if(nn_up==1&&nn_trung_gian_up==1)
_0x13:
	SBIS 0x10,3
	RJMP _0x17
	SBRC R2,0
	RJMP _0x18
_0x17:
	RJMP _0x16
_0x18:
; 0000 005E     {
; 0000 005F         nn_trung_gian_up=0;
	CLT
	BLD  R2,0
; 0000 0060         up_danhan=1;
	SET
	BLD  R2,3
; 0000 0061         if(up_danhan==1&&state==1)
	SBRS R2,3
	RJMP _0x1A
	LDI  R30,LOW(1)
	CP   R30,R8
	BREQ _0x1B
_0x1A:
	RJMP _0x19
_0x1B:
; 0000 0062         {
; 0000 0063             tocdo=tocdo+10;
	MOVW R30,R4
	ADIW R30,10
	MOVW R4,R30
; 0000 0064             if(tocdo>100)
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x1C
; 0000 0065             {
; 0000 0066                 tocdo=100;
	MOVW R4,R30
; 0000 0067             }
; 0000 0068             up_danhan=0;
_0x1C:
	CLT
	BLD  R2,3
; 0000 0069         }
; 0000 006A     }
_0x19:
; 0000 006B }
_0x16:
	RET
; .FEND
;
;void down_button(void)
; 0000 006E {
_down_button:
; .FSTART _down_button
; 0000 006F     if(nn_down==0&&nn_trung_gian_down==0)
	SBIC 0x10,2
	RJMP _0x1E
	SBRS R2,1
	RJMP _0x1F
_0x1E:
	RJMP _0x1D
_0x1F:
; 0000 0070     {nn_trung_gian_down=1;delay_ms(10);}
	SET
	BLD  R2,1
	RCALL SUBOPT_0x0
; 0000 0071     if(nn_down==1&&nn_trung_gian_down==1)
_0x1D:
	SBIS 0x10,2
	RJMP _0x21
	SBRC R2,1
	RJMP _0x22
_0x21:
	RJMP _0x20
_0x22:
; 0000 0072     {
; 0000 0073         nn_trung_gian_down=0;
	CLT
	BLD  R2,1
; 0000 0074         down_danhan=1;
	SET
	BLD  R2,4
; 0000 0075         if(down_danhan==1&&state==1)
	SBRS R2,4
	RJMP _0x24
	LDI  R30,LOW(1)
	CP   R30,R8
	BREQ _0x25
_0x24:
	RJMP _0x23
_0x25:
; 0000 0076         {
; 0000 0077             tocdo=tocdo-10;
	MOVW R30,R4
	SBIW R30,10
	MOVW R4,R30
; 0000 0078             if(tocdo<0)
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRGE _0x26
; 0000 0079             {
; 0000 007A                 tocdo=0;
	CLR  R4
	CLR  R5
; 0000 007B             }
; 0000 007C             down_danhan=0;
_0x26:
	CLT
	BLD  R2,4
; 0000 007D         }
; 0000 007E     }
_0x23:
; 0000 007F }
_0x20:
	RET
; .FEND
;
;
;//--------------------------------------------------------------//
;void lanh(void)
; 0000 0084 {
_lanh:
; .FSTART _lanh
; 0000 0085   if (I_TEMP < 15){fuzzy_temp_lanh = 1;}
	RCALL SUBOPT_0x2
	BRSH _0x27
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
; 0000 0086   else if (I_TEMP >= 15 && I_TEMP <= 20){fuzzy_temp_lanh =((float)20-(float)I_TEMP)/(float)5;}
	RJMP _0x28
_0x27:
	RCALL SUBOPT_0x2
	BRLO _0x2A
	LDI  R30,LOW(20)
	CP   R30,R6
	BRSH _0x2B
_0x2A:
	RJMP _0x29
_0x2B:
	RCALL SUBOPT_0x5
	__GETD2N 0x41A00000
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x4
; 0000 0087   else if (I_TEMP > 20){fuzzy_temp_lanh = 0;}
	RJMP _0x2C
_0x29:
	LDI  R30,LOW(20)
	CP   R30,R6
	BRSH _0x2D
	LDI  R30,LOW(0)
	STS  _fuzzy_temp_lanh,R30
	STS  _fuzzy_temp_lanh+1,R30
	STS  _fuzzy_temp_lanh+2,R30
	STS  _fuzzy_temp_lanh+3,R30
; 0000 0088 }
_0x2D:
_0x2C:
_0x28:
	RET
; .FEND
;
;void vua (void)
; 0000 008B {
_vua:
; .FSTART _vua
; 0000 008C   if (I_TEMP < 15){fuzzy_temp_vua = 0;}
	RCALL SUBOPT_0x2
	BRLO _0xBA
; 0000 008D   else if (I_TEMP >= 15 && I_TEMP < 20){fuzzy_temp_vua = ((float)I_TEMP-(float)15)/(float)5;}
	RCALL SUBOPT_0x2
	BRLO _0x31
	RCALL SUBOPT_0x7
	BRLO _0x32
_0x31:
	RJMP _0x30
_0x32:
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x8
	__GETD1N 0x41700000
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x9
; 0000 008E   else if (I_TEMP >= 20 && I_TEMP <= 25){fuzzy_temp_vua = ((float)25-(float)I_TEMP)/(float)5;}
	RJMP _0x33
_0x30:
	RCALL SUBOPT_0x7
	BRLO _0x35
	RCALL SUBOPT_0xA
	BRSH _0x36
_0x35:
	RJMP _0x34
_0x36:
	RCALL SUBOPT_0x5
	__GETD2N 0x41C80000
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x9
; 0000 008F   else if (I_TEMP > 25){fuzzy_temp_vua = 0;}
	RJMP _0x37
_0x34:
	RCALL SUBOPT_0xA
	BRSH _0x38
_0xBA:
	LDI  R30,LOW(0)
	STS  _fuzzy_temp_vua,R30
	STS  _fuzzy_temp_vua+1,R30
	STS  _fuzzy_temp_vua+2,R30
	STS  _fuzzy_temp_vua+3,R30
; 0000 0090 }
_0x38:
_0x37:
_0x33:
	RET
; .FEND
;
;void nong (void)
; 0000 0093 {
_nong:
; .FSTART _nong
; 0000 0094   if (I_TEMP > 25){fuzzy_temp_nong = 1;}
	RCALL SUBOPT_0xA
	BRSH _0x39
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xB
; 0000 0095   else if (I_TEMP >= 20 && I_TEMP <= 25){fuzzy_temp_nong = ((float)I_TEMP-25)/(float)5;}
	RJMP _0x3A
_0x39:
	RCALL SUBOPT_0x7
	BRLO _0x3C
	RCALL SUBOPT_0xA
	BRSH _0x3D
_0x3C:
	RJMP _0x3B
_0x3D:
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x8
	__GETD1N 0x41C80000
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xB
; 0000 0096   else if (I_TEMP < 20){fuzzy_temp_nong = 0;}
	RJMP _0x3E
_0x3B:
	RCALL SUBOPT_0x7
	BRSH _0x3F
	LDI  R30,LOW(0)
	STS  _fuzzy_temp_nong,R30
	STS  _fuzzy_temp_nong+1,R30
	STS  _fuzzy_temp_nong+2,R30
	STS  _fuzzy_temp_nong+3,R30
; 0000 0097 }
_0x3F:
_0x3E:
_0x3A:
	RET
; .FEND
;
;void kho(void)
; 0000 009A {
_kho:
; .FSTART _kho
; 0000 009B   if (I_RH < 60){fuzzy_kho = 1;}
	RCALL SUBOPT_0xC
	BRSH _0x40
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xD
; 0000 009C   else if (I_RH >= 60 && I_RH <= 70){fuzzy_kho = ((float)70-(float)I_RH)/(float)10;}
	RJMP _0x41
_0x40:
	RCALL SUBOPT_0xC
	BRLO _0x43
	LDI  R30,LOW(70)
	CP   R30,R7
	BRSH _0x44
_0x43:
	RJMP _0x42
_0x44:
	RCALL SUBOPT_0xE
	__GETD2N 0x428C0000
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xD
; 0000 009D   else if (I_RH > 70){fuzzy_kho = 0;}
	RJMP _0x45
_0x42:
	LDI  R30,LOW(70)
	CP   R30,R7
	BRSH _0x46
	LDI  R30,LOW(0)
	STS  _fuzzy_kho,R30
	STS  _fuzzy_kho+1,R30
	STS  _fuzzy_kho+2,R30
	STS  _fuzzy_kho+3,R30
; 0000 009E }
_0x46:
_0x45:
_0x41:
	RET
; .FEND
;
;void thuong(void)
; 0000 00A1 {
_thuong:
; .FSTART _thuong
; 0000 00A2   if (I_RH < 60){fuzzy_thuong = 0;}
	RCALL SUBOPT_0xC
	BRLO _0xBB
; 0000 00A3   else if (I_RH >= 60 && I_RH < 70){fuzzy_thuong = ((float)I_RH-(float)60)/(float)10;}
	RCALL SUBOPT_0xC
	BRLO _0x4A
	RCALL SUBOPT_0x10
	BRLO _0x4B
_0x4A:
	RJMP _0x49
_0x4B:
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x8
	__GETD1N 0x42700000
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x11
; 0000 00A4   else if (I_RH >= 70 && I_RH <= 80){fuzzy_thuong = ((float)80-(float)I_RH)/(float)10;}
	RJMP _0x4C
_0x49:
	RCALL SUBOPT_0x10
	BRLO _0x4E
	RCALL SUBOPT_0x12
	BRSH _0x4F
_0x4E:
	RJMP _0x4D
_0x4F:
	RCALL SUBOPT_0xE
	__GETD2N 0x42A00000
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x11
; 0000 00A5   else if (I_RH > 80){fuzzy_thuong = 0;}
	RJMP _0x50
_0x4D:
	RCALL SUBOPT_0x12
	BRSH _0x51
_0xBB:
	LDI  R30,LOW(0)
	STS  _fuzzy_thuong,R30
	STS  _fuzzy_thuong+1,R30
	STS  _fuzzy_thuong+2,R30
	STS  _fuzzy_thuong+3,R30
; 0000 00A6 }
_0x51:
_0x50:
_0x4C:
	RET
; .FEND
;
;void am(void)
; 0000 00A9 {
_am:
; .FSTART _am
; 0000 00AA   if (I_RH > 80){fuzzy_am = 1;}
	RCALL SUBOPT_0x12
	BRSH _0x52
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x13
; 0000 00AB   else if (I_RH >= 70 && I_RH <= 80){fuzzy_am = ((float)I_RH-(float)70)/(float)10;}
	RJMP _0x53
_0x52:
	RCALL SUBOPT_0x10
	BRLO _0x55
	RCALL SUBOPT_0x12
	BRSH _0x56
_0x55:
	RJMP _0x54
_0x56:
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x8
	__GETD1N 0x428C0000
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x13
; 0000 00AC   else if (I_RH < 70){fuzzy_am = 0;}
	RJMP _0x57
_0x54:
	RCALL SUBOPT_0x10
	BRSH _0x58
	LDI  R30,LOW(0)
	STS  _fuzzy_am,R30
	STS  _fuzzy_am+1,R30
	STS  _fuzzy_am+2,R30
	STS  _fuzzy_am+3,R30
; 0000 00AD }
_0x58:
_0x57:
_0x53:
	RET
; .FEND
;
;void normal(void)
; 0000 00B0 {
_normal:
; .FSTART _normal
; 0000 00B1     if(fuzzy_temp_lanh==0){cot[0]=0;}
	RCALL SUBOPT_0x14
	BRNE _0x59
	LDI  R30,LOW(0)
	STS  _cot,R30
; 0000 00B2     if(fuzzy_temp_lanh!=0){cot[0]=1;}
_0x59:
	RCALL SUBOPT_0x14
	BREQ _0x5A
	LDI  R30,LOW(1)
	STS  _cot,R30
; 0000 00B3 
; 0000 00B4     if(fuzzy_temp_vua==0){cot[1]=0;}
_0x5A:
	RCALL SUBOPT_0x15
	BRNE _0x5B
	LDI  R30,LOW(0)
	__PUTB1MN _cot,1
; 0000 00B5     if(fuzzy_temp_vua!=0){cot[1]=1;}
_0x5B:
	RCALL SUBOPT_0x15
	BREQ _0x5C
	LDI  R30,LOW(1)
	__PUTB1MN _cot,1
; 0000 00B6 
; 0000 00B7     if(fuzzy_temp_nong==0){cot[2]=0;}
_0x5C:
	RCALL SUBOPT_0x16
	BRNE _0x5D
	LDI  R30,LOW(0)
	__PUTB1MN _cot,2
; 0000 00B8     if(fuzzy_temp_nong!=0){cot[2]=1;}
_0x5D:
	RCALL SUBOPT_0x16
	BREQ _0x5E
	LDI  R30,LOW(1)
	__PUTB1MN _cot,2
; 0000 00B9 
; 0000 00BA     if(fuzzy_am==0){hang[0]=0;}
_0x5E:
	RCALL SUBOPT_0x17
	BRNE _0x5F
	LDI  R30,LOW(0)
	STS  _hang,R30
; 0000 00BB     if(fuzzy_am!=0){hang[0]=1;}
_0x5F:
	RCALL SUBOPT_0x17
	BREQ _0x60
	LDI  R30,LOW(1)
	STS  _hang,R30
; 0000 00BC 
; 0000 00BD     if(fuzzy_thuong==0){hang[1]=0;}
_0x60:
	RCALL SUBOPT_0x18
	BRNE _0x61
	LDI  R30,LOW(0)
	__PUTB1MN _hang,1
; 0000 00BE     if(fuzzy_thuong!=0){hang[1]=1;}
_0x61:
	RCALL SUBOPT_0x18
	BREQ _0x62
	LDI  R30,LOW(1)
	__PUTB1MN _hang,1
; 0000 00BF 
; 0000 00C0     if(fuzzy_kho==0){hang[2]=0;}
_0x62:
	RCALL SUBOPT_0x19
	BRNE _0x63
	LDI  R30,LOW(0)
	__PUTB1MN _hang,2
; 0000 00C1     if(fuzzy_kho!=0){hang[2]=1;}
_0x63:
	RCALL SUBOPT_0x19
	BREQ _0x64
	LDI  R30,LOW(1)
	__PUTB1MN _hang,2
; 0000 00C2 }
_0x64:
	RET
; .FEND
;
;
;void setup(void)
; 0000 00C6 {
_setup:
; .FSTART _setup
; 0000 00C7     char i1,j1;
; 0000 00C8     for(i1=0;i1<3;i1++)
	RCALL __SAVELOCR2
;	i1 -> R17
;	j1 -> R16
	LDI  R17,LOW(0)
_0x66:
	CPI  R17,3
	BRSH _0x67
; 0000 00C9     {
; 0000 00CA         for(j1=0;j1<3;j1++)
	LDI  R16,LOW(0)
_0x69:
	CPI  R16,3
	BRSH _0x6A
; 0000 00CB         {
; 0000 00CC             heso[i1][j1]=hang[i1]+cot[j1];
	LDI  R26,LOW(3)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_heso)
	SBCI R31,HIGH(-_heso)
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	RCALL SUBOPT_0x1A
	SUBI R30,LOW(-_hang)
	SBCI R31,HIGH(-_hang)
	LD   R26,Z
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_cot)
	SBCI R31,HIGH(-_cot)
	LD   R30,Z
	ADD  R30,R26
	MOVW R26,R0
	ST   X,R30
; 0000 00CD         }
	SUBI R16,-1
	RJMP _0x69
_0x6A:
; 0000 00CE     }
	SUBI R17,-1
	RJMP _0x66
_0x67:
; 0000 00CF 
; 0000 00D0 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;float min_max(float a,float b)
; 0000 00D3 {
_min_max:
; .FSTART _min_max
; 0000 00D4     if(a==1&b==0)
	RCALL __PUTPARD2
;	a -> Y+4
;	b -> Y+0
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x3
	RCALL __EQD12
	MOV  R0,R30
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	RCALL __EQD12
	AND  R30,R0
	BREQ _0x6B
; 0000 00D5     {
; 0000 00D6         return 0;
	RCALL SUBOPT_0x1D
	RJMP _0x20E0006
; 0000 00D7     }
; 0000 00D8     if(b==1&a==0)
_0x6B:
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x3
	RCALL __EQD12
	MOV  R0,R30
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1D
	RCALL __EQD12
	AND  R30,R0
	BREQ _0x6C
; 0000 00D9     {
; 0000 00DA         return 0;
	RCALL SUBOPT_0x1D
	RJMP _0x20E0006
; 0000 00DB     }
; 0000 00DC     else if(a>0&&b>0)
_0x6C:
	RCALL SUBOPT_0x1E
	BRGE _0x6F
	RCALL SUBOPT_0x1F
	BRLT _0x70
_0x6F:
	RJMP _0x6E
_0x70:
; 0000 00DD     {
; 0000 00DE         if(a<=b)
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x1B
	RCALL __CMPF12
	BREQ PC+3
	BRCS PC+2
	RJMP _0x71
; 0000 00DF         {
; 0000 00E0             return a;
	RCALL SUBOPT_0x21
	RJMP _0x20E0006
; 0000 00E1         }
; 0000 00E2         else
_0x71:
; 0000 00E3         {
; 0000 00E4             return b;
	RCALL SUBOPT_0x20
	RJMP _0x20E0006
; 0000 00E5         }
; 0000 00E6     }
; 0000 00E7     else if(a>0&&b==0)
_0x6E:
	RCALL SUBOPT_0x1E
	BRGE _0x75
	RCALL SUBOPT_0x1F
	BREQ _0x76
_0x75:
	RJMP _0x74
_0x76:
; 0000 00E8     {
; 0000 00E9         return a;
	RCALL SUBOPT_0x21
	RJMP _0x20E0006
; 0000 00EA     }
; 0000 00EB     else if(b>0&&a==0)
_0x74:
	RCALL SUBOPT_0x1F
	BRGE _0x79
	RCALL SUBOPT_0x1E
	BREQ _0x7A
_0x79:
	RJMP _0x78
_0x7A:
; 0000 00EC     {
; 0000 00ED         return b;
	RCALL SUBOPT_0x20
	RJMP _0x20E0006
; 0000 00EE     }
; 0000 00EF     else if(b==0&&a==0)
_0x78:
	RCALL SUBOPT_0x1F
	BRNE _0x7D
	RCALL SUBOPT_0x1E
	BREQ _0x7E
_0x7D:
	RJMP _0x7C
_0x7E:
; 0000 00F0     {
; 0000 00F1         return 0;
	RCALL SUBOPT_0x1D
; 0000 00F2     }
; 0000 00F3 
; 0000 00F4 
; 0000 00F5 }
_0x7C:
_0x20E0006:
	ADIW R28,8
	RET
; .FEND
;
;void tu_dong(void)
; 0000 00F8 {
_tu_dong:
; .FSTART _tu_dong
; 0000 00F9     float a=0,b=0,c=0;
; 0000 00FA     char temp[3];
; 0000 00FB     char t;
; 0000 00FC     char i1,j1;
; 0000 00FD     float tocdo1;
; 0000 00FE     a= (float)min_max(fuzzy_temp_lanh,fuzzy_am);
	SBIW R28,19
	LDI  R24,12
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	LDI  R30,LOW(_0x7F*2)
	LDI  R31,HIGH(_0x7F*2)
	RCALL __INITLOCB
	RCALL __SAVELOCR4
;	a -> Y+19
;	b -> Y+15
;	c -> Y+11
;	temp -> Y+8
;	t -> R17
;	i1 -> R16
;	j1 -> R19
;	tocdo1 -> Y+4
	LDS  R30,_fuzzy_temp_lanh
	LDS  R31,_fuzzy_temp_lanh+1
	LDS  R22,_fuzzy_temp_lanh+2
	LDS  R23,_fuzzy_temp_lanh+3
	RCALL __PUTPARD1
	LDS  R26,_fuzzy_am
	LDS  R27,_fuzzy_am+1
	LDS  R24,_fuzzy_am+2
	LDS  R25,_fuzzy_am+3
	RCALL _min_max
	__PUTD1S 19
; 0000 00FF     b= (float)min_max(fuzzy_temp_vua,fuzzy_thuong);
	LDS  R30,_fuzzy_temp_vua
	LDS  R31,_fuzzy_temp_vua+1
	LDS  R22,_fuzzy_temp_vua+2
	LDS  R23,_fuzzy_temp_vua+3
	RCALL __PUTPARD1
	LDS  R26,_fuzzy_thuong
	LDS  R27,_fuzzy_thuong+1
	LDS  R24,_fuzzy_thuong+2
	LDS  R25,_fuzzy_thuong+3
	RCALL _min_max
	__PUTD1S 15
; 0000 0100     c= (float)min_max(fuzzy_temp_nong,fuzzy_kho);
	LDS  R30,_fuzzy_temp_nong
	LDS  R31,_fuzzy_temp_nong+1
	LDS  R22,_fuzzy_temp_nong+2
	LDS  R23,_fuzzy_temp_nong+3
	RCALL __PUTPARD1
	LDS  R26,_fuzzy_kho
	LDS  R27,_fuzzy_kho+1
	LDS  R24,_fuzzy_kho+2
	LDS  R25,_fuzzy_kho+3
	RCALL _min_max
	__PUTD1S 11
; 0000 0101     t=0;
	LDI  R17,LOW(0)
; 0000 0102     for(i1=0;i1<3;i1++)
	LDI  R16,LOW(0)
_0x81:
	CPI  R16,3
	BRSH _0x82
; 0000 0103     {
; 0000 0104         for(j1=0;j1<3;j1++)
	LDI  R19,LOW(0)
_0x84:
	CPI  R19,3
	BRSH _0x85
; 0000 0105         {
; 0000 0106             if(heso[i1][j1]==2)
	LDI  R26,LOW(3)
	MUL  R16,R26
	MOVW R30,R0
	SUBI R30,LOW(-_heso)
	SBCI R31,HIGH(-_heso)
	RCALL SUBOPT_0x22
	LD   R26,X
	CPI  R26,LOW(0x2)
	BRNE _0x86
; 0000 0107             {
; 0000 0108                 temp[t]= hesothuc[i1][j1] ;
	RCALL SUBOPT_0x1A
	MOVW R26,R28
	ADIW R26,8
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LDI  R26,LOW(3)
	MUL  R16,R26
	MOVW R30,R0
	SUBI R30,LOW(-_hesothuc)
	SBCI R31,HIGH(-_hesothuc)
	RCALL SUBOPT_0x22
	LD   R30,X
	MOVW R26,R22
	ST   X,R30
; 0000 0109                 t++;
	SUBI R17,-1
; 0000 010A             }
; 0000 010B         }
_0x86:
	SUBI R19,-1
	RJMP _0x84
_0x85:
; 0000 010C     }
	SUBI R16,-1
	RJMP _0x81
_0x82:
; 0000 010D     if(t==1)
	CPI  R17,1
	BRNE _0x87
; 0000 010E     {
; 0000 010F         tocdo1=(float)temp[0];
	RCALL SUBOPT_0x23
	RJMP _0xBC
; 0000 0110     }
; 0000 0111     else if(t==2)
_0x87:
	CPI  R17,2
	BREQ PC+2
	RJMP _0x89
; 0000 0112     {
; 0000 0113         if(a==0&&b!=0&&c!=0)
	RCALL SUBOPT_0x24
	BRNE _0x8B
	RCALL SUBOPT_0x25
	RCALL __CPD02
	BREQ _0x8B
	RCALL SUBOPT_0x26
	RCALL __CPD02
	BRNE _0x8C
_0x8B:
	RJMP _0x8A
_0x8C:
; 0000 0114         {
; 0000 0115             tocdo1= (float)((float)b*(float)temp[0]+(float)c*(float)temp[1])/(float)((float)b+(float)c);
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x25
	RCALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x27
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x25
	RCALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0x29
; 0000 0116         }
; 0000 0117         if(b==0&&a!=0&&c!=0)
_0x8A:
	RCALL SUBOPT_0x25
	RCALL __CPD02
	BRNE _0x8E
	RCALL SUBOPT_0x24
	BREQ _0x8E
	RCALL SUBOPT_0x26
	RCALL __CPD02
	BRNE _0x8F
_0x8E:
	RJMP _0x8D
_0x8F:
; 0000 0118         {
; 0000 0119             tocdo1= (float)((float)a*(float)temp[0]+(float)c*(float)temp[1])/(float)((float)a+(float)c);
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x2A
	RCALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x27
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x2A
	RCALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0x29
; 0000 011A         }
; 0000 011B         if(c==0&&a!=0&&b!=0)
_0x8D:
	RCALL SUBOPT_0x26
	RCALL __CPD02
	BRNE _0x91
	RCALL SUBOPT_0x24
	BREQ _0x91
	RCALL SUBOPT_0x25
	RCALL __CPD02
	BRNE _0x92
_0x91:
	RJMP _0x90
_0x92:
; 0000 011C         {
; 0000 011D             tocdo1= (float)((float)a*(float)temp[0]+(float)b*(float)temp[1])/(float)((float)a+(float)b);
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x2A
	RCALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x2B
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x2C
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0x29
; 0000 011E         }
; 0000 011F     }
_0x90:
; 0000 0120     else if(t==3)
	RJMP _0x93
_0x89:
	CPI  R17,3
	BRNE _0x94
; 0000 0121     {
; 0000 0122         if(c!=0&&a!=0&&b!=0)
	RCALL SUBOPT_0x26
	RCALL __CPD02
	BREQ _0x96
	RCALL SUBOPT_0x24
	BREQ _0x96
	RCALL SUBOPT_0x25
	RCALL __CPD02
	BRNE _0x97
_0x96:
	RJMP _0x95
_0x97:
; 0000 0123         {
; 0000 0124             tocdo1= (float)((float)temp[0]*(float)a+(float)temp[1]*(float)b+(float)temp[2]*(float)c)/(float)((float)a+(f ...
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x2A
	RCALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x2B
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+10
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RCALL SUBOPT_0x26
	RCALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x26
	RCALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
_0xBC:
	__PUTD1S 4
; 0000 0125         }
; 0000 0126     }
_0x95:
; 0000 0127 
; 0000 0128     tocdo = floor(tocdo1);
_0x94:
_0x93:
	RCALL SUBOPT_0x1B
	RCALL _floor
	RCALL __CFD1
	MOVW R4,R30
; 0000 0129 }
	RCALL __LOADLOCR4
	ADIW R28,23
	RET
; .FEND
;
;void xu_ly_fuzzy(void)
; 0000 012C {
_xu_ly_fuzzy:
; .FSTART _xu_ly_fuzzy
; 0000 012D     lanh();
	RCALL _lanh
; 0000 012E     nong();
	RCALL _nong
; 0000 012F     vua();
	RCALL _vua
; 0000 0130     am();
	RCALL _am
; 0000 0131     thuong();
	RCALL _thuong
; 0000 0132     kho();
	RCALL _kho
; 0000 0133     normal();
	RCALL _normal
; 0000 0134     setup();
	RCALL _setup
; 0000 0135     tu_dong();
	RCALL _tu_dong
; 0000 0136 }
	RET
; .FEND
;//------------------------------------------------//
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 013A {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 013B     c=UDR;
	IN   R11,12
; 0000 013C     if(c!='.')
	LDI  R30,LOW(46)
	CP   R30,R11
	BREQ _0x98
; 0000 013D     {
; 0000 013E         Data[index]=c;
	MOV  R30,R10
	LDI  R31,0
	RCALL SUBOPT_0x2D
	ST   Z,R11
; 0000 013F         index++;
	INC  R10
; 0000 0140         if(index>=16)
	LDI  R30,LOW(16)
	CP   R10,R30
	BRLO _0x99
; 0000 0141         {
; 0000 0142             index=0;
	CLR  R10
; 0000 0143         }
; 0000 0144     }
_0x99:
; 0000 0145     else
	RJMP _0x9A
_0x98:
; 0000 0146     {
; 0000 0147        ok=1;
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 0148     }
_0x9A:
; 0000 0149 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;void xu_ly_chuoi()
; 0000 014C {
_xu_ly_chuoi:
; .FSTART _xu_ly_chuoi
; 0000 014D     char i=0;
; 0000 014E     if(ok==1)
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0x9B
; 0000 014F     {
; 0000 0150         for(i=0;i<16;i++)
	LDI  R17,LOW(0)
_0x9D:
	CPI  R17,16
	BRSH _0x9E
; 0000 0151         {
; 0000 0152             if(Data[i]=='1')
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x2E
	CPI  R26,LOW(0x31)
	BRNE _0x9F
; 0000 0153             {
; 0000 0154                 nn_trung_gian_up=1;
	SET
	BLD  R2,0
; 0000 0155             }
; 0000 0156             else if(Data[i]=='2')
	RJMP _0xA0
_0x9F:
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x2E
	CPI  R26,LOW(0x32)
	BRNE _0xA1
; 0000 0157             {
; 0000 0158                 nn_trung_gian_down=1;
	SET
	BLD  R2,1
; 0000 0159             }
; 0000 015A             else if(Data[i]=='4')
	RJMP _0xA2
_0xA1:
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x2E
	CPI  R26,LOW(0x34)
	BRNE _0xA3
; 0000 015B             {
; 0000 015C                 state=1;
	LDI  R30,LOW(1)
	RJMP _0xBD
; 0000 015D             }
; 0000 015E             else if(Data[i]=='5')
_0xA3:
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x2E
	CPI  R26,LOW(0x35)
	BRNE _0xA5
; 0000 015F             {
; 0000 0160                 state=2;
	LDI  R30,LOW(2)
	RJMP _0xBD
; 0000 0161             }
; 0000 0162             else if(Data[i]=='9')
_0xA5:
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x2E
	CPI  R26,LOW(0x39)
	BRNE _0xA7
; 0000 0163             {
; 0000 0164                 state=3;
	LDI  R30,LOW(3)
_0xBD:
	MOV  R8,R30
; 0000 0165             }
; 0000 0166         }
_0xA7:
_0xA2:
_0xA0:
	SUBI R17,-1
	RJMP _0x9D
_0x9E:
; 0000 0167         for(i=0;i<16;i++)
	LDI  R17,LOW(0)
_0xA9:
	CPI  R17,16
	BRSH _0xAA
; 0000 0168         {
; 0000 0169             Data[i]='\0';
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x2D
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 016A         }
	SUBI R17,-1
	RJMP _0xA9
_0xAA:
; 0000 016B         index=0;
	CLR  R10
; 0000 016C         ok=0;
	CLR  R13
; 0000 016D     }
; 0000 016E }
_0x9B:
	LD   R17,Y+
	RET
; .FEND
;
;void send_to_app(void)
; 0000 0171 {
_send_to_app:
; .FSTART _send_to_app
; 0000 0172     if(state==2)
	LDI  R30,LOW(2)
	CP   R30,R8
	BRNE _0xAB
; 0000 0173     {
; 0000 0174         sprintf(str,"T= %2doC   H= %2d%%",I_TEMP,I_RH);
	RCALL SUBOPT_0x2F
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x31
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
; 0000 0175         lcd_gotoxy(0,0);
	RCALL SUBOPT_0x32
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x33
; 0000 0176         lcd_puts(str);
; 0000 0177         xu_ly_fuzzy();
	RCALL _xu_ly_fuzzy
; 0000 0178         if(tocdo<0)
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRGE _0xAC
; 0000 0179             {tocdo=0;}
	CLR  R4
	CLR  R5
; 0000 017A         sprintf(str,"Toc do : %3d",tocdo);
_0xAC:
	RCALL SUBOPT_0x2F
	__POINTW1FN _0x0,20
	RCALL SUBOPT_0x34
; 0000 017B         lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x33
; 0000 017C         lcd_puts(str);
; 0000 017D         lcd_puts("%");
	__POINTW2MN _0xAD,0
	RCALL _lcd_puts
; 0000 017E     }
; 0000 017F     sprintf(str,"%2d;%2d;%2d;",I_TEMP,I_RH,tocdo);
_0xAB:
	RCALL SUBOPT_0x2F
	__POINTW1FN _0x0,33
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x31
	MOVW R30,R4
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R24,12
	RCALL _sprintf
	ADIW R28,16
; 0000 0180     puts(str);
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	RCALL _puts
; 0000 0181 }
	RET
; .FEND

	.DSEG
_0xAD:
	.BYTE 0x2
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)     //10ms
; 0000 0185 {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0186     TCNT0=0xB2;
	LDI  R30,LOW(178)
	OUT  0x32,R30
; 0000 0187     up_button();
	RCALL _up_button
; 0000 0188     down_button();
	RCALL _down_button
; 0000 0189     mode_button();
	RCALL _mode_button
; 0000 018A     i_timer_2++;
	INC  R9
; 0000 018B 
; 0000 018C     if(i_timer_2>49)
	LDI  R30,LOW(49)
	CP   R30,R9
	BRSH _0xAE
; 0000 018D     {
; 0000 018E         DHT_GetTemHumi(&I_TEMP,&I_RH);
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RCALL SUBOPT_0x30
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	RCALL _DHT_GetTemHumi
; 0000 018F         send_to_app();
	RCALL _send_to_app
; 0000 0190         i_timer_2=0;
	CLR  R9
; 0000 0191     }
; 0000 0192 }
_0xAE:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)     //10ms
; 0000 0196 {
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R30
; 0000 0197     // Reinitialize Timer2 value
; 0000 0198     TCNT2=0xB2;
	LDI  R30,LOW(178)
	OUT  0x24,R30
; 0000 0199 }
	LD   R30,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 019C {
_main:
; .FSTART _main
; 0000 019D // Declare your local variables here
; 0000 019E 
; 0000 019F // Input/Output Ports initialization
; 0000 01A0 // Port B initialization
; 0000 01A1 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=In
; 0000 01A2 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (1<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(6)
	OUT  0x17,R30
; 0000 01A3 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=T
; 0000 01A4 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 01A5 
; 0000 01A6 // Port C initialization
; 0000 01A7 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 01A8 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 01A9 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 01AA PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 01AB 
; 0000 01AC // Port D initialization
; 0000 01AD // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 01AE DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 01AF // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 01B0 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 01B1 
; 0000 01B2 // Timer/Counter 0 initialization
; 0000 01B3 // Clock source: System Clock
; 0000 01B4 // Clock value: 7.813 kHz
; 0000 01B5 TCCR0=(1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 01B6 TCNT0=0xB2;
	LDI  R30,LOW(178)
	OUT  0x32,R30
; 0000 01B7 
; 0000 01B8 // Timer/Counter 1 initialization
; 0000 01B9 // Clock source: System Clock
; 0000 01BA // Clock value: 125.000 kHz
; 0000 01BB // Mode: Fast PWM top=ICR1
; 0000 01BC // OC1A output: Inverted PWM
; 0000 01BD // OC1B output: Inverted PWM
; 0000 01BE // Noise Canceler: Off
; 0000 01BF // Input Capture on Falling Edge
; 0000 01C0 // Timer Period: 0.1 s
; 0000 01C1 // Output Pulse(s):
; 0000 01C2 // OC1A Period: 0.1 s Width: 0 us
; 0000 01C3 // OC1B Period: 0.1 s Width: 0 us
; 0000 01C4 // Timer1 Overflow Interrupt: Off
; 0000 01C5 // Input Capture Interrupt: Off
; 0000 01C6 // Compare A Match Interrupt: Off
; 0000 01C7 // Compare B Match Interrupt: Off
; 0000 01C8 TCCR1A=(1<<COM1A1) | (1<<COM1A0) | (1<<COM1B1) | (1<<COM1B0) | (1<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(242)
	OUT  0x2F,R30
; 0000 01C9 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (1<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(27)
	OUT  0x2E,R30
; 0000 01CA TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 01CB TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01CC ICR1H=0x30;   //12500
	LDI  R30,LOW(48)
	OUT  0x27,R30
; 0000 01CD ICR1L=0xD3;
	LDI  R30,LOW(211)
	OUT  0x26,R30
; 0000 01CE OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 01CF OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01D0 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01D1 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01D2 
; 0000 01D3 
; 0000 01D4 // Timer/Counter 2 initialization
; 0000 01D5 // Clock source: System Clock
; 0000 01D6 // Clock value: 7.813 kHz
; 0000 01D7 // Mode: Normal top=0xFF
; 0000 01D8 // OC2 output: Disconnected
; 0000 01D9 // Timer Period: 9.984 ms
; 0000 01DA ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 01DB TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (1<<CS22) | (1<<CS21) | (1<<CS20);
	LDI  R30,LOW(7)
	OUT  0x25,R30
; 0000 01DC TCNT2=0xB2;
	LDI  R30,LOW(178)
	OUT  0x24,R30
; 0000 01DD OCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0000 01DE 
; 0000 01DF // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01E0 TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(65)
	OUT  0x39,R30
; 0000 01E1 
; 0000 01E2 // External Interrupt(s) initialization
; 0000 01E3 // INT0: Off
; 0000 01E4 // INT1: Off
; 0000 01E5 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 01E6 
; 0000 01E7 // USART initialization
; 0000 01E8 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01E9 // USART Receiver: On
; 0000 01EA // USART Transmitter: On
; 0000 01EB // USART Mode: Asynchronous
; 0000 01EC // USART Baud Rate: 9600
; 0000 01ED UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 01EE UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 01EF UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 01F0 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01F1 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 01F2 
; 0000 01F3 // Analog Comparator initialization
; 0000 01F4 // Analog Comparator: Off
; 0000 01F5 // The Analog Comparator's positive input is
; 0000 01F6 // connected to the AIN0 pin
; 0000 01F7 // The Analog Comparator's negative input is
; 0000 01F8 // connected to the AIN1 pin
; 0000 01F9 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01FA SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01FB 
; 0000 01FC // ADC initialization
; 0000 01FD // ADC disabled
; 0000 01FE ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 01FF 
; 0000 0200 // SPI initialization
; 0000 0201 // SPI disabled
; 0000 0202 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0203 
; 0000 0204 // TWI initialization
; 0000 0205 // TWI disabled
; 0000 0206 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0207 
; 0000 0208 // Alphanumeric LCD initialization
; 0000 0209 // Connections are specified in the
; 0000 020A // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 020B // RS - PORTC Bit 5
; 0000 020C // RD - PORTD Bit 7
; 0000 020D // EN - PORTC Bit 4
; 0000 020E // D4 - PORTC Bit 3
; 0000 020F // D5 - PORTC Bit 2
; 0000 0210 // D6 - PORTC Bit 1
; 0000 0211 // D7 - PORTC Bit 0
; 0000 0212 // Characters/line: 16
; 0000 0213 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0214 lcd_puts("DO AN TOT NGHIEP");
	__POINTW2MN _0xAF,0
	RCALL _lcd_puts
; 0000 0215 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0216 // Global enable interrupts
; 0000 0217 #asm("sei")
	sei
; 0000 0218 
; 0000 0219 while (1)
_0xB0:
; 0000 021A       {
; 0000 021B         OCR1A=OCR1B=tocdo*125;
	MOVW R30,R4
	LDI  R26,LOW(125)
	LDI  R27,HIGH(125)
	RCALL __MULW12
	OUT  0x28+1,R31
	OUT  0x28,R30
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 021C         switch (state)
	MOV  R30,R8
	LDI  R31,0
; 0000 021D         {
; 0000 021E             case 1: //thu cong
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xB6
; 0000 021F             {
; 0000 0220                 lcd_gotoxy(0,0);
	RCALL SUBOPT_0x32
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 0221                 lcd_puts("Che do thu cong ");
	__POINTW2MN _0xAF,17
	RCALL _lcd_puts
; 0000 0222                 sprintf(str,"Toc do : %3d%%    ",tocdo);
	RCALL SUBOPT_0x2F
	__POINTW1FN _0x0,80
	RCALL SUBOPT_0x34
; 0000 0223                 lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x33
; 0000 0224                 lcd_puts(str);
; 0000 0225                 lcd_puts("%");
	__POINTW2MN _0xAF,34
	RCALL _lcd_puts
; 0000 0226                 break;
	RJMP _0xB5
; 0000 0227             }
; 0000 0228 
; 0000 0229             case 2: // tu dong
_0xB6:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ _0xB5
; 0000 022A             {
; 0000 022B 
; 0000 022C                 break;
; 0000 022D             }
; 0000 022E 
; 0000 022F             case 3:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xB5
; 0000 0230             {
; 0000 0231                 lcd_gotoxy(0,0);
	RCALL SUBOPT_0x32
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 0232                 lcd_puts("     Stop       ");
	__POINTW2MN _0xAF,36
	RCALL _lcd_puts
; 0000 0233                 lcd_gotoxy(0,1);
	RCALL SUBOPT_0x32
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0234                 lcd_puts("                ");
	__POINTW2MN _0xAF,53
	RCALL _lcd_puts
; 0000 0235                 tocdo=0;
	CLR  R4
	CLR  R5
; 0000 0236                 break;
; 0000 0237             }
; 0000 0238         }
_0xB5:
; 0000 0239         xu_ly_chuoi();
	RCALL _xu_ly_chuoi
; 0000 023A       }
	RJMP _0xB0
; 0000 023B }
_0xB9:
	RJMP _0xB9
; .FEND

	.DSEG
_0xAF:
	.BYTE 0x46
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x15,3
	RJMP _0x2000005
_0x2000004:
	CBI  0x15,3
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x15,2
	RJMP _0x2000007
_0x2000006:
	CBI  0x15,2
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x15,1
	RJMP _0x2000009
_0x2000008:
	CBI  0x15,1
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x15,0
	RJMP _0x200000B
_0x200000A:
	CBI  0x15,0
_0x200000B:
	RCALL SUBOPT_0x35
	SBI  0x15,4
	RCALL SUBOPT_0x35
	CBI  0x15,4
	RCALL SUBOPT_0x35
	RJMP _0x20E0003
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x20E0003
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R12,Y+1
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x36
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x36
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	MOV  R12,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	LDS  R30,__lcd_maxx
	CP   R12,R30
	BRLO _0x2000010
_0x2000011:
	RCALL SUBOPT_0x32
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x20E0003
_0x2000013:
_0x2000010:
	INC  R12
	SBI  0x15,5
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,5
	RJMP _0x20E0003
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	RCALL SUBOPT_0x37
	ST   -Y,R17
_0x2000014:
	RCALL SUBOPT_0x38
	BREQ _0x2000016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
	RJMP _0x20E0002
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x14,3
	SBI  0x14,2
	SBI  0x14,1
	SBI  0x14,0
	SBI  0x14,4
	SBI  0x14,5
	SBI  0x11,7
	CBI  0x15,4
	CBI  0x15,5
	CBI  0x12,7
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x39
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
	RJMP _0x20E0003
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	RCALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	RCALL __PUTPARD2
	RCALL SUBOPT_0x1C
	RCALL _ftrunc
	RCALL __PUTD1S0
    brne __floor1
__floor0:
	RCALL SUBOPT_0x20
	RJMP _0x20E0005
__floor1:
    brtc __floor0
	RCALL SUBOPT_0x20
	__GETD2N 0x3F800000
	RCALL __SUBF12
_0x20E0005:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_DHT_GetTemHumi:
; .FSTART _DHT_GetTemHumi
	RCALL SUBOPT_0x37
	SBIW R28,5
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	RCALL __SAVELOCR4
	SBI  0x17,0
	SBI  0x18,0
	RCALL SUBOPT_0x3A
	CBI  0x18,0
	LDI  R26,LOW(25)
	LDI  R27,0
	RCALL _delay_ms
	SBI  0x18,0
	CBI  0x17,0
	RCALL SUBOPT_0x3A
	SBIS 0x16,0
	RJMP _0x206000D
	LDI  R30,LOW(0)
	RJMP _0x20E0004
_0x206000D:
_0x206000F:
	SBIS 0x16,0
	RJMP _0x206000F
	RCALL SUBOPT_0x3A
	SBIC 0x16,0
	RJMP _0x2060012
	LDI  R30,LOW(0)
	RJMP _0x20E0004
_0x2060012:
_0x2060014:
	SBIC 0x16,0
	RJMP _0x2060014
	LDI  R16,LOW(0)
_0x2060018:
	CPI  R16,5
	BRSH _0x2060019
	LDI  R17,LOW(0)
_0x206001B:
	CPI  R17,8
	BRSH _0x206001C
_0x206001D:
	SBIS 0x16,0
	RJMP _0x206001D
	__DELAY_USB 133
	SBIS 0x16,0
	RJMP _0x2060020
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LD   R1,Z
	LDI  R30,LOW(7)
	SUB  R30,R17
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OR   R30,R1
	MOVW R26,R22
	ST   X,R30
_0x2060021:
	SBIC 0x16,0
	RJMP _0x2060021
_0x2060020:
	SUBI R17,-1
	RJMP _0x206001B
_0x206001C:
	SUBI R16,-1
	RJMP _0x2060018
_0x2060019:
	LDD  R30,Y+5
	LDD  R26,Y+4
	ADD  R30,R26
	LDD  R26,Y+6
	ADD  R30,R26
	LDD  R26,Y+7
	ADD  R30,R26
	MOV  R19,R30
	LDD  R30,Y+8
	CP   R30,R19
	BREQ _0x2060024
	LDI  R30,LOW(0)
	RJMP _0x20E0004
_0x2060024:
	LDD  R30,Y+6
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ST   X,R30
	LDD  R30,Y+4
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDI  R30,LOW(1)
_0x20E0004:
	RCALL __LOADLOCR4
	ADIW R28,13
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x20E0003:
	ADIW R28,1
	RET
; .FEND
_puts:
; .FSTART _puts
	RCALL SUBOPT_0x37
	ST   -Y,R17
_0x2080003:
	RCALL SUBOPT_0x38
	BREQ _0x2080005
	MOV  R26,R17
	RCALL _putchar
	RJMP _0x2080003
_0x2080005:
	LDI  R26,LOW(10)
	RCALL _putchar
_0x20E0002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_put_buff_G104:
; .FSTART _put_buff_G104
	RCALL SUBOPT_0x37
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x3B
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2080010
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x3C
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2080012
	__CPWRN 16,17,2
	BRLO _0x2080013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2080012:
	RCALL SUBOPT_0x3B
	ADIW R26,2
	RCALL SUBOPT_0x3D
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2080013:
	RCALL SUBOPT_0x3B
	RCALL __GETW1P
	TST  R31
	BRMI _0x2080014
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x3D
_0x2080014:
	RJMP _0x2080015
_0x2080010:
	RCALL SUBOPT_0x3B
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2080015:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
; .FEND
__print_G104:
; .FSTART __print_G104
	RCALL SUBOPT_0x37
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2080016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2080018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x208001C
	CPI  R18,37
	BRNE _0x208001D
	LDI  R17,LOW(1)
	RJMP _0x208001E
_0x208001D:
	RCALL SUBOPT_0x3E
_0x208001E:
	RJMP _0x208001B
_0x208001C:
	CPI  R30,LOW(0x1)
	BRNE _0x208001F
	CPI  R18,37
	BRNE _0x2080020
	RCALL SUBOPT_0x3E
	RJMP _0x20800CC
_0x2080020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2080021
	LDI  R16,LOW(1)
	RJMP _0x208001B
_0x2080021:
	CPI  R18,43
	BRNE _0x2080022
	LDI  R20,LOW(43)
	RJMP _0x208001B
_0x2080022:
	CPI  R18,32
	BRNE _0x2080023
	LDI  R20,LOW(32)
	RJMP _0x208001B
_0x2080023:
	RJMP _0x2080024
_0x208001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2080025
_0x2080024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2080026
	ORI  R16,LOW(128)
	RJMP _0x208001B
_0x2080026:
	RJMP _0x2080027
_0x2080025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x208001B
_0x2080027:
	CPI  R18,48
	BRLO _0x208002A
	CPI  R18,58
	BRLO _0x208002B
_0x208002A:
	RJMP _0x2080029
_0x208002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x208001B
_0x2080029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x208002F
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x3F
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x41
	RJMP _0x2080030
_0x208002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2080032
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x44
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2080033
_0x2080032:
	CPI  R30,LOW(0x70)
	BRNE _0x2080035
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x44
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2080033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2080036
_0x2080035:
	CPI  R30,LOW(0x64)
	BREQ _0x2080039
	CPI  R30,LOW(0x69)
	BRNE _0x208003A
_0x2080039:
	ORI  R16,LOW(4)
	RJMP _0x208003B
_0x208003A:
	CPI  R30,LOW(0x75)
	BRNE _0x208003C
_0x208003B:
	LDI  R30,LOW(_tbl10_G104*2)
	LDI  R31,HIGH(_tbl10_G104*2)
	RCALL SUBOPT_0x45
	LDI  R17,LOW(5)
	RJMP _0x208003D
_0x208003C:
	CPI  R30,LOW(0x58)
	BRNE _0x208003F
	ORI  R16,LOW(8)
	RJMP _0x2080040
_0x208003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2080071
_0x2080040:
	LDI  R30,LOW(_tbl16_G104*2)
	LDI  R31,HIGH(_tbl16_G104*2)
	RCALL SUBOPT_0x45
	LDI  R17,LOW(4)
_0x208003D:
	SBRS R16,2
	RJMP _0x2080042
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x46
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2080043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x46
	LDI  R20,LOW(45)
_0x2080043:
	CPI  R20,0
	BREQ _0x2080044
	SUBI R17,-LOW(1)
	RJMP _0x2080045
_0x2080044:
	ANDI R16,LOW(251)
_0x2080045:
	RJMP _0x2080046
_0x2080042:
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x46
_0x2080046:
_0x2080036:
	SBRC R16,0
	RJMP _0x2080047
_0x2080048:
	CP   R17,R21
	BRSH _0x208004A
	SBRS R16,7
	RJMP _0x208004B
	SBRS R16,2
	RJMP _0x208004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x208004D
_0x208004C:
	LDI  R18,LOW(48)
_0x208004D:
	RJMP _0x208004E
_0x208004B:
	LDI  R18,LOW(32)
_0x208004E:
	RCALL SUBOPT_0x3E
	SUBI R21,LOW(1)
	RJMP _0x2080048
_0x208004A:
_0x2080047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x208004F
_0x2080050:
	CPI  R19,0
	BREQ _0x2080052
	SBRS R16,3
	RJMP _0x2080053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x45
	RJMP _0x2080054
_0x2080053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2080054:
	RCALL SUBOPT_0x3E
	CPI  R21,0
	BREQ _0x2080055
	SUBI R21,LOW(1)
_0x2080055:
	SUBI R19,LOW(1)
	RJMP _0x2080050
_0x2080052:
	RJMP _0x2080056
_0x208004F:
_0x2080058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x45
_0x208005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x208005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x46
	RJMP _0x208005A
_0x208005C:
	CPI  R18,58
	BRLO _0x208005D
	SBRS R16,3
	RJMP _0x208005E
	SUBI R18,-LOW(7)
	RJMP _0x208005F
_0x208005E:
	SUBI R18,-LOW(39)
_0x208005F:
_0x208005D:
	SBRC R16,4
	RJMP _0x2080061
	CPI  R18,49
	BRSH _0x2080063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2080062
_0x2080063:
	RJMP _0x20800CD
_0x2080062:
	CP   R21,R19
	BRLO _0x2080067
	SBRS R16,0
	RJMP _0x2080068
_0x2080067:
	RJMP _0x2080066
_0x2080068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2080069
	LDI  R18,LOW(48)
_0x20800CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x208006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x41
	CPI  R21,0
	BREQ _0x208006B
	SUBI R21,LOW(1)
_0x208006B:
_0x208006A:
_0x2080069:
_0x2080061:
	RCALL SUBOPT_0x3E
	CPI  R21,0
	BREQ _0x208006C
	SUBI R21,LOW(1)
_0x208006C:
_0x2080066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2080059
	RJMP _0x2080058
_0x2080059:
_0x2080056:
	SBRS R16,0
	RJMP _0x208006D
_0x208006E:
	CPI  R21,0
	BREQ _0x2080070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x41
	RJMP _0x208006E
_0x2080070:
_0x208006D:
_0x2080071:
_0x2080030:
_0x20800CC:
	LDI  R17,LOW(0)
_0x208001B:
	RJMP _0x2080016
_0x2080018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x47
	SBIW R30,0
	BRNE _0x2080072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20E0001
_0x2080072:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x45
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G104)
	LDI  R31,HIGH(_put_buff_G104)
	RCALL SUBOPT_0x30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G104
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20E0001:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	RCALL SUBOPT_0x37
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	RCALL SUBOPT_0x37
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_str:
	.BYTE 0x14
_fuzzy_temp_lanh:
	.BYTE 0x4
_fuzzy_temp_vua:
	.BYTE 0x4
_fuzzy_temp_nong:
	.BYTE 0x4
_fuzzy_am:
	.BYTE 0x4
_fuzzy_thuong:
	.BYTE 0x4
_fuzzy_kho:
	.BYTE 0x4
_heso:
	.BYTE 0x9
_hesothuc:
	.BYTE 0x9
_hang:
	.BYTE 0x3
_cot:
	.BYTE 0x3
_Data:
	.BYTE 0x10
__base_y_G100:
	.BYTE 0x4
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(10)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	MOV  R8,R30
	CLT
	BLD  R2,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(15)
	CP   R6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	STS  _fuzzy_temp_lanh,R30
	STS  _fuzzy_temp_lanh+1,R31
	STS  _fuzzy_temp_lanh+2,R22
	STS  _fuzzy_temp_lanh+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x5:
	MOV  R30,R6
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x6:
	RCALL __SWAPD12
	RCALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40A00000
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(20)
	CP   R6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	STS  _fuzzy_temp_vua,R30
	STS  _fuzzy_temp_vua+1,R31
	STS  _fuzzy_temp_vua+2,R22
	STS  _fuzzy_temp_vua+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(25)
	CP   R30,R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	STS  _fuzzy_temp_nong,R30
	STS  _fuzzy_temp_nong+1,R31
	STS  _fuzzy_temp_nong+2,R22
	STS  _fuzzy_temp_nong+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(60)
	CP   R7,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	STS  _fuzzy_kho,R30
	STS  _fuzzy_kho+1,R31
	STS  _fuzzy_kho+2,R22
	STS  _fuzzy_kho+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xE:
	MOV  R30,R7
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xF:
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x8
	__GETD1N 0x41200000
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(70)
	CP   R7,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	STS  _fuzzy_thuong,R30
	STS  _fuzzy_thuong+1,R31
	STS  _fuzzy_thuong+2,R22
	STS  _fuzzy_thuong+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(80)
	CP   R30,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	STS  _fuzzy_am,R30
	STS  _fuzzy_am+1,R31
	STS  _fuzzy_am+2,R22
	STS  _fuzzy_am+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x14:
	LDS  R30,_fuzzy_temp_lanh
	LDS  R31,_fuzzy_temp_lanh+1
	LDS  R22,_fuzzy_temp_lanh+2
	LDS  R23,_fuzzy_temp_lanh+3
	RCALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x15:
	LDS  R30,_fuzzy_temp_vua
	LDS  R31,_fuzzy_temp_vua+1
	LDS  R22,_fuzzy_temp_vua+2
	LDS  R23,_fuzzy_temp_vua+3
	RCALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	LDS  R30,_fuzzy_temp_nong
	LDS  R31,_fuzzy_temp_nong+1
	LDS  R22,_fuzzy_temp_nong+2
	LDS  R23,_fuzzy_temp_nong+3
	RCALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	LDS  R30,_fuzzy_am
	LDS  R31,_fuzzy_am+1
	LDS  R22,_fuzzy_am+2
	LDS  R23,_fuzzy_am+3
	RCALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x18:
	LDS  R30,_fuzzy_thuong
	LDS  R31,_fuzzy_thuong+1
	LDS  R22,_fuzzy_thuong+2
	LDS  R23,_fuzzy_thuong+3
	RCALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x19:
	LDS  R30,_fuzzy_kho
	LDS  R31,_fuzzy_kho+1
	LDS  R22,_fuzzy_kho+2
	LDS  R23,_fuzzy_kho+3
	RCALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x1B:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x1C:
	RCALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1D:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	RCALL SUBOPT_0x1B
	RCALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	RCALL SUBOPT_0x1C
	RCALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x20:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	MOVW R26,R30
	CLR  R30
	ADD  R26,R19
	ADC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x23:
	LDD  R30,Y+8
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x24:
	__GETD2S 19
	RCALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x25:
	__GETD2S 15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x26:
	__GETD2S 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x27:
	LDD  R30,Y+9
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RCALL SUBOPT_0x26
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	__GETD1S 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x29:
	RCALL __DIVF21
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2A:
	__GETD2S 19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2B:
	LDD  R30,Y+9
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RCALL SUBOPT_0x25
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	__GETD1S 15
	RCALL SUBOPT_0x2A
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2D:
	SUBI R30,LOW(-_Data)
	SBCI R31,HIGH(-_Data)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	RCALL SUBOPT_0x2D
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x30:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x31:
	MOV  R30,R6
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	MOV  R30,R7
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x32:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x33:
	RCALL _lcd_gotoxy
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x34:
	RCALL SUBOPT_0x30
	MOVW R30,R4
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x35:
	__DELAY_USB 13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x37:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x38:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x39:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3A:
	__DELAY_USB 160
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3C:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3D:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x3E:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3F:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x40:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x41:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	RCALL SUBOPT_0x3F
	RJMP SUBOPT_0x40

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x43:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x3C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x45:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	LDI  R30,1
	BREQ __EQD12T
	CLR  R30
__EQD12T:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
