#  CS 219, MIPS Assignment #4

#  MIPS assembly language main program and procedures:

#  * MIPS assembly language procedure, trapPerims(), to
#    calculate the perimeter of each trapezoid in a series
#    of trapezoids.

#  * MIPS assembly language procedure, gnomeSort(), to sort
#    a list of numbers into ascending (small to large) order.
#    The procedure should call a routine displayHeaders() and
#    printList() which is called twice.  The displayHeaders()
#    and printList() routines are provided.

#  * MIPS assembly language procedure, perimsStats(), that will
#    find the minimum, maximum, median, and average.
#    Note, when this call is made, the list is sorted.
#    The main calls a provided procedure to print the results.

#  * Additional procedures are provided...


#####################################################################
#  data segment

.data

# -----
#  Data declarations for main.

asides1:	.word	 19,   7,  15,  13,  11,   9,   7,   5,   3,   1
		.word	107, 121, 137, 141, 157, 367, 177, 181, 191, 199
bsides1:	.word	 92,   4,  96,   8,  10,  12,  90,  16,  18,   5
		.word	203, 215, 221, 239, 248, 259, 262, 274, 280, 291
csides1:	.word	 14,  22,  31,  45,   4,  43,  12,   7,  88,   9
		.word	182, 195, 999, 112, 127, 147, 167, 979, 188, 194
perims1:	.space	80
len1:		.word	20
min1:		.word	0
med1:		.word	0
max1:		.word	0
sum1:		.word	0
fave1:		.float	0.0


asides2:	.word	   1,    2,    3,    4,    5,    6,    7,    8,    9,   10
		.word	 107,  121,  137,  141,  157,  167,  177,  181,  191,  199
		.word	 202,  209,  215,  219,  223,  225,  231,  242,  244,  249
		.word	2215,   25,   33,   44,   58,   69,   72,   86,   99,  101
		.word	 251,  253,  266, 2269,  271,  272,   80,  288, 3291, 1299
		.word	 169,  174,  177,  179,  182,   84,   86,   88,  192,  193

bsides2:	.word	  32,   51,   76,   87,   90, 1100,    1,  123,  132,  145
		.word	 206,  212,  222,  231,  246,  250,  254,  278, 5288, 1292
		.word	1332,  151,  176,  187,  190,  100,   11,   23,  132,  145
		.word	 157,  487,  199,  101,  123,   24,  125,  126, 3175,  194
		.word	3134,  152,  174, 2186,  197,  104,    2,   20,  136, 2153

csides2:	.word	 102,  113,  122,  139,  144,  151,  161,  178, 2186,   97
		.word	1203,  215,  221,  239,  248,  259,   62,   74,  280,  291
		.word	 400,  104,  106,  107,  124,   25,  126,  129, 1148, 4192
		.word	  11, 2113,  124, 2136,  140,  156,  175,  187,  190,  296
		.word	 182,  195,  107,  112,  127,  147,  167,   79,  188,   54

perims2:	.space	200
len2:		.word	50
min2:		.word	0
med2:		.word	0
max2:		.word	0
sum2:		.word	0
fave2:		.float	0.0
 

asides3:	.word	   3,    2,  131,  231,  231, 1134, 1142,  146,  158, 1123
		.word	1112, 1119,  125,    9,   31,   35,   39,  142,   44,   49
		.word	 100,  404,   46,  407, 1424, 1125,  126, 1129,  148,   92
		.word	1241,  243,  146,  249,  251,  252,  254,  258,   61,  265
		.word	 169,  374,   77,  379,  382,   84, 1186,   91, 1192, 1193
		.word	 101,  513,  124,  536, 1540, 1156,  175,  187,   90,  596
bsides3:	.word	   4,    5,   35,    2,   32,  131,  132,    6,  116,   23
		.word	 198,  199,  191, 1122,  123,   91,   76,  131,   19,  156
		.word	 246,  179,  149,  117,  246,   134,  134,   56,   64,   42
		.word	1171, 1148,   95,    3,  112, 1110, 1158,   71,  124,  192
		.word	 215,   62,  176, 1192,   23,  139,   96,  112,  118,   91
		.word	   2,    5, 1176,  187, 1185, 1104,   16, 1120, 1136, 1153
csides3:	.word	 123,  242,  131,  231,  231,  134,  142,   46,   58,  123
		.word	 112,   19,   25,    9,  131,   15, 1139,   42,  144,   49
		.word	1100,  104,   46, 1107,   24,    5,   26,  129,  148,  192
		.word	 241,  243,  146,  149, 1251,  152,  254,  158,   61, 1165
		.word	  69, 1174,   77,    8,  182,   84,  186,   91,  192,   93
		.word	1101,  113,  124, 1136,   40, 1156, 1175, 1187, 1190, 1196
perims3:	.space	240
len3:		.word	25
min3:		.word	0
med3:		.word	0
max3:		.word	0
sum3:		.word	0
fave3:		.float	0.0


asides4:	.word	   5,    4,    3, 1117, 1123,   34, 1134,  156, 1164,  142
		.word	 206,  212, 1122,  131,  246,  150,   54,   78,  188, 1192
		.word	  82, 1195,   17,   12,   27,   47,  167, 1179,   88,  194
		.word	 134,  152,  174,  186,  197, 1104,   16,   12,  136, 2153
		.word	  32,   51,   36,  187,  190,  100,  111,  123, 1132,  145
		.word	 157, 1187,  199,   11, 1123,   24, 1125,   26,  175, 1194
		.word	 149,  126,   62, 1131,   27,  177,   99,  197,  175,   14
		.word	  64,  141,  142,  173,  166, 1134,  146,   23, 1156,  163
		.word	 121, 1118,  177,   43,  178,   12,  111,  110,  135,   10
		.word	 127,  144, 2110,  172, 1124,  125,   16,   62, 1128,  192
bsides4:	.word	   3,    2,    6,  181,   11, 1116,  164,  165,  295,   56
		.word	 137,  123,  123,   40,  115,   11, 1154,   28,   13,  122
		.word	 169, 1126,   16,  127,  127,  127,   59,  177,  175,   14
		.word	  81,   25,   15, 1112,   17, 1135,  110,  129, 1112,  134
		.word	 161,  122, 1151,   22, 1171,   19,  114,   22,  215,   31
		.word	  23, 1242,  146,  176,  110,  126,   64,  165,   55,  156
		.word	 171,  147,   10, 1127,   74,  165,  121,   67,  181,   29
		.word	  23, 2212,  146,   36,  110,   16, 1164,  156, 1115,  132
		.word	 111,  183,  133,  150,   25, 2189,   15,  118, 1113,   15
		.word	 164,  141, 2142, 1133,  166,  134,  146,   23,   56,  163
csides4:	.word	   7,    4,    5,   72, 1124,   25,  116,  162,  138,   92
		.word	 111,  183,  133,  130,   27,  111,   15,   58, 1113,  115
		.word	  17, 1126,   16,  117,  227, 1177,  199,  177,  175,   14
		.word	  94,  124,   12,   43,  176,   34,   26,   32,   56,  163
		.word	 124,   19,  122,  183, 1110,  191, 1192,  129,  129,   22
		.word	  35, 2126,  162, 1137,   27,  127,  159,   77, 1175,  144
		.word	  79,  153,   36,   40,  235,   12,  154,  128,  113,   32
		.word	 161,   92,  151,  213, 1126, 2169, 1114,   22, 2115, 1131
		.word	  94, 2124,  114,  143,  176,  134,  126, 1122,  156,   63
		.word	 149,  144, 2114,   34,   67,   43,   29,  161,  165,  136
len4:		.word	100
perims4:	.space	400
min4:		.word	0
med4:		.word	0
max4:		.word	0
sum4:		.word	0
fave4:		.float	0.0


asides5:	.word	 179,  153, 2136,  140,  235,  112,  154,  128,  113, 1132
		.word	  17,   21,  137,  141,  157,   17,  177,    8,  191,  199
		.word	1202,  209,   15,  219,  223,  225,  231,  242,    4,  249
		.word	 251,  253,  266,   69,  271,   72,  280,  288,  291, 1299
		.word	  15,   25,   33,   44,   58,   69,   72,   86,   99,   11
		.word	 369,  374,  377,  379,  382,  384,  386,  388,  392,  393
		.word	1469, 2474, 3477, 4479, 5482, 5484, 6486, 7788, 8492, 9493

bsides5:	.word	1782, 2795, 3807, 3812, 4827, 5847, 6867, 7879, 7888, 9894
		.word	  32,   51,   76,   87,   90,  100,  111,  123,  132,  145
		.word	 457,  487,  499,  501,  523,  524,  525,  526, 1575,    9
		.word	 634,  652,  674,  686,  697, 1704,  716,  720,  736,  753
		.word	  26,   72,  222,  231,  246,  250,  254,  278,  288,  292
		.word	 332,  351,  376,   87,  390,   40,  411,  423,  432,    5

csides5:	.word	 169,  126,  162,  127,   12,  127,  159,  177,  175,  114
		.word	 203,  215,  221,  239,  248,  259,  262,  274, 1280,  291
		.word	 400,   44,  406,  407,    4,  425,  426,  429,  448,  492
		.word	 501,  513,  524,  536,  540,  556,  575,    7,  590,  596
		.word	 102,    3,  122,  139,  144,  151,  161,  178,  186,  197
		.word	 782,  795,  807,  812,  827,  847,  867,  879,  888,  894
		.word	1912, 2925, 3927, 4932, 5447, 5957, 6967, 7979, 7988, 9994
perims5:	.space	280
len5:		.word	70
min5:		.word	0
med5:		.word	0
max5:		.word	0
sum5:		.word	0
fave5:		.float	0.0


# -----

TRUE = 1
FALSE = 0
NUMSPERLINE = 8

hdr:	.ascii	"\nCS 219 - Assignment #4\n"
	.asciiz	"Trapezoid Perimeters Program"

# -----
#  Local variables/constants for displayHeader procedure.

hdrNum:	.ascii	"\n\n---------------------------"
	.asciiz	"\nData Set #"

hdrLn:	.asciiz	"\nLength: "
hdrUn:	.asciiz	"\n\n Unsorted Perimeters List: \n\n"
hdrSrt:	.asciiz	"\n Sorted Perimeters List: \n\n"


# -----
#  Local variables/constants for trapPerims procedure (if any).



# -----
#  Local variables/constants for gnomeSort procedure (if any).



# -----
#  Local variables/constants for perimsStats procedure (if any).



# -----
#  Local variables/constants for printList procedure.

blanks:	.asciiz	"   "


# -----
#  Local variables for printStats procedure.

newLn:	.asciiz	"\n"

str1:	.asciiz	"\n min = "
str2:	.asciiz	"\n med = "
str3:	.asciiz	"\n max = "
str4:	.asciiz	"\n sum = "
str5:	.asciiz	"\n ave = "


#####################################################################
#  text/code segment

.text

.globl main
.ent main
main:

# -----
#  Display Program Header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

	li	$s0, 1				# counter, data set number

# -----
#  Call routines:
#	* trapPerims() routine
#		- calculate trapezoid perimeters
#	* gnomeSort() routine
#		- display headers
#		- display unsorted list
#		- sort numbers
#		- display sorted list
#	* perimsStats() routine
#		- find stats (min, max, med, sum, and average)
#	* printStats() routine
#		- display stats (min, max, med, sum, and average)

# ----------------------------------------------------
#  Data Set #1

#  Find trapezoid perimters.
#	HLL call:	trapPerims(perims, len, asides, bsides, csides);

	la	$a0, perims1
	lw	$a1, len1
	la	$a2, asides1
	la	$a3, bsides1
	subu	$sp, $sp, 4
	la	$t0, csides1
	sw	$t0, ($sp)			# arg #5, on stack
	jal	trapPerims

	addu	$sp, $sp, 4			# clear stack

#  Sort routine
#	displays headers, display numbers, sort numbers, and re-display numbers.
#	HLL call:	gnomeSort(perims, len)

	la	$a0, perims1
	lw	$a1, len1
	move	$a2, $s0
	jal	gnomeSort

#  Generate perimters stats.
#	HLL call:	perimsStats(perims, len, min, med, max, sum, fave)

	la	$a0, perims1			# arg #1
	lw	$a1, len1			# arg #2
	la	$a2, min1			# arg #3
	la	$a3, med1			# arg #4
	subu	$sp, $sp, 12
	la	$t0, max1
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum1
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, fave1
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	perimsStats

	addu	$sp, $sp, 12			# clear stack

#  Display stats.
#	HLL call:	printStats(min, med, max, sum, fave);

	lw	$a0, min1
	lw	$a1, med1
	lw	$a2, max1
	lw	$a3, sum1
	subu	$sp, $sp, 4
	l.s	$f6, fave1
	s.s	$f6, ($sp)			# arg #5, on stack
	jal	printStats

	addu	$sp, $sp, 4			# clear stack

# ----------------------------------------------------
#  Data Set #2

	add	$s0, $s0, 1

#  Find trapezoid perimters.
#	HLL call:	trapPerims(perims, len, asides, bsides, csides);

	la	$a0, perims2
	lw	$a1, len2
	la	$a2, asides2
	la	$a3, bsides2
	subu	$sp, $sp, 4
	la	$t0, csides2
	sw	$t0, ($sp)			# arg #5, on stack
	jal	trapPerims

	addu	$sp, $sp, 4			# clear stack

#  Sort routine
#	displays headers, display numbers, sort numbers, and re-display numbers.
#	HLL call:	gnomeSort(perims, len)

	la	$a0, perims2
	lw	$a1, len2
	move	$a2, $s0
	jal	gnomeSort

#  Generate perimters stats.
#	HLL call:	perimsStats(perims, len, min, med, max, sum, fave)

	la	$a0, perims2			# arg #1
	lw	$a1, len2			# arg #2
	la	$a2, min2			# arg #3
	la	$a3, med2			# arg #4
	subu	$sp, $sp, 12
	la	$t0, max2
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum2
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, fave2
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	perimsStats

	addu	$sp, $sp, 12			# clear stack

#  Display stats.
#	HLL call:	printStats(min, med, max, sum, fave);

	lw	$a0, min2
	lw	$a1, med2
	lw	$a2, max2
	lw	$a3, sum2
	subu	$sp, $sp, 4
	l.s	$f6, fave2
	s.s	$f6, ($sp)			# arg #5, on stack
	jal	printStats

	addu	$sp, $sp, 4			# clear stack

# ----------------------------
#  Data Set #3

	add	$s0, $s0, 1

#  Find trapezoid perimters.
#	HLL call:	trapPerims(perims, len, asides, bsides, csides);

	la	$a0, perims3
	lw	$a1, len3
	la	$a2, asides3
	la	$a3, bsides3
	subu	$sp, $sp, 4
	la	$t0, csides3
	sw	$t0, ($sp)			# arg #5, on stack
	jal	trapPerims

	addu	$sp, $sp, 4			# clear stack

#  Sort routine
#	displays headers, display numbers, sort numbers, and re-display numbers.
#	HLL call:	gnomeSort(perims, len)

	la	$a0, perims3
	lw	$a1, len3
	move	$a2, $s0
	jal	gnomeSort

#  Generate perimters stats.
#	HLL call:	perimsStats(perims, len, min, med, max, sum, fave)

	la	$a0, perims3			# arg #1
	lw	$a1, len3			# arg #2
	la	$a2, min3			# arg #3
	la	$a3, med3			# arg #4
	subu	$sp, $sp, 12
	la	$t0, max3
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum3
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, fave3
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	perimsStats

	addu	$sp, $sp, 12			# clear stack

#  Display stats.
#	HLL call:	printStats(min, med, max, sum, fave);

	lw	$a0, min3
	lw	$a1, med3
	lw	$a2, max3
	lw	$a3, sum3
	subu	$sp, $sp, 4
	l.s	$f6, fave3
	s.s	$f6, ($sp)			# arg #5, on stack
	jal	printStats

	addu	$sp, $sp, 4			# clear stack

# ----------------------------
#  Data Set #4

	add	$s0, $s0, 1

#  Find trapezoid perimters.
#	HLL call:	trapPerims(perims, len, asides, bsides, csides);

	la	$a0, perims4
	lw	$a1, len4
	la	$a2, asides4
	la	$a3, bsides4
	subu	$sp, $sp, 4
	la	$t0, csides4
	sw	$t0, ($sp)			# arg #5, on stack
	jal	trapPerims

	addu	$sp, $sp, 4			# clear stack

#  Sort routine
#	displays headers, display numbers, sort numbers, and re-display numbers.
#	HLL call:	gnomeSort(perims, len)

	la	$a0, perims4
	lw	$a1, len4
	move	$a2, $s0
	jal	gnomeSort

#  Generate perimters stats.
#	HLL call:	perimsStats(perims, len, min, med, max, sum, fave)

	la	$a0, perims4			# arg #1
	lw	$a1, len4			# arg #2
	la	$a2, min4			# arg #3
	la	$a3, med4			# arg #4
	subu	$sp, $sp, 12
	la	$t0, max4
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum4
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, fave4
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	perimsStats

	addu	$sp, $sp, 12			# clear stack

#  Display stats.
#	HLL call:	printStats(min, med, max, sum, fave);

	lw	$a0, min4
	lw	$a1, med4
	lw	$a2, max4
	lw	$a3, sum4
	subu	$sp, $sp, 4
	l.s	$f6, fave4
	s.s	$f6, ($sp)			# arg #5, on stack
	jal	printStats

	addu	$sp, $sp, 4			# clear stack

# ----------------------------
#  Data Set #5

	add	$s0, $s0, 1

#  Find trapezoid perimters.
#	HLL call:	trapPerims(perims, len, asides, bsides, csides);

	la	$a0, perims5
	lw	$a1, len5
	la	$a2, asides5
	la	$a3, bsides5
	subu	$sp, $sp, 4
	la	$t0, csides5
	sw	$t0, ($sp)			# arg #5, on stack
	jal	trapPerims

	addu	$sp, $sp, 4			# clear stack

#  Sort routine
#	displays headers, display numbers, sort numbers, and re-display numbers.
#	HLL call:	gnomeSort(perims, len)

	la	$a0, perims5
	lw	$a1, len5
	move	$a2, $s0
	jal	gnomeSort

#  Generate perimters stats.
#	HLL call:	perimsStats(perims, len, min, med, max, sum, fave)

	la	$a0, perims5			# arg #1
	lw	$a1, len5			# arg #2
	la	$a2, min5			# arg #3
	la	$a3, med5			# arg #4
	subu	$sp, $sp, 12
	la	$t0, max5
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum5
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, fave5
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	perimsStats

	addu	$sp, $sp, 12			# clear stack

#  Display stats.
#	HLL call:	printStats(min, med, max, sum, fave);

	lw	$a0, min5
	lw	$a1, med5
	lw	$a2, max5
	lw	$a3, sum5
	subu	$sp, $sp, 4
	l.s	$f6, fave5
	s.s	$f6, ($sp)			# arg #5, on stack
	jal	printStats

	addu	$sp, $sp, 4			# clear stack

# -----
#  Done, terminate program.

	la	$a0, newLn
	li	$v0, 4
	syscall					# print new line
	la	$a0, newLn
	li	$v0, 4
	syscall					# print new line

	li	$v0, 10
	syscall					# au revoir...

.end main

#####################################################################
#  Display headers (as per assignment format).

# -----
#    Arguments:
#	$a0 - length of list
#	$a1 - data set count

#    Returns:
#	N/A

.globl	displayHeaders
.ent	displayHeaders
displayHeaders:

	subu	$sp, $sp, 8
	sw	$s0, ($sp)
	sw	$s1, 4($sp)

	move	$s0, $a0
	move	$s1, $a1

	la	$a0, hdrNum
	li	$v0, 4
	syscall

	move	$a0, $s1		# data set count
	li	$v0, 1
	syscall

	la	$a0, hdrLn
	li	$v0, 4
	syscall

	move	$a0, $s0		# length
	li	$v0, 1
	syscall

	lw	$s0, ($sp)
	lw	$s1, 4($sp)
	addu	$sp, $sp, 8

	jr	$ra
.end	displayHeaders


#####################################################################
#  Find perimeters
#	perims(n) = ( asides(n) + 2*bsides(n) + csides(n) )

# -----
#	HLL call:  trapPerims(perims, len, asides, bsides, csides);

#    Arguments:
#	$a0   - starting address of the perimeters array
#	$a1   - length
#	$a2   - starting address of the asides array
#	$a3   - starting address of the bsides array
#	($fp) - starting address of the csides array

#    Returns:
#	N/A

.globl	trapPerims
.ent	trapPerims
trapPerims:

	subu	$sp, $sp, 4
	sw	$fp, ($sp)
	addu	$fp, $sp, 4

	move	$t0, $a0	# perimeters array
	move	$t1, $a1	# length


	move	$t2, $a2	# asides
	move	$t3, $a3	# bsides
	lw	$t4, ($fp)	# csides

calcLoop:

	# calc perimeter
	lw	$t5, ($t2)
	lw	$t6, ($t3)
	lw	$t7, ($t4)

	sll	$t6, $t6, 1
	addu	$t6, $t6 $t5
	addu	$t6, $t6 $t7

	# save area
	sw	$t6, ($t0)

	# increment addresses
	addu	$t0, $t0, 4
	addu	$t2, $t2, 4
	addu	$t3, $t3, 4
	addu	$t4, $t4, 4
	
	subu	$t1, $t1, 1
	bgtz	$t1, calcLoop

	lw	$fp, ($sp)
	addu	$sp, $sp, 4

	jr	$ra
.end	trapPerims


#####################################################################
#  Sort a list of numbers using gnome sort.

# gnomeSort(a[0..size-1]) {
#	i := 1
#	j := 2
#	while (i < size)
#		if (a[i-1] >= a[i])
#			i := j
#			j := j + 1 
#		else
#			swap a[i-1] and a[i]
#			i := i - 1
#			if (i = 0) i := 1
# }

# -----
#  Procedure must:
#	display headers via provided displayHeaders() procedure
#	display unsorted list via provided printList() procedure
#	sort list
#	display sorted list via provided printList() procedure

# -----
#	HLL call:	gnomeSort(array, len);

#    Arguments:
#	$a0 - starting address of the list
#	$a1 - list length
#	$a2 - data set count

#    Returns:
#	n/a

.globl gnomeSort
.ent gnomeSort
gnomeSort: 

	subu	$sp, $sp, 32
	sw	$fp, ($sp)
	sw	$a0, 4($sp)
	sw	$a1, 8($sp)
	sw	$a2, 12($sp)
	sw	$s0, 16($sp)
	sw	$s1, 20($sp)
	sw	$s2, 24($sp)
	sw	$ra, 28($sp)
	addu	$fp, $sp, 32

	# call displayHeaders
	# $a0 - length of list
	# $a1 - data set count
	lw	$a0, 8($sp)
	lw	$a1, 12($sp)
	jal	displayHeaders

	la	$a0, hdrUn
	li	$v0, 4
	syscall

	# call printList
	# $a0 - starting address of the list
	# $a1 - list length
	lw	$a0, 4($sp)
	lw	$a1, 8($sp)
	jal	printList

	# i := 1
	# j := 2
	li	$s0, 1					# $s0 = i
	li	$s1, 2					# $s1 = j

	lw	$s3, 4($sp)				# $s3 = address of array

	# while (i < size)
	gnomeLoop:

		bge	$s0, $a1, endGnomeLoop

		# if (a[i-1] <= a[i])			# $t0 = arg 1, $t1 = arg 2
		addi	$t0, $s0, -1			# $t0 = i - 1
		mulou	$t0, $t0, 4			# $t0 = offset = (i - 1) * 4
		addu	$t0, $s3, $t0			# $t0 = 1st address ($s3) + offset
		lw	$t2, ($t0)			# $t2 = value of list[i - 1]

		mulou	$t1, $s0, 4			# $t1 = offset = (i) * 4
		addu	$t1, $s3, $t1			# $t1 = 1st address ($s3) + offset
		lw	$t3, ($t1)			# $t3 = value of list[i]

		ble	$t2, $t3 gnomeIf
		j	gnomeElse	

	gnomeIf:
	
		# i := j
		move	$s0, $s1

		# j := j + 1 
		addi	$s1, $s1, 1

		j	endGnomeIf

	# else
	gnomeElse:

		# swap a[i-1] and a[i]
		sw	$t2, ($t1)
		sw	$t3, ($t0)				

		# i := i - 1
		addi	$s0, $s0, -1

		# if (i = 0) i := 1			
		bne	$s0, $zero, gnomeINotEqualZero

		li	$s0, 1
		
	gnomeINotEqualZero:			

	j	endGnomeIf

	endGnomeIf:

	j	gnomeLoop
	
	endGnomeLoop:

	la	$a0, hdrSrt
	li	$v0, 4
	syscall

	# call printList
	# $a0 - starting address of the list
	# $a1 - list length
	lw	$a0, 4($sp)
	lw	$a1, 8($sp)
	jal	printList

	lw	$fp, ($sp)
	lw	$a0, 4($sp)
	lw	$a1, 8($sp)
	lw	$a2, 12($sp)
	lw	$s0, 16($sp)
	lw	$s1, 20($sp)
	lw	$s2, 24($sp)
	lw	$ra, 28($sp)
	addu	$sp, $sp, 32

	jr	$ra
.end gnomeSort


#####################################################################
#  MIPS assembly language procedure, perimsStats(), to
#    find the minimum, median, maximum, sum, and average of the list.
#    Finds the maximum after the list is sorted (i.e, max=list(len-1)).
#    The average is calculated as floating point value.

# -----
#    Arguments:
#	$a0 - starting address of the list
#	$a1 - list length
#	$a2 - addr of min
#	$a3 - addr of med
#	($fp) - addr of max
#	4($fp) - addr of sum
#	8($fp) - addr of ave (float)

#    Returns (via addresses):
#	min
#	med
#	max
#	sum
#	average

.globl perimsStats
.ent perimsStats
perimsStats:

	subu	$sp, $sp, 4
	sw	$fp, ($sp)
	addu	$fp, $sp, 4

	move	$t0, $a0		# start address
	move	$t1, $a1		# length
	move	$t2, $a2		# min address
	move	$t3, $a3		# med address
	lw	$t4, ($fp)		# max address
	lw	$t5, 4($fp)		# sum address
	lw	$t6, 8($fp)		# ave address

	# get min
	lw	$t9, ($t0)	
	sw	$t9, ($t2)

	# get max
	subu	$t9, $t1, 1
	mulou	$t9, $t9, 4	
	addu	$t9, $t0, $t9

	# save max
	lw	$t9, ($t9)
	sw	$t9, ($t4)	

	# get median
	divu	$t9, $t1, 2		# t9 = length divided by 2
	mulou	$t9, $t9, 4		# t9 = half length * 4
	addu	$t9, $t0, $t9		# t9 = address of median of odd numbered list
	lw	$t8, ($t9)		# t8 = median value or upper media value

	# length even number check
	and	$t7, $t1, 1		
	beq	$t7, 1, medDone

	# when length is even numbered
	subu	$t9, $t9, 4		# move address
	lw	$t7, ($t9)		# t3 = lower median value	
	addu    $t8, $t7, $t8
	divu	$t8, $t8, 2

medDone:

	sw	$t8, ($t3)		

	li	$t9, 0		# $t1 = sum

statsLoop:

	lw	$t8, ($t0)	# get item
	addu	$t9, $t9, $t8	# add to sum	
	addu	$t0, $t0, 4	# increment addresses

	subu	$t1, $t1, 1
	bgtz	$t1, statsLoop

	# save sum
	sw	$t9, ($t5)		

	mtc1	$t9, $f4
	cvt.s.w $f4, $f4
	move	$t1, $a1
	mtc1	$t1, $f6	
	cvt.s.w $f6, $f6
	div.s	$f8, $f4, $f6

	# save ave
	s.s	$f8, ($t6)

	lw	$fp, ($sp)
	addu	$sp, $sp, 4

	jr	$ra
.end perimsStats


#####################################################################
#  MIPS assembly language procedure, printList(), to display
#   a list of numbers.

#  Note, due to the system calls, the saved registers must be used.
#	As such, must push/pop any altered s-registers.

# -----
#    Arguments:
#	$a0 - starting address of the list
#	$a1 - list length

#    Returns:
#	N/A

.globl	printList
.ent	printList
printList:

# -----
#  Save registers.

	subu	$sp, $sp, 16
	sw	$s0, ($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)

# -----
#  Loop to display numbers in list...

	move	$s0, $a0			# set $t0 addr of list
	move	$s1, $a1			# set $t1 to length
	li	$s3, NUMSPERLINE

prtLp:
	lw	$s2, ($s0)			# get list[n]

	la	$a0, blanks
	li	$v0, 4
	syscall

	move	$a0, $s2			#  Display number
	li	$v0, 1
	syscall

# -----
#  Check to see if a CR/LF is needed.

chkLn:
	sub	$s3, $s3, 1
	bgtz	$s3, nxtLp

	la	$a0, newLn
	li	$v0, 4
	syscall
	li	$s3, NUMSPERLINE

# -----
#   Loop if needed.

nxtLp:
	sub	$s1, $s1, 1			# decrement counter
	addu	$s0, $s0, 4			# increment addr by word
	bnez	$s1, prtLp

# -----
#  Display CR/LF for formatting.

	la	$a0, newLn
	li	$v0, 4
	syscall

# -----
#  Restore registers.

	lw	$s0, ($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	addu	$sp, $sp, 16

# -----
#  Done, return to main.

	jr	$ra
.end printList


#####################################################################
#  MIPS assembly language procedure, printStats(), to display
#   the final results.  The procedure prints the maximum, median,
#   sum, and float average.

# -----
#    Arguments:
#	$a0 - min
#	$a1 - med
#	$a2 - max
#	$a3 - sum
#	($fp) - fave

#    Returns:
#	n/a

.globl	printStats
.ent	printStats
printStats:

# -----
#  Save registers.

	subu	$sp, $sp, 20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$fp, ($sp)

	addu	$fp, $sp, 20

# -----
#  Save arguments to saved registers
#   (since system calls change arg registers).

	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2
	move	$s3, $a3

# -----
#  Print message followed by result.

	la	$a0, str1
	li	$v0, 4
	syscall					# print "min = "

	move	$a0, $s0
	li	$v0, 1
	syscall					# print min

# -----
#  Print message followed by result.

	la	$a0, str2
	li	$v0, 4
	syscall					# print "med = "

	move	$a0, $s1
	li	$v0, 1
	syscall					# print med

# -----
#  Print message followed by result.

	la	$a0, str3
	li	$v0, 4
	syscall					# print "max = "

	move	$a0, $s2
	li	$v0, 1
	syscall					# print max

# -----
#  Print message followed by result.

	la	$a0, str4
	li	$v0, 4
	syscall					# print "sum = "

	move	$a0, $s3
	li	$v0, 1
	syscall					# print sum

# -----
#  Print message followed by result.

	la	$a0, str5
	li	$v0, 4
	syscall					# print "ave = "

	l.s	$f12, ($fp)
	li	$v0, 2
	syscall					# print ave

# -----
#  Restore registers.

	lw	$s0, 16($sp)
	lw	$s1, 12($sp)
	lw	$s2, 8($sp)
	lw	$s3, 4($sp)
	lw	$fp, ($sp)
	addu	$sp, $sp, 20

# -----
#  Done, return.

	jr	$ra
.end	printStats

#####################################################################
