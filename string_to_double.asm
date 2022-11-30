# bytes to double, simulates reading string from file

.macro read_char(%dest_r, %ch_addr_r)
	lb     %dest_r, (%ch_addr_r)
	la     %ch_addr_r, 1(%ch_addr_r)
	
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

	
	.data
str:	.byte 45, 49, 50, 51, 46, 52, 53, 54, 55
 
	.text
	li      $t0, 8			  # counter
	la      $t1, str
	li      $t2, 1
	mtc1    $t2, $f2
	cvt.d.w $f2, $f2
	li      $t2, 10		  
	mtc1    $t2, $f6		  # muliplier changer (for fractional part) - const
	cvt.d.w $f6, $f6
	mtc1    $t2, $f4
	cvt.d.w $f4, $f4		  # muliplier - const for int part
	
	read_char($t3, $t1)
	bne     $t3, 45, non_neg
	li      $t2, -1
	mtc1    $t2, $f2
	cvt.d.w $f2, $f2
	
convertion:				  # $f0-$f1 result register, $t0 - service register,
					  # $t4 - fractional part flag register (0 - int part, non-zero - fr. part)
	beqz   $t0, end_convertion	  
	read_char($t3, $t1)
	
non_neg:
	subi   $t0, $t0, 1
	bne    $t3, 46, non_dot
	li     $t4, 1
	li     $t2, 1
	j      convertion
non_dot:
	bnez   $t4, fr_part
	set_char_in_integer_part($t3, $f12, $f0, $f4)    # %input_dig_t_r, %res_f_r, %serv_f_r, %multiplier_f_r
	j convertion
fr_part:
	set_char_in_fractional_part($t3, $f12, $f0, $f4, $f6) # %input_dig_t_r, %res_f_r, %serv_f_r1, %divider_f_r, %divider_changer_f_r
	j    convertion
end_convertion:
	mul.d $f12, $f2, $f12
	
	li    $v0, 3
	syscall
	li    $v0, 10
	syscall