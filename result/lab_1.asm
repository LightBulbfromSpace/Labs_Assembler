	.data
A:	.double -3
B:	.double 19
C:	.double 1
D:	.double 0.2
E:	.double 4

	.text
	.globl main             # (A-B)/(C+D)-E
  
main:
	l.d   $f0,  A
	l.d   $f2,  B
	sub.d $f4,  $f0, $f2
	l.d   $f0,  C
	l.d   $f2,  D
	add.d $f0,  $f0, $f2
	div.d $f0,  $f4, $f0
	l.d   $f2,  E
	sub.d $f12, $f0, $f2    
	
	li    $v0,  3           # print double result
	syscall
	
	li    $v0,  10          # exit program
	syscall
