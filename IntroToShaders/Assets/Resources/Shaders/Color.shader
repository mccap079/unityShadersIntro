Shader "Custom/Color"
{
	Properties
	{
		// https://docs.unity3d.com/Manual/SL-Properties.html
		_Color("Color", Color) = (1,1,1,0.5)
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }

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

			vertexOutput vert(appdata_base v)
			{
				vertexOutput output;
				output.vertex = UnityObjectToClipPos(v.vertex);
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