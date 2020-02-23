Shader "Custom/XYColorMap"
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
				// https://docs.unity3d.com/Manual/SL-BuiltinFunctions.html
				output.vertex = UnityObjectToClipPos(input.vertex);
				output.uv = input.texcoord;
				return output;
			}

			float normalize(float val, float min, float max) {
				return (val - min) / (max - min);
			}

			fixed4 frag(vertexOutput input) : SV_Target
			{
				// Screen-space pixel position
				fixed2 pos = fixed2(floor(input.vertex.x), floor(input.vertex.y));

				fixed2 normalPos = fixed2(
					normalize(pos.x, 0, _ScreenParams.x),
					normalize(pos.y, 0, _ScreenParams.y));

				return fixed4(normalPos.x, normalPos.y, 0, 1);
			}
			ENDCG
		}
	}
}