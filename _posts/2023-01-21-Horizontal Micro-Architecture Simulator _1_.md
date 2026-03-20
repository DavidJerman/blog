---
title: "Horizontal Micro-Architecture Simulator [1]"
date: 2023-01-21
image: /blog/media/wp_migration/6cb21c_image-3.png
tags:
  - micro-architecture-en
  - mic1-en
  - mac1-en
  - cpu-en
  - c-en
  - programming-en
categories:
  - programming
  - tech
---

This is just an introductory post into the development of a MIC1 horizontal microarchitecture simulator. The aim is to simulate the working of such an architecture, allow the parsing of pascal like code to write a micro-program and while simulating the execution of an instruction also visualize it.

The simulator will be written in C++ and will be cross-platform. I have not yet decided on what graphical framework. I might use either Qt or something more simple such as <a href="https://github.com/OneLoneCoder/olcPixelGameEngine">OneLoneCoder's Pixel Game Engine</a>, since it has all the features I need, is compact and easy to include. It is also cross-platform and open source, as is the aim of this project.

I will not write about the architecture in this post, since it is well documented elsewhere. If you want to understand what this is all about, I recommend you you check out <a href="http://chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://passlab.github.io/CSCE513/resources/MicrocodeIntro_Matloff_Franklin04.pdf">this paper</a> or the original source material: Structured Computer Organization, by Andrew Tanenbaum (Prentice-Hall, 1990).

### Progress

I started by creating the memory class. The aim of this class was to simulate the behavior of the main computer memory (commonly RAM). The class consists of a 4KB array of words (16-bit cells) and also contains the *mbr* and *mar* registers. *Mbr* holds the data and *mar* holds the address. The class is designed so that and illegal memory address is caught and the error signaled via a custom exception. It also ensures that the memory has to be read/written to twice before the data can be read/is written. This simulates the long access time of main memory data, since it is usually much longer than a single CPU cycle. 

After that I created the registers class, which contains all the register values as well as allows the setting and getting of all the registers.

Following that I create the *alu* class that will perform all the arithmetic operations and automatically set the appropriate flags (zero or. negative). The supported operations are *plus, and, neg* and *pos*, which basically just passes the value of bus A through the *alu unit. *

While doing all of this I also created the exceptions and constants class that will contain all the custom exceptions and certain constants that will make my work easier.

Then there is the simulator class that will actually run the commands and call the parser to decode the pascal like commands. The parser will convert the pascal commands into 32-bit instructions that can then be interpreted by the simulator - which represent the MIC1 architecture - and the commands will be executed in sub-cycles. The class also contains tests that will test the components of the architecture internally (memory, registers, alu) - white box testing.

For black box testing there is the *run_tests.h* file that will test the working of the simulator and parser externally. I have already added test for a couple of commands.

The parser can at the time of writing interpret a couple micro-instructions such as: *read, write, goto, if goto *and I am also working on others. I will especially have to be careful when designing the addition part and any other micro-instructions that takes registers as input, since not all combinations are valid. For example, the value of *mbr* can only be moved via the A bus, and as such the micro-instruction *a := mbr + mbr* would be invalid. There are many more such cases of invalid combinations, mostly when there are *mar* and *mbr* involved. Other combinations of registers should all be valid.

### The plan

The plan for now is to first finish the parser. That should be one of the major milestones. Implementing the simulator and putting together all the components shouldn't really be that much of a problem. And finally I will create a visualization tool that will allow you to visualize the working of the micro-architecture - how the data flows from register to register, through *alu* and so on.

#### Next post:

https://davidblog.si/2023/01/25/ho-micro-architecture-simulator-2/
