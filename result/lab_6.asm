.macro push_in_stack(%st_addr_r, %stack)
	la   %st_addr_r, %stack
	sw   $t0, (%st_addr_r)
	addi %st_addr_r, %st_addr_r, 4		#change address
	sw   $t1, (%st_addr_r)
	addi %st_addr_r, %st_addr_r, 4
	sw   $t2, (%st_addr_r)
	addi %st_addr_r, %st_addr_r, 4
	sw   $t3, (%st_addr_r)
	addi %st_addr_r, %st_addr_r, 4
	sw   $t4, (%st_addr_r)
	addi %st_addr_r, %st_addr_r, 4
	sw   $t5, (%st_addr_r)
	addi %st_addr_r, %st_addr_r, 4
	sw   $t6, (%st_addr_r)
	addi %st_addr_r, %st_addr_r, 4
	sw   $t7, (%st_addr_r)
.end_macro

.macro pop_stack(%stack_last_addr_r, %stack)
	lw   $t7, (%stack_last_addr_r)
	subi %stack_last_addr_r, %stack_last_addr_r, 4		#change address
	lw   $t6, (%stack_last_addr_r)
	subi %stack_last_addr_r, %stack_last_addr_r, 4
	lw   $t5, (%stack_last_addr_r)
	subi %stack_last_addr_r, %stack_last_addr_r, 4
	lw   $t4, (%stack_last_addr_r)
	subi %stack_last_addr_r, %stack_last_addr_r, 4
	lw   $t3, (%stack_last_addr_r)
	subi %stack_last_addr_r, %stack_last_addr_r, 4
	lw   $t2, (%stack_last_addr_r)
	subi %stack_last_addr_r, %stack_last_addr_r, 4
	lw   $t1, (%stack_last_addr_r)
	subi %stack_last_addr_r, %stack_last_addr_r, 4
	lw   $t0, (%stack_last_addr_r)
.end_macro

.macro print_num_from_reg_ln(%r)
	move $a0, %r
	li   $v0, 1
	syscall
	
	li $a0, 10
	li $v0, 11
	syscall
.end_macro

.macro read_num(%dest)
	li   $v0, 5
	syscall
	
	move %dest, $v0
.end_macro
	
	.ktext 0x80000180
   	la   $a0, msg
   	li   $v0, 4
   	syscall
   
   	la   $k0, done
   	mtc0 $k0, $14
   	eret
	
   	.kdata
msg:	.asciiz "Wrong input"
   	
	.data
stack:	.space 256

	.text
	li $t1, 4
	li $t4, 6
	li $t7, 9
	li $t0, 3
	
	push_in_stack($s0, stack)
	
	read_num($t0)
	read_num($t1)
	read_num($t2)
	read_num($t4)
	read_num($t7)
	
	pop_stack($s0, stack)
	
	print_num_from_reg_ln($t0)
	print_num_from_reg_ln($t1)
	print_num_from_reg_ln($t2)
	print_num_from_reg_ln($t3)
	print_num_from_reg_ln($t4)
	print_num_from_reg_ln($t5)
	print_num_from_reg_ln($t6)
	print_num_from_reg_ln($t7)

done:
	li $v0, 10
	syscall
