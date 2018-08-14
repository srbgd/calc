.equ TOKENS, -8
.equ STR, -16
.equ COUNT, -24

.section .rodata
multiply_operator_str:
	.string "*"
minus_operator_str:
	.string "-"
plus_operator_str:
	.string "+"
close_bracket_str:
	.string ")"
open_bracket_str:
	.string "("

.text
.globl tokenize
.type tokenize, @function

tokenize:
	pushq %rbp
	movq %rsp, %rbp
	subq $24, %rsp
	movq $0, TOKENS(%rbp)	# pointer on the tokens
	movq $0, COUNT(%rbp)	# number of tokens
	movq %rdi, STR(%rbp)	# input string
loop_step:
	movq STR(%rbp), %rax
	movzbq (%rax), %rbx	# get first byte of the string
	testb %bl, %bl		# check if it is zero
	jz end_loop		# finish loop because of the end of the string
	cmpb $'(, %bl
	je open_bracket
	cmpb $'), %bl
	je close_bracket
	cmpb $'+, %bl
	je plus_operator
	cmpb $'-, %bl
	je minus_operator
	cmpb $'*, %bl
	je multiply_operator
	cmpb $'0, %bl		# check if current character is a digit
	jl next_step
	cmpb $'9, %bl
	jle digit
next_step:
	incq STR(%rbp)
	jmp loop_step
end_loop:
	movq $0, %rdx
	movq TOKENS(%rbp), %rdi
	incq COUNT(%rbp)
	movq COUNT(%rbp), %rsi
	call append_token
	addq $24, %rsp
	leave
	ret


digit:
	movq STR(%rbp), %rsi	# set pointer to the end of the number
start_digit_loop:		# find the end of the number
	movzbq (%rsi), %rbx
	cmpb $'0, %bl
	jl finish
	cmpb $'9, %bl
	jg finish
	incq %rsi
	jmp start_digit_loop
finish:
	subq STR(%rbp), %rsi	# calculate the length of the number
	movq %rsi, %rcx
	pushq %rcx
	movq %rsi, %rdi
	incq %rdi
	call malloc
	movq %rax, %rdx		# save token address
	movq %rax, %rdi
	movq STR(%rbp), %rsi
	popq %rcx
	cld
	rep movsb		# copy number in the allocated memory
	movb $0, (%rdi)
	decq %rsi
	movq %rsi, STR(%rbp)	# restore input string address
	incq COUNT(%rbp)
	movq TOKENS(%rbp), %rdi
	movq COUNT(%rbp), %rsi
	call append_token
	movq %rax, TOKENS(%rbp)
	jmp next_step

multiply_operator:
	movq $multiply_operator_str, %rdi
	jmp append

minus_operator:
	movq $minus_operator_str, %rdi
	jmp append

plus_operator:
	movq $plus_operator_str, %rdi
	jmp append

close_bracket:
	movq $close_bracket_str, %rdi
	jmp append

open_bracket:
	movq $open_bracket_str, %rdi
	jmp append

append:
	call strdup
	movq %rax, %rdx
	movq TOKENS(%rbp), %rdi
	incq COUNT(%rbp)
	movq COUNT(%rbp), %rsi
	call append_token
	movq %rax, TOKENS(%rbp)
	jmp next_step
