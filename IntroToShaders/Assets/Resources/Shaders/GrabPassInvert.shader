Shader "Custom/GrabPassInvert"
{
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

			struct vertexOutput
			{
				float4 grabPos : TEXCOORD0;
				float4 pos : SV_POSITION;
			};

			vertexOutput vert(appdata_base input) {
				vertexOutput output;
				// use UnityObjectToClipPos from UnityCG.cginc to calculate
				// the clip-space of the vertex
				output.pos = UnityObjectToClipPos(input.vertex);
				// use ComputeGrabScreenPos function from UnityCG.cginc
				// to get the correct texture coordinate
				output.grabPos = ComputeGrabScreenPos(output.pos);
				return output;
			}

			sampler2D _BackgroundTexture;

			half4 frag(vertexOutput input) : SV_Target
			{
				half4 bgcolor = tex2Dproj(_BackgroundTexture, input.grabPos);
				return 1 - bgcolor;
			}
			ENDCG
		}
	}
}