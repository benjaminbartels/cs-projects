;  CS 218 - Assignment 8
;  Procedures Template.

;  Benjmain Bartels
;  Section #1002

; --------------------------------------------------------------------
;  Write four assembly language procedures.

;  The first procedure, shellSort(), sorts the numbers into descending
;  order (large to small).  Uses the shell sort algorithm (from asst #7).

;  The second procedure, basicStats(), finds the minimum, median, and maximum,
;  for a list of numbers.  Note, for an odd number of items, the median value
;  is defined as the middle value.  For an even number of values, it is
;  the integer average of the two middle values.

;  The third procedure, advancedStats(), finds the sum and average for
;  a list of numbers.

;  The fourth procedure, linearRegression(), to should compute the linear
;  regression values (b0 and b1) for the two data sets.

;  Summation and division performed as integer values.
;  Due to the data sizes, the summation for the dividend (top)
;  must be performed as a quad-word.


; ----------

section	.data

; -----
;  Define constants.

TRUE	equ	0
FALSE	equ	-1


; -----
;  Local variables for shellSort() procedure.
h	dd	0
ddThree	dd	3
len	dd	0

; -----
;  Local variables for basicStats() procedure (if any).



; -----
;  Local variables for advancedStats() procedure (if any). 



; -----
;  Local variables for linearRegression() procedure (if any).
b1Num		dq	0
b1Denom		dq	0

; --------------------------------------------------------

section	.text


; --------------------------------------------------------
;  Shell sort procedure.
;	Note, modified to sort in desending order

; -----
; Shell Sort

;	h = 1;
;       while ( (h*3+1) < a.length) {
;	    h = 3 * h + 1;
;	}

;       while( h > 0 ) {
;           for (i = h-1; i < a.length; i++) {
;               tmp = a[i];
;               j = i;
;               for( j = i; (j >= h) && (a[j-h] > tmp); j -= h) {
;                   a[j] = a[j-h];
;               }
;               a[j] = tmp;
;           }
;           h = h / 3;
;       }

; -----
;  Call:
;	call shellSort(list, len)

;  Arguments Passed:
;	1) list, addr - 8
;	2) length, value - 12

global	shellSort
shellSort:

	push ebp
	mov ebp, esp
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi

	; i 		-> esi
	; j 		-> edi
	; tmp 		-> ebx
	; lst		-> ecx

	mov eax, dword [ebp + 12] 
	mov dword [len], eax
	mov ecx, dword [ebp + 8]

	; var h = 1;
	mov dword [h], 1

	; while ((h * 3 + 1) < length)
	firstWhileLoop:
	
		; calc first while operand
		mov eax, dword [h]
		mul dword [ddThree]
		inc eax

		; if (h * 3 + 1) >= length
		cmp eax, dword [len]			; eax = h * 3 + 1
		jge firstWhileLoopDone

		; else continue firstWhile
		mov dword [h], eax
		jmp firstWhileLoop

	firstWhileLoopDone:

	; while (h > 0)
	secondWhileLoop:

		; if h <= 0
		cmp dword [h], 0
		jle secondWhileLoopDone

		; else continue secondWhile

		; for (var i = h - 1; i < length; i++)

		; outer for loop init statment
		; i = h - 1
		mov esi, dword [h]
		dec esi

		outerForLoop:

			; outer for loop test statment
			; i < length
			; if i >= length
			cmp esi, dword [len]
			jge outerForLoopDone

			; else continue outer for loop

			; var tmp = lst[i];
			mov ebx, dword [ecx + esi * 4]

			; for (j = i; (j >= h) && (lst[j - h] > tmp); j = j - h)

			; inner for loop init statment
			; j = i
			mov edi, esi

			innerForLoop:

				; inner for loop test statment
				; (j >= h) && (lst[j - h] < tmp)
				; if (j < h)
				cmp edi, dword [h]
				jl innerForLoopDone

				; -OR-
				
				; if (lst[j - h] >= tmp)
				mov eax, edi
				sub eax, dword [h]
				mov eax, dword [ecx + eax * 4]
				cmp eax, ebx
				jge innerForLoopDone

				; else continue inner for loop
				
				; lst[j] = lst[j - h];
				mov dword [ecx + edi * 4], eax 	; its already in eax				

				; inner for loop increment statment
				; j = j - h
				sub edi, dword [h]		

				jmp innerForLoop
		
			innerForLoopDone:

			; lst[j] = tmp;	
			mov dword [ecx + edi * 4], ebx			

			; outer for loop increment statment
			; i++
			inc esi

			jmp outerForLoop 

		outerForLoopDone:		

		; h = h / 3;
		mov eax, dword [h]
		mov edx, 0
		div dword [ddThree]
		mov dword [h], eax
		jmp secondWhileLoop
		
	secondWhileLoopDone:

	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret

; --------------------------------------------------------
;  Find basic stats for list:
;	minimum, median, maximum

;   Note, for an odd number of items, the median value is defined as
;   the middle value.  For an even number of values, it is the integer
;   average of the two middle values.
;   The median must be determined after the list is sorted.

; -----
;  Call:
;	call basicStats(list, len, min, med, max)

;  Arguments Passed:
;	1) list, addr - 8
;	2) length, value - 12
;	3) minimum, addr - 16
;	4) median, addr - 20
;	5) maximum, addr - 24

global basicStats
basicStats:

	push ebp
	mov ebp, esp
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi

	; get max
	mov ebx, dword [ebp + 8]
	mov eax, dword [ebx]
	mov edi, dword [ebp + 24]
	mov dword [edi], eax

	; get min
	mov esi, dword [ebp + 12]
	dec esi
	mov eax, dword [ebx + esi * 4]
	mov edi, dword [ebp + 16]
	mov dword [edi], eax

	; calculate median
	mov esi, dword [ebp + 12]
	shr esi, 1
	mov eax, dword [ebx + esi * 4]
	mov ecx, 1
	and ecx, dword [ebp + 12]
	cmp ecx, 1
	je medianDone
	dec esi
	add eax, dword [ebx + esi * 4]
	shr eax, 1

	medianDone:

		mov edi, dword [ebp + 20]
		mov dword [edi], eax

		pop edi
		pop esi
		pop edx
		pop ecx
		pop ebx
		pop eax
		pop ebp
		ret

; --------------------------------------------------------
;  Find advanced stats for list:
;	sum and average

; -----
;  Call:
;	call advancedStats(list, len, sum, ave)

;  Arguments Passed:
;	1) list, addr - 8
;	2) length, value - 12
;	3) sum, addr - 16
;	4) average, addr - 20

global advancedStats
advancedStats:

	push ebp
	mov ebp, esp
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi

	; init registers
	; list
	mov ebx, dword [ebp + 8] 
	; sum
	mov eax, 0
	; index
	mov esi, 0
	; length
	mov ecx, dword [ebp + 12] 

	; ecx is off limits!
        sumLoop:

		; get next item in list
		mov edi, dword [ebx + esi * 4]

		; add to sum
		add eax, edi

		inc esi
		loop sumLoop

	mov edi, dword [ebp + 16]
	mov dword [edi], eax

	; calculate average
	cdq
	idiv dword esi

	mov edi, dword [ebp + 20]
	mov dword [edi], eax

	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret

; --------------------------------------------------------
;  Calculates the linear regression
;  Must track summation as a quad-word.

; -----
;  Call:
;	call linearRegression(xList, yList, len, b0, b1)

;  Arguments passed:
;	1) xList, addr - 8
;	2) yList, addr - 12
;	3) length, value - 16
;	4) xAve, value - 20
;	5) yAve, value - 24
;	4) b0, addr - 28
;	4) b1, addr - 32

global linearRegression
linearRegression:

	push ebp
	mov ebp, esp
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi

	mov dword[b1Num], 0
	mov dword[b1Num + 4], 0

	mov dword[b1Denom], 0
	mov dword[b1Denom + 4], 0

	mov eax, 0
	mov edx, 0
	mov esi, 0
	mov ecx, dword [ebp + 16] 

	numeratorLoop:

		mov ebx, dword [ebp + 8]	; xList
		mov eax, dword [ebx + esi * 4]	; xList item
		sub eax, dword [ebp + 20]	; xList item - xAve

		mov ebx, dword [ebp + 12]	; yList
		mov edi, dword [ebx + esi * 4]	; yList item
		sub edi, dword [ebp + 24]	; yList item - yAve	
		imul edi			; (xList item - xAve) * (yList item - yAve)
		add dword [b1Num], eax		; add to b1Num
		adc dword [b1Num + 4], edx	; add to b1Num

		inc esi;

		loop numeratorLoop

	mov eax, 0
	mov edx, 0
	mov esi, 0
	mov ecx, dword [ebp + 16] 

	denominatorLoop:

		mov ebx, dword [ebp + 8]	; xList
		mov eax, dword [ebx + esi * 4]	; xList item
		sub eax, dword [ebp + 20]	; xList item - xAve
		imul eax
		add dword [b1Denom], eax	; add to b1Denom
		adc dword [b1Denom + 4], edx	; add to b1Denom

		inc esi;

		loop denominatorLoop

	mov eax, [b1Num]
	mov edx, [b1Num + 4]
	idiv dword [b1Denom]

	mov edi, dword [ebp + 32]
	mov dword [edi], eax

	imul dword [ebp + 20]

	mov ebx, dword [ebp + 24]
	sub ebx, eax

	mov edi, dword [ebp + 28]
	mov dword [edi], ebx

	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret

; --------------------------------------------------------

