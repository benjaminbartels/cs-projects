#  CSC218, MIPS Assignment #0

#  Example program to display a list of
#  numbers and find the mimimum and maximum.


###########################################################
#  data segment

.data

array:	.word	13, 34, 16, 61, 28
	.word	24, 58, 11, 26, 41
	.word	19,  7, 38, 12, 13

len:	.word	15

min:	.word	0
max:	.word	0


hdr:	.asciiz	"\nExample program to find max/min\n\n"
new_ln:	.asciiz	"\n"

a1_msg:	.asciiz	"min = "
a2_msg:	.asciiz	"max = "


###########################################################
#  text/code segment

#  This program will use pointers.
#	t0 - array address
#	t1 - count of elements
#	t2 - min
#	t3 - max
#	t4 - each word from array

.text
.globl	main
.ent	main
main:

# -----
#  Display header.

	la	$a0, hdr
	li	$v0, 4
	syscall				# print header

# -----
#  Find max and min of the array.

	la	$t0, array		# set $t0 addr of array
	lw	$t1, len		# set $t1 to length

	lw	$t2, ($t0)		# set min, $t2 to array[0]
	lw	$t3, ($t0)		# set max, $t3 to array[0]

	add	$t0, $t0, 4		# skip array[0]
	add	$t1, $t1, -1		# length=length-1

loop:	lw	$t4, ($t0)		# get array[n]

	bge	$t4, $t2, noMin		# is new min?
	move	$t2, $t4		# set new min

noMin:	ble	$t4, $t3, noMax		# is new max?
	move	$t3, $t4		# set new max

noMax:	add	$t1, $t1, -1		# decrement counter
	add	$t0, $t0, 4		# increment addr by word
	bnez	$t1, loop

	sw	$t2, min		# save min
	sw	$t3, max		# save max

# -----
#  Display results.

#  Note, some of the system calls utilize/alter the
#        temporary registers.

	la	$a0, a1_msg
	li	$v0, 4
	syscall				# print "min = "

	lw	$a0, min
	li	$v0, 1
	syscall				# print min

	la	$a0, new_ln		# print a newline
	li	$v0, 4
	syscall

	la	$a0, a2_msg
	li	$v0, 4
	syscall				# print "max = "

	lw	$a0, max
	li	$v0, 1
	syscall				# print max

	la	$a0, new_ln		# print a newline
	li	$v0, 4
	syscall

# -----
#  Done, terminate program.

	li	$v0, 10
	syscall				# all done!

.end main