#  CSC218, MIPS Assignment #2
#  Benjamin Bartels
#  Section 1002

###########################################################
#  data segment

.data

asides:	.word 15,  25,  33,  44,  58,  69,  72,  86,  99, 101
	.word 107, 121, 137, 141, 157, 167, 177, 181, 191, 199
	.word 202, 209, 215, 219, 223, 225, 231, 242, 244, 249
	.word 251, 253, 266, 269, 271, 272, 280, 288, 291, 299
	.word 369, 374, 377, 379, 382, 384, 386, 388, 392, 393

bsides: .word 32,  51,  76,  87,  90, 100, 111, 123, 132, 145
	.word 206, 212, 222, 231, 246, 250, 254, 278, 288, 292
	.word 332, 351, 376, 387, 390, 400, 411, 423, 432, 445
	.word 457, 487, 499, 501, 523, 524, 525, 526, 575, 594
	.word 634, 652, 674, 686, 697, 704, 716, 720, 736, 753

csides: .word 102, 113, 122, 139, 144, 151, 161, 178, 186, 197
	.word 203, 215, 221, 239, 248, 259, 262, 274, 280, 291
	.word 400, 404, 406, 407, 424, 425, 426, 429, 448, 492
	.word 501, 513, 524, 536, 540, 556, 575, 587, 590, 596
	.word 782, 795, 807, 812, 827, 847, 867, 879, 888, 894

sareas: .space 200

len:	.word 50

sa_min: .word 0
sa_med: .word 0
sa_max: .word 0
sa_sum: .word 0
sa_ave: .word 0

header:	.asciiz	"\nMIPS Assignment #2\n  Program to calculate surface area of each rectangular parallelepiped\n  in a series of rectangular parallelepiped.\n  Also finds min, med, max, sum, and average for surface areas.\n"
new_ln:	.asciiz	"\n"
spaces:	.asciiz	"    "

surfaceAreaText:	.asciiz	"Surface Areas:\n"

minText:	.asciiz	"surface areas min = "
medText:	.asciiz	"surface areas med = "
maxText:	.asciiz	"surface areas max = "
sumText:	.asciiz	"surface areas sum = "
aveText:	.asciiz	"surface areas ave = "

###########################################################
#  text/code segment

#  This program will use pointers.
#	s0 - asides address
#	s1 - bsides address
#	s2 - csides address
#	s3 - sareas address
#	s4 - length

.text
.globl	main
.ent	main
main:
	
# -----
#  Display header.

	# print header
	la	$a0, header
	li	$v0, 4
	syscall				

	# init addresses
	la	$s0, asides		# asides
	la	$s1, bsides		# bsides
	la	$s2, csides		# csides
	la	$s3, sareas		# sareas	

	# init counters
	lw	$s4, len		# length

mainLoop:

	# get sides
	lw	$t0, ($s0)
	lw	$t1, ($s1)
	lw	$t2, ($s2)

	# calculate area
	mul	$t3, $t0, $t1
	mul	$t4, $t1, $t2
	mul	$t5, $t0, $t2
	add	$t0, $t3, $t4
	add	$t0, $t0, $t5
	mul	$t0, $t0, 2

	# save area
	sw	$t0, ($s3)

	# add to sum
	lw	$t1, sa_sum
	add	$t1, $t1, $t0
	sw	$t1, sa_sum

	# increment addresses
	add	$s0, $s0, 4
	add	$s1, $s1, 4
	add	$s2, $s2, 4
	add	$s3, $s3, 4

	sub	$s4, $s4, 1
	bgtz	$s4, mainLoop

calcStats:				# Not used. For readability only

	# get max
	sw	$t0, sa_max		# t0 should have max at this point

	# get min
	la	$t0, sareas
	lw	$t1, ($t0)
	sw	$t1, sa_min

	# get median
	la	$s3, sareas		# s3 = sareas address again
	lw	$t0, len		# t0 = length
	div	$t1, $t0, 2		# t1 = length divided by 2
	mul	$t2, $t1, 4		# t2 = half length * 4
	add	$s3, $s3, $t2		# s3 = address of median of odd numbered list
	lw	$t3, ($s3)		# t3 = median value or upper media value

	# length even number check
	and	$t4, $t0, 1		
	beq	$t4, 1, medDone

	# when length is even numbered
	sub	$s3, $s3, 4		# move address
	lw	$t4, ($s3)		# t3 = lower median value	
	add     $t3, $t3, $t4
	div	$t3, $t3, 2

medDone:

	sw	$t3, sa_med

	# get sum and ave
	lw	$t0, len
	lw	$t1, sa_sum
	div	$t0, $t1, $t0
	sw	$t0, sa_ave


# -----
#  Display results.

#  Note, some of the system calls utilize/alter the
#        temporary registers.

	la	$a0, surfaceAreaText
	li	$v0, 4
	syscall

	la	$s3, sareas		# sareas
	lw	$s4, len
	li	$s5, 1

areaPrintLoop:

	lw      $t0, 0($s3)
	move	$a0, $t0
	li	$v0, 1
	syscall

	la	$a0, spaces
	li	$v0, 4
	syscall	

	rem	$t1, $s5, 6
	bnez 	$t1, notNewLine

	la	$a0, new_ln
	li	$v0, 4
	syscall	

notNewLine:	

	add	$s3, $s3, 4
	sub	$s4, $s4, 1
	add	$s5, $s5, 1
	bgtz	$s4, areaPrintLoop

	la	$a0, new_ln
	li	$v0, 4
	syscall	

	la	$a0, new_ln
	li	$v0, 4
	syscall	

	la	$a0, minText
	li	$v0, 4
	syscall

	lw	$a0, sa_min
	li	$v0, 1
	syscall

	la	$a0, new_ln
	li	$v0, 4
	syscall	

	la	$a0, medText
	li	$v0, 4
	syscall

	lw	$a0, sa_med
	li	$v0, 1
	syscall

	la	$a0, new_ln
	li	$v0, 4
	syscall	

	la	$a0, maxText
	li	$v0, 4
	syscall

	lw	$a0, sa_max
	li	$v0, 1
	syscall

	la	$a0, new_ln
	li	$v0, 4
	syscall	

	la	$a0, sumText
	li	$v0, 4
	syscall

	lw	$a0, sa_sum
	li	$v0, 1
	syscall

	la	$a0, new_ln
	li	$v0, 4
	syscall	

	la	$a0, aveText
	li	$v0, 4
	syscall

	lw	$a0, sa_ave
	li	$v0, 1
	syscall

	la	$a0, new_ln
	li	$v0, 4
	syscall	

# -----
#  Done, terminate program.

	li	$v0, 10
	syscall				# all done!

.end main