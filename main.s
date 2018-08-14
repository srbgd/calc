.equ BUF_SIZE, 1000

.section .rodata
format_str:
	.string "%d\n"

.bss
buf:
	.space BUF_SIZE

.text
.globl main
.type main, @function

main:
	pushq	%rbp
	movq	%rsp, %rbp
	movq $buf, %rdi
	movl $BUF_SIZE, %esi
	movq stdin, %rdx
	call fgets
	movq $buf, %rdi
	call append_brackets
	movq %rax, %rdi
	call parse
	movq %rax, %rdi
	call reduce
	movq $format_str, %rdi
	movq %rax, %rsi
	xor %rax, %rax
	call printf
	leave
	ret
