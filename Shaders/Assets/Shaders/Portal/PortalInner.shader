Shader "Daniel/Spyro/PortalInner"
{
    Properties
    {
        [Header(Background)]
        _MainTex("Portal Skybox Texture", 2D) = "white" {}
        _Color("Portal Skybox Tint", Color) = (1,1,1,1)

        [Header(Distortion)]
        _DistortTex("Distortion Texture", 2D) = "white" {}
        _DistortAmount("Distortion Amount", float) = 1
        _DistortScrollSpeed("Distortion Speed", float) = -1

        [Header(Edge)]
        [HDR]_EdgeColor("Edge Colour", Color) = (1,1,1,1)
        _DepthFactor("Edge Depth", float) = 1.0
        _EdgeStrength("Edge Strength", float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Transparent" }

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows vertex:vert
        #pragma target 3.5

        sampler2D _MainTex;
        fixed4 _Color;

        sampler2D _DistortTex;
        float4 _DistortTex_ST;
        float _DistortAmount;
        float _DistortScrollSpeed;

        float4 _EdgeColor;
        float _EdgeStrength;
        float _DepthFactor;

        sampler2D _CameraDepthTexture;

        struct Input
        {
            float4 vertex;

            float2 uv_MainTex;
            
            float2 uv_Skybox;
            float2 uv_DistortTex;
            float2 distortUV;
            float2 distortUV2;


            float4 color;

            float3 viewDir;
            float3 worldPos;

            float4 screenPos;
            float eyeDepth;

            float2 screenUV;
            float depth;
        };

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);

            o.vertex = UnityObjectToClipPos(v.vertex);
            o.screenPos = ComputeScreenPos(o.vertex);

            o.screenPos.y = 1 - o.screenPos.y;

            o.depth = -mul(UNITY_MATRIX_MV, v.vertex).z * 1.0;

            o.distortUV = TRANSFORM_TEX(v.texcoord, _DistortTex);
            o.distortUV.y += _DistortScrollSpeed * _Time.x;

            o.distortUV2 = TRANSFORM_TEX(v.texcoord, _DistortTex);
            o.distortUV2.x += _DistortScrollSpeed * _Time.x;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 distort = UnpackNormal(tex2D(_DistortTex, IN.distortUV)).xy;
            distort *= _DistortAmount;

            float2 distort2 = UnpackNormal(tex2D(_DistortTex, IN.distortUV2)).xy;
            distort2 *= _DistortAmount;

            distort += distort2;

            IN.uv_MainTex.xy += distort * IN.uv_MainTex;

            float sceneZ = LinearEyeDepth(
                SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(IN.screenPos)));
            float surfZ = -mul(UNITY_MATRIX_V, float4(IN.worldPos.xyz, 1)).z;
            float diff = sceneZ - surfZ;
            float intersect = 1 - saturate(diff / _DepthFactor);
            float4 interCol = intersect * _EdgeStrength * _EdgeColor;

            fixed4 textureSample = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            fixed4 col = fixed4(lerp(textureSample * _Color, interCol, pow(intersect, 4)));

            o.Albedo = col;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
