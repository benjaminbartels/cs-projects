;  Benjamin Bartels
;  Section #1002
;  CS 218, Assignment #6
;  Provided Main

;	Write a simple assembly language program to calculate
;	calculate the some statistical information for a series
;	of trapezoid areas.

;	The area's are provided as hex values represented as ASCII
;	characters and must be converted into integer in order to
;	perform the calculations.


; --------------------------------------------------------------
;  Macro to convert hex value in ASCII format into an integer.
;  Assumes valid data, no error checking is performed.

;	Call:	ahexToInt  <string>, <integer>, <stringLength>
;	Arguments:
;		%1 -> <string>, string address
;		%2 -> <integer>, address (for result)
;		%3 -> <stringLength>, value

;  Reads <string>, converts to integer and places in <integer>
;  Note, should preserve any registers that the macro alters.

%macro	ahexToInt	3
	push	eax				; save original register contents
	push	ebx
	push	ecx
	push	esi

	; init registers
	mov ecx, %3
	mov ebx, 0

	; rSum = 0
	mov dword [resultSum], 0
	mov dword [intDigit], 0

	; start loop
	%%hexToIntLoop:

		; get char
		mov eax, 0
		mov al, byte [%1 + ebx]

		; convert char to int digit

		; "0"-"9" => -"0"
		cmp al, "9"
		jg %%not0Thru9
		sub al, "0"
		jmp %%done

	%%not0Thru9:

		; "A"-"F" => -"A"+10
		cmp al,	"F"
		jg %%notAThruF
		sub al, "A"
		add al, 10
		jmp %%done

	%%notAThruF:

		; "a"-"f" => -"a"+10
		sub al, "a"
		add al, 10

	%%done:

		; convert int digit to DWord
		cbw
		cwde
		mov dword [intDigit], eax

		; rSum = rSum * 16
		mov eax, dword [resultSum]
		mul dword [ddsixteen]

		; rSum = rSum + int digit
		add eax, dword [intDigit]
		mov dword [resultSum], eax

		; inc strg addr (+1)
		inc ebx

		; loop 8 times
		loop %%hexToIntLoop

	;mov dword [resultSum], eax
	mov  [%2],  eax

	; restore original register contents
	pop	esi
	pop	ecx
	pop	ebx
	pop	eax
%endmacro


; --------------------------------------------------------------
;  Macro to convert integer to hex value in ASCII format.

;	Call:	intToAhex    <integer-value>, <string-address>, <length-value>
;	Arguments:
;		%1 -> <integer>, value
;		%2 -> <string>, string address
;		%3 -> <string length>, value

;  Reads <string>, place count including NULL into <count>
;  Note, should preserve any registers that the macro alters.

%macro	intToAhex	3
	push	eax
	push	ecx
	push	edx
	push	edi

	mov edi, 0

	; get integer
	mov eax, %1

	; start loop 1
	mov ecx, %3
	%%divideLoop:

		; divide by 16
		mov edx, 0
		div dword [ddsixteen]

		; push remainder
		push edx

		; loop 8 times
		loop %%divideLoop


	; start loop 2
	mov ecx, %3
	%%convertLoop:

		; pop stack
		pop eax

		; 0-9 => +"0"
		cmp eax, 9
		jg %%not0thru9
		add eax, "0"
		jmp %%done

	%%not0thru9:

		; 10-15 => -10+"A"
		sub eax, 10
		add eax, "A"

	%%done:

		; put char in strg
		mov byte [%2 + edi], al

		; inc string addr (+1)
		inc edi

		; loop 8 times
		loop %%convertLoop

	pop	edi
	pop	edx
	pop	ecx
	pop	eax
%endmacro


; --------------------------------------------------------------
;  Simple macro to display a string.
;	Call:	printString  <string-address>, <length-value>

;	Arguments:
;		%1 -> <string>, string address
;		%2 -> <length>, value

;  Display <length> characters starting at address <string>

%macro	printString	2
	push	eax		; save altered registers
	push	ebx
	push	ecx
	push	edx

	mov	eax, 4		; system call for write (sys_write)
	mov	ebx, 1		; file descriptor 1 -> standard output
	lea	ecx, [%1]	; address of the string in ecx
	mov	edx, %2		; length of the string in edx
	int	80h		; call the kernel

	pop	edx		; restore registers to original values
	pop	ecx
	pop	ebx
	pop	eax
%endmacro


; --------------------------------------------------------------

section	.data

; -----
;  Constants.

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

NUMS_PER_LINE	equ	5


; -----
;  Assignment #6 Provided Data

STRLENGTH	equ	8

hexAreas	db	"00000A23", "00000C13", "000a1000", "001bfA1D", "0000215F"
		db	"00A01005", "00000FF9", "00000E43", "00000C5A", "00000146"
		db	"00000E69", "000b1783", "00000181", "000006C3", "000D1F43"
		db	"00000143", "000005B9", "00000E27", "00000E29", "00000ABC"
		db	"0000ab12", "000A1323", "00000057", "000D6214", "000cd1d9"
		db	"00000004", "000A1C1D", "00CD1A51", "00a1f178", "00000ACA"
		db	"00000c03", "00000003", "0000025F", "00001005", "00000169"
		db	"00000E43", "00000E43", "00000103", "00000043", "00000012"

length		dd	40

areasSum	dd	0
areasAve	dd	0


; -----
;  Misc. variables for main.

hdr		db	LF, "-----------------------------------------------------"
		db	LF, ESC, "[1m", "CS 218 - Assignment #6", ESC, "[0m", LF
		db	"Trapezoid Information", LF, LF
		db	"Area's:", LF, NULL
HLEN		equ	$-hdr

shdr		db	LF, "Area's Sum:  ", NULL
SLEN		equ	$-shdr

avhdr		db	LF, "Area's Ave:  ", NULL
AVLEN		equ	$-avhdr

numCount	dd	0
tempNum		dd	0

newLine		db	LF, NULL
ddsixteen	dd	16
ddtwo		dd	2
spaces		db	"   ", NULL

; -----
;  Misc. variables for macros.
resultSum	dd	0
intDigit	dd	0

; --------------------------------------------------------------
;  Uninitialized (empty) variables

section	.bss

intAreas	resd	40
tempString	resb	20

; --------------------------------------------------------------

section	.text
global	_start
_start:

; -----
;  Display assignment initial headers.

	printString	hdr, HLEN

; -----
;  Display each of the trapezoid areas.
;  For every 5th line, print a newLine (for formatting).

	mov	ecx, dword [length]
	mov	esi, 0
	mov	dword [numCount], 0

printLoop:
	printString	hexAreas+esi, STRLENGTH
	printString	spaces, 4

	inc	dword [numCount]
	cmp	dword [numCount], NUMS_PER_LINE
	jl	skipNewline
	printString	newLine, 1
	mov	dword [numCount], 0
skipNewline:

	add	esi, STRLENGTH

	dec	ecx
	cmp	ecx, 0
	jne	printLoop

; -----
;  Convert areas from hex (in ASCII format) to integer.

	mov	ecx, dword [length]
	mov	esi, 0

cvtAreasLoop:
	ahexToInt	hexAreas+esi, tempNum, STRLENGTH

	mov	eax, dword [tempNum]
	mov	dword [intAreas+edi*4], eax

	add	esi, STRLENGTH
	inc	edi

	dec	ecx
	cmp	ecx, 0
	ja	cvtAreasLoop

; -----
;  Sum the areas and compute average.

	mov	ecx, dword [length]
	mov	esi, 0
	mov	eax, 0

areasSumLoop:
	add	eax, dword [intAreas+esi*4]
	inc	esi
	loop	areasSumLoop

	mov	dword [areasSum], eax

	cdq
	idiv	dword [length]
	mov	dword [areasAve], eax

; -----
;  Convert sum and average to hex (in ASCII format) for printing.

	printString	shdr, SLEN
	intToAhex	dword [areasSum], tempString, STRLENGTH
	printString	tempString, STRLENGTH

	printString	avhdr, AVLEN
	intToAhex	dword [areasAve], tempString, STRLENGTH
	printString	tempString, STRLENGTH

	printString	newLine, 1
	printString	newLine, 1

; -----
; Done, terminate program.

last:
	mov	eax, 1
	mov	ebx, 0
	int	80h

