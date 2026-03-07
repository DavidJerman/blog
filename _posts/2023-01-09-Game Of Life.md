---
category: tech
title: "Game Of Life"
date: 2023-01-09
image: ../media/39e2a0_image-1.png
---

Game Of Life, or short Life, is a <a href="https://en.wikipedia.org/wiki/Cellular_automaton" rel="noreferrer noopener" target="_blank">cellular automaton</a> devised by the British mathematician <a href="https://en.wikipedia.org/wiki/John_Horton_Conway" rel="noreferrer noopener" target="_blank">John Horton Conway</a> in 1970. It is a zero-player game, which means, that it requires no further input upon having been initialized to a certain state at the start. The idea is that we have a grid of cells, which can either be dead or alive. We set some of the cells to be alive and the other cells to be dead. After that we start the game/simulation and watch the cells create new patterns. You can read more about cellular automatons on <a data-id="https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life" data-type="URL" href="https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life" rel="noreferrer noopener" target="_blank">Wikipedia</a>.

Cells can then become alive, die or simply live on. And the game flow is as such defined by three simple rules. In Game Of Life, these set of rules are:

- A cell can be born if it has 3 living neighbors,

- A will survive if it has 2 or 3 neighbors,

- Otherwise the cell will die / stay dead

With this simple set of rules, we can create random looking patterns, changing and moving with each step. Though remember! The way that cells will develop further on is completely determined by the initial state - which cells were dead or alive at the start.

## My implementation

So I created a simple implementation in C++ that simulates the Game OF Life. You can however also define a custom set of rules by specifying them with the following format: B3/S23. This would be used to define Conway's Game Of Life rules described above.

The implementation is cross-platform and uses the OneLoneCoder's Pixel Game Engine for displaying the cells. The library is open-source, easy to include and available on <a href="https://github.com/OneLoneCoder/olcPixelGameEngine">OneLoneCoder/olcPixelGameEngine</a>. The game repository is also available on <a data-id="https://github.com/DavidJerman/GameOfLife" data-type="URL" href="https://github.com/DavidJerman/GameOfLife">DavidJerman/GameOfLife</a>

![Image](/blog/media/39e2a0_image-1.png)

*Game Of Life game state example*

The game allows you to either let the simulation play by itself or. you can set it to step by step - and by pressing n you can then calculate the new generation. By clicking on the grid you can make the cells alive (left click) and by right clicking them, you can make them dead. You can also randomize the grid and watch the cells develop in interesting ways. To find out more about how to use the program, I would advise you to take a look at my <a href="https://github.com/DavidJerman/GameOfLife">repository</a>, where I have described all the commands and controls.

Another interesting thing is that you can define other algorithms/rules. Conway's Game Of Life is just one of the many sets of rules that produce interesting output. It is defined as B3/S23 and as explained before, B stands for when cells are born, and S for when cells survive. Other interesting rules that I found (and you can find all of these and many more on Wikipedia) are B1/S12, which generates the following interesting pattern by just adding a single pixel in the middle of the screen:

![Image](/blog/media/e19f96_image-2.png)

There are a lot more interesting patterns. I recommend you to try them, experiment with different rules and see what happens!

## Building the program

You can build the program yourself by following the instructions on GitHub. However, here is a simple explanation on how you can build the program with CMake in Linux, though it should be pretty similar on Windows. By default everything should work by just using the commands below (tested on Ubuntu 22). One of the libraries that might be missing though is libgl-dev, which you can install with *sudo apt install libgl-dev.*

```bash
git clone https://github.com/DavidJerman/GameOfLife
cd GameOfLife
mkdir build
cmake -S . -B build
cd build
make
./GameOfLife
```

In the first line we just clone the repository and move inside it. Then we create a build directory and call CMake, which generates the necessary make files for building the program. Following that we just move to the build directory and call make. This compiles the program, which can then be run with ./GameOfLife.
