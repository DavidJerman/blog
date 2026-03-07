---
title: "Quick Assembly cheat sheet [x64 NASM]"
date: 2022-11-23
image: ../media/89806b_assembly-programming-language-code-monitor-50939740.jpg
---

This is just a list of some basic ASM instructions and C functions that are useful when getting started with assembly. Instructions that require additional values in registers will have a list of required values. The list is still being worked on. For more instructions one should use a NASM manual, reference or something similar. Once you understand the basics it isn't hard to look at the manual for new instructions. Note that the wording and terminology might be wrong here and there since I am still a beginner at this.

<table><tbody><tr><td>extern <function></td><td>Import an external (C) function.</td></tr><tr><td>section <section_type></td><td>A section - it can be an executable code section (.text), a data section (.data) or a portion of assembly code that contains statically allocated variables (.bss).</td></tr><tr><td>global <symbol></td><td>NASM specific instruction - export symbols in your code to where it points in the object code generated (in Linux that would be for example main).  
It basically tells the kernel where the entry point of the program is, where it starts.</td></tr><tr><td>mov <to>, <from></td><td>Move data to a register from a register/value/variable/location.  
When referring to data in the .bss section, surround the variable names with square brackets (mov rax, [N]),  
Also when moving data inside of the .bss variable add the data type before it (mov qword [1], 1).</td></tr><tr><td>syscall</td><td>Do a system call. The required register values below are for the print system call. More can be found <a data-id="https://filippo.io/linux-syscall-table/" data-type="URL" href="https://filippo.io/linux-syscall-table/" rel="noreferrer noopener" target="_blank">here</a>.  
Rax = <<a data-id="https://filippo.io/linux-syscall-table/" data-type="URL" href="https://filippo.io/linux-syscall-table/" rel="noreferrer noopener" target="_blank">System call number</a>>  
Rdi = <Parameter for operation>  
Rsi = <Message address>  
Rdx = <Message length [bytes]></td></tr><tr><td>xor <reg_a>, <reg_b></td><td>Xor operation on two registers.</td></tr><tr><td><label_name>: db <data>, <more_data></td><td>Save data in the data section - db is the byte data type.</td></tr><tr><td><label_name>: equ $-msg</td><td>Save the length of the message in the data section.</td></tr><tr><td>.<decl_name></td><td>Declaration - defines a part/block of code, we can use it to jump to it - it works in tandem with the goto instruction (in NASM that is jmp, jg, jl etc.).</td></tr><tr><td>push <data></td><td>Pushes data on the stack.  
Often we have to push the rbp register on the stack at the beginning - rbp contains the <a data-id="https://softwareengineering.stackexchange.com/questions/194339/frame-pointer-explanation#:~:text=The%20frame%20pointer%20(%24fp,relative%20to%20the%20frame%20pointer." data-type="URL" href="https://softwareengineering.stackexchange.com/questions/194339/frame-pointer-explanation#:~:text=The%20frame%20pointer%20(%24fp,relative%20to%20the%20frame%20pointer." rel="noreferrer noopener" target="_blank">frame pointer</a>.</td></tr><tr><td>call <function></td><td>Calls an (external) function.   
Calls any function and then returns to where the function was called.</td></tr><tr><td>cmp <reg_a, req_b/var></td><td>Compare two values in registers/variables.</td></tr><tr><td>jg .<declaration></td><td>Jump to a declaration if a number was greater (a cmp instruction or similar should be used before).</td></tr><tr><td>jl .<declaration></td><td>Jump to a declaration if a number was lower (a cmp instruction or similar should be used before).</td></tr><tr><td>jne .<declaration></td><td>Jump to a declaration if a number was not equal (a cmp instruction or similar should be used before).</td></tr><tr><td>inc <reg/var></td><td>Increase the value of a register/variable by one.</td></tr><tr><td>dec <reg/var></td><td>Decrease the value of a register/variable by one.</td></tr><tr><td>jmp .<declaration></td><td>Jump to a specified declaration.</td></tr><tr><td>pop <reg></td><td>Pop value off a stack to a specified register.</td></tr><tr><td>ret</td><td>Return/exit from the program. A return value should be specified in the %rax register.</td></tr><tr><td><var_name> resq <n></td><td>Reserve n-qwords of data for later use.</td></tr><tr><td>scanf</td><td>Input:  
%rdi - Input format - address to the format string,  
%rsi - Where to save the value,  
%rax - Save a 0 here.  
Output:  
Variable/register specified in %rsi</td></tr><tr><td>printf</td><td>Input:  
%rdi - Output format - address to the format string,  
%rsi - What we are printing out,  
%rax - Set this to 0.  
Output:  
Specified value is printed out on the screen.</td></tr><tr><td>div <divisor></td><td>Input:  
%rax - Dividend,  
Output:  
%rax - Quotient,  
%rdx - Remainder. </td></tr><tr><td>lodsb</td><td>Loads a byte from [%rsi] into %al. If the direction flag is set, decrements %rsi, else it increments.</td></tr><tr><td>stosb</td><td>Stores a byte in %al into [%rdi]. If the direction flag is set, decrements %rdi, else increments.</td></tr><tr><td>cld</td><td>Clears direction flag.</td></tr><tr><td>std</td><td>Set direction flag.</td></tr></tbody></table>

Also useful are the data types in the .data section. Here is a list of them that I found.

- DB - Define Byte - 1 byte

- DW - Define Word - 2 bytes

- DD - Define Double Word (DWord) - 4 bytes

- DQ - Define Quad Word (QWord) - 8 byte

- DT - Define TWord - 10 bytes

- DO / DDQ - Define OWord (DQWord) - 16 bytes

- DY - Define YWord - 32 bytes

- DZ - Define ZWord - 64 bytes

And when it comes to allocating space for variables in the .bss section we have the following commands. The instruction pattern is the same for all of the following instructions: <variable_name> resx <n>, where *variable_name *is the variable name, resx is one of the listed instructions and *n* is the number of variables that we allocate space for.

- RESB - 1 byte

- RESW - 2 bytes

- RESD - 4 bytes

- RESQ - 8 bytes

- REST - 10 bytes

- RESO / RESDQ - 16 bytes

- RESY - 32 bytes

- RESZ - 64 bytes

As you can see, the pattern for these instruction and data types is very predictable. If you know the data types (byte, word, dword, ...), you pretty much know all of these instructions.
