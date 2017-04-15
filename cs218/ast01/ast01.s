#  CSC218, MIPS Assignment #1
#  Benjamin Bartels
#  Section 1002

###########################################################
#  data segment

.data

array:	.word   126, 1193,  982, 1339,  564,  631,  421,  148, 1936,  157
	.word   108,  172, 1698,  162, 1147,  137,  327, 1151,  147, 1354
	.word   432,  551,  176,  486,  490, 1810, 1116,  522, 1532,  445
	.word   163, 1745,  571, 1529,  218, 1219,  122, 1934,  370, 1125
	.word  1315,  145,  313,  174, 1118,  259, 1672,  126, 7230,  135
	.word   199,  104, 1106, 1105,  124,  625,  126,  229, 1248,  992
	.word   132, 1233,  936,  135, 1338,  445,  115, 2645,  246, 1002
	.word  1134,  144, 1032, 1106,   38, 1941, 1843,  145, 1447,  449
	.word   171, 1271,  477,  228, 1178,  184,  586,  186,  388, 1188
	.word   950,  852, 1754, 1254,  658,  760, 1161,  562, 1263,  764
	.word   199, 1213,  124,  366, 1740, 2352,  375, 1387,  114, 1425
len:	.word  110

listMin:	.word  0
listMax:	.word  0
listAve:	.word  0
evenMin:	.word  0
evenMax:	.word  0
evenSum:	.word  0
evenAve:	.word  0
divBySum:	.word  0
divBy7Min:	.word  0
divBy7Max:	.word  0
divBy7Ave:	.word  0

header:	.asciiz	"\nMIPS Assignment #1\nProgram to find:\n   * min, max, and average of a list of numbers.\n   * min, max, and average of the even values. \n   * min, max, and average of the values that are evenly divisible by 7.\n"
new_ln:	.asciiz	"\n"

listMinText:	.asciiz	"List min = "
listMaxText:	.asciiz	"List max = "
listAveText:	.asciiz	"List avg = "
evenMinText:	.asciiz	"Even min = "
evenMaxText:	.asciiz	"Even max = "
evenAveText:	.asciiz	"Even avg = "
divBy7MinText:	.asciiz	"Divisible by 7 min = "
divBy7MaxText:	.asciiz	"Divisible by 7 max = "
divBy7AveText:	.asciiz	"Divisible by 7 avg = "


###########################################################
#  text/code segment

#  This program will use pointers.
#	s0 - array address
#	s1 - each word from array
#	s2 - length
#	s3 - even count
#	s4 - div by 7 count
#	t0 - list sum
#	t1 - list min
#	t2 - list max
#	t3 - even sum
#	t4 - even min
#	t5 - even max
#	t6 - div by 7 sum
#	t7 - div by 7 min
#	t8 - div by 7 max

.text
.globl	main
.ent	main
main:
	
# -----
#  Display header.

	la	$a0, header
	li	$v0, 4
	syscall				# print header

	la	$s0, array		# array

	lw	$s2, len		# length
	li	$s3, 0			# even count
	li	$s4, 0			# div by 7 count

	li	$t0, 0			# sum
	lw	$t1, array		# min
	lw	$t2, array		# max

	li	$t3, 0			# even sum
	lw	$t4, array		# even min
	lw	$t5, array		# even max

	li	$t6, 0			# div by 7 sum
	lw	$t7, array		# div by 7 min
	lw	$t8, array		# div by 7 max

mainLoop:

	lw	$s1,($s0)		# get array(n)
	add	$t0, $t0, $s1
	bge	$s1, $t1, notMin
	move	$t1, $s1

notMin:

	ble	$s1, $t2, notMax
	move	$t2, $s1

notMax:

	and	$t9, $s1, 1		# t9 = and result
	beq	$t9, 1, notEven
	bge	$s1, $t4 notEMin
	move	$t4, $s1

notEMin:

	ble	$s1, $t5, notEMax
	move	$t5, $s1

notEMax:

	add	$t3, $t3, $s1
	add	$s3, $s3, 1

notEven:

	rem	$t9, $s1, 7		# t9 = rem 7 result
	bne	$t9, 0, notDivBy7
	bge	$s1, $t7 not7Min
	move	$t7, $s1

not7Min:

	ble	$s1, $t8, not7Max
	move	$t8, $s1

not7Max:

	add	$t6, $t6, $s1
	add	$s4, $s4, 1

notDivBy7:

	add	$s0, $s0, 4
	sub	$s2, $s2, 1
	bgtz	$s2, mainLoop

calcStats:				# Not used. For readability only

	sw	$t1, listMin	
	sw	$t2, listMax	
	sw	$t4, evenMin	
	sw	$t5, evenMax	
	sw	$t7, divBy7Min	
	sw	$t8, divBy7Max	

	lw	$s2, len
	div	$t9, $t0, $s2
	sw	$t9, listAve

	div	$t9, $t3, $s3
	sw	$t9, evenAve

	div	$t9, $t6, $s4
	sw	$t9, divBy7Ave

# -----
#  Display results.

#  Note, some of the system calls utilize/alter the
#        temporary registers.

	# Print list stats
	la	$a0, listMinText
	li	$v0, 4
	syscall

	lw	$a0, listMin
	li	$v0, 1
	syscall

	la	$a0, new_ln
	li	$v0, 4
	syscall

	la	$a0, listMaxText
	li	$v0, 4
	syscall

	lw	$a0, listMax
	li	$v0, 1
	syscall

	la	$a0, new_ln
	li	$v0, 4
	syscall

	la	$a0, listAveText
	li	$v0, 4
	syscall

	lw	$a0, listAve
	li	$v0, 1
	syscall

	la	$a0, new_ln
	li	$v0, 4
	syscall

	# Print even stats
	la	$a0, evenMinText
	li	$v0, 4
	syscall

	lw	$a0, evenMin
	li	$v0, 1
	syscall

	la	$a0, new_ln
	li	$v0, 4
	syscall

	la	$a0, evenMaxText
	li	$v0, 4
	syscall

	lw	$a0, evenMax
	li	$v0, 1
	syscall

	la	$a0, new_ln
	li	$v0, 4
	syscall

	la	$a0, evenAveText
	li	$v0, 4
	syscall

	lw	$a0, evenAve
	li	$v0, 1
	syscall

	la	$a0, new_ln
	li	$v0, 4
	syscall

	# Print even stats
	la	$a0, divBy7MinText
	li	$v0, 4
	syscall

	lw	$a0, divBy7Min
	li	$v0, 1
	syscall

	la	$a0, new_ln
	li	$v0, 4
	syscall

	la	$a0, divBy7MaxText
	li	$v0, 4
	syscall

	lw	$a0, divBy7Max
	li	$v0, 1
	syscall

	la	$a0, new_ln
	li	$v0, 4
	syscall

	la	$a0, divBy7AveText
	li	$v0, 4
	syscall

	lw	$a0, divBy7Ave
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