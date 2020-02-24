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

			// Normalize the x and y positions from the screen's width and height to 0-1
			fixed2 normalPos = fixed2(
				normalize(pos.x, 0, _ScreenParams.x),
				normalize(pos.y, 0, _ScreenParams.y));

			// Assign x to red, y to green. screenspace is 2d, so z axis is ignored.
			fixed4 color = fixed4(normalPos.x, normalPos.y, 0, 1);

			return color;
		}
		ENDCG
	}
	}
}