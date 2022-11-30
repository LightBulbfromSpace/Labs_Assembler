.macro print_str(%str_addr)			#read from file 5 numbers and make calc of exp from lab_1
	li   $v0, 4
 	la   $a0, %str_addr
 	syscall
.end_macro

.macro done
	li   $v0, 10
	syscall
.end_macro

.macro read_char(%descriptor, %ch_buff_addr)
	move $a0, %descriptor
	la   $a1, %ch_buff_addr
	li   $a2, 1
	li   $v0, 14
	syscall
.end_macro

.macro set_char_in_integer_part
	subi   $t0, $t0, 48
	mul    $t0, $t0, $t1
	mtc1.d $t0, $f2			# check !!!
	add.d  $f0, $f0, $f2
	mul    $t1, $t1, 10
.end_macro

.macro set_char_in_fractional_part
	subi   $t0, $t0, 48
	
	mtc1.d $t0
	mul    $t1, $t1, 10
.end_macro


convertion:				  # $f0-$f1 result register, $t0 - service register,
					  # $t1 - fractional part flag register (0 - int part, non-zero - fr. part)
	read_char($s0, ch_buf)
	
	lb   $t0, ch_buf
	beq  $t0, 13, end_convertion	  # examination for containing '\r'
	bne  $t0, 46, non_dot
	li   $t1, 1
	li   $t0, 1
	j convertion
non_dot:
	bnez $t1, fr_part
	set_char_in_integer_part
	j convertion
fr_part:
	set_char_in_fractional_part
	j    convertion
end_convertion:
	jr   $ra

	.data
f_in:   .asciiz "data/calc.dat"		  # Directory 'data' should be created before start of the program
					  # or name'd be changed to "calc.dat".
err_op: .asciiz "Error: cannot open file"
err_in: .asciiz "Error: wrong input." 
ch_buf:	.byte   0			  # buffer used to extract char
n_buf:  .space	1024			  # buffer used to store result of calculation

	.ktext 0x80000180
 	print_str(err_in)
 	li   $k0, 0x004000A8
 	mtc0 $k0, $14
 	eret

	.text
	.globl file_io_calc
file_io_calc:
	la   $a0, f_in
	li   $a1, 0			  # flag: read-only
	li   $a2, 0
	li   $v0, 13
	syscall
	
	bltz $v0, err_open_file
	
	move $s0, $v0
	
	li   $t1, 1	
	li   $t3, 5			  # number of nums in file
	
	
	jal convertion

	move $a0, $s0			  #
	la   $a1, lp_buf		  # Previos loop stopped after reading '\r',
	li   $a2, 1			  # this block is for skipping '\n'.
	li   $v0, 14			  #
	syscall				  #

	move $a0, $s0
	la   $a1, buffer
	li   $a2, 1024
	li   $v0, 14
	syscall
	
	move $s1, $v0			  # number of read chars
	
	add  $a1, $a1, $s1		  #
	subi $a1, $a1, 1		  #
	lb   $s2, ($a1)			  #
					  #
	beq  $s2, 10, skip		  # Check for '\n' at the end of read chars,
	addi $a1, $a1, 1		  #
	li   $s2, 10			  #
	sb   $s2, ($a1)			  # adds '\n' if it's necessary,
					  #
	addi $s1, $s1, 1		  # changes number of read chars.
skip:					  #
	
	move $a0, $s0
	li   $v0, 16
	syscall
	
	la   $a0, f_out
	li   $a1, 1			  # flag: write-only and create
	li   $a2, 0
	li   $v0, 13
	syscall
	
	move $s0, $v0
	li   $t0, 0
nums_writing:				  #
	beq  $t0, $t1, end_nums_writing   #
	move $a0, $s0			  #
	la   $a1, buffer		  #
	move $a2, $s1			  #
	li   $v0, 15			  # block writes buffer content for n (stored in $t1) times
	syscall				  #
					  #
	addi $t0, $t0, 1		  #
					  #
	j nums_writing			  #
					  #
end_nums_writing:			  #
	done
	
err_open_file:				  #
	print_str(err_op)		  # handle error if file can't be open
	done				  #
