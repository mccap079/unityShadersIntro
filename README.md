Intro to Shaders in Unity
=========================

1 What's a shader?
-------------------

Shader = code that runs on the GPU

GPUs execute code on each pixel in parallel: https://thebookofshaders.com/01/

A shader usually consists of a script, or a collection of scripts that each define one aspect of the *graphics pipeline*

https://vulkan-tutorial.com/images/vulkan_simplified_pipeline.svg

Your shader script(s) will execute for every one of the parallel pipes: http://ithare.com/wp-content/uploads/BB_part114_BookChapter014h_v3.png

The parallel, per-pixel nature is a different way of thinking about your code -- this is why it's infamously difficult to understand. Another hard part is debugging shader code (thankfully Unity makes this easier)

2 Shaders in Unity
-------------------

All of the materials on objects in a unity scene are being rendered with shaders. Unity doesn't let you edit these default ones directly, so when you want more customization you can make your own Shader.

https://docs.unity3d.com/Manual/ShadersOverview.html

3 Setting up an environment
----------------------------

 - Add 3d game obj to scene
 - Create material
 - Create shader script (unlit?)
 - Add shader to material
 - Add material to game obj
 - Start editing your shader script

4 Fragment shader basics
-------------------------

-0.5 to 0.5

Datatypes

Ins & outs

5 Visual debugging in the fragment shader
------------------------------------------

6 Change object color
----------------------

7 Transparency
---------------
 
https://docs.unity3d.com/Manual/SL-Blend.html

`Tags { "Queue" = "Transparent" }`

`discard;`

8 Grab pass
------------

Use https://docs.unity3d.com/Manual/SL-GrabPass.html to get the pixel data behind your game object in the scene

9 Blend modes
--------------

Multiply

Screen

Overlay