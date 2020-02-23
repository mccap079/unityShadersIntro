// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/BlendModeScreen" {
    Properties{
		//name ("display name", 2D) = "defaulttexture" {}
        _MainTex("Texture", 2D) = "defaulttexture" {}
		_Color("Color", Color) = (1,1,1,0.5)
    }
     
    SubShader{
		// Tags are used to tell how/when this subshader should expect to be rendered to the rendering engine 
		// https://docs.unity3d.com/Manual/SL-SubShaderTags.html
		Tags{ "RenderType" = "Transparent" "Queue" = "Transparent" }

		Blend SrcAlpha One
          
		Pass{
			CGPROGRAM
     
			#pragma vertex vert
			#pragma fragment frag
     
			#include "UnityCG.cginc"
     
			sampler2D _MainTex;
			fixed4 _Color;
     
			struct v2f {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
     
			float4 _MainTex_ST; // Get the current texture coordinates of brush sprite in 4d (x,y,z,w)
			//The x,y contains texture scale, and z,w contains translation (offset)
     
			v2f vert(appdata_base v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
     
			half4 frag(v2f i) : COLOR
			{
				fixed4 texcol = tex2D (_MainTex, i.uv);

				return half4(_Color.r, _Color.g, _Color.b, _Color.a * texcol.a);
			}
     
			ENDCG
		}
    }
}
