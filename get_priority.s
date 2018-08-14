.text
.globl get_priority
.type get_priority, @function

get_priority:
	cmpq $'+, %rdi
	je one
	cmpq $'-, %rdi
	je one
	cmpq $'*, %rdi
	je two
	jmp zero

one:
	movq $1, %rax
	ret

two:
	movq $2, %rax
	ret

zero:
	xorq %rax, %rax
	ret
