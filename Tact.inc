//----------------------------------------
InitTact:
	outi	TCCR2,0b010	; CK/8 -> 8e6/8/256 = 3906.25
	ret

//----------------------------------------
.macro	tskTact
	in	r16,TIFR
	sbrc	r16,TOV2
	rjmp	Tact
.endm

//----------------------------------------
Tact:	outi	TIFR,1<<TOV2
;**** RXTimer ****
	ldd	r16,Y+yRXTimer
	inc	r16
	breq	rxtm_1
	std	Y+yRXTimer,r16
	cpi	r16,UARTByteDelay
	brne	rxtm_1
	stdi	yRXPointer,RXBuf-1
rxtm_1:
;**** RXTimer ****

;-- MainCnt 24bit
	ldd	r23,Y+yMainCntL
	ldd	r24,Y+yMainCntM
	ldd	r25,Y+yMainCntH
	subi_w	r24,r23,-1
	sbci	r25,$FF
	std	Y+yMainCntL,r23
	std	Y+yMainCntM,r24
	std	Y+yMainCntH,r25

;--- Br1 ---
	cpi	r23,0b00111111	; 15.25 Hz
	breq	st_BR1
	rjmp	sk_BR1
st_BR1:
	StartADC
	ldd	r16,Y+yNoRequestCnt
	inc	r16
	cpi	r16,20
	brlo	br1_1
	std	Y+yHeating,ZeroReg
	ldi	r16,20
br1_1:	std	Y+yNoRequestCnt,r16
	rcall	L_1D5	; Need name
	rjmp	RetTact
sk_BR1:

;--- Br2 ---
	cpi	r23,0b00000011	; 15.25 Hz
	brne	sk_BR2
	ldd	r16,Y+yHeating
	cpi	r16,0
	breq	br2_1
	sbrc	r24,2
	sbi	LED
	sbrs	r24,2
	cbi	LED
	rjmp	br2_2
br2_1:	andi	r24,0b1111
	ldi	r17,4
	ldd	r16,Y+yNoRequestCnt
	cpi	r16,20
	brlo	br2_3
	ldi	r17,12
br2_3:	cp	r24,r17
	brlo	br2_4
	cbi	LED
	rjmp	br2_2
br2_4:	sbi	LED
br2_2:	rjmp	RetTact
sk_BR2:

;--- Br3 ---
	andi	r23,0b00011111	; 122.08 Hz
	cpi	r23,0b00000001
	brne	skBR3
	rjmp	RetTact
skBR3:

;--- Br4 ---
	andi	r23,0b00011111	; 122.08 Hz
	cpi	r23,0b00000010
	brne	skBR4
	rjmp	RetTact
skBR4:
	rjmp	RetTact
