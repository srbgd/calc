.equ ENTRIES, -8
.equ INDEX, -16
.equ PRIORITY, -24
.equ CURRENT_INDEX, -32
.equ TYPE_OFFSET, 0
.equ VALUE_OFFSET, 8
.equ EXP_TYPE, 1
.equ CONST_TYPE, 2
.equ OPERATOR_TYPE, 3

.text
.globl get_next_operator
.type get_next_operator, @function

get_next_operator:
	pushq %rbp
	movq %rsp, %rbp
	subq $32, %rsp
	movq %rdi, ENTRIES(%rbp)
	movq $0, CURRENT_INDEX(%rbp)
	movq $0, PRIORITY(%rbp)
start_loop:
	movq CURRENT_INDEX(%rbp), %rdi
	movq ENTRIES(%rbp), %rax
	movq (%rax, %rdi, 8), %rbx
	cmpq $0, %rbx
	je end_loop
	movq TYPE_OFFSET(%rbx), %rax
	cmpq $OPERATOR_TYPE, %rax
	jne loop_step
	movq %rdi, CURRENT_INDEX(%rbp)
	movq VALUE_OFFSET(%rbx), %rdi
	call get_priority
	movq PRIORITY(%rbp), %rbx
	cmpq %rax, %rbx
	jge loop_step
	movq CURRENT_INDEX(%rbp), %rdi
	movq %rdi, INDEX(%rbp)
	movq %rax, PRIORITY(%rbp)
loop_step:
	incq CURRENT_INDEX(%rbp)
	jmp start_loop
end_loop:
	movq INDEX(%rbp), %rax
	addq $32, %rsp
	leave
	ret
