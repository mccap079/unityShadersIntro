Shader "MyShaderDirectory/BasicShaderLabFormat"
{
	// a single color property
	Properties{
		_Color("Main Color", Color) = (1,.5,.5,1)
	}
		// define one subshader
		SubShader
	{
		// a single pass in our subshader
		Pass
		{
		CGPROGRAM

		// HLSL/Cg vertex and fragment shader code goes here

		ENDCG
	}
	}
}