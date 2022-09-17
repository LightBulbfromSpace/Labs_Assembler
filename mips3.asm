	.data
A:	.word 2
B:	.word 8
C:	.word 5
D:	.word 2

	.text
	.globl main #(A*B)-(C/D)
		    # A B - C D + /
main:
	lw $t0, A
	lw $t1, B
	mul $t2, $t0, $t1
	lw $t0, C
	lw $t1, D
	div $t0, $t1
	mflo $t0      # whole part from division
	sub $t3, $t2, $t0
	
	mfhi $t0
	abs $t1, $t0
	blez $t1, normdr1
	subi $t2, $t3, 1 # subtract unit if remainder != 0
	move $t3, $t2
normdr1:move $a0, $t3
	li $v0, 1
	syscall	      # whole part of result
	
	li $a0, '.'
	li $v0, 11    # print character
	syscall
	
	blez $t1, normdr2
	# here we need to get number 10^n; n - number of digits in remainder of (C/D)
	# remainder of result = 10^n - $t1
normdr2:move $a0, $t1
	li $v0, 1     # print decimal
	syscall

	
	li $v0, 10    #exit programm
	syscall