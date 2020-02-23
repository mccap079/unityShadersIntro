Intro to Shaders in Unity
=========================

This is technically an intro to *fragment* shaders specifically. No other part of the Unity graphics pipeline is focused on here. Frag shaders are arguably the easiest gateway into shader programming due to both its visual nature and its position near the end of the graphics pipeline.

1 What's a shader?
-------------------

**Shader = code that runs on the GPU**

Shaders are originally designed to handle the rendering of light and shadow (the "shading") in 3d scenes

You should write shader code when you want custom lighting or texture effects beyond what Unity offers out of the box

You should also consider writing shader code for performance intensive things (i.e., something that should uniquely effect every pixel on the screen, every frame, or every vertex of millions of vertices, every frame)

GPUs execute code on each pixel in parallel: https://thebookofshaders.com/01/

A shader usually consists of a script or collection of scripts that define portions of the [graphics pipeline](https://vulkan-tutorial.com/images/vulkan_simplified_pipeline.svg) ([alt](https://en.wikibooks.org/wiki/Cg_Programming/Programmable_Graphics_Pipeline))

Your shader script(s) will execute for every one of the parallel "pipes": http://ithare.com/wp-content/uploads/BB_part114_BookChapter014h_v3.png

The parallel, per-pixel nature is a different way of thinking about your code -- this is why it's infamously difficult to understand. Another hard part is debugging shader code (thankfully Unity makes this easier)

2 Shaders in Unity
-------------------

Shader languages:
 - GLSL
 - HLSL (aka Cg) <-- Unity uses this

ShaderLab

Types of shaders in Unity:
 - Surface shaders

Unity doesn't let you edit default shaders directly, so when you want more customization you can make your own Shader.

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

https://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html

-0.5 to 0.5

Datatypes

Ins & outs

5 Visual debugging in the fragment shader
------------------------------------------

https://en.wikibooks.org/wiki/Cg_Programming/Unity/Debugging_of_Shaders

Magenta = shader failed to compile

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