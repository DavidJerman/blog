---
title: "Quick Assembly cheat sheet [x64 NASM]"
date: 2022-11-23
image: /blog/media/wp_migration/89806b_assembly-programming-language-code-monitor-50939740.jpg
tags:
  - programming-en
  - assembly-en
categories:
  - programming
  - tech
---

This is just a list of some basic ASM instructions and C functions that are useful when getting started with assembly. Instructions that require additional values in registers will have a list of required values. The list is still being worked on. For more instructions one should use a NASM manual, reference or something similar. Once you understand the basics it isn't hard to look at the manual for new instructions. Note that the wording and terminology might be wrong here and there since I am still a beginner at this.

| extern &lt;function&gt; | Import an external (C) function. |
|---|---|
| section &lt;section_type&gt; | A section - it can be an executable code section (.text), a data section (.data) or a portion of assembly code that contains statically allocated variables (.bss). |
| global &lt;symbol&gt; | NASM specific instruction - export symbols in your code to where it points in the object code generated (in Linux that would be for example main).  <br>It basically tells the kernel where the entry point of the program is, where it starts. |
| mov &lt;to&gt;, &lt;from&gt; | Move data to a register from a register/value/variable/location.  <br>When referring to data in the .bss section, surround the variable names with square brackets (mov rax, [N]),  <br>Also when moving data inside of the .bss variable add the data type before it (mov qword [1], 1). |
| syscall | Do a system call. The required register values below are for the print system call. More can be found <a data-id="https://filippo.io/linux-syscall-table/" data-type="URL" href="https://filippo.io/linux-syscall-table/" rel="noreferrer noopener" target="_blank">here</a>.  <br>Rax = &lt;<a data-id="https://filippo.io/linux-syscall-table/" data-type="URL" href="https://filippo.io/linux-syscall-table/" rel="noreferrer noopener" target="_blank">System call number</a>&gt;  <br>Rdi = &lt;Parameter for operation&gt;  <br>Rsi = &lt;Message address&gt;  <br>Rdx = &lt;Message length [bytes]&gt; |
| xor &lt;reg_a&gt;, &lt;reg_b&gt; | Xor operation on two registers. |
| &lt;label_name&gt;: db &lt;data&gt;, &lt;more_data&gt; | Save data in the data section - db is the byte data type. |
| &lt;label_name&gt;: equ $-msg | Save the length of the message in the data section. |
| .&lt;decl_name&gt; | Declaration - defines a part/block of code, we can use it to jump to it - it works in tandem with the goto instruction (in NASM that is jmp, jg, jl etc.). |
| push &lt;data&gt; | Pushes data on the stack.  <br>Often we have to push the rbp register on the stack at the beginning - rbp contains the <a data-id="https://softwareengineering.stackexchange.com/questions/194339/frame-pointer-explanation#:~:text=The%20frame%20pointer%20(%24fp,relative%20to%20the%20frame%20pointer." data-type="URL" href="https://softwareengineering.stackexchange.com/questions/194339/frame-pointer-explanation#:~:text=The%20frame%20pointer%20(%24fp,relative%20to%20the%20frame%20pointer." rel="noreferrer noopener" target="_blank">frame pointer</a>. |
| call &lt;function&gt; | Calls an (external) function.   <br>Calls any function and then returns to where the function was called. |
| cmp &lt;reg_a, req_b/var&gt; | Compare two values in registers/variables. |
| jg .&lt;declaration&gt; | Jump to a declaration if a number was greater (a cmp instruction or similar should be used before). |
| jl .&lt;declaration&gt; | Jump to a declaration if a number was lower (a cmp instruction or similar should be used before). |
| jne .&lt;declaration&gt; | Jump to a declaration if a number was not equal (a cmp instruction or similar should be used before). |
| inc &lt;reg/var&gt; | Increase the value of a register/variable by one. |
| dec &lt;reg/var&gt; | Decrease the value of a register/variable by one. |
| jmp .&lt;declaration&gt; | Jump to a specified declaration. |
| pop &lt;reg&gt; | Pop value off a stack to a specified register. |
| ret | Return/exit from the program. A return value should be specified in the %rax register. |
| &lt;var_name&gt; resq &lt;n&gt; | Reserve n-qwords of data for later use. |
| scanf | Input:  <br>%rdi - Input format - address to the format string,  <br>%rsi - Where to save the value,  <br>%rax - Save a 0 here.  <br>Output:  <br>Variable/register specified in %rsi |
| printf | Input:  <br>%rdi - Output format - address to the format string,  <br>%rsi - What we are printing out,  <br>%rax - Set this to 0.  <br>Output:  <br>Specified value is printed out on the screen. |
| div &lt;divisor&gt; | Input:  <br>%rax - Dividend,  <br>Output:  <br>%rax - Quotient,  <br>%rdx - Remainder. |
| lodsb | Loads a byte from [%rsi] into %al. If the direction flag is set, decrements %rsi, else it increments. |
| stosb | Stores a byte in %al into [%rdi]. If the direction flag is set, decrements %rdi, else increments. |
| cld | Clears direction flag. |
| std | Set direction flag. |

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
