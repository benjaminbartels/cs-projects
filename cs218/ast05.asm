;   Benjamin Bartels
;   Assignment #5
;   Section 1002

section	.macros

; -----
;  Macros

    ; %1 - list
    ; %2 - length
    ; %3 - min
    ; %4 - max
    ; %5 - mid
    ; %6 - sum
    ; %7 - ave
    %macro calcStats 7

        push eax
        push ecx
        push edx
        push esi

        mov edx, 0
        mov esi, 0
        mov ecx, dword [%2]
        mov eax, dword [%1]
        mov dword [%3], eax
        mov dword [%4], eax

        %%statsLoop:

            ; get next item in list
            mov eax, dword [%1 + esi * 4]

            ; add to sum
            add dword [%6], eax

            ; get Min
            cmp eax, dword [%3]
            jge %%notNewMin                     ; if eax >= min, jump to notNewMax
            mov dword [%3], eax                 ; assign eax as new min

        %%notNewMin:

            ; get max
            cmp eax, dword [%4]
            jle %%notNewMax                     ; if eax <= max, jump to notNewMin
            mov dword [%4], eax                 ; assign eax as new max

        %%notNewMax:

            inc esi
            loop %%statsLoop

            ; Calculate average
            mov eax, dword [%6]
            cdq
            idiv dword [%2]
            mov dword [%7], eax

            ; Calculate mid
            mov esi, dword [%2]                     ; set indexer to end
            shr esi, 1                              ; set indexer to middle
            mov eax, dword [%1 + esi * 4]           ; set eax to middle value
            mov ecx, 1                              ; int ecx
            and ecx, dword [%2]                     ; set ecx to parity of len
            cmp ecx, 1
            je %%midDone                            ; if ecx == 1 (lenth is odd), jump to midDone
            dec esi                                 ; subtract 1 from esi
            add eax, dword [%1 + esi * 4]           ; sum both middle values
            shr eax, 1                              ; average of both middle values (/2)

        %%midDone:

            mov dword [%5], eax

            pop esi
            pop edx
            pop ecx
            pop eax

    %endmacro

; -----
;  Provided Data Set
section	.data

aSides	db	   10,    14,    13,    37,    54
		db	   31,    13,    20,    61,    36
		db	   14,    53,    44,    19,    42
		db	   27,    41,    53,    62,    10
		db	    9,     8,     4,    10,    15
		db	    5,    11,    22,    33,    70
		db	   15,    23,    15,    63,    26
		db	   24,    33,    10,    61,    15
		db	   14,    34,    13,    71,    81
		db	   38,    13,    29,    17,    93

bSides	dw	 1233,  1114,  1773,  1131,  1675
		dw	 1164,  1973,  1974,  1123,  1156
		dw	 1344,  1752,  1973,  1142,  1456
		dw	 1165,  1754,  1273,  1175,  1546
		dw	 1153,  1673,  1453,  1567,  1535
		dw	 1144,  1579,  1764,  1567,  1334
		dw	 1456,  1563,  1564,  1753,  1165
		dw	 1646,  1862,  1457,  1167,  1534
		dw	 1867,  1864,  1757,  1755,  1453
		dw	 1863,  1673,  1275,  1756,  1353

cSides	dd	14145, 11134, 15123, 15123, 14123
		dd	18454, 15454, 12156, 12164, 12542
		dd	18453, 18453, 11184, 15142, 12354
		dd	14564, 14134, 12156, 12344, 13142
		dd	11153, 18543, 17156, 12352, 15434
		dd	18455, 14134, 12123, 15324, 13453
		dd	11134, 14134, 15156, 15234, 17142
		dd	19567, 14134, 12134, 17546, 16123
		dd	11134, 14134, 14576, 15457, 17142
		dd	13153, 11153, 12184, 14142, 17134

heights	    dw	  144,   112,   123,   142,   123
            dw	  165,   164,   173,   156,   134
            dw	  153,   153,   143,   153,   135
            dw	  144,   169,   134,   133,   132
            dw	  145,   134,   123,   123,   123
            dw	  134,   134,   156,   164,   142
            dw	  153,   153,   184,   142,   134
            dw	  145,   134,   123,   123,   123
            dw	  134,   131,   156,   116,   142
            dw	  153,   153,   184,   142,   134

length  dd	50

aMin    dd	0
aMid    dd	0
aMax    dd	0
aSum    dd	0
aAve    dd	0

pMin    dd	0
pMid    dd	0
pMax    dd	0
pSum    dd	0
pAve    dd	0

twoDWConst dd  2
twoWConst  dw  2

; --------------------------------------------------------------
; Uninitialized data

section	.bss

Areas   resd	50
Perims  resd	50

section	.text
global _start
_start:

    ; init counters
    mov ecx, [length]
    mov esi, 0

    mainLoop:

        ; Begin calculate Areas ================================
        ; areasn = heightn ∗ [(aSiden  cSiden) / 2]

        ; init registers
        mov eax, 0
        mov ebx, 0
        mov edx, 0

        ; aSiden  cSiden)
        mov al, byte [aSides + esi]
        add eax, dword [cSides + esi * 4]   ; *4 for dword

        ; eax/2
        div dword [twoDWConst]

        ; heightn * eax
        mov bx, word [heights + esi * 2]    ; *2 for word
        mul ebx

        ; save to Areas
        mov dword [Areas + esi * 4], eax    ; *4 for dword

        ; End calculate Areas ===================================

        ; Begin calculate Parimeters ============================
        ; perimsn = aSiden  bSiden ∗ 2  cSiden

        ; init registers
        mov eax, 0
        mov ebx, 0
        mov edx, 0

        ; bSiden ∗ 2
        mov ax, word [bSides + esi * 2]     ; *2 for word
        mul word [twoWConst]

        ; eax + aSide(n)
        mov bl, byte [aSides + esi]
        add eax, ebx

        ; eax + cSide(n)
        add eax, dword [cSides + esi * 4]   ; *4 for dword

        ; save to Perims
        mov dword [Perims + esi * 4], eax   ; *4 for dword

        ; End calculate Parimeters ==============================

        ; esi++
        inc esi

        loop mainLoop

        calcStats Areas, length, aMin, aMax, aMid, aSum, aAve
        calcStats Perims, length, pMin, pMax, pMid, pSum, pAve

last:

	mov	eax, 1
	mov	ebx, 0
	int	80h
