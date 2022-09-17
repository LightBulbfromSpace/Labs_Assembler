	.data
A:	.word 2
B:	.word -3
C:	.word 7

	.text
	.globl main	# (A+B)*(A+B)*(A+B)+C
		   	# A B - C D + /
main:
	li   $a2, 0	# $a2 - counter
	lw   $t0, A
	lw   $t1, B
	li   $a3, 1
	add  $t2, $t1, $t0
loop:	addi $a1, $a2, 1
	move $a2, $a1
	mul  $t3, $t2, $a3
	move $a3, $t3
	beq  $a2, 3, next
	jal  loop
next:	lw   $t0, C
	add  $a0, $a3, $t0
	li   $v0, 1
	syscall
	li   $v0, 10
	syscall
	
