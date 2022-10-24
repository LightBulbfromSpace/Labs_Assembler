	.data

sign:	.word   0x00
e:	.word   0x7F
f:	.word	0x80

	.text
	lwl  $t0, e
	srl  $t0, $t0, 1
	lwl  $t1, sign
	add  $t0, $t0, $t1
	lwl  $t1, f
	srl  $t1, $t1, 9
	add  $t0, $t0, $t1
	mtc1 $t0, $f12
	
	li   $v0, 2
	syscall
	
	li   $v0, 10
	syscall