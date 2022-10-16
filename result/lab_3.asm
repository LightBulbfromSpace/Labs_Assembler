	.data

prmpt1:	.asciiz "\nType 7 zeros or units:\n"
prmpt2: .asciiz "\nDo you want to check sequence again?\nType 'y' to continue or something else to exit.\n"
buffer:	.space  2
err_in: .asciiz "Wrong number. Input should contain only 1 or 0.\n"
input:  .byte 	0, 0, 0, 0, 0, 0, 0
mask1:	.byte 	0, 0, 0, 1, 0, 0, 1
mask2:	.byte 	1, 0, 1, 1, 1, 0, 0
mask3:	.byte 	1, 1, 1, 0, 1, 1, 1
mask4:	.byte 	1, 1, 1, 1, 1, 1, 0
size:	.byte 	7
y1:	.asciiz "y1: "
y2:	.asciiz "y2: "
y3:	.asciiz "y3: "

	.text
	.globl main
main:
	lb   $s0, size
loop:	
	la   $s1, input
	li   $t1, 0

	la   $a0, prmpt1
	li   $v0, 4
	syscall
	
	read:
	beq  $s0, $t1, end_read
	
	li   $v0, 5
	syscall
	
	blt  $v0, 0, err_wrong_input
	bgt  $v0, 1, err_wrong_input
	
	sb   $v0, ($s1)
	
	la   $s1, 1($s1)
	add  $t1, $t1, 1
	
	j    read
	end_read:
	
	li   $t4, 0			# result of DNF
	
	la   $s2, mask1			# $s2 - register for mask's address
	jal  DNF
	beq  $t4, 1, y1_output
	
	la   $s2, mask2
	jal  DNF
	beq  $t4, 1, y1_output
	
	la   $s2, mask3
	jal  DNF
	beq  $t4, 1, y1_output
	
	la   $s2, mask4
	jal  DNF
	
y1_output:

	li   $a0, 10
	li   $v0, 11
	syscall
	
	la   $a0, y1
	jal  y_out
	
	li   $t4, 0
	
	la   $s2, mask2
	jal  DNF
	beq  $t4, 1, y2_output
	
	la   $s2, mask3
	jal  DNF
	
y2_output:
	la   $a0, y2
	jal  y_out
	
	li   $t4, 0
	
	la   $s2, mask1
	jal  DNF
	beq  $t4, 1, y2_output
	
	la   $s2, mask3
	jal  DNF
	
y3_output:
	la   $a0, y3
	jal  y_out
	
question:	
	la   $a0, prmpt2
	li   $v0, 4
	syscall
	
	la   $a0, buffer
	li   $a1, 2
	li   $v0, 8
	syscall
	
	lb   $a0, buffer
	beq  $a0, 121, loop
	
	li   $v0, 10
	syscall
	
err_wrong_input:

	la   $a0, err_in
	li   $v0, 4
	syscall

	j    question
end_err_wrong_input:
	
y_out:
	li   $v0, 4			# address of string should be already loaded
	syscall
	
	move $a0, $t4
	li   $v0, 1
	syscall
	
	li   $a0, 10
	li   $v0, 11
	syscall
	jr   $ra
y_out_end:
	
DNF:					# disjunctive normal form
	move $s3, $ra
	li   $t0, 1			# result of comparation with mask
	la   $s1, input
	
	jal  comparation_mask
	
	or   $t4, $t4, $t0
	
	jr   $s3
end_DNF:

comparation_mask:
	li   $t1, 0			# counter
	start_comparation_mask:
	beq  $s0, $t1, end_comparation_mask
	lb   $t2, ($s1)
	lb   $t3, ($s2)
	
	add  $t1, $t1, 1
	la   $s1, 1($s1)
	la   $s2, 1($s2)
	
	beq  $t3, $t2, start_comparation_mask
	li   $t0, 0  
end_comparation_mask:
	
	jr   $ra
