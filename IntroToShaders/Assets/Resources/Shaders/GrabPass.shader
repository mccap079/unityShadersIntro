Shader "Custom/GrabPass"
{
	Properties
	{
		_Color("Tint Color", Color) = (1,1,1,0.5)
	}
		SubShader
	{
		// Draw ourselves after all opaque geometry
		Tags { "Queue" = "Transparent" }

		// Grab the screen behind the object into _BackgroundTexture
		GrabPass
		{
			"_BackgroundTexture"
		}

		// Render the object with the texture generated above, and invert the colors
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			fixed4 _Color;

			struct vertexOutput
			{
				float4 grabPos : TEXCOORD0;
				float4 pos : SV_POSITION;
			};

			vertexOutput vert(appdata_base input) {
				vertexOutput output;
				// use UnityObjectToClipPos from UnityCG.cginc to calculate
				// the clip-space (space in the camera's view) of the vertex
				output.pos = UnityObjectToClipPos(input.vertex);
				// use ComputeGrabScreenPos function from UnityCG.cginc
				// to get the correct texture coordinate
				output.grabPos = ComputeGrabScreenPos(output.pos);
				return output;
			}

			sampler2D _BackgroundTexture;

			fixed4 frag(vertexOutput input) : SV_Target
			{
				fixed4 bgCol = tex2Dproj(_BackgroundTexture, input.grabPos);

				fixed4 tint = _Color;

				return fixed4(
					bgCol.r * tint.r,
					bgCol.g * tint.g,
					bgCol.b * tint.b,
					1.0);
			}
			ENDCG
		}
	}
}