---
category: tech
title: "Horizontal Micro-Architecture Simulator [2]"
date: 2023-01-25
image: ../media/6cb21c_image-3.png
---

This is just an update to tell the state of the development. As of writing, a large portion of the simulator works - though there might still be some bugs here and there, which is why intensive testing of the program will be required. There a couple of things that I have modified as well as a couple of new things.

### Modificiations

While reviewing the code and putting all the components together, I figured out that some parts of the components weren't designed ideally. The main thing was that I did, was to make the components as similarly as possible to how they would work in an actual micro-architecture. For example, instead of creating multiple interfaces for *ALU* for different operations, I just created a method which sets the operation in the first sub-cycle of a simulation cycle. This way, an instruction can easily be converted to an action. I did the same with the shifter, the memory and all the other components. As per the HO diagram, we can see that in the first cycle all the instruction variables are read and transferred to the components, which tells them how to behave in this cycle. The registers class was also fixed among many other things - mostly in the spirit of consistent behavior across all components.

![Image](/blog/media/6cb21c_image-3.png)

*HO Micro-architecture Diagram*

In addition to the modifications, I added amux and shifter as mentioned before. The parser was also improved and the only thing that is missing for now is the ability to use *MBR* on the right side of the assignment. I will get to that pretty soon.

The parser now also supports the parsing of a file - which redirects the stream to a parser that parses line by line. The code can also contain comments, which can begin with a # and they are ignored. Here is a sample of the code:

```bash
# This is a "hello world" program
0: rd;
1: wr;
2: a := 1;
3: b := (-1);
4: c := a + b;
```

It it not really a hello world program, but it demonstrates the working of the simulator. The code gets parsed successfully, but as excepted when the code is ran, an error occurs. We tried to read and write at the same time which results in the following error - success!

```plain
terminate called after throwing an instance of 'memory_bus_exception'
  what():  Memory bus exception - you probably tried to read while writing or vice versa or set the MAR while the memory was busy
```

And these are the instructions generated and returned by the parser:

![Image](/blog/media/6c2b45_image-4.png)

### Next week

So far so good. In the following days I plan to add support for MBR and later on make the simulator work as a whole in combination with a GUI. Following that, I will probably add an editor and that should be it, unless I get even more ideas.

#### Side note

As you can see, I have shortened the post title. This is just to keep the titles shorter, since there will probably be multiple posts about this project. HO MA of course stands for Horizontal Organization Micro-Architecture.

#### Previous post:

<div class="wp-block-embed__wrapper">
https://davidblog.si/2023/01/21/horizontal-microarchitecture-simulator/
</div>
