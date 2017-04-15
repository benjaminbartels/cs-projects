#  CS 218, MIPS Assignment #3
#  Benjamin Bartels
#  Section 1002

#  MIPS assembly language main program and procedures:

#  * MIPS assembly language procedure, mk_nlist, to create a
#    new list.

#  * Write a MIPS assembly language procedure, prt_lst, to
#    display a list of numbers.  The numbers should be printed
#    7 per line.  The numbers must be right justified (i.e.,
#    lined up on right side).  You may assume that the largest
#    number is 5 digits.

#  * Write a MIPS assembly language procedure, shellSort, to
#    sort a list of numbers into ascending (small to large) order.
#    Uses the shell sort algorithm.

#  * Write a MIPS assembly language procedure, stats, that
#    will find the minimum, maximum, median, sum, and average of
#    the list.  The average is calculated as a floating point value.

#  * Write a MIPS assembly language procedure, prt_stats, to
#    display the list stats.


#####################################################################
#  data segment

.data

# -----
#  Data declarations for main.


asides1:	.word	19, 17, 15, 13, 11,  9,  7,  5,  3,  1
bsides1:	.word	 2,  4,  6,  8, 10, 12, 90, 16, 18, 20
csides1:	.word	14, 22, 31, 45,  4, 43, 12,  7, 88,  9
pvols1:		.space	40
len1:		.word	10
min1:		.word	0
med1:		.word	0
max1:		.word	0
sum1:		.word	0
ave1:		.float	0.0


asides2:	.word	215,  25,  33,  44,  58,  69,  72,  86,  99, 101
		.word	107, 121, 137, 141, 157, 167, 177, 181, 191, 199
		.word	202, 209, 215, 219, 223, 225, 231, 242, 244, 249
		.word	251, 253, 266, 269, 271, 272, 280, 288, 291, 299
		.word	169, 174, 177, 179, 182, 184, 186, 188, 192, 193
bsides2:	.word	 32,  51,  76,  87,  90, 100, 111, 123, 132, 145
		.word	206, 212, 222, 231, 246, 250, 254, 278, 288, 292
		.word	332, 151, 176, 187, 190, 100, 111, 123, 132, 145
		.word	157, 487, 199, 101, 123, 124, 125, 126, 175, 194
		.word	134, 152, 174, 186, 197, 104, 116, 120, 136, 153
csides2:	.word	102, 113, 122, 139, 144, 151, 161, 178, 186, 197
		.word	203, 215, 221, 239, 248, 259, 262, 274, 280, 291
		.word	100, 104, 106, 107, 124, 125, 126, 129, 148, 192
		.word	101, 113, 124, 136, 140, 156, 175, 187, 190, 296
		.word	182, 195, 107, 112, 127, 147, 167, 179, 188, 194
pvols2:		.space	200
len2:		.word	50
min2:		.word	0
med2:		.word	0
max2:		.word	0
sum2:		.word	0
ave2:		.float	0.0


asides3:	.word	123, 242, 131, 231, 231, 134, 142, 146, 158, 123
		.word	112, 119, 125, 129, 131, 135, 139, 142, 144, 149
		.word	100, 404,  46, 407, 424, 125, 126, 129, 148, 192
		.word	241, 243, 146, 249, 251, 252, 254, 258, 161, 265
		.word	169, 374,  77, 379, 382,  84, 186,  91, 192, 193
		.word	101, 513, 124, 536, 540, 156, 175, 187, 190, 596
bsides3:	.word	214, 125, 135, 362, 132, 131, 132, 136, 116, 123
		.word	198, 199, 191, 122, 123,  91, 176, 131,  19, 156
		.word	246, 179, 149, 117, 246  134, 134,  56,  64, 142
		.word	171, 148, 195, 113, 112, 110, 158,  71, 124, 192
		.word	215,  62, 176, 192, 123, 139,  96, 112, 118,  91
		.word	112,  45, 176, 187, 185, 104, 116, 120, 136, 153
csides3:	.word	123, 242, 131, 231, 231, 134, 142,  46,  58, 123
		.word	112, 119, 125, 129, 131, 135, 139, 142, 144, 149
		.word	100, 104,  46, 107, 124, 125, 126, 129, 148, 192
		.word	241, 243, 146, 149, 251, 152, 254, 158, 161, 165
		.word	169, 174,  77, 179, 182,  84, 186,  91, 192,  93
		.word	101, 113, 124, 136, 140, 156, 175, 187, 190, 196
pvols3:		.space	240
len3:		.word	25
min3:		.word	0
med3:		.word	0
max3:		.word	0
sum3:		.word	0
ave3:		.float	0.0


asides4:	.word	145, 134, 123, 117, 123, 134, 134, 156, 164, 142
		.word	206, 212, 122, 131, 246, 150, 154, 178, 188, 192
		.word	182, 195, 107, 112, 127, 147, 167, 179, 188, 194
		.word	134, 152, 174, 186, 197, 104, 116, 120, 136, 153
		.word	132, 151, 136, 187, 190, 100, 111, 123, 132, 145
		.word	157, 187, 199, 101, 123, 124, 125, 126, 175, 194
		.word	149, 126, 162, 131, 127, 177, 199, 197, 175, 114
		.word	164, 141, 142, 133, 166, 134, 146, 123, 156, 163
		.word	121, 118, 177, 143, 178, 112, 111, 110, 135, 110
		.word	127, 144, 110, 172, 124, 125, 116, 162, 128, 192
bsides4:	.word	123, 132, 246, 176, 111, 116, 164, 165, 295, 156
		.word	137, 123, 123, 140, 115, 111, 154, 128, 113, 122
		.word	169, 126, 162, 127, 127, 127, 159, 177, 175, 114
		.word	181, 125, 115, 112, 117, 135, 110, 129, 112, 134
		.word	161, 122, 151, 122, 171, 119, 114, 122, 215, 131
		.word	123, 122, 146, 176, 110, 126, 164, 165, 155, 156
		.word	171, 147, 110, 127, 174, 165, 121, 167, 181, 129
		.word	123, 212, 146, 136, 110, 116, 164, 156, 115, 132
		.word	111, 183, 133, 150, 125, 189, 115, 118, 113, 115
		.word	164, 141, 142, 133, 166, 134, 146, 123, 156, 163
csides4:	.word	127, 164, 110, 172, 124, 125, 116, 162, 138, 192
		.word	111, 183, 133, 130, 127, 111, 115, 158, 113, 115
		.word	117, 126, 162, 117, 227, 177, 199, 177, 175, 114
		.word	194, 124, 112, 143, 176, 134, 126, 132, 156, 163
		.word	124, 119, 122, 183, 110, 191, 192, 129, 129, 122
		.word	135, 126, 162, 137, 127, 127, 159, 177, 175, 144
		.word	179, 153, 136, 140, 235, 112, 154, 128, 113, 132
		.word	161, 192, 151, 213, 126, 169, 114, 122, 115, 131
		.word	194, 124, 114, 143, 176, 134, 126, 122, 156, 163
		.word	149, 144, 114, 134, 167, 143, 129, 161, 165, 136
len4:		.word	100
pvols4:		.space	400
min4:		.word	0
med4:		.word	0
max4:		.word	0
sum4:		.word	0
ave4:		.float	0.0


asides5:	.word	112, 119, 125, 129, 131, 135, 139, 142, 144, 149
		.word	182, 195, 107, 112, 127, 147, 167, 179, 188, 194
		.word	 99, 104, 106, 107, 124, 125, 126, 129, 148, 192
		.word	241, 243, 146, 249, 151, 252, 154, 158, 161, 165
		.word	199, 213, 124, 136, 140, 156, 175, 187, 115, 126
		.word	132, 151, 176, 187, 190, 100, 111, 123, 132, 145
		.word	147, 123, 153, 140, 165, 131, 154, 128, 113, 122
		.word	101, 113, 124, 136, 140, 156, 175, 187, 190, 196
		.word	134, 152, 174, 186, 197, 104, 116, 120, 136, 153
		.word	182, 195, 107, 112, 127, 147, 167, 179, 188, 194
		.word	209, 111, 129, 131, 249, 251, 169, 171, 189, 291
bsides5:	.word	103, 113, 123, 130, 135, 139, 143, 148, 153, 155
		.word	151, 155, 157, 163, 166, 168, 171, 177, 194, 196
		.word	112, 119, 125, 129, 131, 135, 139, 142, 144, 149
		.word	241, 143, 246, 149, 251, 252, 154, 158, 161, 165
		.word	112, 129, 115, 219, 121, 125, 129, 132, 134, 139
		.word	 41,  43, 146, 149, 151, 152, 154, 158, 161, 165
		.word	169, 174, 177, 179, 182, 184, 186, 188, 192, 193
		.word	 69, 174, 177, 179, 182, 184, 186, 188, 192, 193
		.word	169, 174, 177, 179, 182, 184, 186, 188, 192, 193
		.word	100, 104, 106, 107, 124, 125, 126, 129, 148, 192
		.word	145, 175, 115, 122, 117, 115, 110, 129, 112, 134
csides5:	.word	100, 111, 124, 139, 140, 155, 161, 174, 188, 193
		.word	101, 113, 124, 136, 140, 156, 175, 187, 190, 196
		.word	194, 124, 114, 143, 176, 134, 126, 122, 156, 163
		.word	105, 112, 126, 135, 140, 157, 163, 179, 182, 194
		.word	206, 112, 122, 131, 146, 150, 154, 178, 188, 192
		.word	107, 117, 127, 137, 147, 157, 167, 177, 187, 197
		.word	157, 187, 199, 101, 123, 124, 125, 126, 175, 194
		.word	134, 152, 174, 186, 197, 104, 116, 120, 136, 153
		.word	134, 152, 174, 186, 197, 104, 116, 120, 136, 153
		.word	182, 195, 107, 112, 127, 147, 167, 179, 188, 194
		.word	109, 111, 129, 131, 149, 151, 169, 171, 189, 191
pvols5:		.space	440
len5:		.word	110
min5:		.word	0
med5:		.word	0
max5:		.word	0
sum5:		.word	0
ave5:		.float	0.0


# -----
#  Variables for main

hdr:	.asciiz	"\nAssignment #3\n\n"

hdr_nm:	.ascii	"\n---------------------------"
	.asciiz	"\nData Set #"


hdr_ln:	.asciiz	"\nLength: "
hdr_un:	.asciiz	"\n\n Unsorted Rectangular Parallelepiped Volumes: \n\n"
hdr_sr:	.asciiz	"\n Sorted Rectangular Parallelepiped Volumes: \n\n"


# -----
#  Local variables/constants for para_vols procedure.



# -----
#  Local variables/constants for shellSort procedure.

TRUE = 1
FALSE = 0



# -----
#  Local variables/constants for prt_lst procedure.

tab:	.asciiz	"\t"

NUMS_PER_ROW = 5


# -----
#  Local variables for prt_stats procedure.

new_ln:	.asciiz	"\n"

str1:	.asciiz	"\n min = "
str2:	.asciiz	"\n med = "
str3:	.asciiz	"\n max = "
str4:	.asciiz "\n sum = "
str5:	.asciiz	"\n ave = "




#####################################################################
#  text/code segment

.text

.globl	main
.ent	main
main:

# -----
#  Display Program Header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

	li	$s0, 1				# counter, data set number

# -----
#  Basic flow:
#	* display headers

#	for each data set:
#		* find volumes
#		* display unsorted volumes
#		* sort volumes
#		* find volumes stats (min, max, med, sum, and average)
#		* display sorted volumes
#		* display volumes stats  (min, max, med, sum, and average)


# ----------------------------
#  Data Set #1

	la	$a0, hdr_nm
	li	$v0, 4
	syscall

	move	$a0, $s0
	li	$v0, 1
	syscall

	la	$a0, hdr_ln
	li	$v0, 4
	syscall

	lw	$a0, len1
	li	$v0, 1
	syscall

	add	$s0, $s0, 1


#  find volumes
#	call para_vols(pvols1, len1, asides1, bsides1, csides1)

	la	$a0, pvols1
	lw	$a1, len1
	la	$a2, asides1
	la	$a3, bsides1
	subu	$sp, $sp, 4
	la	$t0, csides1
	sw	$t0, ($sp)			# arg #5, on stack
	jal	para_vols

	addu	$sp, $sp, 12			# clear stack


#  Display unsorted volumes
#	call	prt_lst(pvols1, len1)

	la	$a0, hdr_un
	li	$v0, 4
	syscall

	la	$a0, pvols1
	lw	$a1, len1
	jal	prt_lst


#  Sort volumes
#	call	shellSort(pvols1, len1)

	la	$a0, pvols1
	lw	$a1, len1
	jal	shellSort


#  Generate volumes stats

	la	$a0, pvols1			# arg #1
	lw	$a1, len1			# arg #2
	la	$a2, min1			# arg #3
	la	$a3, med1			# arg #4
	subu	$sp, $sp, 12
	la	$t0, max1
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum1
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, ave1
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	pv_stats

	addu	$sp, $sp, 12			# clear stack

#  Display sorted volumes

	la	$a0, hdr_sr
	li	$v0, 4
	syscall

	la	$a0, pvols1
	lw	$a1, len1
	jal	prt_lst

#  Display volumes stats

	lw	$a0, min1
	lw	$a1, med1
	lw	$a2, max1
	lw	$a3, sum1
	subu	$sp, $sp, 4
	lw	$t0, ave1
	sw	$t0, ($sp)
	jal	prt_stats

	addu	$sp, $sp, 4


# ----------------------------
#  Data Set #2

	la	$a0, hdr_nm
	li	$v0, 4
	syscall

	move	$a0, $s0
	li	$v0, 1
	syscall

	la	$a0, hdr_ln
	li	$v0, 4
	syscall

	lw	$a0, len2
	li	$v0, 1
	syscall

	add	$s0, $s0, 1


#  find volumes
#	call para_vols(pvols2, len2, asides2, bsides2, csides2)

	la	$a0, pvols2
	lw	$a1, len2
	la	$a2, asides2
	la	$a3, bsides2
	subu	$sp, $sp, 4
	la	$t0, csides2
	sw	$t0, ($sp)			# arg #5, on stack
	jal	para_vols

	addu	$sp, $sp, 12			# clear stack


#  Display unsorted volumes
#	call	prt_lst(pvols2, len2)

	la	$a0, hdr_un
	li	$v0, 4
	syscall

	la	$a0, pvols2
	lw	$a1, len2
	jal	prt_lst


#  Sort volumes
#	call	shellSort(pvols2, len2)

	la	$a0, pvols2
	lw	$a1, len2
	jal	shellSort


#  Generate volumes stats

	la	$a0, pvols2			# arg #1
	lw	$a1, len2			# arg #2
	la	$a2, min2			# arg #3
	la	$a3, med2			# arg #4
	subu	$sp, $sp, 12
	la	$t0, max2
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum2
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, ave2
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	pv_stats

	addu	$sp, $sp, 12			# clear stack

#  Display sorted volumes

	la	$a0, hdr_sr
	li	$v0, 4
	syscall

	la	$a0, pvols2
	lw	$a1, len2
	jal	prt_lst

#  Display volumes stats

	lw	$a0, min2
	lw	$a1, med2
	lw	$a2, max2
	lw	$a3, sum2
	subu	$sp, $sp, 4
	lw	$t0, ave2
	sw	$t0, ($sp)
	jal	prt_stats

	addu	$sp, $sp, 4


# ----------------------------
#  Data Set #3

	la	$a0, hdr_nm
	li	$v0, 4
	syscall

	move	$a0, $s0
	li	$v0, 1
	syscall

	la	$a0, hdr_ln
	li	$v0, 4
	syscall

	lw	$a0, len3
	li	$v0, 1
	syscall

	add	$s0, $s0, 1


#  find volumes
#	call para_vols(pvols3, len3, asides3, bsides3, csides3)

	la	$a0, pvols3
	lw	$a1, len3
	la	$a2, asides3
	la	$a3, bsides3
	subu	$sp, $sp, 4
	la	$t0, csides3
	sw	$t0, ($sp)			# arg #5, on stack
	jal	para_vols

	addu	$sp, $sp, 12			# clear stack


#  Display unsorted volumes
#	call	prt_lst(pvols3, len3)

	la	$a0, hdr_un
	li	$v0, 4
	syscall

	la	$a0, pvols3
	lw	$a1, len3
	jal	prt_lst


#  Sort volumes
#	call	shellSort(pvols3, len3)

	la	$a0, pvols3
	lw	$a1, len3
	jal	shellSort


#  Generate volumes stats

	la	$a0, pvols3			# arg #1
	lw	$a1, len3			# arg #2
	la	$a2, min3			# arg #3
	la	$a3, med3			# arg #4
	subu	$sp, $sp, 12
	la	$t0, max3
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum3
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, ave3
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	pv_stats

	addu	$sp, $sp, 12			# clear stack

#  Display sorted volumes

	la	$a0, hdr_sr
	li	$v0, 4
	syscall

	la	$a0, pvols3
	lw	$a1, len3
	jal	prt_lst

#  Display volumes stats

	lw	$a0, min3
	lw	$a1, med3
	lw	$a2, max3
	lw	$a3, sum3
	subu	$sp, $sp, 4
	lw	$t0, ave3
	sw	$t0, ($sp)
	jal	prt_stats

	addu	$sp, $sp, 4


# ----------------------------
#  Data Set #4

	la	$a0, hdr_nm
	li	$v0, 4
	syscall

	move	$a0, $s0
	li	$v0, 1
	syscall

	la	$a0, hdr_ln
	li	$v0, 4
	syscall

	lw	$a0, len4
	li	$v0, 1
	syscall

	add	$s0, $s0, 1


#  find volumes
#	call para_vols(pvols4, len4, asides4, bsides4, csides4)

	la	$a0, pvols4
	lw	$a1, len4
	la	$a2, asides4
	la	$a3, bsides4
	subu	$sp, $sp, 4
	la	$t0, csides4
	sw	$t0, ($sp)			# arg #5, on stack
	jal	para_vols

	addu	$sp, $sp, 12			# clear stack


#  Display unsorted volumes
#	call	prt_lst(pvols4, len4)

	la	$a0, hdr_un
	li	$v0, 4
	syscall

	la	$a0, pvols4
	lw	$a1, len4
	jal	prt_lst


#  Sort volumes
#	call	shellSort(pvols4, len4)

	la	$a0, pvols4
	lw	$a1, len4
	jal	shellSort


#  Generate volumes stats

	la	$a0, pvols4			# arg #1
	lw	$a1, len4			# arg #2
	la	$a2, min4			# arg #3
	la	$a3, med4			# arg #4
	subu	$sp, $sp, 12
	la	$t0, max4
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum4
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, ave4
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	pv_stats

	addu	$sp, $sp, 12			# clear stack

#  Display sorted volumes

	la	$a0, hdr_sr
	li	$v0, 4
	syscall

	la	$a0, pvols4
	lw	$a1, len4
	jal	prt_lst

#  Display volumes stats

	lw	$a0, min4
	lw	$a1, med4
	lw	$a2, max4
	lw	$a3, sum4
	subu	$sp, $sp, 4
	lw	$t0, ave4
	sw	$t0, ($sp)
	jal	prt_stats

	addu	$sp, $sp, 4


# ----------------------------
#  Data Set #5

	la	$a0, hdr_nm
	li	$v0, 4
	syscall

	move	$a0, $s0
	li	$v0, 1
	syscall

	la	$a0, hdr_ln
	li	$v0, 4
	syscall

	lw	$a0, len5
	li	$v0, 1
	syscall

	add	$s0, $s0, 1


#  find volumes
#	call para_vols(pvols5, len5, asides5, bsides5, csides5)

	la	$a0, pvols5
	lw	$a1, len5
	la	$a2, asides5
	la	$a3, bsides5
	subu	$sp, $sp, 4
	la	$t0, csides5
	sw	$t0, ($sp)			# arg #5, on stack
	jal	para_vols

	addu	$sp, $sp, 12			# clear stack


#  Display unsorted volumes
#	call	prt_lst(pvols5, len5)

	la	$a0, hdr_un
	li	$v0, 4
	syscall

	la	$a0, pvols5
	lw	$a1, len5
	jal	prt_lst


#  Sort volumes
#	call	shellSort(pvols5, len5)

	la	$a0, pvols5
	lw	$a1, len5
	jal	shellSort


#  Generate volumes stats

	la	$a0, pvols5			# arg #1
	lw	$a1, len5			# arg #2
	la	$a2, min5			# arg #3
	la	$a3, med5			# arg #4
	subu	$sp, $sp, 12
	la	$t0, max5
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum5
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, ave5
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	pv_stats

	addu	$sp, $sp, 12			# clear stack

#  Display sorted volumes

	la	$a0, hdr_sr
	li	$v0, 4
	syscall

	la	$a0, pvols5
	lw	$a1, len5
	jal	prt_lst

#  Display volumes stats

	lw	$a0, min5
	lw	$a1, med5
	lw	$a2, max5
	lw	$a3, sum5
	subu	$sp, $sp, 4
	lw	$t0, ave5
	sw	$t0, ($sp)
	jal	prt_stats

	addu	$sp, $sp, 4


# -----
#  Done, terminate program.

	li	$v0, 10
	syscall					# au revoir...

.end main


#####################################################################
#  Find volumes
#	pvols(n) = ( asides(n) * bsides(n) * csides(n) )

# -----
#	call para_vols(pvols1, len1, asides1, bsides2, csides3)

#    Arguments:
#	$a0   - starting address of the volumes array
#	$a1   - length
#	$a2   - starting address of the asides array
#	$a3   - starting address of the bsides array
#	($fp) - starting address of the csides array

#    Returns:
#	N/A

.globl	para_vols
.ent	para_vols
para_vols:

	subu	$sp, $sp, 4
	sw	$fp, ($sp)
	addu	$fp, $sp, 4

	move	$t0, $a0
	move	$t1, $a1
	move	$t2, $a2
	move	$t3, $a3
	lw	$t4, ($fp)

calcLoop:

	# multiply sides
	lw	$t5, ($t2)
	lw	$t6, ($t3)
	mul	$t5, $t5, $t6
	lw	$t6, ($t4)
	mul	$t5, $t5, $t6

	# save area
	sw	$t5, ($t0)

	# increment addresses
	add	$t0, $t0, 4
	add	$t2, $t2, 4
	add	$t3, $t3, 4
	add	$t4, $t4, 4
	
	sub	$t1, $t1, 1
	bgtz	$t1, calcLoop

	lw	$fp, ($sp)
	lw	$s0, 4($sp)
	addu	$sp, $sp, 4

	jr	$ra
.end	para_vols


#####################################################################
#  Sort a list of numbers using shell sort.

# -----
#    Arguments:
#	$a0 - starting address of the list
#	$a1 - list length

#    Returns:
#	n/a

.globl shellSort
.ent shellSort
shellSort:

	# t1 = h
	# t2 = i
	# t3 = j
	# t4 = temp
	
	# var h = 1;
	li	$t1, 1			#h = 1

#while ( (h*3+1) < length )
firstWhileLoop:

	#   h = 3 * h + 1;
	mul	$t0, $t1, 3
	add	$t0, $t0, 1

	# if (h * 3 + 1) >= length
	bge	$t0, $a1 firstWhileLoopDone

	move	$t1, $t0

	#   h = 3 * h + 1;
	b	firstWhileLoop

firstWhileLoopDone:

# while (h > 0)
secondWhileLoop:

	# if h <= 0
	ble	 $t1, 0, secondWhileLoopDone

	# else continue secondWhile

	# for (var i = h - 1# i < length# i++)

	# outer for loop init statment
	# i = h - 1
	sub	$t2, $t1, 1

	outerForLoop:

		# outer for loop test statment
		# i < length
		# if i >= length
		bge	$t2, $a1, outerForLoopDone

		# else continue outer for loop

		# var tmp = lst[i]
		mul	$t0, $t2, 4			# t0 = offset = i * 4
		add	$t0, $a0, $t0			# t0 = 1st address + offset
		lw	$t4, ($t0)			# t0 = value of list[i]

		# for (j = i# (j >= h) && (lst[j - h] > tmp)# j = j - h)

		# inner for loop init statment
		# j = i
		move	$t3, $t2

		innerForLoop:

			# inner for loop test statment
			# (j >= h) && (lst[j - h] > tmp)
			# if (j < h)
			blt	$t3, $t1, innerForLoopDone

			# -OR-
			
			# if (lst[j - h] <= tmp)			
			
			sub	$t9, $t3, $t1			# t9 = j - h
			mul	$t9, $t9, 4			# t9 = offset = (j - h) * 4
			add	$t9, $a0, $t9			# t9 = 1st address + offset
			lw	$t9, ($t9)			# t9 = value of list[j - h]
			ble	$t9, $t4, innerForLoopDone

			# else continue inner for loop
			
			# lst[j] = lst[j - h]
	
			mul	$t8, $t3, 4			# t8 = offset = j * 4
			add	$t8, $a0, $t8			# t8 = 1st address + offset

			sw	$t9, ($t8)			# save list[j - h] to list[j]

			# inner for loop increment statment
			# j = j - h
			sub	$t3, $t3, $t1
			
			b	innerForLoop
	
		innerForLoopDone:

		# lst[j] = tmp	
		mul	$t7, $t3, 4			# t7 = offset = j * 4
		add	$t7, $a0, $t7			# t8 = 1st address + offset

		sw	$t4, ($t7)			# save tmp to list[j]

		# outer for loop increment statment
		# i++
		add	$t2, $t2, 1

		b	outerForLoop 

	outerForLoopDone:		

	# h = h / 3
	div	$t1, $t1, 3
	b	secondWhileLoop
	
secondWhileLoopDone:

	jr	$ra
.end shellSort



#####################################################################
#  MIPS assembly language procedure, stats, that will
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

.globl pv_stats
.ent pv_stats
pv_stats:

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
	sub	$t9, $t1, 1
	mul	$t9, $t9, 4	
	add	$t9, $t0, $t9

	# save max
	lw	$t9, ($t9)
	sw	$t9, ($t4)						


	# get median
	div	$t9, $t1, 2		# t9 = length divided by 2
	mul	$t9, $t9, 4		# t9 = half length * 4
	add	$t9, $t0, $t9		# t9 = address of median of odd numbered list
	lw	$t8, ($t9)		# t8 = median value or upper media value

	# length even number check
	and	$t7, $t1, 1		
	beq	$t7, 1, medDone

	# when length is even numbered
	sub	$t9, $t9, 4		# move address
	lw	$t7, ($t9)		# t3 = lower median value	
	add     $t8, $t7, $t8
	div	$t8, $t8, 2

medDone:

	sw	$t8, ($t3)		

	li	$t9, 0		# $t1 = sum

statsLoop:

	lw	$t8, ($t0)	# get item
	add	$t9, $t9, $t8	# add to sum	
	add	$t0, $t0, 4	# increment addresses

	sub	$t1, $t1, 1
	bgtz	$t1, statsLoop

	# save ave
	sw	$t9, ($t5)		

	mtc1	$t9, $f4
	cvt.d.w $f4, $f4
	mtc1	$t1, $f6	
	cvt.d.w $f6, $f6
	div.d	$f2, $f4, $f6

#####################################################################

	lw	$fp, ($sp)
	lw	$s0, 4($sp)
	addu	$sp, $sp, 4

	jr	$ra
.end pv_stats


#####################################################################
#  MIPS assembly language procedure, prt_lst, to display
#   a list of numbers.  The numbers should be printed 6 per line.
#   The numbers are right justified (i.e., lined up on right
#   side).  Assumes that the largest number is 5 digits.

#  Note, due to the system calls, the saved registers must
#        be used.  As such, push/pop saved registers altered.

# -----
#    Arguments:
#	$a0 - starting address of the list
#	$a1 - list length

#    Returns:
#	N/A

.globl	prt_lst
.ent	prt_lst
prt_lst:

	move	$s0, $a0		# a0 is needed to save params
	move	$s1, $a1
	li	$s2, 1

printLoop:

	la	$a0, tab
	li	$v0, 4
	syscall	

	lw      $t0, ($s0)
	move	$a0, $t0
	li	$v0, 1
	syscall

	rem	$t1, $s2, NUMS_PER_ROW
	bnez 	$t1, notNewLine

	la	$a0, new_ln
	li	$v0, 4
	syscall	


notNewLine:	

	sub	$s1, $s1, 1
	add	$s0, $s0, 4
	add	$s2, $s2, 1
	bgtz	$s1, printLoop

	jr	$ra
.end prt_lst


#####################################################################
#  MIPS assembly language procedure, prt_stats, to display
#   the final results.  The procedure prints the maximum, median,
#   sum, and average.

# -----
#    Arguments:
#	$a0 - min
#	$a1 - med
#	$a2 - max
#	$a3 - sum1
#	($fp) - average

#    Returns:
#	n/a

.globl	prt_stats
.ent	prt_stats
prt_stats:

	move	$t0, $a0

	la	$a0, str1
	li	$v0, 4
	syscall

	move	$a0, $t0
	li	$v0, 1
	syscall

	la	$a0, str2
	li	$v0, 4
	syscall

	move	$a0, $a1
	li	$v0, 1
	syscall

	la	$a0, str3
	li	$v0, 4
	syscall

	move	$a0, $a2
	li	$v0, 1
	syscall

	la	$a0, str4
	li	$v0, 4
	syscall

	move	$a0, $a3
	li	$v0, 1
	syscall

	la	$a0, str5
	li	$v0, 4
	syscall

	move	$a0, $sp
	li	$v0, 1
	syscall


	jr	$ra
.end	prt_stats


#####################################################################