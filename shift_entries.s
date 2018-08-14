.text
.globl shift_entries
.type shift_entries, @function

shift_entries:
	movq %rsi, %rax
	addq $2, %rax			# index + 2
start_loop:
	cmpq %rdx, %rax
	jge end_loop
	movq (%rdi, %rax, 8), %rbx
	movq %rbx, (%rdi, %rsi, 8)
	movq $0, (%rdi, %rax, 8)
	incq %rsi
	incq %rax
	jmp start_loop
end_loop:
	ret
