Shader "Custom/ColorAlpha"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,0.5)
	}
		SubShader
	{
		Tags { "RenderQueue" = "Transparent" } // Transparent stuff must render after evrything else

		Blend SrcAlpha OneMinusSrcAlpha // Traditional transparency

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			fixed4 _Color;

			struct vertexOutput
			{
				float4 vertex : SV_POSITION;
			};

			vertexOutput vert(appdata_base input)
			{
				vertexOutput output;
				output.vertex = UnityObjectToClipPos(input.vertex);
				return output;
			}

			fixed4 frag(vertexOutput input) : SV_Target
			{
				return _Color;
			}
			ENDCG
		}
	}
}