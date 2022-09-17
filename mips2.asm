	.data
A:	.word 2
B:	.word 23
C:	.word 7
D:	.word 2

	.text
	.globl main #(A-B)/(C+D)
		    # A B - C D + /
main:
	lw $t0, A
	lw $t1, B
	sub $t2, $t0, $t1
	lw $t0, C
	lw $t1, D
	add $t3, $t0, $t1
	div $t2, $t3
	
	mflo $a0
	li $v0, 1     # print decimal
	syscall
	
	li $a0, '.'
	li $v0, 11    # print character
	syscall
	
	mfhi $t1
	abs $t0, $t1
	li $t1, 1000000
	mul $t2, $t0, $t1
	div $t2, $t3
	mflo $t0
	abs $a0, $t0
	li $v0, 1
	syscall
	
	li $v0, 10    #exit programm
	syscall