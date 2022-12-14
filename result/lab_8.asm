# exchange sort

.macro swap(%r1, %r2)
	add  %r1, %r1, %r2
	sub  %r2, %r1, %r2
	sub  %r1, %r1, %r2
.end_macro

.macro print_int(%r)
	li   $v0, 1
	move $a0, %r
	syscall
.end_macro

.macro print_new_line
	li   $v0, 11
	li   $a0, 10
	syscall
.end_macro

.macro print_space
	li   $v0, 11
	li   $a0, 32
	syscall
.end_macro

.macro output_array_in_console(%arr_addr, %length_r, %counter_r, %addr_r, %it_r)
	print_new_line
	li   %counter_r, 0
	la   %addr_r, %arr_addr
out_loop:
	beq  %counter_r, %length_r, done
	lw   %it_r, (%addr_r)
	print_int(%it_r)
	addi %addr_r, %addr_r, 4
	addi %counter_r, %counter_r, 1
	print_space
	j    out_loop
done:
.end_macro

	.data
array:  .word 4, 1, 5, 2, 8, 2, 3, 1
length: .word 8

	.text
	lw   $t0, length 		 # length of array, counter
	lw   $s0, length 		 # length of array
	la   $t1, array	 		 # address of current element
	li   $t2, 0			 # index of current element

start:	
	beqz  $t0, end
	
	lw   $t4, ($t1)			 # current element
	sub  $t3, $s0, $t2 	 	 # counter for nested loop
	move $t5, $t1			 # address of iterated element in nested loop
	
start_nested:	
	beqz $t3, end_nested 		 # while counter of nested loop is not equal length of array
	addi $t5, $t5, 4		 # adress of next element
	lw   $t6, ($t5)
	ble  $t4, $t6, no_exchange
	swap($t4, $t6)
	sb   $t4, ($t1)
	sb   $t6, ($t5)
no_exchange:   
	subi $t3, $t3, 1
	j    start_nested
	
end_nested:
	addi  $t1, $t1, 4
	subi  $t0, $t0, 1
	addi  $t2, $t2, 1
	j     start	
end:
	lw   $t0, length 		 # length of array
	output_array_in_console(array, $t0, $t1, $t2, $t3)
	li    $v0, 10
	syscall