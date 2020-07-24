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


L_60:	ldi	r16,0	// $00
	out	UCSRA,r16
	ldi	r16,24	// $18
	out	UCSRB,r16
	ldi	r16,134	// $86
	out	UBRRH,r16
	ldi	r16,0	// $00
	out	UBRRH,r16
	ldi	r16,25	// $19
	out	UBRRL,r16
	ldi	r16,32	// $20
	std	Y+$04,r16	// 4
	std	Y+$05,r16	// 5
	ldi	r16,255	// $ff
	std	Y+$03,r16	// 3
	std	Y+$06,YH	// 6
	cbi	PORTD,2
	sbi	DDRD,2
	ldi	r16,53	// $35
	std	Y+$08,r16	// 8
	std	Y+$07,YH	// 7
	ret
L_76:	in	r16,UDR
	ldd	XL,Y+$03	// 3
	cpi	XL,255	// $ff
	breq	L_87
	cpi	XL,0	// $00
	breq	L_90
	lds	r17,$0100	// 256
	cp	XL,r17
	breq	L_98
L_80:	st	X+,r16
	ldd	r17,Y+$07	// 7
	add	r17,r16
	std	Y+$07,r17	// 7
L_84:	std	Y+$03,XL	// 3
L_85:	std	Y+$06,YH	// 6
	rjmp	L_2A7
L_87:	cpi	r16,20	// $14
	brne	L_85
	ldd	r16,Y+$06	// 6
	cpi	r16,16	// $10
	brlo	L_85	// brcs
	ldi	r16,17	// $11
	std	Y+$07,r16	// 7
	inc	XL
	rjmp	L_84
L_90:	cpi	r16,1	// $01
	brlo	L_94	// brcs
	cpi	r16,30	// $1e
	brlo	L_96	// brcs
L_94:	ldi	XL,255	// $ff
	rjmp	L_84
L_96:	subi	r16,253	// $fd
	rjmp	L_80
L_98:	ldd	r17,Y+$07	// 7
	cp	r16,r17
	brne	L_94
	ldi	r16,17	// $11
	std	Y+$06,r16	// 6
	ldi	r16,36	// $24
	std	Y+$04,r16	// 4
	ldi	XL,1	// $01
	ld	r16,X+
	ld	r17,X+
	std	Y+$03,XL	// 3
	ldd	r18,Y+$08	// 8
	cp	r16,r18
	brne	L_A7
	rjmp	L_E9
L_A7:	cpi	r16,48	// $30
	breq	L_D5
	cpi	r16,74	// $4a
	breq	L_C5
L_AB:	ldi	r16,32	// $20
	std	Y+$04,r16	// 4
	std	Y+$05,r16	// 5
	ldi	r16,255	// $ff
	std	Y+$03,r16	// 3
	rjmp	L_2A7
L_B1:	ldd	XL,Y+$04	// 4
	cpi	XL,36	// $24
	breq	L_AB
	rcall	L_B6
	rjmp	L_2A7
L_B6:	mov	r20,XL
	subi	r20,36	// $24
	inc	XL
	std	Y+$05,XL	// 5
	ldi	XL,32	// $20
	std	Y+$04,XL	// 4
	ldi	r18,20	// $14
	st	X+,r18
	st	X+,r20
	st	X+,r16
	st	X+,r17
	ldi	r16,255	// $ff
	std	Y+$03,r16	// 3
	std	Y+$07,YH	// 7
	ret
L_C5:	lds	XL,$0100	// 256
	ld	r16,-X
	std	Y+$18,r16	// 24
	std	Y+$19,YH	// 25
	cpi	r16,0	// $00
	brne	L_CF
	clt
	bld	AFlags,1
	bld	AFlags,2
L_CF:	ldi	r16,32	// $20
	std	Y+$04,r16	// 4
	std	Y+$05,r16	// 5
	ldi	r16,255	// $ff
	std	Y+$03,r16	// 3
	rjmp	L_2A7
L_D5:	ldd	XL,Y+$03	// 3
	ld	r16,X+
	std	Y+$03,XL	// 3
	cpi	r16,128	// $80
	brne	L_E5
	ldi	XL,32	// $20
	std	Y+$04,XL	// 4
	ldi	r16,0	// $00
	bst	AFlags,1
	bld	r16,0
	bst	AFlags,2
	bld	r16,1
	st	X+,r16
	com	r16
	st	X+,r16
	std	Y+$05,XL	// 5
L_E5:	lds	XL,$0100	// 256
	std	Y+$03,XL	// 3
	rjmp	L_2A7
L_E9:	ldd	XL,Y+$03	// 3
L_EA:	ld	r16,X+
	std	Y+$03,XL	// 3
	cpi	r16,0	// $00
	brne	L_F9
	ld	r16,X+
	ld	r17,X+
	std	Y+$03,XL	// 3
	std	Y+$10,r16	// 16
	std	Y+$11,r17	// 17
	ldd	XL,Y+$04	// 4
	ldi	r16,128	// $80
	st	X+,r16
	st	X+,AFlags
	std	Y+$04,XL	// 4
	rjmp	L_133
L_F9:	cpi	r16,112	// $70
	brne	L_10D
	ld	ZH,X+
	ld	ZL,X+
	std	Y+$03,XL	// 3
	ldd	XL,Y+$04	// 4
	ldi	r17,240	// $f0
	st	X+,r17
	mov	r25,ZH
	andi	ZH,7	// $07
	lsr	r25
	lsr	r25
	lsr	r25
	breq	L_10B
L_107:	ld	r16,Z+
	st	X+,r16
	dec	r25
	brne	L_107
L_10B:	std	Y+$04,XL	// 4
	rjmp	L_133
L_10D:	cpi	r16,113	// $71
	brne	L_11D
	ld	ZH,X+
	ld	ZL,X+
	mov	r25,ZH
	andi	ZH,7	// $07
	lsr	r25
	lsr	r25
	lsr	r25
	breq	L_11B
L_117:	ld	r16,X+
	st	Z+,r16
	dec	r25
	brne	L_117
L_11B:	std	Y+$03,XL	// 3
	rjmp	L_133
L_11D:	cpi	r16,114	// $72
	brne	L_12D
	ld	ZH,X+
	ld	ZL,X+
	ld	r16,X+
	ld	r17,X+
	ld	r18,X+
	std	Y+$03,XL	// 3
	cli
	ldd	r19,Z+$00	// 0
	and	r19,r16
	or	r19,r17
	eor	r19,r18
	std	Z+$00,r19	// 0
	sei
	rjmp	L_133
L_12D:	cpi	r16,127	// $7f
	brne	L_130
	rjmp	L_F00
L_130:	lds	XL,$0100	// 256
	std	Y+$03,XL	// 3
L_133:	lds	r16,$0100	// 256
	ldd	XL,Y+$03	// 3
	cp	XL,r16
	brsh	L_139	// brcc
	rjmp	L_EA
L_139:	lds	r16,$0102	// 258
	ldd	r17,Y+$08	// 8
	rjmp	L_B1
L_13D:	ldi	r16,2	// $02
	out	TCCR2,r16
	ret
L_140:	ldi	r16,64	// $40
	out	TIFR,r16
	ldd	r16,Y+$06	// 6
	inc	r16
	breq	L_14A
	std	Y+$06,r16	// 6
	cpi	r16,8	// $08
	brne	L_14A
	ldi	r16,255	// $ff
	std	Y+$03,r16	// 3
L_14A:	ldd	r23,Y+$00	// 0
	ldd	r24,Y+$01	// 1
	ldd	r25,Y+$02	// 2
	subi	r23,255	// $ff
	sbci	r24,255	// $ff
	sbci	r25,255	// $ff
	std	Y+$00,r23	// 0
	std	Y+$01,r24	// 1
	std	Y+$02,r25	// 2
	cpi	r23,63	// $3f
	breq	L_156
	rjmp	L_162
L_156:	sbi	ADCSRA,6
	ldi	r16,23	// $17
	std	Y+$0a,r16	// 10
	ldd	r16,Y+$19	// 25
	inc	r16
	cpi	r16,20	// $14
	brlo	L_15F	// brcs
	std	Y+$18,YH	// 24
	ldi	r16,20	// $14
L_15F:	std	Y+$19,r16	// 25
	rcall	L_1D5
	rjmp	L_28F
L_162:	cpi	r23,3	// $03
	brne	L_178
	ldd	r16,Y+$18	// 24
	cpi	r16,0	// $00
	breq	L_16C
	sbrc	r24,2
	sbi	PORTD,6
	sbrs	r24,2
	cbi	PORTD,6
	rjmp	L_177
L_16C:	andi	r24,15	// $0f
	ldi	r17,4	// $04
	ldd	r16,Y+$19	// 25
	cpi	r16,20	// $14
	brlo	L_172	// brcs
	ldi	r17,12	// $0c
L_172:	cp	r24,r17
	brlo	L_176	// brcs
	cbi	PORTD,6
	rjmp	L_177
L_176:	sbi	PORTD,6
L_177:	rjmp	L_28F
L_178:	andi	r23,31	// $1f
	cpi	r23,1	// $01
	brne	L_17C
	rjmp	L_28F
L_17C:	andi	r23,31	// $1f
	cpi	r23,2	// $02
	brne	L_180
	rjmp	L_28F
L_180:	rjmp	L_28F
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
	std	Y+$18,YH	// 24
	ldd	r16,Y+$18	// 24
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
	ldd	r18,Y+$18	// 24
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
	rcall	L_13D
	rcall	L_60
	rcall	InitADC
	sei
L_28C:	in	r16,TIFR
	sbrc	r16,6
	rjmp	L_140
L_28F:	ldd	XL,Y+$04	// 4
	ldd	r17,Y+$05	// 5
	cp	XL,r17
	breq	L_2A3
	sbis	UCSRA,5
	rjmp	L_2A7
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
	rjmp	L_2A7
L_2A3:	sbic	UCSRA,6
	cbi	PORTD,2
	sbic	UCSRA,7
	rjmp	L_76
L_2A7:	ldd	r16,Y+$0a	// 10
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


.ORG	$F00
L_F00:	


/*

;------ BOOTLOADER ------
.macro	InitPorts  ; <- Initial ports state
	outi	PORTB,0b000000
	outi	DDRB, 0b000000
	outi	PORTC,0b000000
	outi	DDRC, 0b000000
	outi	PORTD,0b00000000
	outi	DDRD, 0b00000000
.endm
#define	UART_DIR_PORT	PORTD,2	; <- UartDir
#define	UART_DIR_DDR	 DDRD,2
.equ	CPU_FREQ  = 8000000	; <- FCPU
.equ	UART_RATE = 9600	; <- BAUD RATE
.equ	UBRRB_V   = (CPU_FREQ/(16*UART_RATE)-1)


.macro	TR_Start
#ifdef	UART_DIR_PORT
	sbi	UART_DIR_PORT
#endif
	sbi	UCSRA,6
.endm

.macro	TR_Wait
	sbis	UCSRA,6
	rjmp	PC-1
#ifdef	UART_DIR_PORT
	cbi	UART_DIR_PORT
#endif
.endm
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

;--- Обмен "приветстивием" $A5-$5A ---
	in	r16,UDR
	TR_Start
	outi	UDR,$A5	; Отправка признака входа в загрузчик
	TR_Wait
	ldi	r18,High(65000)
BTL_1:	subi_w	r18,r17,1
	brne	BTL_2
BTL_3:	rjmp	BTL_EX
BTL_2:	sbis	UCSRA,RXC
	rjmp	BTL_1
	in	r16,UDR
	cpi	r16,$5A
	brne	BTL_3
;--- Инициализация загрузчика
	outi	TCCR1B,0b011	; CK/64 -> 8e6/64/65536 = 1.907Hz Overflow
	ldi	r25,58		; Счетчик выхода из загрузчика через 30 сек
;--- Получение посылки по UART ---
BTL_9: 	ldi	XL,0
	ldi	r24,0
BTL_4:	in	r16,TIFR
	sbrs	r25,7
	sbrs	r16,TOV1
	rjmp	BTL_5
	outi	TIFR,1<<TOV1
	dec	r25
	breq	BTL_3
BTL_5:	sbis	UCSRA,RXC
	rjmp	BTL_4
	in	r16,UDR
	cpi	XL,0
	brne	BTL_6
	cpi	r16,'B'
	brne	BTL_4
BTL_8:	add	r24,r16
	st	X+,r16
	rjmp	BTL_4
BTL_6:	cpi	XL,1
	brne	BTL_7
	ldi	r23,3+64
	cpi	r16,'W'
	breq	BTL_8
	ldi	r23,3
	cpi	r16,'R'
	breq	BTL_8
	ldi	r23,2+6
	cpi	r16,'O'
	breq	BTL_8
	ldi	r23,2
	cpi	r16,'I'
	breq	BTL_8
	ldi	r23,2
	cpi	r16,'Q'
	breq	BTL_8
	ldi	r23,4
	cpi	r16,'E'
	breq	BTL_8
	rjmp	BTL_9
BTL_7:	cp	XL,r23
	brlo	BTL_8
	cp	r24,r16
	brne	BTL_9
	sbrs	r25,7
	ldi	r25,58

;--- Обработка команд ---
	ldi	XL,0
	ldi	r16,'b'
	st	X+,r16
	ld	r16,X+
	cpi	r16,'W'	;--- Запись страницы ---
	brne	BWP_1
	ld	ZH,X+
	rcall	ERASE_PAGE
BWP_2:	ld	r0,X+
	ld	r1,X+
	ldi	r16,1<<SPMEN
	rcall	DO_SPM
	subi	ZL,-2
	cpi	XL,3+64
	brlo	BWP_2
	subi	ZL,64
	ldi	r16,(1<<PGWRT) | (1<<SPMEN)
	rcall	DO_SPM
BWP_3:	ldi	r16,(1<<RWWSRE) | (1<<SPMEN)
	rcall	DO_SPM
	in	r16,SPMCR
	sbrc	r16,RWWSB
	rjmp	BWP_3
	ldi	r25,$FF
	ldi	r23,3
	rjmp	BSU_3
BWP_1:
	cpi	r16,'E'	;--- Стирание страниц ---
	brne	BEP_1
	ld	r10,X+
	ld	r11,X+
BEP_2:	mov	ZH,r10
	rcall	ERASE_PAGE
	cp	r10,r11
	brsh	BEP_3
	inc	r10
	rjmp	BEP_2
BEP_3:	ldi	r25,$FF
	ldi	r23,4
	rjmp	BSU_3
BEP_1:

	cpi	r16,'R'	;--- Чтение страницы ---
	brne	BRP_1
BRP_3:	in	r17,SPMCR
	sbrc	r17,SPMEN
	rjmp	BRP_3
	ld	ZH,X+
	ldi	ZL,0
	lsr16	ZH,ZL
	lsr16	ZH,ZL
	ldi	XL,3
BRP_2:	lpm	r16,Z+
	st	X+,r16
	cpi	XL,3+64
	brlo	BRP_2
	ldi	r23,64+3
	rjmp	BSU_3
BRP_1:
	cpi	r16,'O'	;--- Установка GPIO ---
	brne	BOP_1
	ldi	ZL,$39
	ldi	ZH,0
BOP_2:	ld	r16,X+
	ld	r17,X+
	st	-Z,r16
	st	-Z,r17
	dec	ZL
	cpi	XL,2+6
	brlo	BOP_2
	rjmp	BIP_3
BOP_1:
	cpi	r16,'I'	;--- Чтение GPIO ---
	brne	BIP_1
BIP_3:	ldi	ZL,$39
	ldi	ZH,0
	ldi	XL,2
BIP_2:	ld	r16,-Z
	st	X+,r16
	cpi	XL,2+9
	brlo	BIP_2
	ldi	r23,2+9
	rjmp	BSU_3
BIP_1:
;--- Выход из загрузчика ---
BTL_EX:	InitPorts
	out	UCSRB,YH
 	rjmp	0

;--- Отправка данных из буфера UART ---
BSU_3:	ldi	r17,9
BSU_4:	subi_w	r17,r16,1
	brcc	BSU_4
	TR_Start
	ldi	r24,0
	ldi	XL,0
BSU_1:	sbis	UCSRA,UDRE
	rjmp	BSU_1
	ld	r16,X+
	out	UDR,r16
	add	r24,r16
	cp	XL,r23
	brlo	BSU_1
BSU_2:	sbis	UCSRA,UDRE
	rjmp	BSU_2
	out	UDR,r24
	TR_Wait
	rjmp	BTL_9

ERASE_PAGE:
	ldi	ZL,0
	lsr16	ZH,ZL
	lsr16	ZH,ZL
	ldi	r16,(1<<PGERS) | (1<<SPMEN)
	rcall	DO_SPM
	ldi	r16,(1<<RWWSRE) | (1<<SPMEN)
	rjmp	DO_SPM

;--- Процедурка из мануалки ---
DO_SPM:	in	r17,SPMCR
	sbrc	r17,SPMEN
	rjmp	DO_SPM
DSPM_1:	sbic	EECR,EEWE
	rjmp	DSPM_1
	out	SPMCR,r16
	spm
	ret
	
.db	"The end of boot+"

*/
