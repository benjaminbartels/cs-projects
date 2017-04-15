;  Benjamin Bartels
;  Section 1002
;  CS 218
;  Assignment #11
;  Provided Procedures Template

;-----------------------------

section	.data

; -----
;  Define standard constants

LF		equ	10			; line feed
NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	-1

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_exit	equ	1			; system call code for terminate
SYS_fork	equ	2			; system call code for fork
SYS_read	equ	3			; system call code for read
SYS_write	equ	4			; system call code for write
SYS_open	equ	5			; system call code for file open
SYS_close	equ	6			; system call code for file close
SYS_create	equ	8			; system call code for file open/create

O_RDONLY	equ	000000q			; file permission - read only
O_WRONLY	equ	000001q			; file permission - write only
O_RDWR		equ	000002q			; file permission - read and write

S_IRUSR		equ	00400q			; user permission to read
S_IWUSR		equ	00200q			; to write
S_IXUSR		equ	00100q			; to execute

; -----
;  rot13 specific constants

SUCCESS		equ	0
NOSUCCESS	equ	1
LASTREAD	equ	2

ROT		equ	13

BUFF_LARGE	equ	60000
BUFF_SMALL	equ	5

; -----
;  Local variables for getFileDescriptors routine.

errUsage	db	"Usage: rot13 -bf <L/l/S/s> -if "
		db	"<inputFile> -of <outputFile>", LF, NULL

errBF		db	"Error, must specify buffer size: "
		db	"-/bf <L/l/S/s>", LF, NULL
errLS		db	"Error, must specify L/l (Large) or S/s (Small)."
		db	LF, NULL

errIF		db	"Error, must specify input file name: "
		db	"-if <inputFile>", LF, NULL
errIFbad	db	"Error, opening input file."
		db	LF, NULL

errOF		db	"Error, must specify output file name: "
		db	"-of <outputFile>", LF, NULL
errOFbad	db	"Error, opening output file."
		db	LF, NULL

errTooFew	db	"Error, command line arguments "
		db	"incomplete.", LF, NULL
errTooMany	db	"Error, too many characters entered "
		db	"on command line.", LF, NULL

; -----
;  Local variables for writeBuff routine.

errOnWrite	db	"Unrecoverable error on output file write."
		db	LF, "Program terminated."
		db	LF, NULL

; -----
;  Local variables for readBuff

lastRead	db	FALSE					; flag for last read

errOnRead	db	"Unrecoverable error on input file read."
		db	LF, "Program terminated."
		db	LF, NULL

; -------------------------------------------------------

section	.text

; -------------------------------------------------------
;  Check command line information.
;	Includes all error checking and opening files
;	and returning file descriptors

;  Note, the buffer size choice accepts "L", "l",
;	"S", or "s".  The procedure must return ONLY
;	an "l" or "s" for the buffer size choice.
;  Note, the buffer size choice is a byte variable

; -----
;  status = getFileDescriptors (ARGC, ARGV, buffSizePick,
;				fdInput, fdOutput)

; -----
; Arguments:
;	1) ARGC, value, (8)
;	2) ARGV, address (12)
;	3) buffer size pick, address (16)
;	4) input file descriptor, address (20)
;	5) output file descriptor, address (24)
;  Returns:
;	status code (in eax)
;	buffer size pick (via passed address)
;	input file descriptor (via passed address)
;	output file descriptor (via passed address)

global getFileDescriptors
getFileDescriptors:

	push ebp
	mov ebp, esp
	push ebx
	push ecx

	mov eax, dword [ebp + 8]		; get ARGC

	; check arg count
	cmp eax, 1
	je errorUsage

	cmp eax, 7
	jg errorTooMany

	cmp eax, 7
	jl errorTooFew

	mov esi, dword [ebp + 12]

	; check Arg labels
	mov ebx, dword [esi + 4]		; get "-bf"
	cmp dword [ebx], 0x0066622d
	jne errorBF

	mov ebx, dword [esi + 12]		; get "-if"
	cmp dword [ebx], 0x0066692d
	jne errorIF

	mov ebx, dword [esi + 20]		; get "-of"
	cmp dword [ebx], 0x00666f2d
	jne errorOf


	; check/convert buffer size
	mov ebx, dword [esi + 8]

	; must be only one char
	cmp byte [ebx + 1], NULL
	jne errorLS

	cmp byte [ebx], "L"
	je isL
	cmp byte [ebx], "l"
	je validSize
	cmp byte [ebx], "S"
	je isS
	cmp byte [ebx], "s"
	je validSize

	; if it gets here it is an error	
	jmp errorLS	
	
	isL:

		mov byte [ebx], "l"
		jmp validSize

	isS:

		mov byte [ebx], "s"
		jmp validSize
	

	validSize:

		mov ecx, 0
		mov cl, byte [ebx]
		mov eax, dword [ebp + 16]
		mov dword [eax], ecx

		; check input filename	
		mov eax, SYS_open
		mov ebx, dword [esi + 16]
		mov ecx, O_RDONLY
		int 0x80

		cmp eax, 0
		jl errorIFbad

		mov ecx, dword [ebp + 20]
		mov dword [ecx], eax

		; check output filename
		mov eax, SYS_create
		mov ebx, dword [esi + 24]
		mov ecx, O_WRONLY
		int 0x80

		cmp eax, 0
		jl errorOFbad

		mov ecx, dword [ebp + 24]
		mov dword [ecx], eax

		mov eax, SUCCESS	
		jmp endGetFileDescriptors
		

	; Error handlers, should not fall into this code
	errorUsage:

		push dword errUsage
		call printString
		add esp, 4
		jmp finishError
	
	errorTooMany:
		push dword errTooMany
		call printString
		add esp, 4
		jmp finishError

	errorTooFew:
		push dword errTooFew
		call printString
		add esp, 4
		jmp finishError

	errorBF:
		push dword errBF
		call printString
		add esp, 4
		jmp finishError

	errorIF:
		push dword errIF
		call printString
		add esp, 4
		jmp finishError

	errorOf:
		push dword errOF
		call printString
		add esp, 4
		jmp finishError

	errorLS:
		push dword errLS
		call printString
		add esp, 4
		jmp finishError	

	errorIFbad:
		push dword errIFbad
		call printString
		add esp, 4
		jmp finishError

	errorOFbad:
		push dword errOFbad
		call printString
		add esp, 4
		jmp finishError

	finishError:
		mov eax, NOSUCCESS

	endGetFileDescriptors:	

		pop ecx
		pop ebx
		mov esp, ebp	 		;restore ESP (clear local vars)
		pop ebp
		ret

; ******************************************************************
;  Read buffer function.
;	read from input file descriptor and place
;	characters in buffer.
;	Returns characters and the number of characters read
;	Note, must check for last read and subsequently
;	return 0 characters (on next call)

;	Note, must check for error on read -> unlikely
;		but can not allow untrapped errors...

; -----
;  charCount = buffRead (buffer, fdInput, buffSizePick)

; -----
;  Arguments:
;	1) buffer, address (8)
;	2) fdInput, value (12)
;	3) buffSizePick ("l" or "s"), value (16)
;  Returns:
;	count of characters read (in eax)
;	characters in buffer (via passed address)

global	buffRead
buffRead:

	push ebp
	mov ebp, esp
	push ebx
	push ecx
	push edx

	mov eax, 0
	cmp byte [lastRead], TRUE ; eof check
	je readDone
 
	; convert buffer size 
	mov edx, BUFF_SMALL
	mov eax, dword [ebp + 16]
	cmp al, "s"
	je setBFDone
	mov edx, BUFF_LARGE
	
	setBFDone:

		; read file
		mov eax, SYS_read
		mov ebx, dword [ebp + 12]
		mov ecx, dword [ebp + 8]
		int 0x80

		cmp eax, 0
		jl errorOnRead

		cmp eax, edx
		jl eofFound
		jmp endBuffRead

	eofFound:
		mov byte [lastRead], TRUE
		jmp endBuffRead		

	errorOnRead:
		push dword errOnRead
		call printString
		add esp, 4
		jmp endBuffRead

	readDone:

		mov byte [lastRead], FALSE

	endBuffRead:	

		pop edx
		pop ecx
		pop ebx
		mov esp, ebp	 		;restore ESP (clear local vars)
		pop ebp
		ret


; ******************************************************************
;  Rotate Characters (ROT13) Routine.
;	If letter (upper or lower case), rotate 13 places
;	if non-letter, do not change

; -----
;  call  rotate13 (buffer, readChrCnt)

; -----
;  Arguments:
;	1) buffer, address (8)
;	2) readCharCnt, value (12)
;  Returns
;	N/A
;	Note, characters in buffer are modified

global rotate13
rotate13:

	push ebp
	mov ebp, esp
	push eax
	push ebx
	push ecx
	push esi

	; init regisers
	mov esi, 0
        mov ecx, dword [ebp + 12]
	mov ebx, dword [ebp + 8]

	; rot13:
	; A-M + 13
	; N-Z - 13	
	rotateLoop:

		mov eax, 0
		mov al, byte [ebx + esi]

		cmp al, "A"
		jl invalidChar
		cmp al, "M"
		jg notAthruM

		jmp plus13

	notAthruM:

		cmp al, "Z"
		jg notCapital

		jmp minus13

	notCapital:

		cmp al, "a"
		jl invalidChar
		cmp al, "m"
		jg notLowerAthruM

		jmp plus13

	notLowerAthruM:

		cmp al, "z"
		jg invalidChar

		jmp minus13
		
	plus13:
		add al, 13
		jmp done

	minus13:
		sub al, 13
		jmp done		

	done:
	
		mov byte [ebx + esi], al

	invalidChar:

		inc esi
		loop rotateLoop

		pop edi
		pop esi
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp	 		
		pop ebp
		ret

; ******************************************************************
;  Write buffer function.
;	write characters from buffer to the output
;	file descriptor

;	Note, must check for error on write -> unlikely
;		but can not allow untrapped errors...

; -----
;  call  status = buffWrite (buffer, fdOutput, readChrCnt)

; -----
;  Arguments passed:
;	1) buffer, address (8)
;	2) fdOutput, value (12)
;	3) readChrCnt, value (16)
;  Returns
;	status (SUCCESS / NOSUCCESS)

global buffWrite
buffWrite:

	push ebp
	mov ebp, esp
	push ebx
	push ecx
	push edx

	;write to file
	mov eax, SYS_write
	mov ebx, dword [ebp + 12]
	mov ecx, dword [ebp + 8]
	mov edx, dword [ebp + 16]
	int 0x80

	cmp eax, 0
	jl errorOnWrite

	mov eax, SUCCESS

	jmp endBuffWrite

	errorOnWrite:

		push dword errOnWrite
		call printString
		add esp, 4
		mov eax, NOSUCCESS
		jmp endBuffRead

	endBuffWrite:	

		pop edx
		pop ecx
		pop ebx
		mov esp, ebp	 		;restore ESP (clear local vars)
		pop ebp
		ret


; ******************************************************************
;  Generic procedure to display a string to the screen.
;  String must be NULL terminated.
;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

;  Arguments:
;	1) address, string
;  Returns:
;	N/A

global	printString
printString:
	push	ebp
	mov	ebp, esp
	push	eax
	push	ebx
	push	ecx
	push	edx

; -----
;  Count characters in string.

	mov	ebx, [ebp+8]
	mov	edx, 0
stringCountLoop:
	cmp	byte [ebx], NULL
	je	stringCountDone
	inc	edx
	inc	ebx
	jmp	stringCountLoop
stringCountDone:

; -----
;  Call OS to output string.

	mov	eax, SYS_write			; system code for write()
	mov	ebx, STDOUT			; file descriptor for standard in
	mov	ecx, [ebp+8]			; address of characters to write
						; EDX=count (to write), set above
	int	80h				; syscall

; -----
;  String printed, return to calling routine.

	pop	edx
	pop	ecx
	pop	ebx
	pop	eax
	pop	ebp
	ret

; ******************************************************************

