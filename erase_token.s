.text
.globl erase_token
.type erase_token, @function

erase_token:
	pushq %rdi
	movq (%rdi), %rdi
	call free
	popq %rdi
	movq $0, (%rdi)
	ret
