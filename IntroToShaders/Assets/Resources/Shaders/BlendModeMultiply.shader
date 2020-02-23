// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/BlendModeMultiply" {
    Properties{
		//name ("display name", 2D) = "defaulttexture" {}
        _MainTex("Texture", 2D) = "defaulttexture" {}
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
				//float4 vertex : POSITION;
				
				float2 uv : TEXCOORD1;
				float4 grabPos : TEXCOORD0;
				float4 pos : SV_POSITION;
			};
     
			float4 _MainTex_ST; // Get the current texture coordinates of brush sprite in 4d (x,y,z,w)
			//The x,y contains texture scale, and z,w contains translation (offset)
     
			v2f vert(appdata_base v) {
				v2f o;
				//o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.pos = UnityObjectToClipPos(v.vertex);
				o.grabPos = ComputeGrabScreenPos(o.pos);
				return o;
			}
     
			half4 frag(v2f i) : COLOR
			{
				fixed4 texcolAlpha = tex2D (_MainTex, i.uv);
				fixed4 texcol = fixed4(_Color.r, _Color.g, _Color.b, _Color.a * texcolAlpha.a);
				fixed4 bgcol = tex2D(_BackgroundTexture, i.grabPos);
	
				fixed4 multiplied = texcol * bgcol;

				return multiplied;
			}
     
			ENDCG
		}
    }
}
