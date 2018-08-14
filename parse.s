.equ STR, -8
.equ TOKENS, -16
.equ EXP, -24

.text
.globl parse
.type parse, @function

parse:
	pushq %rbp
	movq %rsp, %rbp
	subq $24, %rsp
	movq $0, TOKENS(%rbp)	# pointer on the tokens
	movq $0, EXP(%rbp)	# pointer on the expretion
	movq %rdi, STR(%rbp)	# input string
	call tokenize
	movq %rax, TOKENS(%rbp)
	movq %rax, %rdi
	call make_expretion
	movq %rax, EXP(%rbp)
	movq TOKENS(%rbp), %rdi
	call free
	movq STR(%rbp), %rdi
	call free
	movq EXP(%rbp), %rax
	addq $24, %rsp
	leave
	ret
