 Shader "MobileTerrain/6SplatNTerrain" {
    Properties {
      _Color ("Color",Color) = (1,1,1,1)
      
      [NoScaleOffset] _MainTex ("Splatmap 1-4", 2D) = "white" {}
      [NoScaleOffset] _MainTex2 ("Splatmap 4-8", 2D) = "white" {}
      
      [NoScaleOffset] _Splat1 ("Splat Texture 1", 2D) = "white" {}
      [NoScaleOffset] _Splat2 ("Splat Texture 2", 2D) = "white" {}
      [NoScaleOffset] _Splat3 ("Splat Texture 3", 2D) = "white" {}
      [NoScaleOffset] _Splat4 ("Splat Texture 4", 2D) = "white" {}
      [NoScaleOffset] _Splat5 ("Splat Texture 5", 2D) = "white" {}
      [NoScaleOffset] _Splat6 ("Splat Texture 6", 2D) = "white" {}
     
	  _NormalStrength("Normal Strength",Range(0,1)) = 1
	  [NoScaleOffset] _Normal1("Splat Normal Texture 1", 2D) = "white" {}
	  [NoScaleOffset] _Normal2("Splat Normal Texture 2", 2D) = "white" {}
	  [NoScaleOffset] _Normal3("Splat Normal Texture 3", 2D) = "white" {}
	  [NoScaleOffset] _Normal4("Splat Normal Texture 4", 2D) = "white" {}
	  [NoScaleOffset] _Normal5("Splat Normal Texture 5", 2D) = "white" {}
	  [NoScaleOffset] _Normal6("Splat Normal Texture 6", 2D) = "white" {}
	  
      _Splat1Size ("Splat Texture 1 Tiling",float) = 50
      _Splat2Size ("Splat Texture 2 Tiling",float) = 50
      _Splat3Size ("Splat Texture 3 Tiling",float) = 50
      _Splat4Size ("Splat Texture 4 Tiling",float) = 50
      _Splat5Size ("Splat Texture 5 Tiling",float) = 50
      _Splat6Size ("Splat Texture 6 Tiling",float) = 50
    }
    SubShader {
      Tags { "RenderType" = "Opaque" }
      CGPROGRAM
      #pragma surface surf Lambert vertex:vert 
      // #pragma target 5.0
     
      sampler2D _MainTex;
      sampler2D _MainTex2; 
	  sampler2D _Splat1, _Splat2, _Splat3, _Splat4, _Splat5, _Splat6;

	  sampler2D _Normal1, _Normal2, _Normal3, _Normal4, _Normal5, _Normal6;
      
	  half _Splat1Size, _Splat2Size, _Splat3Size, _Splat4Size, _Splat5Size, _Splat6Size;
      half3 _Color;
	  half _NormalStrength;
      
      struct Input {
        half2 uv_MainTex;
        half3 wNormal; 
      };
      
      void vert (inout appdata_full v, out Input o) {
          UNITY_INITIALIZE_OUTPUT(Input,o);
          o.wNormal = v.normal;
      }
      
      void surf (Input IN, inout SurfaceOutput o) {
      	half4 splatmap = tex2D (_MainTex, IN.uv_MainTex); 
      	half4 splatmap2 = tex2D (_MainTex2, IN.uv_MainTex);
        o.Albedo = (tex2D (_Splat1,IN.uv_MainTex*_Splat1Size)*splatmap.r)+(tex2D (_Splat2,IN.uv_MainTex*_Splat2Size)*splatmap.g)+(tex2D (_Splat3,IN.uv_MainTex*_Splat3Size)*splatmap.b)+(tex2D (_Splat4,IN.uv_MainTex*_Splat4Size)*splatmap.a);
		o.Albedo += (tex2D(_Splat5, IN.uv_MainTex*_Splat5Size)*splatmap2.r) + (tex2D(_Splat6, IN.uv_MainTex*_Splat6Size)*splatmap2.g);// +(tex2D(_Splat7, IN.uv_MainTex*_Splat7Size)*splatmap2.b);// +(tex2D(_Splat8, IN.uv_MainTex*_Splat8Size)*splatmap2.a);
        
        o.Albedo *= _Color*4;

		o.Normal = UnpackNormal(tex2D(_Normal1, IN.uv_MainTex*_Splat1Size))*splatmap.r + UnpackNormal(tex2D(_Normal2, IN.uv_MainTex*_Splat2Size))*splatmap.g + UnpackNormal(tex2D(_Normal3, IN.uv_MainTex*_Splat3Size))*splatmap.b + UnpackNormal(tex2D(_Normal4, IN.uv_MainTex*_Splat4Size))*splatmap.a;
		o.Normal += UnpackNormal(tex2D(_Normal5, IN.uv_MainTex*_Splat5Size))*splatmap2.r + UnpackNormal(tex2D(_Normal6, IN.uv_MainTex*_Splat6Size))*splatmap2.g;// +UnpackNormal(tex2D(_Normal7, IN.uv_MainTex*_Splat7Size))*splatmap2.b;// +UnpackNormal(tex2D(_Normal8, IN.uv_MainTex*_Splat8Size))*splatmap2.a;
		
		o.Normal = lerp(half3(0, 0, 1), o.Normal, _NormalStrength);
		o.Normal = normalize(half3(IN.wNormal.xz + o.Normal.xy, IN.wNormal.y*o.Normal.z));
      }
      ENDCG
    } 
    // Fallback "Diffuse"
  }