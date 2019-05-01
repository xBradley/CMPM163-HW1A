Shader "CMPM163/TexturedSpecular" {
    Properties {
		_Texture("Texture", 2D) = "white" {}
		_SpecColor("Specular Color", Color) = (1,1,1,1)
		_Shininess("Shininess", Range(0,1)) = 0.5
	}
    SubShader {
		Tags { "RenderType" = "Opaque" }
		LOD 300

		Pass {
			Tags{ "LightMode" = "ForwardAdd"}
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			uniform sampler2D _Texture;
			uniform float4 _LightColor0;
			uniform float4 _SpecColor;
			uniform float _Shininess;
			float4 _Texture_ST;

			float3x3 getRotationMatrixY(float theta) {
				float s = -sin(theta);
				float c = cos(theta);
				return float3x3(c, 0, s, 0, 1, 0, -s, 0, c);
			}

			struct vertexInput {
				float4 vertex : POSITION;
				float3 normal: NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct vertexOutput {
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float timeVal : Float;
			};

			vertexOutput vert(vertexInput v) {
				vertexOutput o;

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.uv = TRANSFORM_TEX(v.uv, _Texture);
				
				return o;
			}


			fixed4 frag(vertexOutput i) : SV_Target {

				i.normal = normalize(i.normal);

				float3 P = i.worldPos.xyz;
				float3 N = i.normal;

				
				float3 L = _WorldSpaceLightPos0.xyz;
				float3 V = _WorldSpaceCameraPos - P;
				float3 H = normalize(L + V);

				
				float3 Ks = _SpecColor.rgb;
				float3 Kl = _LightColor0.rgb;

				float specVal = pow(max(dot(N, H), 0), _Shininess);
				float3 specular = Ks * Kl * specVal;
				
				fixed4 col = tex2D(_Texture, i.uv);
				
				return col + float4(specular, 1.0);
			}
			
			ENDCG
		}

	}
}
