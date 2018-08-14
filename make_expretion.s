.equ TYPE, -8
.equ TOKENS, -16
.equ EXP, -24
.equ EXP_TYPE, 1
.equ CONST_TYPE, 2
.equ OPERATOR_TYPE, 3
.equ TYPE_OFFSET, 0
.equ VALUE_OFFSET, 8

.text
.globl make_expretion
.type make_expretion, @function

make_expretion:
	pushq %rbp
	movq %rsp, %rbp
	subq $24, %rsp
	movq %rdi, TOKENS(%rbp)
	movq (%rdi), %rdi		# first token
	call set_type
	movq %rax, TYPE(%rbp)
	movq $16, %rdi
	call malloc
	movq %rax, EXP(%rbp)
	movq TYPE(%rbp), %rdx
	movq %rdx, TYPE_OFFSET(%rax)
	movq TYPE(%rbp), %rdx
	cmpq $CONST_TYPE, %rdx
	je parse_const
	movq TYPE(%rbp), %rdx
	cmpq $OPERATOR_TYPE, %rdx
	je parse_operator
	jmp parse_exp

parse_const:
	movq TOKENS(%rbp), %rdi
	movq (%rdi), %rdi
	call atoi
	movq EXP(%rbp), %rbx
	movq %rax, VALUE_OFFSET(%rbx)
	movq TOKENS(%rbp), %rdi
	call erase_token
	jmp finish

parse_operator:
	movq TOKENS(%rbp), %rdi
	movq (%rdi), %rdi
	movzbq (%rdi), %rax
	movq EXP(%rbp), %rbx
	movq %rax, VALUE_OFFSET(%rbx)
	movq TOKENS(%rbp), %rdi
	call erase_token
	jmp finish

parse_exp:
	movq $8, %rdi
	call malloc
	movq EXP(%rbp), %rbx
	movq %rax, VALUE_OFFSET(%rbx)
	movq $0, (%rax)
	movq TOKENS(%rbp), %rdi
	call erase_token
	addq $8, TOKENS(%rbp)
start_loop:
	movq TOKENS(%rbp), %rdi
	movq (%rdi), %rdi
	movzbq (%rdi), %rbx
	cmpb $'), %bl
	je end_loop
	movq TOKENS(%rbp), %rdi
	call make_expretion
	movq %rax, %rsi
	movq EXP(%rbp), %rdi
	call append_entry
skip_removed_tokens:
	movq TOKENS(%rbp), %rdx
	cmpq $0, (%rdx)
	jne start_loop
	addq $8, TOKENS(%rbp)
	jmp skip_removed_tokens
end_loop:
	movq TOKENS(%rbp), %rdi
	call erase_token
	jmp finish

finish:
	movq EXP(%rbp), %rax
	addq $24, %rsp
	leave
	ret
