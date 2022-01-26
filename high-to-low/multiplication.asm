.globl multiply
.globl factorial

# Push value to application stack.
.macro	PUSH (%reg)
	addi	$sp,$sp,-4              # decrement stack pointer (stack builds "downwards" in memory)
	sw	    %reg,0($sp)         # save value to stack
.end_macro

# Pop value from application stack.
.macro	POP (%reg)
	lw	    %reg,0($sp)  # load value from stack to given registry
	addi	$sp,$sp,4        # increment stack pointer (stack builds "downwards" in memory)
.end_macro

.data
	nl: .asciiz "\n"

.text 

main:
	li $a0, 11
	li $a1, 10
	
	jal multiply
	
	la $a0, ($v0)
	li $v0, 1
	syscall
	
	jal new_line
	
	li $a0, 12
	
	jal factorial
	
	la $a0, ($v0)
	li $v0, 1
	syscall
	
	li $v0 10
	syscall
multiply:
	PUSH($ra)
	PUSH($a0)
	PUSH($a1)
	li $t0, 0
	mulloop:
		beq $a1, $zero, mulexit
		addi $a1, $a1, -1
		add $t0, $t0, $a0
		j mulloop
	mulexit:
		la $v0, ($t0) 
		POP($a1)
		POP($a0)
		POP($ra)
		jr $ra
	
factorial:
	PUSH($ra)
	PUSH($a0)
	PUSH($a1)
	addi $a1, $a0, -1
	facloop:
		beq $a1, $zero, facexit
		jal multiply
		la $a0, ($v0)
		addi $a1, $a1, -1
		j facloop
	facexit:
		la $v0, ($a0)
		POP($a1)
		POP($a0)
		POP($ra)
		jr $ra

	
	
new_line:
	la $a0, nl
	li $v0, 4
	syscall
	jr $ra
