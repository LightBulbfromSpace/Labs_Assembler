	.data			# testcases
	
A1: 	.word 1
B1: 	.word 1
C1:	.word 11
D1:	.word 3
exptd1:	.float -2.6666667

A1: 	.word 1
B1: 	.word 1
C1:	.word 5
D1:	.word 6
exptd2:	.float 1.6666667

A1: 	.word 1
B1: 	.word 1
C1:	.word 6
D1:	.word 5
exptd3:	.float -0.2

	.text
	.globl main
main:
	li $a2, 0		# "index" of testcase
	
