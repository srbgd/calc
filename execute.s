.text
.globl execute
.type execute, @function

execute:
	cmpq $'+, %rdx
	je plus
	cmpq $'-, %rdx
	je minus
	cmpq $'*, %rdx
	je mul
	jmp zero

plus:
	addq %rsi, %rdi
	movq %rdi, %rax
	ret

minus:
	subq %rsi, %rdi
	movq %rdi, %rax
	ret

mul:
	imul %rsi, %rdi
	movq %rdi, %rax
	ret

zero:
	xorq %rax, %rax
	ret
