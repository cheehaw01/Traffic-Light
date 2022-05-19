; traffic light

	ORG	00h
	AJMP	MAIN

MAIN:	MOV	A, #00h
	MOV	P0, A		;set port 0 as output
	MOV	P1, A		;set port 1 as output
	MOV	P2, A		;set port 2 as output
	MOV	P3, A		;set port 3 as output
	MOV	R2, #0Ah
	MOV	DPTR, #SEG	;move table address to Data Point
	AJMP	START

START:	MOV	A, #01h
	MOV	P1, A
	MOV	A, #0FEh
	MOV	P2, A
	MOV	A, #0FEh
	MOV	P3, A
	MOV	A, R2
	AJMP	GO1

GO1:	SUBB	A, #01h
	MOV	R1, A
	ANL	A, #0FH
	MOVC	A, @A+DPTR	;load value from table
	MOV	P0, A
	MOV	A, R1
	ACALL	DELAY
	CJNE	A, #00h, GO1
	MOV	P0, A
	ACALL	GREEN		;off current green led
	ACALL	YELLOW		;yellow led on for a while then off
	MOV	A, P1
	RL	A
	CJNE	A, #10h, GO2
	MOV	A, #01h
	AJMP	GO2

GO2:	MOV	P1, A
	ACALL	GREEN		;on next green led
	MOV	A, R2		;load from register 2
	ADD	A, #00h
	AJMP	GO1

YELLOW:	MOV	A, P2
	RL	A
	MOV	P2, A
	ACALL	DELAY
	ACALL	DELAY
	ACALL	DELAY
	MOV	A, P2
	RL	A
	MOV	P2, A
	RET

GREEN:	MOV	A, P3
	RL	A
	MOV	P3, A
	RET

;delay subroutine
DELAY:	MOV	R1, #05h
DELAY1:	DJNZ	R1, DELAY1
	RET

;lookup table for 7- segment display pattern
SEG:	DB	3Fh, 06h, 5Bh, 4Fh, 66h, 6Dh, 7Dh, 07h, 7Fh, 6Fh, 77h, 7Ch, 39h, 5Eh, 79h, 71h

	END