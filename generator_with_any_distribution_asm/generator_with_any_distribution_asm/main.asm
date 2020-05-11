includelib libcmt.lib
includelib legacy_stdio_definitions.lib

.model flat
.686

extern _ExitProcess@4 : PROC
extern __read : PROC 
extern _printf : PROC

public _main
public _random_number_inverted_distribution_generator
public _random_number_elimination_method_generator
public _random_number_shift_register

.data
;constans for main program and some variables for outputting uint32 numbers and waiting for enter pressed
get_enter_buffer db 1
uint32_printf_output db "%d", 10, 0
uint32_x2_printf_output db "%u %u", 10, 0
press_enter_msg db "press enter to continue", 10, 0
ITERATION_COUNTER_END EQU 10000

;constans and variables for shift register
P_CONST EQU 7
Q_CONST EQU 3
INIT_VECTOR_LENGTH_CONST EQU 7
NUMBER_BIT_LENGTH_CONST EQU 32
actual_starting_vector dd 00000045h

;constans and variables for inverted distribution
INTERVALS_CONST dd 0.2,0.6,0.9,1.0
RAND_MAX_CONST dd 07fffffffh

;constans and variables for elimination method
a_CONST EQU 30 
b_CONST EQU 100
d_CONST EQU 50
A_FORMULA_CONST EQU 2
B_FORMULA_CONST EQU 20 ; we will subtract  that value
.code

_random_number_shift_register PROC
	push ebp
	mov ebp,esp
	push ebx
	push ecx

	;calculating formula bi = bi-p  XOR  bi-q	where b is bit in number
	mov eax,actual_starting_vector
	;we set 2 bits in register which will be operands for XOR first
	mov ebx,00000001h
	shl ebx, INIT_VECTOR_LENGTH_CONST - P_CONST
	mov edx,00000001h
	shl edx,INIT_VECTOR_LENGTH_CONST - Q_CONST
	add ebx,edx

	mov ecx,INIT_VECTOR_LENGTH_CONST
	generate_number:
	cmp ecx,NUMBER_BIT_LENGTH_CONST
	je generate_numberend
		;instead of XOR operation of 2 bits we can do AND operation
		;with actual_vector and vector with bits to xor
		;if resault of operation is equal to 0 or equal to vector with bits to xor
		;it's mean XOR operation resault will be 0
		;else XOR operation resault will be 1
		mov edx,eax
		and edx,ebx
		cmp edx,0
		je setzero
		cmp edx,ebx
		je setzero
		bts eax,ecx
		jmp setnotzero
		setzero:
		btr eax,ecx
		setnotzero:
		shl ebx,1	;shift vector with bits to xor by one
	inc ecx
	jmp generate_number
	generate_numberend:
	mov actual_starting_vector,eax
	shr actual_starting_vector,NUMBER_BIT_LENGTH_CONST - INIT_VECTOR_LENGTH_CONST

	pop ecx
	pop ebx
	pop ebp
	ret
_random_number_shift_register ENDP

_random_number_inverted_distribution_generator PROC
	push ebp
	mov ebp,esp
	push esi 
	push edi

	;random float - esi
	call _random_number_shift_register
	and eax, 07fffffffh
	push eax
	finit 
	fild dword ptr [esp]
	fild RAND_MAX_CONST
	fdivp
	fstp dword ptr [esp]
	pop esi

	;compare random with intervals
	mov ecx,0
	compare_with_intervals:
		inc ecx
		;here we compare floats, sign bit is always set on 0
		;if exponent (more significant bits) is greater, then number is greater
		;in case of exponent equal
		;if mantysa (less significant bits) is greater, then number is greater
		cmp	esi,[INTERVALS_CONST + 4* ecx - 4]
	ja compare_with_intervals

	push ecx
	push OFFSET uint32_printf_output
	call _printf
	add esp,4
	pop eax

	pop edi
	pop esi
	pop ebp
	ret
_random_number_inverted_distribution_generator ENDP

_random_number_elimination_method_generator PROC
	push ebp
	mov ebp,esp
	push esi 
	push edi
	push ebx

	;U2 - esi
	call _random_number_shift_register
	mov edx, 0
	mov ecx,d_CONST
	div ecx
	mov esi,edx
	
	;U1 - edi
	call _random_number_shift_register
	mov edx, 0
	mov ecx,b_CONST
	sub ecx,a_CONST
	inc ecx
	div ecx
	add edx,a_CONST
	mov edi,edx

	;A*U1 + B - ebx
	mov eax,A_FORMULA_CONST
	mov edx, 0
	mul edi
	add eax,B_FORMULA_CONST

	;U2 < A*U1 + B
	cmp esi,ebx
	jb end_rand_elimination
	;In normal generator we reject this values and we should draw again
	je not_print
	end_rand_elimination:
	push esi
	push edi
	push OFFSET uint32_x2_printf_output
	call _printf
	add esp,12
	mov eax,edi

	not_print:
	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
_random_number_elimination_method_generator ENDP

_main PROC

	;10000 iteration with writing into console of generating numbers with inverted distribution generator
	mov ecx,ITERATION_COUNTER_END
	loop1:
		push ecx
		call _random_number_inverted_distribution_generator
		pop ecx
	loop loop1



	;waiting for pressing enter
	push OFFSET press_enter_msg
	call _printf
	add esp,4
	push dword ptr 1
	push dword ptr OFFSET get_enter_buffer
	push dword ptr 0
	call __read
	add esp,12



	;10000 iteration with writing into console of generating numbers with elimination method generator
	mov ecx,ITERATION_COUNTER_END
	loop2:
		push ecx
		call _random_number_elimination_method_generator
		pop ecx
	loop loop2



	;waiting for pressing enter
	push OFFSET press_enter_msg
	call _printf
	add esp,4
	push dword ptr 1
	push dword ptr OFFSET get_enter_buffer
	push dword ptr 0
	call __read
	add esp,12

	push 0
	call _ExitProcess@4

_main ENDP

END