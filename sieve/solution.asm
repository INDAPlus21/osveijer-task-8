.data
 primes: .space 1000
 err_msg: .asciiz "Invalid input! Expected integer between 1 and 1000."
 split: .asciiz ", "
 nl: .asciiz "\n"

.text
main: 
  li $v0, 5
  syscall
  
  la $s0, ($v0)
  
  li $t0, 1001
  slt $t1, $s0, $t0
  beq $t1, $zero, invalid_input
  
  li $t0, 1
  slt $t1, $t0, $s0
  beq $t1, $zero, invalid_input
  
  la $t0, primes
  li $t1, 999
  li $t2, 0
  li $t3, 1
  
init_loop:
  sb $t3, ($t0)
  add $t0, $t0, 1
  add $t2, $t2, 1
  bne $t1, $t2, init_loop

li $t0, 1000
beq $s0, $t0, skip_if_no_higher_number

# clear numbers that are over input
  la $t0, primes
  add $t1, $t0, $s0
  addi $t1, $t1, -1
  addi $t2, $t0, 999
clear_loop:
  sb $zero, ($t1)
  addi $t1, $t1, 1
  bne $t1, $t2, clear_loop
  
skip_if_no_higher_number:
  

  li $t0, -1
  la $t1, primes
  la $t7, ($s0)
  add $t7, $t7, $t0
  add $t5, $t1, $t7
# seive
sieve_loop:
  addi $t0, $t0, 1
  beq $t0, $t7, display
  add $t2, $t1, $t0
  lb $t4, ($t2)
  beq $zero, $t4, sieve_loop
  addi $t6, $t0, 2
  jal sieve_round
  j sieve_loop
  
sieve_round:
  add $t2, $t2, $t6
  sb $zero, ($t2)
  ble $t2, $t5, sieve_round
  jr $ra
  
display:
  la $t0, primes
  li $t2, 0
  li $t1, 0
  li $t5, 15
display_loop:
  add $t3, $t0, $t2
  lb $t4, ($t3)
  bne $t4, $zero, number_print
  np_return:
  addi $t2, $t2, 1
  beq $t2, $s0, exit
  j display_loop

number_print:
  addi $a0, $t2, 2
  li $v0, 1
  syscall
  jal split_print
  addi $t1, $t1, 1
  beq $t1, $t5, line_print
  line_return:
  j np_return

split_print:
  la $a0, split
  li $v0, 4
  syscall
  jr $ra

line_print:
  li $t1, 0
  la $a0, nl
  li $v0, 4
  syscall
  j line_return

invalid_input:
  li $v0, 4
  la $a0, err_msg
  syscall
  j main

exit:
  li $v0, 10
  syscall
