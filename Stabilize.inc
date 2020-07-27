#define	V_RANGE		15.56
#define	V_MAX		12.0
#define	V_MAX_K		(V_MAX*655.36/V_RANGE+0.5)
#define	V_BREAK_MIN	2.5
#define	V_BREAK_MIN_ADC	(V_BREAK_MIN*256.0/V_RANGE+0.5)
#define	I_RANGE		125.0 // -62.5 ... 62.5A
#define	I_ZERO_ADC	32768.0
#define	I_MAX		25.0
#define	I_MAX_ADC	(I_ZERO_ADC-I_MAX*65536.0/I_RANGE+0.5)

Set_U_Fan:
	ldi	r16,10	// Reset FAN intro counter
	sbis	FAN
	std	Y+yFanBeforeCnt,r16

	sbrc	AFlags,afStringShorted
	std	Y+yHeating,ZeroReg

	ldd	r16,Y+yHeating // If Heating is on
	cpi	r16,0
	breq	sfu_1
	sbi	FAN			// start FAN
	ldi	r17,40
	std	Y+yFanAfterCnt,r17	// reset FAN afterword counter
	ldd	r16,Y+yFanBeforeCnt	// downcount Fan intro counter
	subi	r16,1
	brcs	sfu_2			// allow heating after FAN intro
	std	Y+yFanBeforeCnt,r16
	rjmp	sfu_3
sfu_1:
	ldd	r16,Y+yFanAfterCnt // Else ( Heating is off )
	subi	r16,1			// downcount FAN afterword counter
	brcc	sfu_4
	cbi	FAN			// stop FAN if afterword finished
	ldi	r16,0
sfu_4:	std	Y+yFanAfterCnt,r16
sfu_3:	in	r16,MCUCR		// if PWM is active
	cpi	r16,0
	breq	sfu_5
	rcall	StopPWM			// stop it
sfu_5:	std	Y+yDestUL,ZeroReg	// Set U = 0
	std	Y+yDestUH,ZeroReg
	ret

sfu_2:	// --- Heating is allowed ---
	in	r16,MCUCR  // If PWM isn't active
	cpi	r16,0
	brne	sfu_6
	rcall	StartPWM	// start it
sfu_6:
	ldd	r18,Y+yHeating	// Limit to 100 %
	cpi	r18,100	
	brlo	sfu_7
	ldi	r18,100
sfu_7:
	ldi_w	r17,r16,V_MAX_K // Calculate Udest
	mul	r16,r18
	movw	r21:r20, r1:r0
	mul	r17,r18
	add	r21,r0
	std	Y+yDestUL,r20
	std	Y+yDestUH,r21
	ret

//------------------------------------------------
Stabilize:
	clt
	bld	AFlags,afADCComplete
	ldd	r16,Y+yDestUL
	ldd	r17,Y+yDestUH
	or	r16,r17
	brne	st_1
	std	Y+yPWML,ZeroReg
	std	Y+yPWMH,ZeroReg
	rjmp	st_2
st_1:	
	GetADC	adcU	// -- DeltaU --
	cpi	r17,V_BREAK_MIN_ADC	// No string break break if V<V_BREAK_MIN
	brlo	st_3
	set
	sbis	STR_BR_IN
	bld	AFlags,afStringBroken
st_3:	lsr16	r17,r16
	ldd	r18,Y+yDestUL
	ldd	r19,Y+yDestUH
	lsr16	r19,r18
	sub	r18,r16
	sbc	r19,r17

	GetADC	adcI	// -- DeltaI --
	lsr16	r17,r16
	ldi_w	r21,r20,I_MAX_ADC
	lsr16	r21,r20
	sub	r16,r20
	sbc	r17,r21

	cp	r16,r18 // Check minimal (positive increases PWM)
	cpc	r17,r19
	brlt	st_4
	movw	r17:r16, r19:r18
st_4:	bst	r17,7	// If result is negative, calc module and set T
	brtc	st_5
	com	r17
	com	r16
	subi_w	r17,r16,-1
st_5:
	cpi	r17,0	// Assign minimal diff if it's too small
	brne	st_2
	cpi	r16,64
	brlo	st_2
	ldi	r17,1
st_2:
	ldd	r24,Y+yPWML	// Izero (not used)
	ldd	r25,Y+yPWMH
	cp	r24,ZeroReg
	cpc	r25,ZeroReg
	brne	st_6
	GetADC_	r19,r18,adcI
	std	Y+yIzeroL,r18
	std	Y+yIzeroH,r19
st_6:
	brts	st_7
	add	r24,r17
	adc	r25,ZeroReg
	cpi_w	r25,r24, PWM_PERIOD, r17
	brlo	st_8
	ldi_w	r25,r24,PWM_PERIOD
	rjmp	st_8
st_7:
	sub	r24,r17
	sbc	r25,ZeroReg
	brcc	st_8
	ldi_w	r25,r24,0
st_8:
	std	Y+yPWML,r24
	std	Y+yPWMH,r25

	ldd	r16,Y+yPWML
	ldd	r17,Y+yPWMH
	ldi_w	r19,r18,PWM_PERIOD
	sub	r18,r16
	sbc	r19,r17
	out	OCR1AH,r19
	out	OCR1AL,r18
	sei
	ret
