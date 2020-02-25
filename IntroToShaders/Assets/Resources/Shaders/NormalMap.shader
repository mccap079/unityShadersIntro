Shader "Custom/NormalMap"
{
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// include file that contains UnityObjectToWorldNormal helper function
			#include "UnityCG.cginc"

			struct vertexOutput {
		// we'll output world space normal as one of regular ("texcoord") interpolators
		half3 worldNormal : TEXCOORD0;
		float4 pos : SV_POSITION;
	};

	// vertex shader: takes object space normal as input too
	vertexOutput vert(float4 vertex : POSITION, float3 normal : NORMAL)
	{
		vertexOutput output;
		output.pos = UnityObjectToClipPos(vertex);
		// UnityCG.cginc file contains function to transform
		// normal from object to world space, use that
		output.worldNormal = UnityObjectToWorldNormal(normal);
		return output;
	}

	fixed4 frag(vertexOutput input) : SV_Target
	{
		fixed4 c = 0;
	// normal is a 3D vector with xyz components; in -1..1
	// range. To display it as color, bring the range into 0..1
	// and put into red, green, blue components
	c.rgb = input.worldNormal * 0.5 + 0.5;
	return c;
	}
	ENDCG
}
	}
}