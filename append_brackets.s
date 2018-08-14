.text
.globl append_brackets
.type append_brackets, @function

append_brackets:
	pushq %rbp
	movq %rsp, %rbp		# save base pointer
	pushq %rdi		# save input string addres
	call strlen		# get length of input string
	pushq %rax
	movq %rax, %rdi
	addq $3, %rdi		# increase the length of output string
	call malloc		# allocate space for output string
	movb $'(, (%rax)	# set first character of the output string
	leaq 1(%rax), %rdi
	popq %rcx
	popq %rsi
	cld			# clear direction flag
	rep movsb
	movb $'), 0(%rdi)
	movb $0, 1(%rdi)
	leave
	ret
