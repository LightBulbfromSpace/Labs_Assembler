	.data
msg:    .asciiz "Some message\n"
num:	.word   1111

	.text
	.globl main
	
main:	lw $a0, num
	li $v0, 1
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	la $a0, msg
	li $v0, 4
	syscall
	
	li $a0, '.'
	li $v0, 11
	syscall
	
	li $v0, 10
	syscall
