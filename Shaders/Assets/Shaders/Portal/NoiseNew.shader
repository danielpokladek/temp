Shader "Daniel/Other/NoiseNew"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        _NoiseTex("Noise Texture", 2D) = "white" {}
        _NoiseTex2("Noise Texture 2", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma vertex vert
        #pragma target 3.5

        sampler2D _MainTex;
        sampler2D _NoiseTex;
        sampler2D _NoiseTex2;
        float4 _NoiseTex_ST;

        struct Input
        {
            float2 uv_MainTex;

            float2 uv_NoiseTex;
            float2 uv_NoiseTex2;

            float2 bigNoiseUV;
            float2 bigNoiseUV2;
            float2 combined;
        };

        float4 _Color;

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);

            o.bigNoiseUV = TRANSFORM_TEX(v.texcoord, _NoiseTex) * .25;
            o.bigNoiseUV -= (_Time.x * 0.25) - o.uv_NoiseTex;

            o.bigNoiseUV2 = TRANSFORM_TEX(v.texcoord, _NoiseTex) * .25;
            o.bigNoiseUV2 += (_Time.x * 0.25) - o.uv_NoiseTex;

            o.combined = o.bigNoiseUV + o.bigNoiseUV2;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float4 tex = tex2D(_MainTex, IN.uv_MainTex);

            float4 ogNoise = tex2D(_NoiseTex, IN.uv_NoiseTex2);
            float4 noise1 = tex2D(_NoiseTex, IN.bigNoiseUV);
            float4 noise2 = tex2D(_NoiseTex, IN.bigNoiseUV2);

            float4 combinedNoise = (noise1 + noise2) * 0.5;
            float4 almostFinal = (ogNoise + combinedNoise) * 0.5;

            float4 overlayed = tex2D(_NoiseTex, almostFinal);
            float4 final = (overlayed * combinedNoise) * 1.5;

            fixed3 col = tex - final;

            o.Albedo = col;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
