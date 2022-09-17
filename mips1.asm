	.data # F=A*B-(C/D)
	
A: 	.word 3
B: 	.word 4
C: 	.word 5
D: 	.word 6

	.text
	.globl main
main:
	mulo $t0, A, B
	
	
