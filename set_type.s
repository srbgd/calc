.equ EXP_TYPE, 1
.equ CONST_TYPE, 2
.equ OPERATOR_TYPE, 3

.text
.globl set_type
.type set_type, @function

set_type:
	movzbq (%rdi), %rbx
	cmpb $'(, %bl
	je set_type_expretion
	cmpb $'), %bl
	je set_type_expretion
	cmpb $'+, %bl
	je set_type_operator
	cmpb $'-, %bl
	je set_type_operator
	cmpb $'*, %bl
	je set_type_operator
	jmp set_type_const

set_type_expretion:
	movq $EXP_TYPE, %rax
	ret

set_type_operator:
	movq $OPERATOR_TYPE, %rax
	ret

set_type_const:
	movq $CONST_TYPE, %rax
	ret
