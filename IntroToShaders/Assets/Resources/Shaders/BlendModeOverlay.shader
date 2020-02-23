// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/BlendModeOverlay" {
    Properties{
        _MainTex("Texture", 2D) = "defaulttexture" {} //name ("display name", 2D) = "defaulttexture" {}
		_Color("Color", Color) = (1,1,1,0.5)
    }
     
    SubShader{
		// Tags are used to tell how/when this subshader should expect to be rendered to the rendering engine 
		// https://docs.unity3d.com/Manual/SL-SubShaderTags.html
		Tags{ "RenderType" = "Transparent" "Queue" = "Transparent" }

		// Enable alpha blending
		Blend SrcAlpha OneMinusSrcAlpha

		GrabPass
        {
            "_BackgroundTexture"
        }
          
		Pass{
			CGPROGRAM
     
			#pragma vertex vert
			#pragma fragment frag
     
			#include "UnityCG.cginc"
     
			sampler2D _MainTex;
			sampler2D _BackgroundTexture;
			fixed4 _Color;
     
			struct v2f {
				float2 uv : TEXCOORD1;
				float4 grabPos : TEXCOORD0;
				float4 pos : SV_POSITION;
			};
     
			float4 _MainTex_ST; // Get the current texture coordinates of brush sprite in 4d (x,y,z,w)
			//The x,y contains texture scale, and z,w contains translation (offset)
     
			v2f vert(appdata_base v) 
			{
				v2f o;
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.pos = UnityObjectToClipPos(v.vertex);
				o.grabPos = ComputeGrabScreenPos(o.pos);
				return o;
			}
     
			half4 frag(v2f i) : COLOR
			{
				fixed fgalpha = _Color.a * tex2D(_MainTex, i.uv).a;
				fixed4 fgcol = fixed4(_Color.r, _Color.g, _Color.b, fgalpha);
				fixed4 bgcol = tex2D(_BackgroundTexture, i.grabPos);

				fixed3 finalcol;
				float bgLuminance = (0.2126*bgcol.r) + (0.7152*bgcol.g) + (0.0722*bgcol.b); // via https://stackoverflow.com/a/24213274/1757149
				
				// Overlay formula via http://www.simplefilter.de/en/basics/mixmods.html
				if(bgLuminance <= 0.5){ // If the background is darker than 50% gray
					finalcol = 2 * fgcol * bgcol; // Multiply
				} else {
					finalcol = 1 - 2*(1 - bgcol) * (1 - fgcol); // Screen
				}

				return fixed4(finalcol, fgalpha);
			}
     
			ENDCG
		}
    }
}
