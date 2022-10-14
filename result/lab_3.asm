	.data
	
x_1:	.byte 0, 0, 0, 1, 0, 0, 1
x_2:	.byte 1, 0, 1, 1, 1, 0, 0
x_3:	.byte 1, 1, 1, 0, 1, 1, 1
x_4:	.byte 1, 1, 1, 1, 1, 1, 0
size:	.byte 7

	.text
	.globl main
main:
	la   $s1, x_1		# address of the first memory sell
	lb   $t0, size		# array's size
	li   $t1, 0		# counter for array's cells
	
	li   $t4, 1		# future result of x1 & x2 & ... &x7 = Fn
	li   $t5, 0		# future resulf of F1 || F2 || ... || Fn
y1.1:	
	beq  $t1, $t0, end_y1.1
	lb   $t3, ($s1)
	beq  $t1, 3, continue_y1.1
	beq  $t1, 6, continue_y1.1
	
	jal  b_inv
	
continue_y1.1:

	and  $t4, $t4, $t3
	add  $t1, $t1, 1
	la   $s1, 1($s1)
	
	j y1.1
	
end_y1.1:
	
	la   $s1, x_2
	li   $t1, 0
	or   $t5, $t5, $t4
	li   $t4, 1
y1.2:	
	beq  $t1, $t0, end_y1.2
	lb   $t3, ($s1)
	beq  $t1, 0, continue_y1.2
	beq  $t1, 2, continue_y1.2
	beq  $t1, 3, continue_y1.2
	beq  $t1, 4, continue_y1.2
	
	jal  b_inv
	
continue_y1.2:

	and  $t4, $t4, $t3
	add  $t1, $t1, 1
	la   $s1, 1($s1)
	
	j y1.2
	
end_y1.2:

	or $t5, $t5, $t4
	
	la   $s1, x_3
	li   $t1, 0
	li   $t4, 1

y1.3:	
	beq  $t1, $t0, end_y1.3
	lb   $t3, ($s1)
	bne  $t1, 3, continue_y1.3
	
	jal  b_inv
	
continue_y1.3:

	and  $t4, $t4, $t3
	add  $t1, $t1, 1
	la   $s1, 1($s1)
	
	j y1.3
	
end_y1.3:

	or $t5, $t5, $t4
	
	la   $s1, x_4
	li   $t1, 0
	li   $t4, 1

y1.4:	
	beq  $t1, $t0, end_y1.4
	lb   $t3, ($s1)
	bne  $t1, 6, continue_y1.4
	
	jal  b_inv
	
continue_y1.4:

	and  $t4, $t4, $t3
	add  $t1, $t1, 1
	la   $s1, 1($s1)
	
	j y1.4
	
end_y1.4:

	or   $t5, $t5, $t4

	move $a0, $t5
	li   $v0, 1
	syscall
	
	li   $a0, '\n'
	li   $v0, 11
	syscall
	
	la   $s1, x_2
	li   $t1, 0
	li   $t4, 1
	li   $t5, 0

y2.2:	
	beq  $t1, $t0, end_y2.2
	lb   $t3, ($s1)
	beq  $t1, 0, continue_y2.2
	beq  $t1, 2, continue_y2.2
	beq  $t1, 3, continue_y2.2
	beq  $t1, 4, continue_y2.2
	
	jal  b_inv
	
continue_y2.2:

	and  $t4, $t4, $t3
	add  $t1, $t1, 1
	la   $s1, 1($s1)
	
	j y2.2
	
end_y2.2:

	or   $t5, $t5, $t4

	la   $s1, x_3
	li   $t1, 0
	li   $t4, 1
	
y2.3:	
	beq  $t1, $t0, end_y2.3
	lb   $t3, ($s1)
	bne  $t1, 3, continue_y2.3
	
	jal  b_inv
	
continue_y2.3:

	and  $t4, $t4, $t3
	add  $t1, $t1, 1
	la   $s1, 1($s1)
	
	j y2.3
	
end_y2.3:

	or $t5, $t5, $t4
	
	move $a0, $t5
	li   $v0, 1
	syscall
	
	li   $a0, '\n'
	li   $v0, 11
	syscall
	
	la   $s1, x_1
	li   $t1, 0
	li   $t4, 1
	li   $t5, 0

y3.1:	
	beq  $t1, $t0, end_y3.1
	lb   $t3, ($s1)
	beq  $t1, 3, continue_y3.1
	beq  $t1, 6, continue_y3.1
	
	jal  b_inv
	
continue_y3.1:

	and  $t4, $t4, $t3
	add  $t1, $t1, 1
	la   $s1, 1($s1)
	
	j y3.1
	
end_y3.1:

	or   $t5, $t5, $t4

	la   $s1, x_3
	li   $t1, 0
	li   $t4, 1
	
y3.3:	
	beq  $t1, $t0, end_y3.3
	lb   $t3, ($s1)
	bne  $t1, 3, continue_y3.3
	
	jal  b_inv
	
continue_y3.3:

	and  $t4, $t4, $t3
	add  $t1, $t1, 1
	la   $s1, 1($s1)
	
	j y3.3
	
end_y3.3:

	or $t5, $t5, $t4
	
	move $a0, $t5
	li   $v0, 1
	syscall
	
	li   $v0, 10
	syscall


	
b_inv:				# custom integer inversion: converts 0 to 1, any non-zero number to 0
	beqz $t3, is_zero
	li   $t3, 0
	j    is_unit
is_zero:
	li   $t3, 1
is_unit:
	jr   $ra