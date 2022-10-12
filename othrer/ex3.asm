global _start

section .data

	str: times 10 db 0

section .bss

section .text
_start:
	mov eax, 3 ; sys_call for read
	mov ebx, 0 ; file's descriptor (stdin)
	mov ecx, str ; destination
	mov edx, 10 ; length
	int 0x80

	mov eax, 4 ; sys_call for write
	mov ebx, 1 ; file's descriptor (stdout)
	mov ecx, str ; source
	mov edx, 10 ; length
	int 0x80

	mov ebx, 0 ; programm exit status
	mov eax, 1 ; sys_exit system call
	int 0x80
