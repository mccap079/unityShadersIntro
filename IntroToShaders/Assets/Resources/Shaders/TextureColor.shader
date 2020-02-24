Shader "Custom/TextureColor"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,0.5)
	}
		SubShader
		{
			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				// This time we define our own input to the vertex shader
				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct vertexOutput
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST; // Texture's tiling information; `{TextureName}_ST`; required
				// https://docs.unity3d.com/Manual/SL-PropertiesInPrograms.html

				float4 _Color;

				vertexOutput vert(appdata input)
				{
					vertexOutput output;
					output.vertex = UnityObjectToClipPos(input.vertex);
					output.uv = TRANSFORM_TEX(input.uv, _MainTex);
					return output;
				}

				fixed4 frag(vertexOutput input) : SV_Target
				{
					fixed4 col = tex2D(_MainTex, input.uv); // sample the texture
					return col * _Color;
				}
				ENDCG
			}
		}
}