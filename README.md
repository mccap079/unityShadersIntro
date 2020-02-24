Intro to Shaders in Unity
=========================

This is technically an intro to *fragment* shaders specifically. No other part of the Unity graphics pipeline is focused on here -- we use minimal vertex shader code mainly as a "pass-through" shader. Frag shaders are arguably the easiest gateway into shader programming due to both its visual nature and its place near the end of the graphics pipeline.

1 What is a shader?
-------------------

**Shader = code that runs on the GPU**

Shaders were originally designed to handle the rendering of light and shadow (the "shading") in 3d scenes

You should write shader code when you want custom lighting or texture effects beyond what Unity offers out of the box

You should also consider writing shader code for performance intensive things (i.e., something that should uniquely effect every pixel on the screen, every frame, or every vertex of millions of vertices, every frame)

GPUs execute code on each pixel in parallel: https://thebookofshaders.com/01/

A shader usually consists of a script or collection of scripts that define portions of the [graphics pipeline](https://vulkan-tutorial.com/images/vulkan_simplified_pipeline.svg) ([alt](https://en.wikibooks.org/wiki/Cg_Programming/Programmable_Graphics_Pipeline))

Your shader script(s) will execute for every one of the parallel "pipes": http://ithare.com/wp-content/uploads/BB_part114_BookChapter014h_v3.png

The parallel, per-pixel nature is a different way of thinking about your code -- this is why it's infamously difficult to understand. Another hard part is debugging shader code (thankfully Unity makes this easier)

2 Shaders in Unity
-------------------

Common [shading languages](https://en.wikipedia.org/wiki/Shading_language):
 - GLSL (OpenGl Shading Language)
 - HLSL (High-Level Shading Language) <-- **Unity uses this**
 - Cg (Deprecated, Unity considers this more-or-less the same as HLSL) <-- **Unity uses this**

Unity also uses its own shading paradigm called ShaderLab

ShaderLab = Unity's language for writing shaders. Has the `.shader` file extension. Your HLSL/Cg shader code will exist within a ShaderLab script.

[Types of shaders in Unity](https://docs.unity3d.com/Manual/ShadersOverview.html):
 - Surface shaders: Highly abstracted HLSL, is effected by scene lighting by default
 - Vertex & Fragment shaders: HLSL/Cg, lower level, higher level of customization, most useful across platforms
 - Fixed function shaders

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

4 .shader 101
-------------------------

https://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html

### ShaderLab basics:

Shader naming

Properties: variables that can be input from the Inspector

SubShader: Each shader in Unity consists of a list of subshaders. Unity will pick the first subshader that runs on the user's graphics card

[Pass](https://docs.unity3d.com/Manual/SL-Pass.html): One render "pass". Shader can have multiple render passes

`CGPROGRAM` & `ENDCG`

### HLSL/Cg bascis:

Compilation directives: `#pragma vertex vert` & `#pragma fragment frag` ([src](https://docs.unity3d.com/Manual/SL-ShaderPrograms.html))

Built-in functions & variables: `#include "UnityCG.cginc"` ([src](https://docs.unity3d.com/Manual/SL-BuiltinIncludes.html))

#### [Datatypes](https://docs.unity3d.com/Manual/SL-DataTypesAndPrecision.html)

Floats: 
 - `float` (high precision), 
 - `half` (med precision, range of –60000 to +60000), 
 - `fixed` (you mostly want to use this; low precision, range of –2.0 to +2.0)

Vectors:

Vector = datatype that stores 2 types of information: direction, and magnitude (i.e., how *much* in that direction) 

2D vectors = `float2`, `half2`, `fixed2`

3D vectors = `float3`, `half3`, `fixed3`

Vectors in shaders commonly store a **color**:

`float3 color = float3(r, g, b);` <-- red, green, and blue values (no transparency data, fully opaque)

`float4 color = float4(r, g, b, a);` <-- red, green, blue, and alpha (transparency) values

Or a **position**:

`float2 pos = float2(x, y);` <-- 2D position

`float3 pos = float3(x, y, z);` <-- 3D position

### UV space vs XY space

In 3d engines you are dealing with multiple "spaces":
 - X,Y,Z world space
 - X,Y screen space
 - U,V space (the X and Y axes of a 2d texture on the face of a 3d object are not known as "x" and "y", but "u" and "v")

### Normalization

UV space is typically normalized (x, y values range from 0-1)

Color values in frag shaders are also normalized:
 - Red = `fixed3(1, 0, 0);`
 - Green = `fixed3(0, 1, 0);`
 - Blue = `fixed3(0, 0, 1);`

### Ins and outs: passing data between shaders

Every shader passes its output to the next shader in the graphics pipeline as input

The vertex shader passes its output data to the fragment shader as input

You must define the data that the vertex shader will pass to the fragment shader. Create a `struct` that declares what data you'll pass:

```
struct vertexOutput
{
	float4 vertex : SV_POSITION; // The position of the current pixel in screen space coordinates
	float4 uv : TEXCOORD0; // The position of the current pixel in texture space coordinates

}
```

See [here](https://docs.unity3d.com/Manual/SL-VertexProgramInputs.html) for more types of data you can send from the vert to the frag shader

In your vertex shader you must assign a value to all the items you put in your `struct`:

```
// We input `appdata_base` into the vert shader, which is a built-in variable defined via `#include "UnityCG.cginc"` (https://docs.unity3d.com/Manual/SL-VertexProgramInputs.html)
vertexOutput vert(appdata_base input) 
{
	// Instantiate an instance of the output struct we made
	vertexOutput output; 

	// Assign values to its data
	output.vertex = UnityObjectToClipPos(input.vertex); // UnityObjectToClipPos() is a built-in function defined via `#include "UnityCG.cginc"`
	output.uv = input.texcoord;

	// Return it
	return output;
}
```

In the frag shader we'll take the vert shader's output as input, where we can use it (or not, depending on what you want to do!) to draw colors to the screen:

```
// `SV_TARGET` = "single value target"; our frag shader will only return a single `fixed4(r,g,b,a)` color value (as opposed to a struct)
fixed4 frag(vertexOutput input) : SV_Target
{

	// Get the screen-space pixel position that we outputted from the vertex shader
	fixed2 pos = fixed2(floor(input.vertex.x), floor(input.vertex.y)); // floor() is a common math function that will round a decimal down (i.e., from 1.5 to 1.0)

	// Assign the uv texture x,y coordinates to the red and green values of a color
	fixed4 color = fixed4(input.uv.r, input.uv.g, 0, 1);

	// Return the color
	return color;
}
```

5 Visual debugging in the fragment shader
------------------------------------------

https://en.wikibooks.org/wiki/Cg_Programming/Unity/Debugging_of_Shaders

Use UV color mapping technique to determine your pixel position

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