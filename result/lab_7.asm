.macro read_double(%dest_r)
	li     $v0, 7
	syscall
	
	mov.d  %dest_r, $f0
.end_macro

.macro print_str(%src_buf)
	la     $a0, %src_buf
	li     $v0, 4
	syscall
.end_macro

.macro print_double		 # value to print should be already set in $f12
	li  $v0, 3
	syscall
.end_macro

   	.kdata
msg:	.asciiz "Wrong input"

	.ktext 0x80000180
   	la   $a0, msg
   	li   $v0, 4
   	syscall
   
   	la   $k0, done
   	mtc0 $k0, $14
   	eret

	.data
prmpt:  .asciiz "Enter A, B, C values for Ax^2+Bx+C\n"
prt_A:  .asciiz "A: "
prt_B:  .asciiz "B: "
prt_C:  .asciiz "C: "
prt_r1: .asciiz "\nFirst root:\n"
prt_r2: .asciiz "\nSecond root:\n"
n_prpt: .asciiz "\nNo real roots."
l_prpt: .asciiz "\nError: Linear equation."

	.text
	print_str(prmpt)
	print_str(prt_A)
	read_double($f2)	 # A
	mtc1.d 	$0,  $f4
	cvt.d.w $f4, $f4
	c.eq.d	$f2, $f4	 # $f4 
	bc1t lin_eq
	print_str(prt_B)
	read_double($f4)	 # B
	print_str(prt_C)
	read_double($f6)	 # C
	
	mul.d   $f8,  $f4,  $f4  # B^2
	
	mul.d   $f10, $f2,  $f6	 # A*C
	li      $t0,  4
	mtc1    $t0,  $f12
	cvt.d.w $f12, $f12
	mul.d   $f10, $f10, $f12 # 4*A*C
	
	sub.d   $f8,  $f8,  $f10 # B^2 - 4*A*C
	
	cvt.w.d $f14, $f8
	mfc1.d  $t0,  $f14
	
	bltz    $t0,  _neg
	
	sqrt.d  $f8,  $f8	 # D^(1/2)
	
	li      $t0,  -1
	mtc1    $t0,  $f10
	cvt.d.w $f10, $f10
	mul.d   $f4,  $f4,  $f10 # -B
	add.d   $f12, $f4,  $f8	 # -B+D^(1/2)
	li      $t0,  2
	mtc1    $t0,  $f10
	cvt.d.w $f10, $f10
	mul.d   $f2,  $f2,  $f10 # 2*A
	div.d   $f12, $f12, $f2  # (-B+D^(1/2))/(2*A)
	print_str(prt_r1)
	print_double
	
	sub.d   $f12, $f4,  $f8  # -B-D^(1/2)
	div.d   $f12, $f12, $f2  # (-B-D^(1/2))/(2*A)
	print_str(prt_r2)
	print_double
	j      done
_neg:
	print_str(n_prpt)
done:
	li      $v0, 10
	syscall
lin_eq:
	print_str(l_prpt)
	j 	done
