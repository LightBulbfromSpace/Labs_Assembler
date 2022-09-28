	.data
	
msg1:   .asciiz "Write some msg:\n"
msg2:	.asciiz "Your msg:\n"
buff:	.space	20

	.text
	.globl main
	
main:	li $a0, '\n'
	li $v0, 11
	syscall
	
	la $a0, msg1
	li $v0, 4
	syscall
	
	li $v0, 8
	la $a0, buff # putting buffer address in $a0
	li $a1, 20
	syscall
	
	la $a0, msg2
	li $v0, 4
	syscall
	
	la $a0, buff
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
