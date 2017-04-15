#  CS 219, MIPS Assignment #5


#####################################################################
#  data segment

.data

hdr:	.ascii	"CS 219 - Assignment #5\n"
	.asciiz	"Floating Point Calculations.\n\n"
nline:	.asciiz	"\n"


# -----
#  Single precision

fval1:	.float	7.25
fval2:	.float	2.5
fval3:	.float	7.5
fval4:	.float	2.3

fans1:	.float	0.0
fans2:	.float	0.0

fval:	.float	0.0001
fsum:	.float	0.0

fmsg1:	.asciiz	"\nFloat Answer #1 = "
fmsg2:	.asciiz	"\nFloat Answer #2 = "
fmsg3:	.asciiz	"\nFloat Sum = "

# -----
#  Double precision

dval1:	.double	7.25
dval2:	.double	2.5
dval3:	.double	7.5
dval4:	.double	2.3

dans1:	.double	0.0
dans2:	.double	0.0

dval:	.double	0.0001
dsum:	.double	0.0

dmsg1:	.asciiz	"\nDouble Answer #1 = "
dmsg2:	.asciiz	"\nDouble Answer #2 = "
dmsg3:	.asciiz	"\nDouble Sum = "


#####################################################################
#  text/code segment

.text

.globl	main
.ent	main
main:

# -----
#  Display simple header

	li	$v0, 4
	la	$a0, hdr
	syscall

# -----
#  Calculate float values
#	fans1 = fval1 + fval2
#	fans2 = fval3 + fval4

	l.s	$f0, fval1
	l.s	$f2, fval2
	add.s	$f0, $f0, $f2
	s.s	$f0, fans1

	l.s	$f4, fval3
	l.s	$f6, fval4
	add.s	$f4, $f4, $f6
	s.s	$f4, fans2

	l.d	$f8, dval1
	l.d	$f10, dval2
	add.d	$f8, $f8, $f10
	s.d	$f8, dans1

	l.d	$f12, dval3
	l.d	$f14, dval4
	add.d	$f12, $f12, $f14
	s.d	$f12, dans2
	

	l.s	$f16, fval
	l.d	$f20, dval

	li	$t0, 10000

	floatLoop:

		add.s	$f18, $f18, $f16
		add.d	$f22, $f22, $f20
		
		addi	$t0, $t0, -1

		bnez	$t0, floatLoop

	s.s	$f18, fsum
	s.d	$f22, dsum

# -----
#  Display results.

	li	$v0, 4
	la	$a0, fmsg1
	syscall
	li	$v0, 2
	l.s	$f12, fans1
	syscall

	li	$v0, 4
	la	$a0, fmsg2
	syscall
	li	$v0, 2
	l.s	$f12, fans2
	syscall

	li	$v0, 4
	la	$a0, nline
	syscall

# -----
#  Calculate double values
#	dans1 = dval1 + dval2
#	dans2 = dval3 + dval4

#	your code goes here...


# -----
#  Display results.

	li	$v0, 4
	la	$a0, dmsg1
	syscall
	li	$v0, 3
	l.d	$f12, dans1
	syscall

	li	$v0, 4
	la	$a0, dmsg2
	syscall
	li	$v0, 3
	l.d	$f12, dans2
	syscall

	li	$v0, 4
	la	$a0, nline
	syscall

# -----
#  Calcluate float values.
#	fsum = 0.0
#	do 10000 times
#		fsum = fsum + fval

#	your code goes here...

# -----
#  Display fsum.

	li	$v0, 4
	la	$a0, fmsg3
	syscall

	li	$v0, 2
	l.s	$f12, fsum
	syscall

# -----
#  Calcluate double values.
#	dsum = 0.0
#	do 10000 times
#		dsum = dsum + dval

#	your code goes here...


# -----
#  Display dsum.

	li	$v0, 4
	la	$a0, dmsg3
	syscall

	li	$v0, 3
	l.d	$f12, dsum
	syscall

	li	$v0, 4
	la	$a0, nline
	syscall

# -----
#  Done, terminate program.

	li	$v0, 10
	syscall					# au revoir...

.end main

#####################################################################

