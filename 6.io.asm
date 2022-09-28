	.data
	
msg1:   .asciiz "Write some number:\n"
msg2:	.asciiz "Your number:\n"

	.text
	.globl main
	
main:	li $a0, '\n'
	li $v0, 11
	syscall
	
	la $a0, msg1
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $t0, $v0
	
	la $a0, msg2
	li $v0, 4
	syscall
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	
	li $v0, 10
	syscall
