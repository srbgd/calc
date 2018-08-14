.equ EXP, -8
.equ RESULT, -16
.equ LENGTH, -24
.equ NEXT, -32
.equ EXP_TYPE, 1
.equ CONST_TYPE, 2
.equ OPERATOR_TYPE, 3
.equ TYPE_OFFSET, 0
.equ VALUE_OFFSET, 8

.text
.globl reduce
.type reduce, @function

reduce:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	movq %rdi, EXP(%rbp)
	movq TYPE_OFFSET(%rdi), %rbx
	cmpq $CONST_TYPE, %rbx
	je const_type
	cmpq $OPERATOR_TYPE, %rbx
	je operator_type
	jmp exp_type

finish:
	addq $8, %rsp
	leave
	ret

operator_type:
	call free
	xor %rax, %rax
	jmp finish

const_type:
	movq VALUE_OFFSET(%rdi), %rax
	pushq %rax
	call free
	popq %rax
	jmp finish

exp_type:
	subq $16, %rsp
	call get_length
	movq %rax, LENGTH(%rbp)
	cmpq $1, %rax
	je one_arg
	cmpq $2, %rax
	je two_args
	jmp many_args

one_arg:
	movq VALUE_OFFSET(%rdi), %rdi
	movq (%rdi), %rdi
	call reduce
	movq %rax, RESULT(%rbp)
	movq EXP(%rbp), %rdi
	movq VALUE_OFFSET(%rdi), %rdi
	call free
	movq EXP(%rbp), %rdi
	call free
	movq RESULT(%rbp), %rax
	addq $16, %rsp
	jmp finish

two_args:
	movq $1, %rcx			# set multiplier
	movq VALUE_OFFSET(%rdi), %rdi
	movq (%rdi), %rdi
	movq VALUE_OFFSET(%rdi), %rdi
	cmpq $'+, %rdi
	je leave_multiplier_unchanged
	movq $-1, %rcx
leave_multiplier_unchanged:
	pushq %rcx
	movq EXP(%rbp), %rdi
	movq VALUE_OFFSET(%rdi), %rdi
	movq 8(%rdi), %rdi
	call reduce
	popq %rcx
	imul %rcx, %rax
	movq %rax, RESULT(%rbp)
	movq EXP(%rbp), %rdi
	movq VALUE_OFFSET(%rdi), %rdi
	movq (%rdi), %rdi
	call free
	movq EXP(%rbp), %rdi
	movq VALUE_OFFSET(%rdi), %rdi
	call free
	movq EXP(%rbp), %rdi
	call free
	movq RESULT(%rbp), %rax
	addq $16, %rsp
	jmp finish

many_args:
	movq EXP(%rbp), %rdi
	movq VALUE_OFFSET(%rdi), %rdi
	call get_next_operator
	subq $8, %rsp
	movq %rax, NEXT(%rbp)		# save next operator
	movq EXP(%rbp), %rdi
	movq VALUE_OFFSET(%rdi), %rdi
	leaq (%rdi, %rax, 8), %rdi
	subq $8, %rdi
	movq (%rdi), %rdi
	call reduce
	pushq %rax			# save left expretion result
	movq EXP(%rbp), %rdi
	movq VALUE_OFFSET(%rdi), %rdi
	movq NEXT(%rbp), %rax
	leaq (%rdi, %rax, 8), %rdi
	addq $8, %rdi
	movq (%rdi), %rdi
	call reduce
	popq %rdi			# left expretion
	movq %rax, %rsi			# right expretion
	movq EXP(%rbp), %rax
	movq VALUE_OFFSET(%rax), %rax
	movq NEXT(%rbp), %rdx
	leaq (%rax, %rdx, 8), %rdx
	movq (%rdx), %rdx
	movq VALUE_OFFSET(%rdx), %rdx	# operator
	call execute
	movq %rax, RESULT(%rbp)
	movq NEXT(%rbp), %rax
	movq EXP(%rbp), %rdi
	movq VALUE_OFFSET(%rdi), %rdi
	leaq (%rdi, %rax, 8), %rdi
	movq (%rdi), %rdi
	call free
	movq $16, %rdi
	call malloc
	movq %rax, %rbx
	movq NEXT(%rbp), %rax
	decq %rax
	movq EXP(%rbp), %rdi
	movq VALUE_OFFSET(%rdi), %rdi
	movq %rbx, (%rdi, %rax, 8)
	movq $CONST_TYPE, (%rbx)
	movq RESULT(%rbp), %rax
	movq %rax, VALUE_OFFSET(%rbx)
	movq EXP(%rbp), %rdi
	movq VALUE_OFFSET(%rdi), %rdi
	movq NEXT(%rbp), %rax
	movq $0, (%rdi, %rax, 8)
	incq %rax
	movq $0, (%rdi, %rax, 8)
	movq EXP(%rbp), %rdi
	movq VALUE_OFFSET(%rdi), %rdi
	movq NEXT(%rbp), %rsi
	movq LENGTH(%rbp), %rdx
	call shift_entries
	movq EXP(%rbp), %rdi
	call reduce
	addq $24, %rsp
	jmp finish
