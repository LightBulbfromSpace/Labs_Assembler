	.data
A:	.word 1#17		# bug in cases: 1 1 11 3;	expected: -2.667, 	got: -1.334
B:	.word 1#-3		#		1 1 6 5;	expected: -0.2,		got: 0.8
C:	.word 11#-25
D:	.word 3#-19
prñsn:	.word 100000000 	# precision: put any number 10^n,  0 < n < 9;
				# the larger number is, the more precise calculation is.
	.text
	.globl main 		#(A*B)-(C/D)
		    		# A B - C D + /
main:
	lw $t0, A
	bgez $t0, pozA
	li $t6, 1		# $t6 is counter of minuses before A, B, C, D
pozA:	lw $t1, B
	bgez $t1, pozB
	addi $t7, $t6, 1
	move $t6, $t7
pozB:	mul $t2, $t0, $t1	# A*B
	blez $t2, frbool
	li $a1, 1		# $a1 is counter of minuses before (A*B) and (C/D).
frbool:	lw $t0, C
	bgez $t0, pozC
	addi $t7, $t6, 1
	move $t6, $t7
pozC:	lw $t4, D
	bgez $t4, pozD
	addi $t7, $t6, 1
	move $t6, $t7
	
pozD:	div $t0, $t4		# C/D
	mflo $t0      		# whole part from division
	sub $t3, $t2, $t0	# preliminary calculation of whole part of result (*)
	
	li $a0, '"'
	li $v0, 11    		# printing point of result
	syscall
	move $a0, $t6
	li $v0, 1    		# printing point of result
	syscall
	li $a0, '"'
	li $v0, 11    		# printing point of result
	syscall
	
	bgez $t0, frbl
	addi $a2, $a1, 1
	move $a1, $a2
	
frbl:
	mfhi $t0
	abs  $t1, $t0		# $t1 - reminder
	beqz $t1, normdr1	# check if we got integer result
	li   $t7, 2
	div  $a1, $t7
	mfhi $a1
	
	li   $a0, '"'
	li   $v0, 11    	# printing point of result
	syscall
	move $a0, $t0
	li   $v0, 1    		# printing point of result
	syscall
	li   $a0, '"'
	li   $v0, 11    	# printing point of result
	syscall
	
	li   $a0, '"'
	li   $v0, 11    	# printing point of result
	syscall
	move $a0, $a1
	li   $v0, 1    		# printing point of result
	syscall
	li   $a0, '"'
	li   $v0, 11    	# printing point of result
	syscall
	
	beqz $a1, normdr1	# if there are different sign before parentheses, we need to subtract or add unit
	bltz $t3, lbl		# depending on the sign of $t3 (calculated in (*))
	beqz $t3, normdr1		
	subi $t2, $t3, 1 	
	j tomove
lbl:	addi $t2, $t3, 1	
tomove:	move $t3, $t2
normdr1:move $a0, $t3		#
	li   $v0, 1		# printing whole part of result
	syscall	      		# 
	
	li $a0, '.'
	li $v0, 11    		# printing point of result
	syscall
	
	blez $t1, normdr2
	lw $t2, prñsn		#
	mul $t0, $t1, $t2	#
	abs $t5, $t4		# preliminary calculating of fractional part
	div $t0, $t5		#
	mflo $t0		#
	
	li   $a0, '"'
	li   $v0, 11    	# printing point of result
	syscall
	move $a0, $t0
	li   $v0, 1    		# printing point of result
	syscall
	li   $a0, '"'
	li   $v0, 11    	# printing point of result
	syscall
	
	div $t6, $t7
	mfhi $t6
	
	bgtz $t6, skip		# check if "inversion" of fractional part is needed # !!! bgtz
	move $t1, $t0
	sub $t0, $t2, $t1
skip:	li $t3, 10
	mtlo $t0
loop:	mflo $t0		#
	div $t0, $t3		# shrinking of insignificant zeros in the end of 
	mfhi $t1		# fractional part
	beqz $t1, loop		#
	move $t1, $t0
normdr2:move $a0, $t1		#
	li $v0, 1		# printing fractional part
	syscall			#

	
	li $v0, 10    		# exit programm
	syscall			#
