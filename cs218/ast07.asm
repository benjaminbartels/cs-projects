;	Benjmain Bartels
;	assignmnet #7
;	section #1002


; ----------------------------------------------
          
section	.data

lst	dd	 1113, -1232,  2146, 13376,  5120, 22356, 23164, 34565, 43155, 23157
	dd	-1001,   128,    33,   105,  8327,   101,   115,   108, 12233, -2115
	dd	 1227,  1226,  5129,   117,   107,   105,   109,   730,  -150,  3414
	dd	 1107,  6103,  1245,  6440,   465, 12311,   254,  4528,   913,  6722
	dd	-1149,  2126,  5671,  4647,  4628,  -327, -2390,   177,  8275,  5614
	dd	 3121,   415,  -615,    22,  7217,   -11,    10,   129,  -812,  2134
	dd	-1221,   -34,  6151,   432,   114,   629,   114,   522,  2413,   131
	dd	 5639,   126,    62,    41,   127,  -877,   199,  5679,   101,  3414
	dd	  117,    54,    40,   172,  4524,   125,    16,  9762,     0, 11292
	dd	-2101,   133,   133,    50,  4532,  8619,    15,  1618,   113,  -115
	dd	 1219,  3116,   -62,    17,   127,  6787,  4569,    79, 15675,    14
	dd	 1104,  6825,    84,    43,    76,   134, -4626,   100,  4566,  2346
	dd	   14,  6786,   617,   183, -3512,  7881, -8320,  3467,  4559, -1190
	dd	  103,   112,   146,   186,   191,   186,   134,  1125, -5675,  3476
	dd	 2137,  2113, -1647,   114,    15, -6571, -7624,   128,   113,  3112
	dd	  724,  6316,    17,   183, -4352,   121,   320,  4540,  5679, -1190
	dd	 9125,   116,   122,   117,   127,  5677,   101,  3727,   125,  3184
	dd	  897,  6374,   190,     3,    24,   125,   116,  8126,  6784, 12329
	dd	  104,   124,   112,   143,   176,  7534,  2126,  6112,   156,  1103
	dd	 6759,  6326,    71,   147, -5628,  7527,  7569,   177,  6785,  3514
	dd	  153,   172,   146,   176,   170,   156,   164,   165,  -155,  5156
	dd	  894,  6325,    84,    43,    76,  5634,  7526,  3413,  7686,  7563
	dd	  147,   113,  -143,   140,   165,   191,   154,   168,   143,   162
	dd	  511,  6383,   133,    50,  -825,  5721,  5615,  4568,  7813,  1231
	dd	  169,   146,   162,   147,   157,   167,   169,   177,   175,  2144
	dd	 5527,  6364,    30,   172,    24,  7525,  5616,  5662,  6328,  2342
	dd	  181,   155,   145,   132,   167,   185,   150,   149,   182,   434
	dd	 6581,  3625,  6315,     9,  -617,  7855, 16737,   129,  4512,   134
	dd	  177,   164,   160,   172,   184,   175,   166,  6762,   158,  4572
	dd	 6561,    83,   133,   150,   135,  5631, -8185,   178,   197,   185
	dd	  147,   123,  3645,    40, -1766, -3451, -1954,  4628, -1613,  5432
	dd	 5649,  6366,   162,   167,   167,   177,   169,   177,   175,   169
	dd	  161,   122,   151,    32, -8770,    29,  5464, -3242, -1213,   131
	dd	 5684,   179,   117,   183,   190,   100, -4611,   123,  3122,  -131
	dd	  123,    42,   146,    76,  5460,    56, 18964,  3466,   155,  4357
len	dd	350

min	dd	0
med	dd	0
max	dd	0
sum	dd	0
avg	dd	0

h	dd	0
ddThree	dd	3

; ----------------------------------------------

section	.bss

; ----------------------------------------------


section	.text
global _start
_start:

	; i 	-> esi
	; j 	-> edi
	; tmp 	-> ebx	

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
			mov ebx, dword [lst + esi * 4]

			; for (j = i; (j >= h) && (lst[j - h] > tmp); j = j - h)

			; inner for loop init statment
			; j = i
			mov edi, esi

			innerForLoop:

				; inner for loop test statment
				; (j >= h) && (lst[j - h] > tmp)
				; if (j < h)
				cmp edi, dword [h]
				jl innerForLoopDone

				; -OR-
				
				; if (lst[j - h] <= tmp)
				mov eax, edi
				sub eax, dword [h]
				mov eax, dword [lst + eax * 4]
				cmp eax, ebx
				jle innerForLoopDone

				; else continue inner for loop
				
				; lst[j] = lst[j - h];
				mov dword [lst + edi * 4], eax 	; its already in eax				

				; inner for loop increment statment
				; j = j - h
				sub edi, dword [h]		

				jmp innerForLoop
		
			innerForLoopDone:

			; lst[j] = tmp;	
			mov dword [lst + edi * 4], ebx			

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

	mov ecx, [len]
	mov esi, 0
        sumLoop:

            ; get next item in list
            mov eax, dword [lst + esi * 4]

            ; add to sum
            add dword [sum], eax

            inc esi
            loop sumLoop

	; calculate average
	mov eax, dword [sum]
	cdq
	idiv dword [len]
	mov dword [avg], eax

	; get min
	mov eax, dword [lst]
	mov dword [min], eax	

	; get max
	mov esi, [len]
	dec esi
	mov eax, dword [lst + esi * 4]
	mov dword [max], eax

	; calculate median
	mov esi, dword [len]
	shr esi, 1
	mov eax, dword [lst + esi * 4]
	mov ecx, 1
	add ecx, dword [len]
	cmp ecx, 1
	je medianDone
	dec esi
	add eax, dword[lst + esi * 4]
	shr eax, 1

	medianDone:

		mov dword [med], eax	
	
	
last:
	mov	eax, 1
	mov	ebx, 0
	int	80h
