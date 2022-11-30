.macro print_str(%str_addr)			  # read from file 5 numbers and make calc of exp from lab_1
	li   $v0, 4
 	la   $a0, %str_addr
 	syscall
.end_macro

.macro print_double			  # value to print should be already set in $f12
	li   $v0, 3
 	syscall
.end_macro

.macro done
	li   $v0, 10
	syscall
.end_macro

.macro read_char(%descriptor, %ch_buff_addr, %dest_t_r)
	move $a0, %descriptor
	la   $a1, %ch_buff_addr
	li   $a2, 1
	li   $v0, 14
	syscall
	lb   %dest_t_r, %ch_buff_addr
.end_macro

.macro set_char_in_integer_part(%input_dig_t_r, %res_f_r, %serv_f_r, %multiplier_f_r)
	subi    %input_dig_t_r, %input_dig_t_r, 48
	mul.d   %res_f_r, %res_f_r, %multiplier_f_r
	mtc1    %input_dig_t_r, %serv_f_r
	cvt.d.w %serv_f_r, %serv_f_r
	add.d   %res_f_r, %res_f_r, %serv_f_r
.end_macro

.macro set_char_in_fractional_part(%input_dig_t_r, %res_f_r, %serv_f_r1, %divider_f_r, %divider_changer_f_r)
	subi    %input_dig_t_r, %input_dig_t_r, 48
	
	mtc1    %input_dig_t_r, %serv_f_r1
	cvt.d.w %serv_f_r1, %serv_f_r1
	div.d   %serv_f_r1, %serv_f_r1, %divider_f_r
	add.d   %res_f_r, %res_f_r, %serv_f_r1
	mul.d   %divider_f_r, %divider_f_r, %divider_changer_f_r
.end_macro

.macro skip_new_line_char
	move $a0, $s0			  #
	la   $a1, ch_buf		  # Previos loop stopped after reading '\r',
	li   $a2, 1			  # this block is for skipping '\n'.
	li   $v0, 14			  #
	syscall				  #
.end_macro
	

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
	
	move $s0, $v0			  # save descriptor
	
					  # (A-B)/(C+D)-E
	jal convertion_start		  # A: result in $f12
	
	skip_new_line_char
	
	mov.d $f10, $f12		  # A in $f10
	
	jal convertion_start		  # B: result in $f12
	skip_new_line_char
	
	sub.d $f10, $f10, $f12		  # A-B in $f10
	
	jal convertion_start		  # C: result in $f12
	skip_new_line_char
	
	mov.d $f8, $f12		  	  # C in $f8
	
	jal convertion_start		  # D: result in $f12
	skip_new_line_char
	
	add.d $f8, $f8, $f12		  # C+D in $f8
	
	div.d $f10, $f10, $f8		  # (A-B)/(C+D) in $f10
	
	jal convertion_start		  # E: result in $f12
	skip_new_line_char
	
	sub.d $f12, $f10, $f12		  # (A-B)/(C+D)-E in $f12
	
	move $a0, $s0			  #
	li   $v0, 16			  # close file
	syscall				  #
	
	#la   $a0, f_in
	#li   $a1, 1			  # flag: write-only and create
	#li   $a2, 0
	#li   $v0, 13
	#syscall
	
	print_double
	
					  
end_nums_writing:			  
	done
	
err_open_file:				  #
	print_str(err_op)		  # handle error if file can't be open
	done				  #


# start of code for convertion
convertion_start:
	mul.d   $f12, $f12, $f14	  # $f14 should be equal to zero
	li      $t2, 1
	mtc1    $t2, $f2
	cvt.d.w $f2, $f2
	li      $t2, 10		  
	mtc1    $t2, $f6		  # muliplier changer (for fractional part) - const
	cvt.d.w $f6, $f6
	mtc1    $t2, $f4
	cvt.d.w $f4, $f4		  # muliplier - const for int part
	li      $t4, 0			  # flag of frac. part (0 - int part, 1 - frac part) 

	read_char($s0, ch_buf, $t3)
	bne     $t3, 45, non_neg
	li      $t2, -1
	mtc1    $t2, $f2
	cvt.d.w $f2, $f2
	subi    $t0, $t0, 1
convertion:				  
		  
	read_char($s0, ch_buf, $t3)
non_neg:	
	beq     $t3, 13,  end_convertion
	
	bne     $t3, 46, non_dot
	li      $t4, 1
	j       convertion
non_dot:
	bnez   $t4, fr_part
	set_char_in_integer_part($t3, $f12, $f0, $f4)
	j convertion
fr_part:
	set_char_in_fractional_part($t3, $f12, $f0, $f4, $f6)
	j    convertion
end_convertion:
	mul.d $f12, $f2, $f12
	jr   $ra
#end of code for convertion