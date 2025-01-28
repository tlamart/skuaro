# Skuaro
_a logic game made with LÖVE by tlamart_.
## What is skuaro ?
Skuaro is my implementation of the game SquarO.<br>
I discovered this game during an event hosted by my France Travail agency.<br>
The goal is to find the circles to _fill_.
To do this, each square has a number, from 0 to 4, which corresponds to the number of circles to fill from among those located in the four corners of the square.<br>
In order to fill a circle, simply click on it.<br>
Wanna empty it ? Just re-click on it !
## What is [LÖVE](https://youtu.be/HEXWRTEbj1I?si=37njbXq3isze1tlL) ?
[LÖVE](https://love2d.org/) is a framework for making 2D games in the Lua programming language. LÖVE is totally free, and can be used in anything from friendly open-source hobby projects, to evil, closed-source commercial ones.<br>
In that case, It is an open-source hobby projectthat I may be submit as my final project for [CS50x](https://cs50.harvard.edu/x/2025/), a free course on computer science that I would recommend to anyone new to programming !
## How does this work ?
First, a grid is randomly generated. Each grid has at least one solution and possibly severals.<br>
Then the player can, whenever he wants, check is answer -> the result is either correct or wrong and do not provide more hints.
