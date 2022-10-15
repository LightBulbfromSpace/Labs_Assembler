	.data

f_in:   .asciiz "data/input.dat"	# Directory 'data' should be created before start of the program
f_out:  .asciiz "data/output.dat"	# or names'd be changed to "input.dat" and "output.dat", respectively.
err_op: .asciiz "cannot open file"	 
lp_buf:	.byte   0			# buffer used to extract loops' number
buffer: .space	1024			# buffer used to store numbers to be written to 'output.dat'

	.text
	.globl file_io
file_io:
	la   $a0, f_in
	li   $a1, 0			# flag: read-only
	li   $a2, 0
	li   $v0, 13
	syscall
	
	bltz $v0, err_open_file
	
	move $s0, $v0
		
	li   $t1, 0			# future integer loops' number
	
convertion:
	move $a0, $s0
	la   $a1, lp_buf
	li   $a2, 1
	li   $v0, 14
	syscall
	
	lb   $t0, lp_buf
	beq  $t0, 13, end_convertion	# examination for containing '\r'
	subi $t0, $t0, 48
	mul  $t1, $t1, 10
	add  $t1, $t1, $t0
	
	j    convertion
end_convertion:

	move $a0, $s0			#
	la   $a1, lp_buf		# Previos loop stopped after reading '\r',
	li   $a2, 1			# this block is for skipping '\n'.
	li   $v0, 14			#
	syscall				#

	move $a0, $s0
	la   $a1, buffer
	li   $a2, 1024
	li   $v0, 14
	syscall
	
	move $s1, $v0			# number of read chars
	
	add  $a1, $a1, $s1		#
	subi $a1, $a1, 1		#
	lb   $s2, ($a1)			#
					#
	beq  $s2, 10, skip		# Check for '\n' at the end of read chars,
	addi $a1, $a1, 1		#
	li   $s2, 10			#
	sb   $s2, ($a1)			# adds '\n' if it's necessary,
					#
	addi $s1, $s1, 1		# changes number of read chars.
skip:					#
	
	move $a0, $s0
	li   $v0, 16
	syscall
	
	la   $a0, f_out
	li   $a1, 1			# flag: write-only and create
	li   $a2, 0
	li   $v0, 13
	syscall
	
	move $s0, $v0
	li   $t0, 0
nums_writing:				#
	beq  $t0, $t1, end_nums_writing #
	move $a0, $s0			#
	la   $a1, buffer		#
	move $a2, $s1			#
	li   $v0, 15			# block writes buffer content for n (stored in $t1) times
	syscall				#
					#
	addi $t0, $t0, 1		#
					#
	j nums_writing			#
					#
end_nums_writing:			#
	
	li   $v0, 10
	syscall
	
err_open_file:				# 
					#
	la $a0, err_op			#
	li $v0, 4			# handle error if file can't be open
	syscall				#
					#
	li   $v0, 10			#
	syscall				#