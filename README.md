
I had a bit of trouble deciding what to make for this project, so I ended up with a lot of completely different projects, all with different 
mechanics, but none of them fully developed really. I started working on a first person game with a hookshot and physics system, but then I 
moved on to making a punch-out clone, and ended with a weird, KCD inspired action combat game. I had to code a lot of different scripts for 
this to work right, and I did it in GDscript. Every script is a class that inherits its properties from the node it comes from (signalled by 
the “extends: at the beginning at the script). The variables aren’t hard coded to a type (eg: int or string), rather they are called Variants, 
and can work as any type of variable depending on context. I had a lot of functions, whether pre built or ones I made my own to help it work. 
In one unique instance, I had a timer running at delta in the draw function, and when the timer timeout, it will call another random function 
for blocking, and then restart the timer. Inheritance is really easy in GDscript, as the child nodes simply inheret all the functions from 
their parents (most functions are built in, but you can make your own functions make a child, and then it inherates the function). 
Abstraction is done through @abstract, you can use super() in order to create a unique function of a pre-existing function in a child, and 
interfaces don’t really exist in gdscript. I didn’t really need to use much abstraction or inheritance, but I set up scripts/scenes with it in 
case I did. Overall I think I have an interesting setup for something I can work on over the summer, and I’m glad I focused on mechanics rather 
than polish really. Toby helped me on some aspects (ex: how to structure some of the blocking and testing the cameras to make sure they 
functioned correctly)


I used this video to help with the grapple hook (I did change some of the code though):
https://www.youtube.com/watch?v=yWRHMOqoxGM

