.text
.globl append_token
.type append_token, @function

append_token:
	pushq %rdi
	pushq %rdx
	pushq %rsi
	imul $8, %rsi
	call realloc
	popq %rsi
	decq %rsi
	popq %rdx
	popq %rdi
	movq %rdx, (%rax, %rsi, 8)
	ret
