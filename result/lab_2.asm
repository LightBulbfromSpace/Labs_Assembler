	.data
A:	.float 2.2
B:	.float 3
C:	.float 7.4
countr: .byte  3		# power of (A+B)^n

	.text
	.globl main		# (A+B)*(A+B)*(A+B)+C

main:
	lw    $t0, countr
	l.s   $f0, A
	l.s   $f1, B
	add.s $f2, $f1, $f0
	mov.s $f1, $f2
	lb    $t2, countr	
	li    $t0, 1		# $t0 - counter register
loop:	addi  $t1, $t0, 1	
	move  $t0, $t1
	mul.s $f0, $f2, $f1
	mov.s $f2, $f0
	beq   $t0, $t2, next	# check if $t0 is equal to countr
	jal   loop
next:	l.s   $f0, C
	add.s $f12, $f2, $f0
	
	li   $v0, 2
	syscall
	
	li   $v0, 10
	syscall
	
