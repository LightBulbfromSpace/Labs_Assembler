.macro read_double(%dest_r)
	li     $v0, 7
	syscall
	
	mov.d  %dest_r, $f0
.end_macro

.macro print_str(%src_buf)
	la   $a0, %src_buf
	li   $v0, 4
	syscall
.end_macro

.macro print_double		# value to print should be already set in $f12
	li  $v0, 3
	syscall
.end_macro
	.data
prmpt:  .asciiz "Put in A, B, C values for Ax^2+Bx+C=\n"
prt_r1: .asciiz "\nFirst root:\n"
prt_r2: .asciiz "\nSecond root:\n"
n_prpt: .asciiz "No real roots."
	.text
	print_str(prmpt)
	
	read_double($f2)	# A
	read_double($f4)	# B
	read_double($f6)	# C
	
	mul.d  $f8,  $f4,  $f2	# B^2
	
	#mov.d  $f12, $f8
	#print_double
	
	mul.d  $f10, $f2,  $f6	# A*C
	li     $t0,  4
	mtc1   $t0,  $f12
	mul.d  $f10, $f10, $f12 # 4*A*C
	sub.d  $f8,  $f8,  $f10 # B^2 - 4*A*C
	
	mfc1.d $t0,  $f8
	bltz   $t0,  _neg
	
	sqrt.d $f8,  $f8	# D^(1/2)
	
	mov.d  $f12, $f8
	print_double
	
	li     $t0,  -1
	mtc1   $t0,  $f10
	mul.d  $f4,  $f4,  $f10	# -B
	add.d  $f12, $f4,  $f8	# -B+D^(1/2)
	li     $t0,  2
	mtc1   $t0,  $f10
	mul.d  $f2,  $f2,  $f10 # 2*A
	div.d  $f12, $f12, $f2  # (-B+D^(1/2))/(2*A)
	print_str(prt_r1)
	print_double
	sub.d  $f12, $f4,  $f8  # -B-D^(1/2)
	div.d  $f12, $f12, $f2  # (-B-D^(1/2))/(2*A)
	print_str(prt_r2)
	print_double
	j      done
_neg:
	print_str(n_prpt)
done:
	li $v0, 10
	syscall	