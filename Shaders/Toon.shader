Shader "CMPM163/Toon"
{
	Properties
	{
		_Color("Color", Color) = (1, 1, 1, 1) //The color of our object
		_Shininess("Shininess", Float) = 32 //Shininess
		_SpecColor("Specular Color", Color) = (1, 1, 1, 1) //Specular highlights color
		_StepVal("Steps", Float) = 0.2
	}

	SubShader {
		Pass{				
			Tags{ "LightMode" = "ForwardAdd"} 
			
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"


				uniform float4 _LightColor0; //From UnityCG
				uniform float4 _Color;
				uniform float4 _SpecColor;
				uniform float _Shininess;
				uniform float _StepVal;

				struct vertexInput {
					float4 vertex : POSITION;
					float3 normal : NORMAL;
				};

				struct vertexOutput {
					float4 vertex : SV_POSITION;
					float3 normalInWorldCoords : NORMAL;
					float3 vertexInWorldCoords : TEXCOORD1;
				};


				vertexOutput vert(vertexInput v) {
					vertexOutput o;
					o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex); //Vertex position in WORLD coords
					o.normalInWorldCoords = UnityObjectToWorldNormal(v.normal); //Normal in WORLD coords
					o.vertex = UnityObjectToClipPos(v.vertex);

					return o;
				}

				fixed4 frag(vertexOutput i) : SV_Target {

					float3 P = i.vertexInWorldCoords.xyz;
					float3 N = normalize(i.normalInWorldCoords);
					float3 V = normalize(_WorldSpaceCameraPos - P);
					float3 L = normalize(_WorldSpaceLightPos0.xyz - P);
					float3 H = normalize(L + V);

					float3 Kd = _Color.rgb; //Color of object
					float3 Ka = UNITY_LIGHTMODEL_AMBIENT.rgb; //Ambient light
	
					float3 Ks = _SpecColor.rgb; //Color of specular highlighting
					float3 Kl = _LightColor0.rgb; //Color of light


					const float A = 0.3; //0.5;
					const float B = 0.6; //1.0;
					const float C = 0.9;


					//AMBIENT LIGHT 
					float3 ambient = Ka;



					//DIFFUSE LIGHT
					float diffuseVal = max(dot(N, L), 0);
					float lightIntensity = diffuseVal;


		
					//Cel shading
					if (diffuseVal < A) diffuseVal = A;
					else if (diffuseVal < B) diffuseVal = B;
					else if (diffuseVal < C) diffuseVal = C;
					else diffuseVal = 1.0;
					lightIntensity = diffuseVal;
		

	
					float3 diffuse = Kd * Kl * lightIntensity;


					//SPECULAR LIGHT
					float specularVal = pow(max(dot(N,H), 0), _Shininess);

					if (diffuseVal <= 0) {
						specularVal = 0;
					}

					specularVal = smoothstep(0.25, 0.25 + _StepVal, specularVal);
					float3 specular = Ks * Kl * specularVal;

					//FINAL COLOR OF FRAGMENT
					return float4(ambient + diffuse + specular, 1.0);


				}

				ENDCG


			}

		}
}
