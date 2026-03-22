---
title: "Examples of ASM code [x64 NASM]"
date: 2022-11-25
image: /blog/media/wp_migration/89806b_assembly-programming-language-code-monitor-50939740.jpg
tags:
  - programming
  - assembly
categories:
  - programming
  - tech
---

**Average of an array**  
This code works correctly with numbers from 0 to 9. ASCII numbers in the array are converted to values by subtracting 48 from them (0 is 48 in ASCII decimal).

```plain
extern printf
extern scanf

section .data
	inputPrompt: db "Enter the numbers (0 - 9): ", 0
	inputFormat: db "%s", 0
	outputFormat: db "Average: %ld", 10, 0

section .bss
	data: resb 128
	temp: resq 1

global main

section .text
main:
	; Setup
	push rbp

	; Input prompt
	mov rdi, inputPrompt
	xor rsi, rsi
	xor rax, rax
	call printf

	; Input
	mov rdi, inputFormat
	mov rsi, data
	xor rax, rax
	call scanf

	; Function call	
	mov rdi, data
	call .average
	
	; Print out the result
	mov rdi, outputFormat
	mov rsi, rax
	xor rax, rax
	call printf

	; End of the program
	pop rbp
	xor rax, rax
	ret
	
.average:
	; Function - Average of numbers
	; Input:	
	; 	%rdi - Data address
	; Output:
	; 	%rax - Average value
	
	; Init
	xor rbx, rbx ; Sum
	xor rcx, rcx ; Count
	mov rsi, rdi
	
.averageLoop:
	; Load the data
	lodsb
	
	; If end of the loop
	cmp al, 0
	jz .averageEnd
	inc rcx

	; Process value
	; ASCII convert
	mov byte [temp], al
	mov rax, [temp]
	sub rax, 48
	add rbx, rax ; Cannot add 8-bit register to 64-bit register?
	
	jmp .averageLoop

.averageEnd:
	; Divide here
	mov rax, rbx
	div rcx
	
	; Return result
	ret
```

**Maximum of an array**  
This code works correctly with numbers from 0 to 9. ASCII numbers in the array are converted to values by subtracting 48 from them (0 is 48 in ASCII decimal).

```plain
extern printf
extern scanf

section .data
	inputPrompt: db "Enter the numbers (0 - 9): ", 10, 0
	inputFormat: db "%s", 0
	outputFormat: db "Largest number: %ld", 10, 0

section .bss
	data: resb 128
	n: resq 1

global main

section .text
main:
	; Setup
	push rbp

	; Input prompt
	mov rdi, inputPrompt
	xor rsi, rsi
	xor rax, rax
	call printf

	; Input
	mov rdi, inputFormat
	mov rsi, data
	xor rax, rax
	call scanf

; Function: data address in rdi, output in [n]
	mov rdi, data
	call .maxOfNumbers

	; End
	; Print result
	mov rdi, outputFormat
	mov rsi, [n]
	xor rax, rax
	call printf

	; Exit
	pop rbp
	xor rax, rax
	ret

.maxOfNumbers:
	; Init
	mov bl, 0
	mov rsi, rdi
	
.maxOfNumbersLoop:
	; If end of the loop
	lodsb
	cmp al, 0
	jz .maxOfNumbersEnd

	sub al, 48
	cmp al, bl	
	jle .maxOfNumbersLoop
.isBigger:
	mov bl, al
	jmp .maxOfNumbersLoop

.maxOfNumbersEnd:
	mov byte [n], bl
	ret
```

**Reverse an array**  
This code will take an array from a user, reverse it and print it reversed.

```plain
extern scanf
extern printf

; Scanf, printf formats
section .data
	inputPrompt: db "Enter text:", 10, 0
	inputFormat: db "%s", 0
	outputFormat: db "Reversed: %s", 10, 0

section .bss
	text: resb 1024 ; Fixed size

global main

section .text
main:
	; Setup
	push rbp

	; Input prompt
	mov rdi, inputPrompt
	xor rsi, rsi
	xor rax, rax
	call printf

	; Input
	mov rdi, inputFormat
	mov rsi, text
	xor rax, rax
	call scanf

	mov rdi, text
	call .reverse

	; End 
	; Print
	mov rdi, outputFormat
	mov rsi, text
	xor rax, rax
	call printf	

	; Exit
	pop rbp
	xor rax, rax
	ret
	
	; Reverse function
.reverse:
	mov rsi, rdi
	cld	
	
	; Get the end pointer 
.endPtr:	
	lodsb
	cmp al, 0
	jnz .endPtr
	sub rsi, 2 ; Decrease by two because of the new line I suppose
	
.reverseLoop:
	; If pointers cross
	cmp rdi, rsi
	jge .endReverse		
	
.swap:	
	; Swap the bytes
	mov byte dl, [rdi]
	std
	lodsb
	cld
	stosb
	mov byte [rsi+1], dl
	jmp .reverseLoop
	
.endReverse:
	; End of the function
	ret
```

**Bubble sort**  
A little bit more complicated since it contains two loops, but it still contains only the essential instructions.

```plain
extern printf
extern scanf

section .data
	inputPrompt: db "Enter an array to sort:", 10, 0
	inputFormat: db "%s", 0
	outputFormat: db "Sorted array: %s", 10, 0
	
section .bss
	data: resb 128
	size: resq 1

global main

section .text
main:
	; Setup
	push rbp

	; Input prompt
	mov rdi, inputPrompt
	xor rsi, rsi
	xor rax, rax
	call printf

	; Input
	mov rdi, inputFormat
	mov rsi, data
	xor rax, rax
	call scanf

	; Call function
	mov rdi, data
	call .bubbleSort

	; Print
	mov rdi, outputFormat
	mov rsi, rax
	xor rax, rax
	call printf	

	; Exit
	pop rbp
	xor rax, rax
	ret

; Bubble sort
; Input:
; 	%rdi - Address to data
; Output:
; 	%rax - Address to sorted data (original address)
.bubbleSort:
	; Init
	mov rsi, rdi
	xor rax, rax
	xor rdx, rdx
; Get the length of the array to know how many times to loop
.length:
	lodsb
	cmp al, 0
	inc rax
	jz .length
	dec rax     ; Length N
	mov qword [size], rax
	
	; Setup for first loop
	xor rdx, rdx
	xor rax, rax
.loop1:
	; If (i >= size) break
	cmp rdx, [size]
	jge .endLoop1
	inc rdx
	
	; Setup for second loop
	mov rsi, rdi
.loop2:
	; Compare two neighbors and do another looping
	lodsb
	cmp al, 0
	jz .endLoop2
	mov bl, al
	mov byte bh, [rsi]
	cmp bh, 0
	jz .endLoop2
	cmp bl, bh
	jg .swap
	jmp .loop2	
.swap:
	mov cl, bl
	mov bl, bh
	mov bh, cl
	mov byte [rsi-1], bl
	mov byte [rsi], bh
	jmp .loop2

.endLoop2:
	jmp .loop1

.endLoop1:
	; Exit function
	mov rax, data
	ret
```

**To upper case**

```plain
extern printf
extern scanf 

section .data
	inputPrompt: db "Enter data:", 10, 0
	inputFormat: db "%s", 0
	outputFormat: db "To upper case: %s", 10, 0

section .bss
	data: resb 128

global main

section .text
main:
	; Setup
	push rbp

	; Input prompt
	mov rdi, inputPrompt
	xor rsi, rsi
	xor rax, rax
	call printf

	; Input
	mov rdi, inputFormat
	mov rsi, data
	xor rax, rax
	call scanf

	; Function call
	mov rdi, data
	call .toUpper

	; Output
	mov rdi, outputFormat
	mov rsi, data
	xor rax, rax
	call printf

	; Exit
	pop rbp
	xor rax, rax
	ret

; Cast letters to upper letters
; Input:
; 	%rdi - Text address
; Output:
; 	%rax - Text address
.toUpper:
	; Setup
	xor rax, rax
	mov rbx, rdi
	mov rsi, rdi

	; Loop
.loop:
	; If last symbol, return
	lodsb
	cmp al, 0
	jz .end
	
	; If letter, to upper case, otherwise increase rdi
	cmp al, 97
	jl .skipUpper
	cmp al, 122
	jg .skipUpper
	sub al, 32
.skipUpper:
	stosb
	jmp .loop

.end:
	mov rax, rbx
	ret
```

**Sum of an array**

```plain
extern printf
extern scanf 

section .data
	inputPrompt: db "Enter the numbers:", 10, 0
	inputFormat: db "%s", 0
	outputFormat: db "Sum: %ld", 10, 0

section .bss
	data: resb 128
	N: resq 1

section .text

global main

main:
	push rbp
	
	mov rdi, inputPrompt
	xor rax, rax
	call printf

	mov rdi, inputFormat
	mov rsi, data
	xor rax, rax
	call scanf

	mov rdi, data
	call .sum

	mov rdi, outputFormat
	mov rsi, rax
	xor rax, rax
	call printf

	pop rbp
	xor rax, rax
	ret

.sum:
	xor rbx, rbx
	xor rax, rax
	mov rsi, rdi

.loop:	
	lodsb
	cmp al, 0
	jz .end
	
	sub al, 48
	add rbx, rax 
	jmp .loop

.end:
	mov rax, rbx
	ret	
```

**Max of last three numbers**

```plain

extern printf
extern scanf

section .data
	inputPrompt: db "Enter numbers:", 10, 0
	inputFormat: db "%s", 0
	outputFormat: db "Max of %ld, %ld, %ld: %ld", 10, 0

section .bss
	data: resb 128

section .text

global main

main:
	; Setup
	push rbp

	; Input prompt
	mov rdi, inputPrompt
	xor rax, rax
	call printf

	; Input
	mov rdi, inputFormat
	mov rsi, data
	xor rax, rax
	call scanf

	; Call function
	mov rdi, data
	call .maxOf3

	; Print
	mov rdi, outputFormat
	mov rsi, rax
	mov r8, rdx
	mov rcx, rcx
	mov rdx, rbx
	call printf

	; Exit
	pop rbp
	mov rax, 60
	xor rdi, rdi
	syscall

; Function
; Input:
; 	%rdi - Array address
; Output:
; 	%rax - A
; 	%rbx - B
; 	%rcx - C
; 	%rdx - Max
.maxOf3:
	; Setup
	mov rsi, rdi
	xor rax, rax ; A
	xor rbx, rbx ; B
	xor rcx, rcx ; C
	xor rdx, rdx ; D = Max
	xor rdi, rdi ; Counter

	cld

.loop:
	; If end
	lodsb
	cmp al, 0
	jz .endLoop
	inc rdi
	jmp .loop

.endLoop:
	; Setup
	sub rsi, 2

	; Not enough numbers
	cmp rdi, 3
	jl .exitFault

	; Get the numbers
	std
	lodsb
	mov rcx, rax
	sub rcx, 48
	lodsb
	mov rbx, rax
	sub rbx, 48
	lodsb
	sub rax, 48

	; Maximum of three
	cmp rax, rbx
	jl .bc
	cmp rax, rcx
	jl .c
	mov rdx, rax
	jmp .exit

.bc:
	cmp rbx, rcx
	jl .c
	mov rdx, rbx
	jmp .exit

.c:
	mov rdx, rcx
	jmp .exit

.exitFault:
	mov rax, 0
	mov rbx, 0
	mov rcx, 0
	mov rdx, 0
.exit:
	ret
```

**Remove last three letters**  
Removes last three letters of a word - if word is too short, does nothing. Prints out the results using a syscall instead of printf.

```plain
extern scanf
; Output using syscall

section .data
	inputPrompt: db "Enter the text: ", 10, 0
	inLen: equ $-inputPrompt
	inputFormat: db "%s", 0
	newLine: db " ", 10, 0
	newLineLen: equ $-newLine

section .bss
	data: resb 128

section .text

global main

main:
	; Setup
	push rbp

	; Input prompt
	mov rax, 1
	mov rdi, 1
	mov rsi, inputPrompt
	mov rdx, inLen
	syscall

	; Input
	mov rdi, inputFormat
	mov rsi, data
	xor rax, rax
	call scanf

	; Function call
	mov rdi, data
	call .removeLast3

	; Print result
	mov rax, 1
	mov rdi, 1
	mov rsi, data
	syscall
	mov rax, 1
	mov rdi, 1
	mov rsi, newLine
	mov rdx, newLineLen
	syscall

	; Exit
	pop rbp
	ret

; Input: rdi - address
; Output: rax - address
;         rdx - size
.removeLast3:
	; Setup
	xor rdx, rdx ; Counter
	mov rsi, rdi
	cld

.loop:
	; If end of data
	lodsb
	cmp al, 0
	jz .exitLoop
	inc rdx
	jmp .loop

.exitLoop:
	sub rsi, 2

	; Check if enough letters
	cmp rdx, 3
	jl .exitFailure

	; Quick hack - just place a zero at the right spot
	mov byte [rsi-2], 0
	jmp .exit

.exitFailure:
	mov rax, rdi
.exit:
	sub rdx, 3
	ret
```
