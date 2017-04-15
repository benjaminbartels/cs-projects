#  CS 218, MIPS Assignment #5
#  Provided Main


#  Write a simple assembly language program to
#  compute Pascal's triangle

#  The following function computes the kth element
#  of the nth row (k and n are 0-based):

#	Pascal(n,k)
#	   if k = 0 or k = n then
#	      return 1
#	   else
#	      return Pascal(n-1,k-1) + Pascal(n-1, k)



#####################################################################
#  data segment

.data

# -----
#  Define basic parameters

TRUE = 1
FALSE = 0
NUMSIZE = 6		# parameter for maximum number size (digits)


# -----
#  Local variables for main.

hdr:	.ascii	"\nMIPS Assignment #5\n"
	.asciiz	"Pascal's Triangle Program\n\n"

rows:	.word	0


# -----
#  Local variables for displayPascalTriangle routine.

rmsg1:	.asciiz	"\nrow "
rmsg2:	.asciiz	":    "


# -----
#  Local variables for readRows routine.

entN:	.asciiz	"\nEnter number of rows in triangle (1-25): "
badRow:	.asciiz	"\nError, valid row amount, please re-enter."


# -----
#  Local variables for prtPnum routine.

spc:	.asciiz	"   "

# -----
#  Local variables for prtBlanks routine.

spc1:	.asciiz	" "
nline:	.asciiz	"\n"


# -----
#  Local variables for checkAgain routine.

uAns:	.byte	0, 0, 0

ask:	.asciiz	"\n\nAnother Game (y/Y/n/N)? "
dMsg:	.asciiz	"\nGame Over. \nThank you for playing.\n\n"
badAns:	.asciiz	"\nError, invalid input, please try again."

#####################################################################
#  text/code segment

.text

.globl main
.ent main
main:

# -----
#  Display header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header


# -----
#  Read max rows (1-25).

pascalAgain:
	jal	readRows
	sw	$v0, rows


# -----
#  Display the pascal triangle.

	lw	$a0, rows
	jal	displayPascalTriangle


# -----
#  Check for another triangle?

	jal	checkAgain

	beq	$v0, TRUE, pascalAgain

# -----
#  Done, terminate program.

	la	$a0, nline
	li	$v0, 4
	syscall
	la	$a0, nline
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall					# au revoir...

.end main


#####################################################################
#  MIPS assembly language function, readRows()
#	Reads a number from the user and ensure that the number
#	is between 1 and 25 (inclusive).
#	Includes prompting and error checking.
#	Re-prompts for incorrect input.

# -----
#    Arguments:
#	none

#    Returns:
#	$v0 - n (between 1-25)


.globl	readRows
.ent	readRows
readRows:

	tryAgain:

		la	$a0, entN
		li	$v0, 4
		syscall

		li	$v0, 5
		syscall

		blt	$v0, 1, inputError
		bgt	$v0, 25, inputError
		b	inputDone

	inputError:

		la	$a0, badRow
		li	$v0, 4
		syscall

		b	tryAgain

	inputDone:

		jr	$ra

.end	readRows


#####################################################################
#  Display the pascal triangle.
#	Routine must compute the Pascal number (via call),
#	display approriate row headers (per example), and
#	then print the pascal numbers.

#	Uses prtPnum() procedure to print the formatted
#	pascal number.

#	Since the pascal() function computes a single
#	Pascal number, the pascal() function will need
#	to be called in a nested loop (rows and columns).


# -----
#    Arguments:
#	$a0 - rows (value)

#    Returns:
#	nothing


.globl	displayPascalTriangle
.ent	displayPascalTriangle
displayPascalTriangle:

	subu	$sp, $sp, 28
	sw	$fp, ($sp)
	sw	$ra, 4($sp)		
	sw	$gp, 8($sp)
	sw	$s0, 12($sp)		# i
	sw	$s1, 16($sp)		# j
	sw	$s2, 20($sp)		# k
	sw	$s3, 24($sp)		# rows
	addu	$fp, $sp, 28
	
	move	$s3, $a0

#            for (int i = 0; i <= num; i++)
#            {
#                for (int j = num; j > i; j--)
#                    Console.Write("   ");
#                for (int k = 0; k <= i; k++)
#                    Console.Write(calc(i, k).ToString().PadLeft(6, ' '));
#
#                Console.WriteLine("\n");
#            }

	# firstForLoop init
	li	$s0, 0

	firstForLoop:

		# firstForLoop test statment
		# i <= num
		# if i > num
		bge	$s0, $s3, firstForLoopDone

		la	$a0, nline
		li	$v0, 4
		syscall

		la	$a0, rmsg1
		li	$v0, 4
		syscall

		move	$a0, $s0
		li	$v0, 1
		syscall

		la	$a0, rmsg2
		li	$v0, 4
		syscall

		bgt	$s0, 9, noSpace

		la	$a0, spc1
		li	$v0, 4
		syscall		

		noSpace:

		move	$s1, $s3

		rowPrintLoop:

		# rowPrintLoop test statment
		# j > i
		# if j <= i
		ble	$s1, $s0, rowPrintLoopDone

		la	$a0, spc
		li	$v0, 4
		syscall

		sub	$s1, $s1, 1

		b	rowPrintLoop

		rowPrintLoopDone:

		# secondForLoop init
		li	$s2, 0

		secondForLoop:

			# secondForLoop test statment
			# k <= i
			# if k > i
			add	$t0, $s0, 1
			bge	$s2, $t0, secondForLoopDone
		
			move	$a0, $s0
			move	$a1, $s2

			jal	pascal

			move	$a0, $s0
			move	$a1, $v0

			jal prtPnum

			add	$s2, $s2, 1
			b	secondForLoop

		secondForLoopDone:

		add	$s0, $s0, 1
		b	firstForLoop	

	firstForLoopDone:
	

	lw	$fp, ($sp)
	lw	$ra, 4($sp)
	lw	$gp, 8($sp)
	lw	$s0, 12($sp)
	lw	$s1, 16($sp)
	lw	$s2, 20($sp)
	lw	$s3, 24($sp)
	addu	$sp, $sp, 28

	jr	$ra
.end	displayPascalTriangle


#####################################################################
#  Pascal's triangle.
#  Compute the kth element of the nth row.
#  Note, k and n are 0-based

#	Pascal(n,k)
#	   if k = 0 or k = n then
#	      return 1
#	   else
#	      return Pascal(n-1,k-1) + Pascal(n-1, k)

# -----
#    Arguments:
#	$a0 - n
#	$a1 - k

#    Returns:
#	$v0 - pascal(n,k)

.globl	pascal
.ent	pascal
pascal:

	subu	$sp, $sp, 32
	sw	$fp, ($sp)
	sw	$ra, 4($sp)		
	sw	$gp, 8($sp)
	sw	$s0, 12($sp)
	sw	$s1, 16($sp)
	sw	$s2, 20($sp)
	sw	$s3, 24($sp)
	sw	$s4, 28($sp)
	addu	$fp, $sp, 32

	move	$s0, $a0	# s0 = n
	move	$s1, $a1	# s1 = k
	move	$t0, $a0	# t0 = n
	move	$t1, $a1	# t1 = k
	
	beq	$s1, 0, returnOne	# if k = 0 return 1
	beq	$s1, $s0, returnOne	# if k = n return 1

	sub	$t0, $s0, 1
	sub	$t1, $s1, 1

	move	$a0, $t0
	move	$a1, $t1

	jal	pascal

	move	$s3, $v0

	sub	$t0, $s0, 1
	move	$a0, $t0
	move	$a1, $s1

	jal	pascal

	move	$s4, $v0

	add	$v0, $s3, $s4

	b	pascalEnd

	returnOne:

		li	$v0, 1

		b	pascalEnd

	pascalEnd:

	lw	$fp, ($sp)
	lw	$ra, 4($sp)
	lw	$gp, 8($sp)
	lw	$s0, 12($sp)
	lw	$s1, 16($sp)
	lw	$s2, 20($sp)
	lw	$s3, 24($sp)
	lw	$s4, 28($sp)
	addu	$sp, $sp, 32

	jr	$ra
.end pascal



#####################################################################
#  Print formatted pascal number as per asst #5 specificiations.
#	In order to provide the correct triangle output the
#	number will need to be printed in a formatted manner.

#	This procedure must use a procedure to print the
#	leading blanks.

# -----
#  Arguments:
#	$a0 - n (value)
#	$a1 - pascal number (value)

#  Returns
#	nothing


.globl	prtPnum
.ent	prtPnum
prtPnum:

	subu	$sp, $sp, 20
	sw	$fp, ($sp)
	sw	$ra, 4($sp)		
	sw	$gp, 8($sp)
	sw	$s0, 12($sp)
	sw	$s1, 16($sp)
	addu	$fp, $sp, 20

	move	$s0, $a0
	move	$s1, $a1

	rem	$t0, $s0, 2

	move	$a0, $s1
	li	$v0, 1
	syscall

	move	$a0, $s1
	la	$a1, NUMSIZE	
	jal	prtBlanks

	lw	$fp, ($sp)
	lw	$ra, 4($sp)
	lw	$gp, 8($sp)
	lw	$s0, 12($sp)
	lw	$s1, 16($sp)
	addu	$sp, $sp, 20

	jr	$ra
.end prtPnum


#####################################################################
#  Print an appropriate number of blanks based on
#  size of the number.

# -----
#  Arguments:
#	$a0 - number (value)
#	$a1 - max number of digits for number (value)

.globl	prtBlanks
.ent	prtBlanks
prtBlanks:

	subu	$sp, $sp, 20
	sw	$fp, ($sp)
	sw	$ra, 4($sp)		
	sw	$gp, 8($sp)
	sw	$s0, 12($sp)
	sw	$s1, 16($sp)
	addu	$fp, $sp, 20

	move      $s0, $a0

	bgt	$s0, 9, not1		
	li	$s1, 5
	b	done

	not1:
	bgt	$s0, 99, not2		
	li	$s1, 4
	b	done

	not2:
	bgt	$s0, 999, not3		
	li	$s1, 3
	b	done

	not3:
	bgt	$s0, 9999, not4		
	li	$s1, 2
	b	done

	not4:
	bgt	$s0, 99999, not5		
	li	$s1, 1
	b	done

	not5:
	
	li	$s1, 0

	done:

	spacePrintLoop:

		beqz	$s1, spacePrintLoopDone

		la	$a0, spc1
		li	$v0, 4
		syscall
		
		sub	$s1, $s1, 1
		
		b	spacePrintLoop

	spacePrintLoopDone:

	lw	$fp, ($sp)
	lw	$ra, 4($sp)
	lw	$gp, 8($sp)
	lw	$s0, 12($sp)
	lw	$s1, 16($sp)
	addu	$sp, $sp, 20


	jr	$ra
.end prtBlanks


#####################################################################
#  MIPS assembly language function, checkAgain() routine to
#  see if the user wants to display another pascals triangle.
#	Returns TRUE for "Y" or "y" and FALSE for "N" or "n".
#	Re-prompts for incorrect input.
#	If the user enters "N" or "n", the routine displays
#	a final message "Game Over." and "Thank you for playing.".

.globl	checkAgain
.ent	checkAgain
checkAgain:

	retry:

		la	$a0, ask
		li	$v0, 4
		syscall

		li	$v0, 12
		syscall

		beq	$v0, 'N', notAgain
		beq	$v0, 'n', notAgain
		beq	$v0, 'Y', doAgain
		beq	$v0, 'y', doAgain

		la	$a0, badAns
		li	$v0, 4
		syscall

		b	retry

	doAgain:

		li	$v0, TRUE
		b	checkAgainDone

	notAgain:

		la	$a0, dMsg
		li	$v0, 4
		syscall	

		li	$v0, FALSE
		b	checkAgainDone

	checkAgainDone:

		jr	$ra
.end	checkAgain

#####################################################################

