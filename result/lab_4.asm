.macro print_str(%str_addr)
	li   $v0, 4
 	la   $a0, %str_addr
 	syscall
.end_macro
	
	.data
prmpt0: .asciiz "This is calculator for (A-B)/(C+D)-E.\n"
prmpt1: .asciiz "Put in 5 numbers for A, B, C, D, E:\n"
prmpt2: .asciiz "\n\nDo you want repeat calculation?\nWrite 'y' to continue or something else to exit.\n"
prmpt3: .asciiz "\nYour answer is: "
prmpt4: .asciiz "\nWrong input."
answer: .space  10
nums: 	.float	0, 0, 0, 0, 0
 
 	.ktext 0x80000180
 	
 	print_str(prmpt4)
 	li   $k0, 0x004000A8
 	mtc0 $k0, $14
 	eret
 	
 	.text
 	.globl main			# This program calculates (A-B)/(C+D)-E,
main:					# loops if it gets answer 'y' after calculation
 	print_str(prmpt0)		# and finishes if gets something else

loop:
 	print_str(prmpt1)
 
 	la   $s0, nums  		# preparation for nums' reading
 	li   $t0, 0     		# loop counter       
 	
nums_read:
	beq  $t0, 5, end_nums_read
 	li   $v0, 6
 	syscall
 	s.s  $f0, ($s0)
 	la   $s0, 4($s0)
 	addi $t0, $t0, 1
 	j    nums_read
end_nums_read:
 
 	la    $s0,  nums
 	
 	l.s   $f0, ($s0)
 	l.s   $f1, 4($s0)
 	sub.s $f2,  $f0, $f1
 	l.s   $f0, 8($s0)
 	l.s   $f1, 12($s0)
 	add.s $f3,  $f0, $f1
 	div.s $f0,  $f2, $f3
 	l.s   $f1, 16($s0)
 	sub.s $f12, $f0, $f1 
 
 	li    $v0,  2
 	syscall

 	print_str(prmpt2)
 	
 	la   $a0, answer
 	li   $a1, 10
 	li   $a2, 0
 	li   $v0, 8
 	syscall
 	
 	print_str(prmpt3)
 	la   $a0, answer
 	syscall
 	
 	lb   $t0, ($a0)
 	
 	li   $a0, '\n'
 	li   $v0, 11
 	syscall
 	
 	beq  $t0, 121, loop		# 'y' is equal 121 in ascii.
 	
 	
 	li   $v0, 10
 	syscall
