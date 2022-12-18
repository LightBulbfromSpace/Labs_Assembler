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
	li $a0, 13
	li $a1, 17
	push_in_stack($a0)
	push_in_stack($a1)
	jal bar
	lw $a1, ($sp)
	lw $a0, 4($sp)
	push_in_stack($v0)
	jal foo
	pop_stack($v0)
	pop_stack($t1)
	pop_stack($t0)
	print_int_nl($v0)
	print_int_nl($t0)
	print_int_nl($t1)
	
	done
	
foo:				# prints result of (2 * $a0 + $a1 * $a1), function type: void
	add $a0, $a0, $a0
	mul $a1, $a1, $a1
	add $a0, $a0, $a1
	print_int_nl($a0)
	jr $ra
	
bar:				# returns result of ($a0 * $t0 - $a1 * $a1), function type: int
	mul $a1, $a1, $a1
	mul $a0, $a0, $a0
	sub $v0, $a0, $a1
	jr  $ra