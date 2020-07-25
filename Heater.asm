.include "m8def.inc"
.include "Macro.inc"
.include "Pinout.inc"
.include "Vars.inc"

rjmp	RESET		; Reset
reti			; INT0
rjmp	ShortStr	; INT1
reti			; TIMER2 COMP
reti			; TIMER2 OVF
reti			; TIMER1 CAPT
reti			; TIMER1 COMPA
reti			; TIMER1 COMPB
reti			; TIMER1 OVF
reti			; TIMER0 OVF
reti			; SPI,STC
reti			; UART, RX
reti			; UART, UDRE
reti			; UART, TX
reti			; ADC
reti			; EE_RDY
reti			; ANA_COMP
reti			; TWI
reti			; SPM_RDY

ShortStr:
	out	TCCR1A,ZeroReg
	out	TCCR1B,ZeroReg
	cbi	PORTB,1
	in	SSREG,SREG
	set
	bld	AFlags,afStringShorted
	out	SREG,SSREG
	out	MCUCR,ZeroReg
	out	GICR,ZeroReg
	outi	GIFR, 0b10000000
	cbi	PORTB,1
	reti

.include "ADC.inc"
.include "UART.inc"
.include "Tact.inc"
.include "Subs.inc"
.include "Stabilize.inc"

RESET:
.include "Init.inc"

Main:
	tskTact
RetTact:

	tskUart
RetUart:

	tskADC
RetADC:

	sbrc	AFlags,afADCComplete
	rcall	Stabilize

	rjmp	Main

StartPWM:
	outi	MCUCR,1<<ISC11	// Falling edge external INT1
	outi	GIFR,1<<INTF1	// Clear interrupt flag
	outi	GICR,1<<INT1	// Enable INT1
	cbi	PORTB,1		// Turn off key
	ldi_w	r17,r16,PWM_PERIOD
	out	ICR1H,r17
	out	ICR1L,r16
	ldi_w	r17,r16,PWM_PERIOD
	out	OCR1AH,r17
	out	OCR1AL,r16
	outi	TCCR1A, 1<<COM1A1 | 1<<COM1A0 | 1<<WGM11  // Inverted fast PWM(ICR1)
	outi	TCCR1B, 1<<WGM13  | 1<<WGM12  | 1<<CS10
	ret

StopPWM:
	out	MCUCR,ZeroReg
	out	GICR,ZeroReg
	outi	GIFR,1<<INTF1
	ldi_w	r17,r16,PWM_PERIOD
	ldi_w	r17,r16,PWM_PERIOD
	out	OCR1AH,r17
	out	OCR1AL,r16
	out	TCCR1A,YH
	out	TCCR1B,YH
	cbi	PORTB,1
	ret


#define	UART_DIR_PORT	PORTD,2	; <- UartDir
#define	UART_DIR_DDR	 DDRD,2
;********** BootLoader V0.0 **********
.ORG	SECONDBOOTSTART
BootLoader:
	cli
;-- Порты --
	InitPorts
#ifdef	UART_DIR_PORT
	cbi	UART_DIR_PORT
	sbi	UART_DIR_DDR
#endif
;--- Стек и указатели ---
	outi	SPH,high(RAMEND)
	outi	SPL,low(RAMEND)
	ldi	XH,1
	ldi_w	YH,YL,$60
;--- Остановить таймеры ---
	out	TCCR1A,YH
	out	TCCR1B,YH
	out	TCCR0,YH
	out	TCCR2,YH
;-- Очиститка памяти с $100 по $1ff
	ldi_w	YH,YL,$60
	ldi_w	XH,XL,$100

	ldi_w	ZH,ZL,$60
bini_1:	st	Z+,YH
	cpi	ZH,2
	brlo	bini_1
;--- Инициализация UART ---
	out	UCSRA,YH
	outi	UCSRB,(1<<RXEN) | (1<<TXEN)	; Разрешить прием и передачу
	outi	UCSRC,0b10000110	; 8-бит
	outi	UBRRH,High(UBRRB_V)
	outi	UBRRL,Low(UBRRB_V)
Boot_continue:


