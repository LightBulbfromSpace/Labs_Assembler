section .data

	msg: db "My message", 0x0a
	len: equ $ - msg

section .text

global _start
_start:
	mov eax, 4 ; sys_write system call
	mov ebx, 1 ; stdout file descriptor
	mov ecx, msg ; bytes to write
	mov edx, len ; number of bytes to write
	int 0x80 ; perform system call (address to kernel)

	mov ebx, 0 ; return code 0
	mov eax, 1 ; system call sys_exit
	int 0x80
