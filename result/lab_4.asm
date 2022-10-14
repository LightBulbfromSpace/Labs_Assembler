	.data
prmpt0: .asciiz "This is calculator for (A-B)/(C+D)-E.\n"
prmpt1: .asciiz "Put in 5 numbers for A, B, C, D, E:\n"
prmpt2: .asciiz "\n\nDo you want repeat calculation?\nWrite 'y' to continue or something else to exit.\n"
prmpt3: .asciiz "\nYour answer is: "
answer: .space  10
nums: 	.float	0, 0, 0, 0, 0
 
 	.text
 	.globl main
main:				# This program calculates (A-B)/(C+D)-E,
 	la   $a0, prmpt0	# loops if it gets answer 'y' after calculation
 	li   $v0, 4		# and finishes if gets something else
 	syscall

loop:
 	la   $a0, prmpt1
 	li   $v0, 4
 	syscall
 
 	la   $s0, nums  	# preparation for nums' reading
 	li   $t0, 0     	# loop counter       
 	
nums_read:
	beq  $t0, 5, end_nums_read
 	li   $v0, 6
 	syscall
 	s.s  $f0, ($s0)
 	la   $s0, 4($s0)
 	addi $t0, $t0, 1
 	j    nums_read
end_nums_read:
 
 	la      $s0,  nums
 	
 	l.s     $f0, ($s0)
 	l.s     $f1, 4($s0)
 	sub.s   $f2,  $f0, $f1
 	l.s     $f0, 8($s0)
 	l.s     $f1, 12($s0)
 	add.s   $f3,  $f0, $f1
 	div.s   $f0,  $f2, $f3
 	l.s     $f1, 16($s0)
 	sub.s   $f12, $f0, $f1 
 
 	li    $v0,  2
 	syscall
 	
 	li   $v0, 4
 	la   $a0, prmpt2
 	syscall
 	
 	
 	la   $a0, answer
 	li   $a1, 10
 	li   $a2, 0
 	li   $v0, 8
 	syscall
 	
 	li   $v0, 4
 	la   $a0, prmpt3
 	syscall
 	la   $a0, answer
 	syscall
 	
 	lb   $t0, ($a0)
 	
 	li   $a0, '\n'
 	li   $v0, 11
 	syscall
 	
 	beq  $t0, 121, loop
 	
 	
 	li   $v0, 10
 	syscall
