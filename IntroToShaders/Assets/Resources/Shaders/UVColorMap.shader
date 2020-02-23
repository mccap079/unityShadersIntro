Shader "Custom/UVColorMap"
{
	SubShader
	{
		Tags { "RenderType" = "Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct vertexOutput
			{
				float4 vertex : SV_POSITION;
				float4 uv : TEXCOORD0;
			};

			vertexOutput vert(appdata_base input)
			{
				vertexOutput output;

				output.vertex = UnityObjectToClipPos(input.vertex); // https://docs.unity3d.com/Manual/SL-BuiltinFunctions.html
				output.uv = input.texcoord;

				return output;
			}

			fixed4 frag(vertexOutput input) : SV_Target
			{
				fixed4 color = fixed4(input.uv.r, input.uv.g, 0, 1);
				return color;
		}
		ENDCG
	}
	}
}