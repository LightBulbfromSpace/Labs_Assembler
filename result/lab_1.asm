	.data
A:	.float -3
B:	.float 19
C:	.float 1
D:	.float 0.2
E:	.float 4

	.text
	.globl main             # (A-B)/(C+D)-E
  
main:
	l.s   $f0,  A
	l.s   $f1,  B
	sub.s $f2,  $f0, $f1
	l.s   $f0,  C
	l.s   $f1,  D
	add.s $f3,  $f0, $f1
	div.s $f0,  $f2, $f3
	l.s   $f1,  E
	sub.s $f12, $f0, $f1    
	
	li    $v0,  2           # print float result
	syscall
	
	li    $v0,  10          # exit program
	syscall
