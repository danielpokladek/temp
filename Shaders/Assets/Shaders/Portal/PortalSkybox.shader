﻿Shader "Daniel/Spyro/PortalSkybox"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        Lighting Off
        Cull Front
        LOD 200

        CGPROGRAM
        #pragma surface surf NoLighting vertex:vert
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 LightingNoLighting(SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            fixed4 c;
            c.rgb = s.Albedo;
            c.a = s.Alpha;
            return c;
        }

        void vert(inout appdata_full v)
        {
            v.normal.xyz = v.normal * -1;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb * 0.8;
        }
        ENDCG
    }
    FallBack "Unlit/Texture"
}
