---
category: tech
title: "Horizontal Micro-Architecture Simulator [3]"
date: 2023-02-16
image: /blog/media/6cb21c_image-3.png
---

After the exams period I decided to finish this project. To sum everything up: I added all the remaining components, completed the parser (although there are some bugs that I suspect might be present in the code). I suspect operands order might be a problem - especially MBR and MAR registers not being in the correct places etc., but I have not verified this, since I want to wrap this project up. I might take a closer look at this, but right now, the simulator works for all the different programs that I have tried it with. One of the programs that I have tried it with is SUMOFN.MP, which sums up all the numbers from the memory. Here is the pascal-like program:

```plain
0:   mar := pc; rd;  # 0 - 20, 1 - 28, 2 - 19
1:   rd; pc := pc + 1;
2:   a := mbr;
3:   mar := pc; rd;
4:   rd; d := 0;
5:   b := mbr;
6:   mar := a; rd;
7:   rd; pc := pc + 1;
8:   c := mbr;
9:   mar := b; rd;
10:  rd;
11:  c := c + (-1);
12:  e := mbr;
13:  d := d + e;
14:  b := b + 1;
15:  c := c; if z then goto 17;
16:  goto 9;
17:  mar := pc; rd;
18:  rd;
19:  a := mbr;
20:  mar := a; mbr := d; wr;
21:  wr;
# This program sums n-numbers (n located at m[20]) and stores the result in m[19]
# Numbers are stored in m[28] and higher
```

And here is the C++ code that sets the required memory values and runs the program itself in the simulator.

```c++
#include <iostream>
#include "simulator.h"

int main() {
    std::cout << "MIC-1 Simulator" << std::endl;

    simulator sim;
    sim.reset();
    std::vector<instruction> instructions;
    parser p;

    sim.reset();
    instructions = p.parseFile("SUMOFN.MP");
    if (instructions.empty()) {
        std::cout << "No instructions parsed" << std::endl;
    }
    sim.setInstructions(instructions);
    sim.setMemoryCell((word)0, (word)20);
    sim.setMemoryCell((word)1, (word)28);
    sim.setMemoryCell((word)2, (word)19);
    sim.setMemoryCell((word)20, (word)5);
    sim.setMemoryCell((word)28, (word)1);
    sim.setMemoryCell((word)29, (word)2);
    sim.setMemoryCell((word)30, (word)3);
    sim.setMemoryCell((word)31, (word)4);
    sim.setMemoryCell((word)32, (word)5);
    while (sim.next()) ;
    auto res = sim.getMemoryCell((word)19);
    std::cout << "Result: " << res << std::endl;

    sim.printState();

    return 0;
}
```

The output of the program is the following:

```
MIC-1 Simulator

Result: 15

Cycle: 53
Sub cycle: 1

Current instruction: 
Amux: A Latch
Cond: No Jump
Alu: +
Sh: No Shift
Mbr: No
Mar: No
Rd: No
Wr: Yes
Enc: No
Bus C: 0x0
Bus B: 0x0
Bus A: 0x0
Address: 0x0

Registers: 
R0: 2
R1: 0
R2: 0
R3: 0
R4: 0
R5: 0
R6: 1
R7: ffff
R8: fff
R9: ff
Ra: 13
Rb: 21
Rc: 0
Rd: f
Re: 5
Rf: 0

Memory: 
               0x0000 0x0001 0x0002 0x0003 0x0004 0x0005 0x0006 0x0007 0x0008 0x0009 0x000A 0x000B 0x000C 0x000D 0x000E 0x000F 
0x0000: 0x0014 0x001C 0x0013 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 
0x0010: 0x0000 0x0000 0x0000 0x000F 0x0005 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0001 0x0002 0x0003 0x0004 
0x0020: 0x0005 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 
0x0030: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
```

As we can see, the memory contains the addresses in location 0x00 to 0x02. In location 0x14 (20) we can see the number of numbers that are to be added together. In location 0x13 (19) we can see the value of 15, which is the sum of numbers 1 to 5 located at 0x1C to 0x20.

Another important thing to look at are the register contents, where in register A (Ra in the console) we can see the value of 13, where the result was saved.

Then there is the Cycle and Subcycle information - this tells us how many cycles have passed during the execution of the program. Subcycle refers to the number of cycles in each micro-instruction (there are a total of 4). The instruction is represented with flags and corresponds to the write command called in the program - as such the Wr (write) flag is set. The rest are just default values - mostly flags set to false or 0.

#### A bit on components

I designed the components in a way that makes them behave just like actual components of a computer. They receive the values and hold them until, then they receive the flags and when prompted give an output. For example, the memory component is supposed to be interacted with through the following methods: **setSetMar(Mbr)**, **setRd(Wr)**, **setMar(Mbr)**, **getMbr**. The first command just enables or disables writing to MAR or MBR. The second method instructs the memory component to start the writing/reading process. The **setMar/Mbr** method only sets the value of MAR or MBR if the writing to it was enabled with **setSetMar/Mbr**. The last function **getMbr** is responsible for retrieving the value of MBR. Though, since the component tries to imitate the actual component - until the read has been completed, the value of MBR is not changed. Very neat. While the component was supposed to be interacted with only though these means, it also has the functions for setting and reading memory values directly - mostly for testing purposes and such.

The rest of the functions work in the same way. Flags and values are set to them, then they are activated and give a result. There are latches for holding the values in each component, again with the aim of simulating the actual computer.

### Conclusion

This was a fun little project that helped me better understand the working of a computer and improved my skills a little bit. Perhaps in the future I might expand on it a little bit, but for now you can interact with the simulator by calling appropriate functions - write a pascal-like program in an external program, parse it with the parser to obtain the instructions - the parser should to a certain extent warn you of any errors. With the correct syntax however, the instructions will be translated and can then be fed to the simulator. By repeatedly calling the function **next** on the simulator you can then run the program itself. By calling the **printState** function you can print out the register values and the memory contents. There are some examples in the main function on <a href="https://github.com/DavidJerman/MIC1_Simulator">GitHub</a>, but I also provided an example in this post. Pascal-like program examples can also be found on GitHub. 

#### Previous post

<div class="wp-block-embed__wrapper">
https://davidblog.si/2023/01/25/ho-micro-architecture-simulator-2/
</div>
