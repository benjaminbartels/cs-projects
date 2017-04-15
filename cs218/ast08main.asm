;  CS 218 - Assignment 8
;  Provided Main.

;  DO NOT EDIT THIS FILE

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
;  Data Sets for Assignment #8.

xList_1		dd	    30,     10,    100,    -10,     60
		dd	     0,     80,     50,     70,     20
		dd	    90,     40,    -20
yList_1		dd	112130, 531110, 613213, 412140, 341160
		dd	231190, 542118, 731150, 631170, 951120
		dd	-12110, 831100, 921200
len_1		dd	13
xMin_1		dd	0
xMed_1		dd	0
xMax_1		dd	0
xSum_1		dd	0
xAve_1		dd	0
yMin_1		dd	0
yMed_1		dd	0
yMax_1		dd	0
ySum_1		dd	0
yAve_1		dd	0
b0_1		dd	0
b1_1		dd	0


xList_2		dd	 12327,  10255,   5417,  12315,   1361
		dd	  1000,   1220,   1122,   3124,   9026
		dd	  1129,  12213,  -3455,   1535,   5437
		dd	  -739,  10341,   1543,   1345,  10349
		dd	  2153,   2319, -12123,  13217,   1459
		dd	 11416,    415,   1551,   6567, -10669
		dd	 -1328,  13430,  13432,   2333,      1
		dd	   338,   4340,  -4542,   7644,   6746
		dd	  1321,   3425,  14251,  14113,  14519
		dd	  4257,  14999,   1453,    165,   5679
yList_2		dd	112327, 510255, 315417, 612315, 511361
		dd	211683, 343114, 755111, -44128,  -3112
		dd	311326, -22117, -77127, 749127, 855184
		dd	-13974, 342102, 934125, -26126, 751129
		dd	121188, 242315, 313101, -15108,  -3115
		dd	-11126, 239117, 641105, 899110, 765114
		dd	545124, 642143, -36134, 976112, 646103
		dd	631572, -46176, 755456,  -4165, 535156
		dd	764453, 733140, 855191, 454168, -33162
		dd	561646, 832147, -27167, 679177, 645144
len_2		dd	50
xMin_2		dd	0
xMed_2		dd	0
xMax_2		dd	0
xSum_2		dd	0
xAve_2		dd	0
yMin_2		dd	0
yMed_2		dd	0
yMax_2		dd	0
ySum_2		dd	0
yAve_2		dd	0
b0_2		dd	0
b1_2		dd	0


xList_3		dd	  9244,   4434,   7243,   9261,   5436
		dd	  4441,  -2233,  -6234,   6223,  -6263
		dd	  1218,   7443,   8612,   1210,   5310
		dd	 -4224,   2243,   6234,   6212,  -6203
		dd	  7253,  -3340,  -5291,   5468,   3362
		dd	  1347,    227,   4399,   1297,  -1229
		dd	  1383,   3450,   5201,   5228,   3315
		dd	  1683,   3114,  -5111,   4128,   3112
		dd	 -1326,   2117,   7127,   9127,   5184
		dd	  3974,    102,   4125,   6126,  -1129
		dd	  1188,  -3105,    101,   5108,   3115
		dd	  1126,   9117,  -1105,   9110,    114
		dd	   124,   2143,   6134,   6112,   6103
		dd	  1572,   6176,    156,   4165,  -5156
		dd	 -1453,  -3140,  -5191,   4168,   3162
		dd	  1646,   2147,   7167,   9177,  -5144
		dd	  1855,   5132,   7185,   2149,    134
		dd	  1764,    172,  -4175,   6162,   8172
		dd	 -1683,    150,   5131,   5178,  -7185
		dd	  1466,  -2167,   7177,   9177,   5164
yList_3		dd	 11000,   1220,   1122,   3124, 999026
		dd	121129,  12213,  -3455, 311535,   5437
		dd	  -739,  10341,  11543,  10345,  10349
		dd	212153,   2319, -12123,  13217,  13459
		dd	311416,    415,  10551, 426567, -10669
		dd	 -1328,  13430, 213432,   2333,      1
		dd	   338, 314340,  -4542,   7644,   6746
		dd	311321,   3425,  14251,  14113,  14519
		dd	  4257,  14999, 311453,  42165,   5679
		dd	542327, 210255,  15417,  12315,  11361
		dd	341683,   3114,   5111,  -4128,  -3112
		dd	 -1326,  -2117,  -7127,  49127, 315184
		dd	534188,   3105,    101,  -5108,  -3115
		dd	 -1126,   9117,   1105, 119110,    114
		dd	857124,   2143,  -6134,   6112,   6103
		dd	  1572,  -6176,    156,  -4165, 315156
		dd	851453,  13140,   5191,   4168,  -3162
		dd	 71646, 312147,  -7167, 119177,   5144
		dd	 -1855,  -5132,   7185,    149,    134
		dd	521764,   1172,   4175,   6162,  -8172
len_3		dd	100
xMin_3		dd	0
xMed_3		dd	0
xMax_3		dd	0
xSum_3		dd	0
xAve_3		dd	0
yMin_3		dd	0
yMed_3		dd	0
yMax_3		dd	0
ySum_3		dd	0
yAve_3		dd	0
b0_3		dd	0
b1_3		dd	0


; --------------------------------------------------------

extern	shellSort, basicStats
extern	advancedStats, linearRegression

section	.text
global	main
main:

; **************************************************
;  Call procedures for data set 1.

;  call shellSort(xList_1, len_1)
	push	dword [len_1]
	push	xList_1
	call	shellSort
	add	esp, 8

;  call shellSort(yList_1, len_1)
	push	dword [len_1]
	push	yList_1
	call	shellSort
	add	esp, 8

;  call basicStats(xList_1, len_1, xMin_1, xMed_1, xMax_1)
	push	xMax_1
	push	xMed_1
	push	xMin_1
	push	dword [len_1]
	push	xList_1
	call	basicStats
	add	esp, 20

;  call basicStats(yList_1, len_1, yMin_1, yMed_1, yMax_1)
	push	yMax_1
	push	yMed_1
	push	yMin_1
	push	dword [len_1]
	push	yList_1
	call	basicStats
	add	esp, 20

;  call advancedStats(xList_1, len_1, xSum_1, xAve_1)
	push	xAve_1
	push	xSum_1
	push	dword [len_1]
	push	xList_1
	call	advancedStats
	add	esp, 16

;  call advancedStats(yList_1, len_1, ySum_1, yAve_1)
	push	yAve_1
	push	ySum_1
	push	dword [len_1]
	push	yList_1
	call	advancedStats
	add	esp, 16

;  call linearRegression(xList_1, yList_1, xAve_1, yAve_2, len_1, b0_1, b1_1)
	push	b1_1
	push	b0_1
	push	dword [yAve_1]
	push	dword [xAve_1]
	push	dword [len_1]
	push	yList_1
	push	xList_1
	call	linearRegression
	add	esp, 28


; **************************************************
;  Call procedures for data set 2.

;  call shellSort(xList_2, len_2)
	push	dword [len_2]
	push	xList_2
	call	shellSort
	add	esp, 8

;  call shellSort(yList_2, len_2)
	push	dword [len_2]
	push	yList_2
	call	shellSort
	add	esp, 8

;  call basicStats(xList_2, len_2, xMin_2, xMed_2, xMax_2)
	push	xMax_2
	push	xMed_2
	push	xMin_2
	push	dword [len_2]
	push	xList_2
	call	basicStats
	add	esp, 20

;  call basicStats(yList_2, len_2, yMin_2, yMed_2, yMax_2)
	push	yMax_2
	push	yMed_2
	push	yMin_2
	push	dword [len_2]
	push	yList_2
	call	basicStats
	add	esp, 20

;  call advancedStats(xList_2, len_2, xSum_2, xAve_2)
	push	xAve_2
	push	xSum_2
	push	dword [len_2]
	push	xList_2
	call	advancedStats
	add	esp, 16

;  call advancedStats(yList_2, len_2, ySum_2, yAve_2)
	push	yAve_2
	push	ySum_2
	push	dword [len_2]
	push	yList_2
	call	advancedStats
	add	esp, 16

;  call linearRegression(xList_2, yList_2, xAve_2, yAve_2, len_2, b0_2, b1_2)
	push	b1_2
	push	b0_2
	push	dword [yAve_2]
	push	dword [xAve_2]
	push	dword [len_2]
	push	yList_2
	push	xList_2
	call	linearRegression
	add	esp, 28


; **************************************************
;  Call procedures for data set 3.

;  call shellSort(xList_3, len_3)
	push	dword [len_3]
	push	xList_3
	call	shellSort
	add	esp, 8

;  call shellSort(yList_3, len_3)
	push	dword [len_3]
	push	yList_3
	call	shellSort
	add	esp, 8

;  call basicStats(xList_3, len_3, xMin_3, xMed_3, xMax_3)
	push	xMax_3
	push	xMed_3
	push	xMin_3
	push	dword [len_3]
	push	xList_3
	call	basicStats
	add	esp, 20

;  call basicStats(yList_3, len_3, yMin_3, yMed_3, yMax_3)
	push	yMax_3
	push	yMed_3
	push	yMin_3
	push	dword [len_3]
	push	yList_3
	call	basicStats
	add	esp, 20

;  call advancedStats(xList_3, len_3, xSum_3, xAve_3)
	push	xAve_3
	push	xSum_3
	push	dword [len_3]
	push	xList_3
	call	advancedStats
	add	esp, 16

;  call advancedStats(yList_3, len_3, ySum_3, yAve_3)
	push	yAve_3
	push	ySum_3
	push	dword [len_3]
	push	yList_3
	call	advancedStats
	add	esp, 16

;  call linearRegression(xList_3, yList_3, xAve_3, yAve_3, len_3, b0_3, b1_3)
	push	b1_3
	push	b0_3
	push	dword [yAve_3]
	push	dword [xAve_3]
	push	dword [len_3]
	push	yList_3
	push	xList_3
	call	linearRegression
	add	esp, 28


; -----
;  Done, terminate program.

last:
	mov	eax, 1
	mov	ebx, 0
	int	0x80
