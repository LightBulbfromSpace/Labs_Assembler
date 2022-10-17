.macro done
	li   $v0, 10
	syscall
.end_macro

	# disjunctive normal form
.macro DNF(%result_dnf, %counter_r, %size_r, %result_comp_r, %user_input_addr_r, %m_addr_r, %mask, %y_output, %fr_r1, %fr_r2)										
	li   %result_dnf, 0
	la   %m_addr_r, %mask
	la   %user_input_addr_r, input
	
	comparation_mask(%counter_r, %size_r, %result_comp_r, %user_input_addr_r, %m_addr_r, %fr_r1, %fr_r2)
	
	or   %result_dnf, %result_dnf, %result_comp_r
	
	beq  %result_dnf, 1, %y_output
.end_macro

.macro print_char(%char)
	li   $a0, %char
	li   $v0, 11
	syscall
.end_macro

.macro print_str(%str)
	la   $a0, %str
	li   $v0, 4
	syscall
.end_macro

.macro print_int_r(%int_r)
	move $a0, %int_r
	li   $v0, 1
	syscall
.end_macro

.macro y_out(%y_str, %result_r)
	print_str(%y_str)
	print_int_r(%result_r)
	print_char(10)
.end_macro

.macro read_int_to_arr_loop(%counter_r, %size_r, %destination_addr_r)
	
	la   %destination_addr_r, input
	move %counter_r, $zero 
	
	read_loop:
	li   $v0, 5
	syscall
	
	bltz $v0, err_wrong_input
	bgt  $v0, 1, err_wrong_input
	
	sb   $v0, (%destination_addr_r)
	
	la   %destination_addr_r, 1(%destination_addr_r)
	add  %counter_r, %counter_r, 1

	blt  %counter_r, %size_r, read_loop
.end_macro

.macro comparation_mask(%counter_r, %size_r, %result_r, %user_input_addr, %mask_addr, %free_r1, %free_r2)
	li   %result_r, 1
	li   %counter_r, 0
start_comparation_mask:
	beq  %counter_r, %size_r, end_comparation_mask
	lb   %free_r1, (%user_input_addr)
	lb   %free_r2, (%mask_addr)
	add  %counter_r, %counter_r, 1
	la   %user_input_addr, 1(%user_input_addr)
	la   %mask_addr, 1(%mask_addr)
	beq  %free_r1, %free_r2, start_comparation_mask
	li   %result_r, 0
end_comparation_mask:

.end_macro

.macro question(%got_answer_r, %buffer_addr)
	print_str(prmpt2)
	
	la   $a0, %buffer_addr
	li   $a1, 2
	li   $v0, 8
	syscall
	
	lb   %got_answer_r, %buffer_addr
.end_macro
	
	.ktext 0x80000180
	
   	mfc0 $k0,$14      		# Coprocessor 0 register $14 has address of trapping instruction
   	addi $k0,$k0, 4   		# Add 4 to point to next instruction
  	mtc0 $k0,$14      		# Store new address back into $14
   	eret
   	
	.data

prmpt1:	.asciiz "\nType 7 zeros or units:\n"
prmpt2: .asciiz "\nDo you want to check sequence again?\nType 'y' to continue or something else to exit.\n"
buffer:	.space  2
err_in: .asciiz "Wrong number. Input should contain only 1 or 0.\n"
input:  .byte 	0, 0, 0, 0, 0, 0, 0
mask1:	.byte 	0, 0, 0, 1, 0, 0, 1
mask2:	.byte 	1, 0, 1, 1, 1, 0, 0
mask3:	.byte 	1, 1, 1, 0, 1, 1, 1
mask4:	.byte 	1, 1, 1, 1, 1, 1, 0
size:	.byte 	7
y1:	.asciiz "y1: "
y2:	.asciiz "y2: "
y3:	.asciiz "y3: "

	.text
	.globl main
main:
	lb   $s0, size
main_loop:						

	print_str(prmpt1)
	
	# %counter_r, %size_r, %destination_adr_r
	read_int_to_arr_loop($t1, $s0, $s1)
				
	# %counter_r, %size_r, %result_comp_r, %user_input_addr_r, %mask, %mask_addr_r, %y_output
	DNF($t4, $t1, $s0, $t0, $s1, $s2, mask1, y1_output, $t2, $t3)
	DNF($t4, $t1, $s0, $t0, $s1, $s2, mask2, y1_output, $t2, $t3)
	DNF($t4, $t1, $s0, $t0, $s1, $s2, mask3, y1_output, $t2, $t3)
	DNF($t4, $t1, $s0, $t0, $s1, $s2, mask4, y1_output, $t2, $t3)
	
y1_output:

	print_char(10)
	
	y_out(y1, $t4)
	
	DNF($t4, $t1, $s0, $t0, $s1, $s2, mask2, y2_output, $t2, $t3)
	DNF($t4, $t1, $s0, $t0, $s1, $s2, mask3, y2_output, $t2, $t3)
	
y2_output:
	y_out(y2, $t4)
	
	DNF($t4, $t1, $s0, $t0, $s1, $s2, mask1, y3_output, $t2, $t3)
	DNF($t4, $t1, $s0, $t0, $s1, $s2, mask3, y3_output, $t2, $t3)
	
y3_output:
	y_out(y3, $t4)

q_and_choice:
	question($a0, buffer)
	beq  $a0, 121, main_loop
	
	done


err_wrong_input:

	print_str(err_in)
	j    q_and_choice