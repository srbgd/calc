.equ EXP_TYPE, 1

.text
.globl get_length
.type get_length, @function

# rdi is caller-save

get_length:
	movq (%rdi), %rax
	cmpq $EXP_TYPE, %rax
	jne not_exp
	pushq %rdi
	xorq %rbx, %rbx
	movq 8(%rdi), %rdi
start_loop:
	movq (%rdi, %rbx, 8), %rdx
	testq %rdx, %rdx
	je finish
	incq %rbx
	jmp start_loop

finish:
	popq %rdi
	movq %rbx, %rax
	ret

not_exp:
	movq $1, %rax
	ret
