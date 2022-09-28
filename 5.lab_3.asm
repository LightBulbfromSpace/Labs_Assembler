	.data		# y1:0001001 1
			#    1011100 1
			#    1110111 1
			#    1111110 1
prmpt1: .asciiz "Enter quantity of nulls and units:\n"
prmpt2: .asciiz "Enter sequence of nulls and units:\n"
ext_ad: .word	extract
cmr_ad: .word	conjunctive_member_result
inv_ad: .word	inversion

	.text
	.globl main
main:
	#loading addresses
	lw   $a1, cmr_ad
	lw   $a2, ext_ad
	lw   $s0, inv_ad
	
	#print the prompt1
	li   $v0, 4
	la   $a0, prmpt1
	syscall
	
	#get input
	li   $v0, 5
	syscall
	
	move $t3, $v0
	
	#print the prompt2
	li   $v0, 4
	la   $a0, prmpt2
	syscall
	
	#get input
	li   $v0, 5
	syscall
	
	move $t0, $v0
	
	
	jalr $s0
	
	jalr $a1
	
	#print characher
	li   $a0, '\n'
	li   $v0, 11
	syscall
	
	move $a0, $t5
	li   $v0, 1
	syscall
	
	li   $v0, 10
	syscall

extract:
	addi $t4, $t1, 1
	move $t1, $t4
	
	div  $t0, $t2
	mfhi $t4
	mflo $t0
	jr   $ra
	
conjunctive_member_result:
	move $a3, $ra
	li   $t1, 0		# counter
	li   $t2, 10
	jalr $a2
	move $t5, $t4
while:
	jalr $a2
	add  $t6, $t5, $t4
	move $t5, $t6
	blt  $t1, $t3, while
end_while:
	jr $a3
	
inversion:
	beqz $s2, to_unit
	li   $s2, 0
	j    to_zero
to_unit:li   $s2, 1
to_zero:jr   $ra
