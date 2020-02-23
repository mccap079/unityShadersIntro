Shader "Custom/GrabPassAlpha"
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

			struct v2f
			{
				float4 grabPos : TEXCOORD0;
				float4 pos : SV_POSITION;
			};

			v2f vert(appdata_base v) {
				v2f o;
				// use UnityObjectToClipPos from UnityCG.cginc to calculate
				// the clip-space of the vertex
				o.pos = UnityObjectToClipPos(v.vertex);
				// use ComputeGrabScreenPos function from UnityCG.cginc
				// to get the correct texture coordinate
				o.grabPos = ComputeGrabScreenPos(o.pos);
				return o;
			}

			sampler2D _BackgroundTexture;

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 bgCol = tex2Dproj(_BackgroundTexture, i.grabPos);

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