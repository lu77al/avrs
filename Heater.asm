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

L_181:	.dw	$934f
L_182:	.dw	$935f
L_183:	.dw	$936f
L_184:	.dw	$9f02
L_185:	.dw	$2d41
L_186:	.dw	$e050
L_187:	.dw	$e060
L_188:	.dw	$9f03
L_189:	.dw	$0d40
L_18A:	.dw	$1d51
L_18B:	.dw	$1f6d
L_18C:	.dw	$9f12
L_18D:	.dw	$0d40
L_18E:	.dw	$1d51
L_18F:	.dw	$1f6d
L_190:	.dw	$9f13
L_191:	.dw	$0d50
L_192:	.dw	$1d61
L_193:	.dw	$2f05
L_194:	.dw	$2f16
L_195:	.dw	$916f
L_196:	.dw	$915f
L_197:	.dw	$914f
L_198:	.dw	$9508
L_199:	.dw	$24ee
L_19A:	.dw	$18ff
L_19B:	.dw	$e141
L_19C:	.dw	$1f00
L_19D:	.dw	$1f11
L_19E:	.dw	$954a
L_19F:	.dw	$f409
L_1A0:	.dw	$9508
L_1A1:	.dw	$1cee
L_1A2:	.dw	$1cff
L_1A3:	.dw	$1ae2
L_1A4:	.dw	$0af3
L_1A5:	.dw	$f420
L_1A6:	.dw	$0ee2
L_1A7:	.dw	$1ef3
L_1A8:	.dw	$9488
L_1A9:	.dw	$cff2
L_1AA:	.dw	$9408
L_1AB:	.dw	$cff0
L_1AC:	.dw	$24dd
L_1AD:	.dw	$24ee
L_1AE:	.dw	$18ff
L_1AF:	.dw	$e169
L_1B0:	.dw	$1f00
L_1B1:	.dw	$1f11
L_1B2:	.dw	$1f22
L_1B3:	.dw	$956a
L_1B4:	.dw	$f409
L_1B5:	.dw	$9508
L_1B6:	.dw	$1cdd
L_1B7:	.dw	$1cee
L_1B8:	.dw	$1cff
L_1B9:	.dw	$1ad3
L_1BA:	.dw	$0ae4
L_1BB:	.dw	$0af5
L_1BC:	.dw	$f428
L_1BD:	.dw	$0ed3
L_1BE:	.dw	$1ee4
L_1BF:	.dw	$1ef5
L_1C0:	.dw	$9488
L_1C1:	.dw	$cfee
L_1C2:	.dw	$9408
L_1C3:	.dw	$cfec
L_1C4:	.dw	$18ff
L_1C5:	.dw	$e029
L_1C6:	.dw	$1f00
L_1C7:	.dw	$952a
L_1C8:	.dw	$f411
L_1C9:	.dw	$9500
L_1CA:	.dw	$9508
L_1CB:	.dw	$1cff
L_1CC:	.dw	$1af1
L_1CD:	.dw	$f7c0
L_1CE:	.dw	$0ef1
L_1CF:	.dw	$cff6
L_1D0:	.dw	$9005
L_1D1:	.dw	$920d
L_1D2:	.dw	$950a
L_1D3:	.dw	$f7e1
L_1D4:	.dw	$9508

L_1D5:	ldi	r16,10	// $0a
	sbis	PORTD,7
	std	Y+$1a,r16	// 26
	sbrc	AFlags,1
	std	Y+yHeating,YH	// 24
	ldd	r16,Y+yHeating	// 24
	cpi	r16,0	// $00
	breq	L_1E5
	sbi	PORTD,7
	ldi	r17,40	// $28
	std	Y+$1b,r17	// 27
	ldd	r16,Y+$1a	// 26
	subi	r16,1	// $01
	brlo	L_1F2	// brcs
	std	Y+$1a,r16	// 26
	rjmp	L_1EB
L_1E5:	ldd	r16,Y+$1b	// 27
	subi	r16,1	// $01
	brsh	L_1EA	// brcc
	cbi	PORTD,7
	ldi	r16,0	// $00
L_1EA:	std	Y+$1b,r16	// 27
L_1EB:	in	r16,MCUCR
	cpi	r16,0	// $00
	breq	L_1EF
	rcall	L_2C3
L_1EF:	std	Y+$14,YH	// 20
	std	Y+$15,YH	// 21
	ret
L_1F2:	in	r16,MCUCR
	cpi	r16,0	// $00
	brne	L_1F6
	rcall	L_2AF
L_1F6:	ldi	r17,2	// $02
	ldi	r16,104	// $68
	ldd	r18,Y+yHeating	// 24
	cpi	r18,100	// $64
	brlo	L_1FC	// brcs
	ldi	r18,100	// $64
L_1FC:	mul	r16,r18
	movw	r21:r20, r1:r0
	mul	r17,r18
	add	r21,r0
	std	Y+$14,r20	// 20
	std	Y+$15,r21	// 21
	ret
L_203:	clt
	bld	AFlags,0
	ldd	r16,Y+$14	// 20
	ldd	r17,Y+$15	// 21
	or	r16,r17
	brne	L_20C
	std	Y+$10,YH	// 16
	std	Y+$11,YH	// 17
	rjmp	L_238
L_20C:	lds	r16,$0140	// 320
	lds	r17,$0141	// 321
	cpi	r17,72	// $48
	brlo	L_215	// brcs
	set
	sbis	PIND,4
	bld	AFlags,2
L_215:	lsr	r17
	ror	r16
	ldd	r18,Y+$14	// 20
	ldd	r19,Y+$15	// 21
	lsr	r19
	ror	r18
	sub	r18,r16
	sbc	r19,r17
	lds	r16,$0142	// 322
	lds	r17,$0143	// 323
	lsr	r17
	ror	r16
	ldi	r21,24	// $18
	ldi	r20,249	// $f9
	lsr	r21
	ror	r20
	sub	r16,r20
	sbc	r17,r21
	cp	r16,r18
	cpc	r17,r19
	brlt	L_22D
	movw	r17:r16, r19:r18
L_22D:	bst	r17,7
	brtc	L_233
	com	r17
	com	r16
	subi	r16,255	// $ff
	sbci	r17,255	// $ff
L_233:	cpi	r17,0	// $00
	brne	L_238
	cpi	r16,64	// $40
	brlo	L_238	// brcs
	ldi	r17,1	// $01
L_238:	ldd	r24,Y+$10	// 16
	ldd	r25,Y+$11	// 17
	cp	r24,YH
	cpc	r25,YH
	brne	L_243
	lds	r18,$0142	// 322
	lds	r19,$0143	// 323
	std	Y+$12,r18	// 18
	std	Y+$13,r19	// 19
L_243:	brts	L_24D
	add	r24,r17
	adc	r25,YH
	ldi	r17,1	// $01
	cpi	r24,144	// $90
	cpc	r25,r17
	brlo	L_252	// brcs
	ldi	r25,1	// $01
	ldi	r24,144	// $90
	rjmp	L_252
L_24D:	sub	r24,r17
	sbc	r25,YH
	brsh	L_252	// brcc
	ldi	r25,0	// $00
	ldi	r24,0	// $00
L_252:	std	Y+$10,r24	// 16
	std	Y+$11,r25	// 17
	ldd	r16,Y+$10	// 16
	ldd	r17,Y+$11	// 17
	ldi	r19,1	// $01
	ldi	r18,144	// $90
	sub	r18,r16
	sbc	r19,r17
	out	OCR1AH,r19
	out	OCR1AL,r18
	sei
	ret



RESET:	ldi	r16,2	// $02
	out	DDRB,r16
	ldi	r16,61	// $3d
	out	PORTB,r16
	ldi	r16,0	// $00
	out	DDRC,r16
	ldi	r16,51	// $33
	out	PORTC,r16
	ldi	r16,196	// $c4
	out	DDRD,r16
	ldi	r16,32	// $20
	out	PORTD,r16
	ldi	r16,4	// $04
	out	SPH,r16
	ldi	r16,95	// $5f
	out	SPL,r16
	ldi	YH,0	// $00
	ldi	YL,96	// $60
	ldi	XH,1	// $01
	ldi	XL,0	// $00
	ldi	ZH,0	// $00
	ldi	ZL,96	// $60
L_274:	st	Z+,YH
	cpi	ZH,2	// $02
	brlo	L_274	// brcs
	ldi	YH,0	// $00
	ldi	YL,96	// $60
	ldi	XH,1	// $01
	ldi	XL,0	// $00
	ldi	r18,2	// $02
	ldi	r17,0	// $00
	ldi	r16,0	// $00
L_27E:	subi	r16,1	// $01
	sbci	r17,0	// $00
	sbci	r18,0	// $00
	brne	L_27E
	ldi	r16,0	// $00
	out	SPCR,r16
	ldi	r16,0	// $00
	out	SPSR,r16
	eor	AFlags,AFlags
	eor	r8,r8
	rcall	InitTact
	rcall	InitUart
	rcall	InitADC
	sei
L_28C:

	tskTact
RetTact:

;	in	r16,TIFR
;	sbrc	r16,6
;	rjmp	L_140
;RetTact:

	ldd	XL,Y+$04	// 4
	ldd	r17,Y+$05	// 5
	cp	XL,r17
	breq	L_2A3
	sbis	UCSRA,5
	rjmp	RetUart
	sbi	PORTD,2
	ld	r16,X+
	cp	XL,r17
	brne	L_29C
	cpi	r17,36	// $24
	brlo	L_29C	// brcs
	ldd	r16,Y+$07	// 7
L_29C:	out	UDR,r16
	std	Y+$04,XL	// 4
	ldd	r17,Y+$07	// 7
	add	r17,r16
	std	Y+$07,r17	// 7
	sbi	UCSRA,6
	rjmp	RetUart
L_2A3:	sbic	UCSRA,6
	cbi	PORTD,2
	sbic	UCSRA,7
	rjmp	ReadUart
RetUart:

	ldd	r16,Y+$0a	// 10
	cpi	r16,255	// $ff
	breq	RetADC
	sbis	ADCSRA,6
	rjmp	CheckADCProc
RetADC:	sbrc	AFlags,0
	rcall	L_203
	rjmp	L_28C
L_2AF:	ldi	r16,8	// $08
	out	MCUCR,r16
	ldi	r16,128	// $80
	out	GIFR,r16
	ldi	r16,128	// $80
	out	GICR,r16
	cbi	PORTB,1
	ldi	r17,1	// $01
	ldi	r16,144	// $90
	out	ICR1H,r17
	out	ICR1L,r16
	ldi	r17,1	// $01
	ldi	r16,144	// $90
	out	OCR1AH,r17
	out	OCR1AL,r16
	ldi	r16,194	// $c2
	out	TCCR1A,r16
	ldi	r16,25	// $19
	out	TCCR1B,r16
	ret
L_2C3:	out	MCUCR,YH
	out	GICR,YH
	ldi	r16,128	// $80
	out	GIFR,r16
	ldi	r17,1	// $01
	ldi	r16,144	// $90
	ldi	r17,1	// $01
	ldi	r16,144	// $90
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


