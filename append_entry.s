.text
.globl append_entry
.type append_entry, @function

append_entry:
	pushq %rdi
	pushq %rsi
	call get_length
	pushq %rax
	addq $2, %rax
	imul $8, %rax
	movq %rax, %rsi
	movq 8(%rdi), %rdi
	call realloc
	popq %rbx
	popq %rsi
	popq %rdi
	movq %rax, 8(%rdi)
	movq %rsi, (%rax, %rbx, 8)
	incq %rbx
	movq $0, (%rax, %rbx, 8)
	ret
