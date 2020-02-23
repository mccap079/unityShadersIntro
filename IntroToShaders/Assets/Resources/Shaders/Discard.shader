Shader "Custom/Discard"
{
	Properties
	{
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
				float4 sv_vertex : POSITION;
				float4 uv : TEXCOORD0;
			};

			vertexOutput vert(appdata_base input)
			{
				vertexOutput output;
				// https://docs.unity3d.com/Manual/SL-BuiltinFunctions.html
				output.sv_vertex = UnityObjectToClipPos(input.vertex);
				output.uv = input.texcoord;
				return output;
			}

			fixed4 frag(vertexOutput input) : SV_Target
			{
				// Screen-space pixel position
				//fixed2 pos = fixed2(floor(i.sv_vertex.x), floor(i.sv_vertex.y));
				//if (pos.x > 600.0) discard;
				if (input.uv.x > 0.5) discard;
				return fixed4(input.uv.r, input.uv.g, 0,1);
		}
		ENDCG
	}
	}
}