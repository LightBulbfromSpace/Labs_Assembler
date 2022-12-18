.macro push_in_stack(%val_r)
	addiu   $sp, $sp, -4	# allocate place for word
	sw   	%val_r, ($sp)
.end_macro

.macro pop_stack(%val_r)
	lw   	%val_r, ($sp)
	addiu   $sp, $sp, 4	# deallocate place for word
.end_macro

.macro print_int_nl(%r)
	move	$a0, %r
	li	$v0, 1
	syscall
	
	li	$a0, 10
	li	$v0, 11
	syscall
.end_macro

.macro done
	li      $v0, 10
	syscall
.end_macro

	.text
	li $t0, 13
	li $t1, 17
	push_in_stack($t0)
	push_in_stack($t1)
	jal bar
	lw $t1, ($sp)
	lw $t0, 4($sp)
	push_in_stack($v0)
	jal foo
	pop_stack($v0)
	pop_stack($t1)
	pop_stack($t0)
	print_int_nl($v0)
	print_int_nl($t0)
	print_int_nl($t1)
	
	done
	
foo:				# prints result of (2 * $t0 + $t1 * $t1), function type: void
	add $t0, $t0, $t0
	mul $t1, $t1, $t1
	add $a0, $t0, $t1
	print_int_nl($a0)
	jr $ra
	
bar:				# returns result of ($t0 * $t0 - $t1 * $t1), function type: int
	mul $t1, $t1, $t1
	mul $t0, $t0, $t0
	sub $v0, $t0, $t1
	jr  $ra