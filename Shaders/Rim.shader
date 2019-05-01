//https://github.com/matinas/shadersfromscratch/blob/master/Assets/Shaders/20.%20HardRim.shader
Shader "CMPM163/Rim" {
	Properties {
		_RimColor("Rim Color", Color) = (0,0.5,0.5,1)
		_RimPower("Rim Power", Range(0.5,10)) = 3.0
		_RimIntensity("Rim Intensity", Range(0.1,10)) = 1.0
		_RimThreshold("Rim Threshold", Range(0.0,0.9)) = 0
	}

	SubShader {

		CGPROGRAM
		#pragma surface surf Lambert

		fixed4 _RimColor;
		float _RimPower, _RimIntensity, _RimThreshold;

		struct Input {
			fixed3 viewDir;
		};

		void surf(Input IN, inout SurfaceOutput o) {
			half rim = 1- saturate(dot(o.Normal,IN.viewDir));

			o.Emission = _RimColor * (rim > _RimThreshold ? pow(rim,_RimPower) : 0) * _RimIntensity;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
