.data
	nl: .asciiz "\n"

.text

main:
	li $a0, 10
	li $a1, 10
	
	jal multiply
	
	la $a0, ($v0)
	li $v0, 1
	syscall
	
	jal new_line
	
	li $a0, 4
	
	j fakultet
	
return_fakultet:
	la $a0, ($v0)
	li $v0, 1
	syscall
	
	li $v0 10
	syscall

multiply:
	li $t0, 0
	j mulloop
	
mulloop:
	beq $a1, $zero, exit
	addi $a1, $a1, -1
	add $t0, $t0, $a0
	j mulloop
	
fakultet:
	la $t1, ($a0)
	addi $t1, $t1, -1
	
fakloop:
	beq $a1, $zero, return_fakultet
	la $a1, ($t1)
	jal multiply
	la $a0, ($v0)
	addi $t1, $t1, -1
	j fakloop
	

exit:
	la $v0, ($t0) 
	jr $ra
	
new_line:
	la $a0, nl
	li $v0, 4
	syscall
	jr $ra