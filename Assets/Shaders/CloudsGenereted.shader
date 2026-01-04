Shader "CloudGenereted"
{
    Properties
    {
        _Rotate_Projection("Rotate Projection", Vector) = (1, 0, 0, 0)
        _Noise_Scale("Noise Scale", Float) = 1
        _Noise_Speed("Noise Speed", Float) = 0.1
        _Noise_Height("Noise Height", Float) = 1
        _Noise_Remap("Noise Remap", Vector) = (0, 1, -1, 1)
        _Color_Peak("Color Peak", Color) = (1, 1, 1, 0)
        _Color_Valley("Color Valley", Color) = (0, 0, 0, 0)
        _Noise_egde_1("Noise egde 1", Float) = 0
        _Noise_edge_2("Noise edge 2", Float) = 1
        _Noise_Power("Noise Power", Float) = 1
        _Base_Scale("Base Scale", Float) = 5
        _Base_Speed("Base Speed", Float) = 1
        _Base_Strenght("Base Strenght", Float) = 0
        _Emmision_Strenght("Emmision Strenght", Float) = 2
        _Curvature_Radius("Curvature Radius", Float) = 1
        _Fresnel_Power("Fresnel Power", Float) = 2
        _FrenselOpacity("FrenselOpacity", Float) = 1
        _Fade_Depth("Fade Depth", Float) = 100
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue"="Transparent"
            "DisableBatching"="False"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalUnlitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                // LightMode: <None>
            }
        
        // Render State
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma shader_feature _ _SAMPLE_GI
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_UNLIT
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
             float3 normalWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Noise_Speed;
        float _Noise_Height;
        float4 _Noise_Remap;
        float4 _Color_Peak;
        float4 _Color_Valley;
        float _Noise_egde_1;
        float _Noise_edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Base_Speed;
        float _Base_Strenght;
        float _Emmision_Strenght;
        float _Curvature_Radius;
        float _Fresnel_Power;
        float _FrenselOpacity;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float);
            float _Property_0ce616d0ca0c457c8456d3015b06b9db_Out_0_Float = _Curvature_Radius;
            float _Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float;
            Unity_Divide_float(_Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float, _Property_0ce616d0ca0c457c8456d3015b06b9db_Out_0_Float, _Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float);
            float _Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float;
            Unity_Power_float(_Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float, float(3), _Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float);
            float3 _Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float.xxx), _Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3);
            float _Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float = _Noise_egde_1;
            float _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float = _Noise_edge_2;
            float4 _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4 = _Rotate_Projection;
            float _Split_96447af7694c48dda519bfc5db262513_R_1_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[0];
            float _Split_96447af7694c48dda519bfc5db262513_G_2_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[1];
            float _Split_96447af7694c48dda519bfc5db262513_B_3_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[2];
            float _Split_96447af7694c48dda519bfc5db262513_A_4_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[3];
            float3 _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4.xyz), _Split_96447af7694c48dda519bfc5db262513_A_4_Float, _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3);
            float _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float = _Noise_Speed;
            float _Multiply_344384a91f4a493a9688557729416887_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float, _Multiply_344384a91f4a493a9688557729416887_Out_2_Float);
            float2 _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_344384a91f4a493a9688557729416887_Out_2_Float.xx), _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2);
            float _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float = _Noise_Scale;
            float _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float);
            float2 _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2);
            float _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float);
            float _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float;
            Unity_Add_float(_GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float, _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float);
            float _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float;
            Unity_Divide_float(_Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float, float(2), _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float);
            float _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float;
            Unity_Saturate_float(_Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float, _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float);
            float _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float = _Noise_Power;
            float _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float;
            Unity_Power_float(_Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float, _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float, _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float);
            float4 _Property_062c88217e21495993819b1283de5996_Out_0_Vector4 = _Noise_Remap;
            float _Split_10a48c3e20374baca2339a6864cc7239_R_1_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[0];
            float _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[1];
            float _Split_10a48c3e20374baca2339a6864cc7239_B_3_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[2];
            float _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[3];
            float4 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4;
            float3 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3;
            float2 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_R_1_Float, _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float, float(0), float(0), _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2);
            float4 _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4;
            float3 _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3;
            float2 _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_B_3_Float, _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float, float(0), float(0), _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4, _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2);
            float _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float;
            Unity_Remap_float(_Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2, _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float);
            float _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float;
            Unity_Absolute_float(_Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float);
            float _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float;
            Unity_Smoothstep_float(_Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float, _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float, _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float);
            float _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float = _Base_Speed;
            float _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float, _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float);
            float2 _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float.xx), _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2);
            float _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float = _Base_Scale;
            float _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2, _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float, _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float);
            float _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float = _Base_Strenght;
            float _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float, _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float);
            float _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float;
            Unity_Add_float(_Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float, _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float);
            float _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float;
            Unity_Add_float(float(1), _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float);
            float _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float;
            Unity_Divide_float(_Add_b109669985f848f487a0dd38a9421be2_Out_2_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float, _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float);
            float3 _Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float.xxx), _Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3);
            float _Property_1678667631e2404b948823a2a19e8511_Out_0_Float = _Noise_Height;
            float3 _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3, (_Property_1678667631e2404b948823a2a19e8511_Out_0_Float.xxx), _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3);
            float3 _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3, _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3);
            float3 _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3;
            Unity_Add_float3(_Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3, _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3, _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3);
            description.Position = _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_cd893287511d4118b9d44e315a046048_Out_0_Vector4 = _Color_Valley;
            float4 _Property_78c7ae34f64a4d8b8d053036ede212b8_Out_0_Vector4 = _Color_Peak;
            float _Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float = _Noise_egde_1;
            float _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float = _Noise_edge_2;
            float4 _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4 = _Rotate_Projection;
            float _Split_96447af7694c48dda519bfc5db262513_R_1_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[0];
            float _Split_96447af7694c48dda519bfc5db262513_G_2_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[1];
            float _Split_96447af7694c48dda519bfc5db262513_B_3_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[2];
            float _Split_96447af7694c48dda519bfc5db262513_A_4_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[3];
            float3 _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4.xyz), _Split_96447af7694c48dda519bfc5db262513_A_4_Float, _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3);
            float _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float = _Noise_Speed;
            float _Multiply_344384a91f4a493a9688557729416887_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float, _Multiply_344384a91f4a493a9688557729416887_Out_2_Float);
            float2 _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_344384a91f4a493a9688557729416887_Out_2_Float.xx), _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2);
            float _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float = _Noise_Scale;
            float _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float);
            float2 _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2);
            float _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float);
            float _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float;
            Unity_Add_float(_GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float, _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float);
            float _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float;
            Unity_Divide_float(_Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float, float(2), _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float);
            float _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float;
            Unity_Saturate_float(_Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float, _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float);
            float _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float = _Noise_Power;
            float _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float;
            Unity_Power_float(_Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float, _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float, _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float);
            float4 _Property_062c88217e21495993819b1283de5996_Out_0_Vector4 = _Noise_Remap;
            float _Split_10a48c3e20374baca2339a6864cc7239_R_1_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[0];
            float _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[1];
            float _Split_10a48c3e20374baca2339a6864cc7239_B_3_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[2];
            float _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[3];
            float4 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4;
            float3 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3;
            float2 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_R_1_Float, _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float, float(0), float(0), _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2);
            float4 _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4;
            float3 _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3;
            float2 _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_B_3_Float, _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float, float(0), float(0), _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4, _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2);
            float _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float;
            Unity_Remap_float(_Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2, _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float);
            float _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float;
            Unity_Absolute_float(_Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float);
            float _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float;
            Unity_Smoothstep_float(_Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float, _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float, _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float);
            float _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float = _Base_Speed;
            float _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float, _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float);
            float2 _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float.xx), _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2);
            float _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float = _Base_Scale;
            float _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2, _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float, _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float);
            float _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float = _Base_Strenght;
            float _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float, _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float);
            float _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float;
            Unity_Add_float(_Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float, _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float);
            float _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float;
            Unity_Add_float(float(1), _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float);
            float _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float;
            Unity_Divide_float(_Add_b109669985f848f487a0dd38a9421be2_Out_2_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float, _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float);
            float4 _Lerp_4090d82a4dc543adb198ac95e3cdd705_Out_3_Vector4;
            Unity_Lerp_float4(_Property_cd893287511d4118b9d44e315a046048_Out_0_Vector4, _Property_78c7ae34f64a4d8b8d053036ede212b8_Out_0_Vector4, (_Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float.xxxx), _Lerp_4090d82a4dc543adb198ac95e3cdd705_Out_3_Vector4);
            float _Property_75a490a070f34bafa1845ee47423c5c1_Out_0_Float = _Fresnel_Power;
            float _FresnelEffect_0e41833cbb1e4580aea61b7d6702ae45_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_75a490a070f34bafa1845ee47423c5c1_Out_0_Float, _FresnelEffect_0e41833cbb1e4580aea61b7d6702ae45_Out_3_Float);
            float _Multiply_bda9335a7d344c6993716e390ed8e4ed_Out_2_Float;
            Unity_Multiply_float_float(_Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float, _FresnelEffect_0e41833cbb1e4580aea61b7d6702ae45_Out_3_Float, _Multiply_bda9335a7d344c6993716e390ed8e4ed_Out_2_Float);
            float _Property_717ba187ade246b392a6efd4df013a1c_Out_0_Float = _FrenselOpacity;
            float _Multiply_1e98a2564ce4440fabd73dc21ccf282d_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_bda9335a7d344c6993716e390ed8e4ed_Out_2_Float, _Property_717ba187ade246b392a6efd4df013a1c_Out_0_Float, _Multiply_1e98a2564ce4440fabd73dc21ccf282d_Out_2_Float);
            float4 _Add_8e88b06ab85e4daeb32c624835cda120_Out_2_Vector4;
            Unity_Add_float4(_Lerp_4090d82a4dc543adb198ac95e3cdd705_Out_3_Vector4, (_Multiply_1e98a2564ce4440fabd73dc21ccf282d_Out_2_Float.xxxx), _Add_8e88b06ab85e4daeb32c624835cda120_Out_2_Vector4);
            float _SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float);
            float4 _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_275ad52e843942b49d76a58decbed093_R_1_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[0];
            float _Split_275ad52e843942b49d76a58decbed093_G_2_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[1];
            float _Split_275ad52e843942b49d76a58decbed093_B_3_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[2];
            float _Split_275ad52e843942b49d76a58decbed093_A_4_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[3];
            float _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float;
            Unity_Subtract_float(_Split_275ad52e843942b49d76a58decbed093_A_4_Float, float(1), _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float);
            float _Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float, _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float, _Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float);
            float _Property_a8180489db804f679d140893d579b48e_Out_0_Float = _Fade_Depth;
            float _Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float;
            Unity_Divide_float(_Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float, _Property_a8180489db804f679d140893d579b48e_Out_0_Float, _Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float);
            float _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float;
            Unity_Saturate_float(_Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float, _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float);
            surface.BaseColor = (_Add_8e88b06ab85e4daeb32c624835cda120_Out_2_Vector4.xyz);
            surface.Alpha = _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "MotionVectors"
            Tags
            {
                "LightMode" = "MotionVectors"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        ColorMask RG
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.5
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_MOTION_VECTORS
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Noise_Speed;
        float _Noise_Height;
        float4 _Noise_Remap;
        float4 _Color_Peak;
        float4 _Color_Valley;
        float _Noise_egde_1;
        float _Noise_edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Base_Speed;
        float _Base_Strenght;
        float _Emmision_Strenght;
        float _Curvature_Radius;
        float _Fresnel_Power;
        float _FrenselOpacity;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float);
            float _Property_0ce616d0ca0c457c8456d3015b06b9db_Out_0_Float = _Curvature_Radius;
            float _Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float;
            Unity_Divide_float(_Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float, _Property_0ce616d0ca0c457c8456d3015b06b9db_Out_0_Float, _Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float);
            float _Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float;
            Unity_Power_float(_Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float, float(3), _Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float);
            float3 _Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float.xxx), _Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3);
            float _Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float = _Noise_egde_1;
            float _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float = _Noise_edge_2;
            float4 _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4 = _Rotate_Projection;
            float _Split_96447af7694c48dda519bfc5db262513_R_1_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[0];
            float _Split_96447af7694c48dda519bfc5db262513_G_2_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[1];
            float _Split_96447af7694c48dda519bfc5db262513_B_3_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[2];
            float _Split_96447af7694c48dda519bfc5db262513_A_4_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[3];
            float3 _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4.xyz), _Split_96447af7694c48dda519bfc5db262513_A_4_Float, _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3);
            float _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float = _Noise_Speed;
            float _Multiply_344384a91f4a493a9688557729416887_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float, _Multiply_344384a91f4a493a9688557729416887_Out_2_Float);
            float2 _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_344384a91f4a493a9688557729416887_Out_2_Float.xx), _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2);
            float _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float = _Noise_Scale;
            float _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float);
            float2 _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2);
            float _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float);
            float _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float;
            Unity_Add_float(_GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float, _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float);
            float _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float;
            Unity_Divide_float(_Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float, float(2), _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float);
            float _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float;
            Unity_Saturate_float(_Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float, _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float);
            float _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float = _Noise_Power;
            float _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float;
            Unity_Power_float(_Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float, _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float, _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float);
            float4 _Property_062c88217e21495993819b1283de5996_Out_0_Vector4 = _Noise_Remap;
            float _Split_10a48c3e20374baca2339a6864cc7239_R_1_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[0];
            float _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[1];
            float _Split_10a48c3e20374baca2339a6864cc7239_B_3_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[2];
            float _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[3];
            float4 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4;
            float3 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3;
            float2 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_R_1_Float, _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float, float(0), float(0), _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2);
            float4 _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4;
            float3 _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3;
            float2 _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_B_3_Float, _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float, float(0), float(0), _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4, _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2);
            float _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float;
            Unity_Remap_float(_Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2, _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float);
            float _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float;
            Unity_Absolute_float(_Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float);
            float _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float;
            Unity_Smoothstep_float(_Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float, _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float, _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float);
            float _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float = _Base_Speed;
            float _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float, _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float);
            float2 _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float.xx), _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2);
            float _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float = _Base_Scale;
            float _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2, _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float, _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float);
            float _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float = _Base_Strenght;
            float _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float, _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float);
            float _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float;
            Unity_Add_float(_Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float, _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float);
            float _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float;
            Unity_Add_float(float(1), _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float);
            float _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float;
            Unity_Divide_float(_Add_b109669985f848f487a0dd38a9421be2_Out_2_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float, _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float);
            float3 _Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float.xxx), _Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3);
            float _Property_1678667631e2404b948823a2a19e8511_Out_0_Float = _Noise_Height;
            float3 _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3, (_Property_1678667631e2404b948823a2a19e8511_Out_0_Float.xxx), _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3);
            float3 _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3, _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3);
            float3 _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3;
            Unity_Add_float3(_Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3, _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3, _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3);
            description.Position = _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float);
            float4 _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_275ad52e843942b49d76a58decbed093_R_1_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[0];
            float _Split_275ad52e843942b49d76a58decbed093_G_2_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[1];
            float _Split_275ad52e843942b49d76a58decbed093_B_3_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[2];
            float _Split_275ad52e843942b49d76a58decbed093_A_4_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[3];
            float _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float;
            Unity_Subtract_float(_Split_275ad52e843942b49d76a58decbed093_A_4_Float, float(1), _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float);
            float _Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float, _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float, _Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float);
            float _Property_a8180489db804f679d140893d579b48e_Out_0_Float = _Fade_Depth;
            float _Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float;
            Unity_Divide_float(_Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float, _Property_a8180489db804f679d140893d579b48e_Out_0_Float, _Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float);
            float _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float;
            Unity_Saturate_float(_Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float, _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float);
            surface.Alpha = _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/MotionVectorPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormalsOnly"
            Tags
            {
                "LightMode" = "DepthNormalsOnly"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
             float3 normalWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Noise_Speed;
        float _Noise_Height;
        float4 _Noise_Remap;
        float4 _Color_Peak;
        float4 _Color_Valley;
        float _Noise_egde_1;
        float _Noise_edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Base_Speed;
        float _Base_Strenght;
        float _Emmision_Strenght;
        float _Curvature_Radius;
        float _Fresnel_Power;
        float _FrenselOpacity;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float);
            float _Property_0ce616d0ca0c457c8456d3015b06b9db_Out_0_Float = _Curvature_Radius;
            float _Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float;
            Unity_Divide_float(_Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float, _Property_0ce616d0ca0c457c8456d3015b06b9db_Out_0_Float, _Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float);
            float _Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float;
            Unity_Power_float(_Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float, float(3), _Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float);
            float3 _Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float.xxx), _Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3);
            float _Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float = _Noise_egde_1;
            float _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float = _Noise_edge_2;
            float4 _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4 = _Rotate_Projection;
            float _Split_96447af7694c48dda519bfc5db262513_R_1_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[0];
            float _Split_96447af7694c48dda519bfc5db262513_G_2_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[1];
            float _Split_96447af7694c48dda519bfc5db262513_B_3_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[2];
            float _Split_96447af7694c48dda519bfc5db262513_A_4_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[3];
            float3 _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4.xyz), _Split_96447af7694c48dda519bfc5db262513_A_4_Float, _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3);
            float _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float = _Noise_Speed;
            float _Multiply_344384a91f4a493a9688557729416887_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float, _Multiply_344384a91f4a493a9688557729416887_Out_2_Float);
            float2 _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_344384a91f4a493a9688557729416887_Out_2_Float.xx), _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2);
            float _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float = _Noise_Scale;
            float _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float);
            float2 _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2);
            float _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float);
            float _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float;
            Unity_Add_float(_GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float, _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float);
            float _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float;
            Unity_Divide_float(_Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float, float(2), _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float);
            float _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float;
            Unity_Saturate_float(_Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float, _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float);
            float _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float = _Noise_Power;
            float _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float;
            Unity_Power_float(_Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float, _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float, _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float);
            float4 _Property_062c88217e21495993819b1283de5996_Out_0_Vector4 = _Noise_Remap;
            float _Split_10a48c3e20374baca2339a6864cc7239_R_1_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[0];
            float _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[1];
            float _Split_10a48c3e20374baca2339a6864cc7239_B_3_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[2];
            float _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[3];
            float4 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4;
            float3 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3;
            float2 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_R_1_Float, _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float, float(0), float(0), _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2);
            float4 _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4;
            float3 _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3;
            float2 _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_B_3_Float, _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float, float(0), float(0), _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4, _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2);
            float _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float;
            Unity_Remap_float(_Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2, _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float);
            float _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float;
            Unity_Absolute_float(_Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float);
            float _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float;
            Unity_Smoothstep_float(_Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float, _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float, _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float);
            float _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float = _Base_Speed;
            float _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float, _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float);
            float2 _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float.xx), _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2);
            float _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float = _Base_Scale;
            float _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2, _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float, _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float);
            float _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float = _Base_Strenght;
            float _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float, _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float);
            float _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float;
            Unity_Add_float(_Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float, _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float);
            float _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float;
            Unity_Add_float(float(1), _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float);
            float _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float;
            Unity_Divide_float(_Add_b109669985f848f487a0dd38a9421be2_Out_2_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float, _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float);
            float3 _Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float.xxx), _Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3);
            float _Property_1678667631e2404b948823a2a19e8511_Out_0_Float = _Noise_Height;
            float3 _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3, (_Property_1678667631e2404b948823a2a19e8511_Out_0_Float.xxx), _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3);
            float3 _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3, _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3);
            float3 _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3;
            Unity_Add_float3(_Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3, _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3, _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3);
            description.Position = _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float);
            float4 _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_275ad52e843942b49d76a58decbed093_R_1_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[0];
            float _Split_275ad52e843942b49d76a58decbed093_G_2_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[1];
            float _Split_275ad52e843942b49d76a58decbed093_B_3_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[2];
            float _Split_275ad52e843942b49d76a58decbed093_A_4_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[3];
            float _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float;
            Unity_Subtract_float(_Split_275ad52e843942b49d76a58decbed093_A_4_Float, float(1), _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float);
            float _Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float, _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float, _Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float);
            float _Property_a8180489db804f679d140893d579b48e_Out_0_Float = _Fade_Depth;
            float _Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float;
            Unity_Divide_float(_Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float, _Property_a8180489db804f679d140893d579b48e_Out_0_Float, _Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float);
            float _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float;
            Unity_Saturate_float(_Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float, _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float);
            surface.Alpha = _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
             float3 normalWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Noise_Speed;
        float _Noise_Height;
        float4 _Noise_Remap;
        float4 _Color_Peak;
        float4 _Color_Valley;
        float _Noise_egde_1;
        float _Noise_edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Base_Speed;
        float _Base_Strenght;
        float _Emmision_Strenght;
        float _Curvature_Radius;
        float _Fresnel_Power;
        float _FrenselOpacity;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float);
            float _Property_0ce616d0ca0c457c8456d3015b06b9db_Out_0_Float = _Curvature_Radius;
            float _Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float;
            Unity_Divide_float(_Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float, _Property_0ce616d0ca0c457c8456d3015b06b9db_Out_0_Float, _Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float);
            float _Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float;
            Unity_Power_float(_Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float, float(3), _Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float);
            float3 _Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float.xxx), _Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3);
            float _Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float = _Noise_egde_1;
            float _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float = _Noise_edge_2;
            float4 _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4 = _Rotate_Projection;
            float _Split_96447af7694c48dda519bfc5db262513_R_1_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[0];
            float _Split_96447af7694c48dda519bfc5db262513_G_2_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[1];
            float _Split_96447af7694c48dda519bfc5db262513_B_3_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[2];
            float _Split_96447af7694c48dda519bfc5db262513_A_4_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[3];
            float3 _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4.xyz), _Split_96447af7694c48dda519bfc5db262513_A_4_Float, _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3);
            float _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float = _Noise_Speed;
            float _Multiply_344384a91f4a493a9688557729416887_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float, _Multiply_344384a91f4a493a9688557729416887_Out_2_Float);
            float2 _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_344384a91f4a493a9688557729416887_Out_2_Float.xx), _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2);
            float _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float = _Noise_Scale;
            float _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float);
            float2 _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2);
            float _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float);
            float _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float;
            Unity_Add_float(_GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float, _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float);
            float _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float;
            Unity_Divide_float(_Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float, float(2), _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float);
            float _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float;
            Unity_Saturate_float(_Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float, _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float);
            float _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float = _Noise_Power;
            float _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float;
            Unity_Power_float(_Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float, _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float, _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float);
            float4 _Property_062c88217e21495993819b1283de5996_Out_0_Vector4 = _Noise_Remap;
            float _Split_10a48c3e20374baca2339a6864cc7239_R_1_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[0];
            float _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[1];
            float _Split_10a48c3e20374baca2339a6864cc7239_B_3_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[2];
            float _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[3];
            float4 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4;
            float3 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3;
            float2 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_R_1_Float, _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float, float(0), float(0), _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2);
            float4 _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4;
            float3 _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3;
            float2 _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_B_3_Float, _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float, float(0), float(0), _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4, _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2);
            float _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float;
            Unity_Remap_float(_Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2, _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float);
            float _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float;
            Unity_Absolute_float(_Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float);
            float _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float;
            Unity_Smoothstep_float(_Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float, _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float, _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float);
            float _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float = _Base_Speed;
            float _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float, _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float);
            float2 _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float.xx), _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2);
            float _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float = _Base_Scale;
            float _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2, _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float, _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float);
            float _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float = _Base_Strenght;
            float _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float, _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float);
            float _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float;
            Unity_Add_float(_Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float, _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float);
            float _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float;
            Unity_Add_float(float(1), _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float);
            float _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float;
            Unity_Divide_float(_Add_b109669985f848f487a0dd38a9421be2_Out_2_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float, _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float);
            float3 _Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float.xxx), _Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3);
            float _Property_1678667631e2404b948823a2a19e8511_Out_0_Float = _Noise_Height;
            float3 _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3, (_Property_1678667631e2404b948823a2a19e8511_Out_0_Float.xxx), _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3);
            float3 _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3, _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3);
            float3 _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3;
            Unity_Add_float3(_Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3, _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3, _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3);
            description.Position = _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float);
            float4 _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_275ad52e843942b49d76a58decbed093_R_1_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[0];
            float _Split_275ad52e843942b49d76a58decbed093_G_2_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[1];
            float _Split_275ad52e843942b49d76a58decbed093_B_3_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[2];
            float _Split_275ad52e843942b49d76a58decbed093_A_4_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[3];
            float _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float;
            Unity_Subtract_float(_Split_275ad52e843942b49d76a58decbed093_A_4_Float, float(1), _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float);
            float _Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float, _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float, _Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float);
            float _Property_a8180489db804f679d140893d579b48e_Out_0_Float = _Fade_Depth;
            float _Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float;
            Unity_Divide_float(_Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float, _Property_a8180489db804f679d140893d579b48e_Out_0_Float, _Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float);
            float _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float;
            Unity_Saturate_float(_Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float, _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float);
            surface.Alpha = _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP0;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP1;
            #endif
             float3 positionWS : INTERP2;
             float3 normalWS : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Noise_Speed;
        float _Noise_Height;
        float4 _Noise_Remap;
        float4 _Color_Peak;
        float4 _Color_Valley;
        float _Noise_egde_1;
        float _Noise_edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Base_Speed;
        float _Base_Strenght;
        float _Emmision_Strenght;
        float _Curvature_Radius;
        float _Fresnel_Power;
        float _FrenselOpacity;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float);
            float _Property_0ce616d0ca0c457c8456d3015b06b9db_Out_0_Float = _Curvature_Radius;
            float _Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float;
            Unity_Divide_float(_Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float, _Property_0ce616d0ca0c457c8456d3015b06b9db_Out_0_Float, _Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float);
            float _Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float;
            Unity_Power_float(_Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float, float(3), _Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float);
            float3 _Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float.xxx), _Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3);
            float _Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float = _Noise_egde_1;
            float _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float = _Noise_edge_2;
            float4 _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4 = _Rotate_Projection;
            float _Split_96447af7694c48dda519bfc5db262513_R_1_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[0];
            float _Split_96447af7694c48dda519bfc5db262513_G_2_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[1];
            float _Split_96447af7694c48dda519bfc5db262513_B_3_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[2];
            float _Split_96447af7694c48dda519bfc5db262513_A_4_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[3];
            float3 _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4.xyz), _Split_96447af7694c48dda519bfc5db262513_A_4_Float, _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3);
            float _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float = _Noise_Speed;
            float _Multiply_344384a91f4a493a9688557729416887_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float, _Multiply_344384a91f4a493a9688557729416887_Out_2_Float);
            float2 _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_344384a91f4a493a9688557729416887_Out_2_Float.xx), _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2);
            float _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float = _Noise_Scale;
            float _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float);
            float2 _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2);
            float _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float);
            float _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float;
            Unity_Add_float(_GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float, _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float);
            float _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float;
            Unity_Divide_float(_Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float, float(2), _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float);
            float _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float;
            Unity_Saturate_float(_Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float, _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float);
            float _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float = _Noise_Power;
            float _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float;
            Unity_Power_float(_Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float, _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float, _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float);
            float4 _Property_062c88217e21495993819b1283de5996_Out_0_Vector4 = _Noise_Remap;
            float _Split_10a48c3e20374baca2339a6864cc7239_R_1_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[0];
            float _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[1];
            float _Split_10a48c3e20374baca2339a6864cc7239_B_3_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[2];
            float _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[3];
            float4 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4;
            float3 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3;
            float2 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_R_1_Float, _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float, float(0), float(0), _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2);
            float4 _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4;
            float3 _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3;
            float2 _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_B_3_Float, _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float, float(0), float(0), _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4, _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2);
            float _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float;
            Unity_Remap_float(_Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2, _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float);
            float _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float;
            Unity_Absolute_float(_Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float);
            float _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float;
            Unity_Smoothstep_float(_Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float, _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float, _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float);
            float _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float = _Base_Speed;
            float _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float, _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float);
            float2 _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float.xx), _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2);
            float _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float = _Base_Scale;
            float _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2, _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float, _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float);
            float _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float = _Base_Strenght;
            float _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float, _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float);
            float _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float;
            Unity_Add_float(_Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float, _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float);
            float _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float;
            Unity_Add_float(float(1), _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float);
            float _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float;
            Unity_Divide_float(_Add_b109669985f848f487a0dd38a9421be2_Out_2_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float, _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float);
            float3 _Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float.xxx), _Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3);
            float _Property_1678667631e2404b948823a2a19e8511_Out_0_Float = _Noise_Height;
            float3 _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3, (_Property_1678667631e2404b948823a2a19e8511_Out_0_Float.xxx), _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3);
            float3 _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3, _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3);
            float3 _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3;
            Unity_Add_float3(_Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3, _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3, _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3);
            description.Position = _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_cd893287511d4118b9d44e315a046048_Out_0_Vector4 = _Color_Valley;
            float4 _Property_78c7ae34f64a4d8b8d053036ede212b8_Out_0_Vector4 = _Color_Peak;
            float _Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float = _Noise_egde_1;
            float _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float = _Noise_edge_2;
            float4 _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4 = _Rotate_Projection;
            float _Split_96447af7694c48dda519bfc5db262513_R_1_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[0];
            float _Split_96447af7694c48dda519bfc5db262513_G_2_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[1];
            float _Split_96447af7694c48dda519bfc5db262513_B_3_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[2];
            float _Split_96447af7694c48dda519bfc5db262513_A_4_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[3];
            float3 _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4.xyz), _Split_96447af7694c48dda519bfc5db262513_A_4_Float, _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3);
            float _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float = _Noise_Speed;
            float _Multiply_344384a91f4a493a9688557729416887_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float, _Multiply_344384a91f4a493a9688557729416887_Out_2_Float);
            float2 _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_344384a91f4a493a9688557729416887_Out_2_Float.xx), _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2);
            float _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float = _Noise_Scale;
            float _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float);
            float2 _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2);
            float _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float);
            float _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float;
            Unity_Add_float(_GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float, _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float);
            float _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float;
            Unity_Divide_float(_Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float, float(2), _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float);
            float _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float;
            Unity_Saturate_float(_Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float, _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float);
            float _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float = _Noise_Power;
            float _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float;
            Unity_Power_float(_Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float, _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float, _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float);
            float4 _Property_062c88217e21495993819b1283de5996_Out_0_Vector4 = _Noise_Remap;
            float _Split_10a48c3e20374baca2339a6864cc7239_R_1_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[0];
            float _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[1];
            float _Split_10a48c3e20374baca2339a6864cc7239_B_3_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[2];
            float _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[3];
            float4 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4;
            float3 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3;
            float2 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_R_1_Float, _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float, float(0), float(0), _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2);
            float4 _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4;
            float3 _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3;
            float2 _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_B_3_Float, _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float, float(0), float(0), _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4, _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2);
            float _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float;
            Unity_Remap_float(_Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2, _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float);
            float _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float;
            Unity_Absolute_float(_Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float);
            float _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float;
            Unity_Smoothstep_float(_Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float, _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float, _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float);
            float _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float = _Base_Speed;
            float _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float, _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float);
            float2 _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float.xx), _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2);
            float _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float = _Base_Scale;
            float _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2, _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float, _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float);
            float _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float = _Base_Strenght;
            float _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float, _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float);
            float _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float;
            Unity_Add_float(_Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float, _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float);
            float _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float;
            Unity_Add_float(float(1), _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float);
            float _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float;
            Unity_Divide_float(_Add_b109669985f848f487a0dd38a9421be2_Out_2_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float, _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float);
            float4 _Lerp_4090d82a4dc543adb198ac95e3cdd705_Out_3_Vector4;
            Unity_Lerp_float4(_Property_cd893287511d4118b9d44e315a046048_Out_0_Vector4, _Property_78c7ae34f64a4d8b8d053036ede212b8_Out_0_Vector4, (_Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float.xxxx), _Lerp_4090d82a4dc543adb198ac95e3cdd705_Out_3_Vector4);
            float _Property_75a490a070f34bafa1845ee47423c5c1_Out_0_Float = _Fresnel_Power;
            float _FresnelEffect_0e41833cbb1e4580aea61b7d6702ae45_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_75a490a070f34bafa1845ee47423c5c1_Out_0_Float, _FresnelEffect_0e41833cbb1e4580aea61b7d6702ae45_Out_3_Float);
            float _Multiply_bda9335a7d344c6993716e390ed8e4ed_Out_2_Float;
            Unity_Multiply_float_float(_Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float, _FresnelEffect_0e41833cbb1e4580aea61b7d6702ae45_Out_3_Float, _Multiply_bda9335a7d344c6993716e390ed8e4ed_Out_2_Float);
            float _Property_717ba187ade246b392a6efd4df013a1c_Out_0_Float = _FrenselOpacity;
            float _Multiply_1e98a2564ce4440fabd73dc21ccf282d_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_bda9335a7d344c6993716e390ed8e4ed_Out_2_Float, _Property_717ba187ade246b392a6efd4df013a1c_Out_0_Float, _Multiply_1e98a2564ce4440fabd73dc21ccf282d_Out_2_Float);
            float4 _Add_8e88b06ab85e4daeb32c624835cda120_Out_2_Vector4;
            Unity_Add_float4(_Lerp_4090d82a4dc543adb198ac95e3cdd705_Out_3_Vector4, (_Multiply_1e98a2564ce4440fabd73dc21ccf282d_Out_2_Float.xxxx), _Add_8e88b06ab85e4daeb32c624835cda120_Out_2_Vector4);
            float _SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float);
            float4 _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_275ad52e843942b49d76a58decbed093_R_1_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[0];
            float _Split_275ad52e843942b49d76a58decbed093_G_2_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[1];
            float _Split_275ad52e843942b49d76a58decbed093_B_3_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[2];
            float _Split_275ad52e843942b49d76a58decbed093_A_4_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[3];
            float _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float;
            Unity_Subtract_float(_Split_275ad52e843942b49d76a58decbed093_A_4_Float, float(1), _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float);
            float _Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float, _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float, _Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float);
            float _Property_a8180489db804f679d140893d579b48e_Out_0_Float = _Fade_Depth;
            float _Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float;
            Unity_Divide_float(_Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float, _Property_a8180489db804f679d140893d579b48e_Out_0_Float, _Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float);
            float _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float;
            Unity_Saturate_float(_Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float, _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float);
            surface.BaseColor = (_Add_8e88b06ab85e4daeb32c624835cda120_Out_2_Vector4.xyz);
            surface.Alpha = _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Noise_Speed;
        float _Noise_Height;
        float4 _Noise_Remap;
        float4 _Color_Peak;
        float4 _Color_Valley;
        float _Noise_egde_1;
        float _Noise_edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Base_Speed;
        float _Base_Strenght;
        float _Emmision_Strenght;
        float _Curvature_Radius;
        float _Fresnel_Power;
        float _FrenselOpacity;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float);
            float _Property_0ce616d0ca0c457c8456d3015b06b9db_Out_0_Float = _Curvature_Radius;
            float _Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float;
            Unity_Divide_float(_Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float, _Property_0ce616d0ca0c457c8456d3015b06b9db_Out_0_Float, _Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float);
            float _Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float;
            Unity_Power_float(_Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float, float(3), _Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float);
            float3 _Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float.xxx), _Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3);
            float _Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float = _Noise_egde_1;
            float _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float = _Noise_edge_2;
            float4 _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4 = _Rotate_Projection;
            float _Split_96447af7694c48dda519bfc5db262513_R_1_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[0];
            float _Split_96447af7694c48dda519bfc5db262513_G_2_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[1];
            float _Split_96447af7694c48dda519bfc5db262513_B_3_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[2];
            float _Split_96447af7694c48dda519bfc5db262513_A_4_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[3];
            float3 _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4.xyz), _Split_96447af7694c48dda519bfc5db262513_A_4_Float, _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3);
            float _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float = _Noise_Speed;
            float _Multiply_344384a91f4a493a9688557729416887_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float, _Multiply_344384a91f4a493a9688557729416887_Out_2_Float);
            float2 _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_344384a91f4a493a9688557729416887_Out_2_Float.xx), _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2);
            float _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float = _Noise_Scale;
            float _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float);
            float2 _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2);
            float _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float);
            float _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float;
            Unity_Add_float(_GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float, _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float);
            float _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float;
            Unity_Divide_float(_Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float, float(2), _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float);
            float _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float;
            Unity_Saturate_float(_Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float, _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float);
            float _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float = _Noise_Power;
            float _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float;
            Unity_Power_float(_Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float, _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float, _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float);
            float4 _Property_062c88217e21495993819b1283de5996_Out_0_Vector4 = _Noise_Remap;
            float _Split_10a48c3e20374baca2339a6864cc7239_R_1_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[0];
            float _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[1];
            float _Split_10a48c3e20374baca2339a6864cc7239_B_3_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[2];
            float _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[3];
            float4 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4;
            float3 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3;
            float2 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_R_1_Float, _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float, float(0), float(0), _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2);
            float4 _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4;
            float3 _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3;
            float2 _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_B_3_Float, _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float, float(0), float(0), _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4, _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2);
            float _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float;
            Unity_Remap_float(_Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2, _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float);
            float _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float;
            Unity_Absolute_float(_Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float);
            float _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float;
            Unity_Smoothstep_float(_Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float, _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float, _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float);
            float _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float = _Base_Speed;
            float _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float, _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float);
            float2 _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float.xx), _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2);
            float _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float = _Base_Scale;
            float _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2, _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float, _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float);
            float _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float = _Base_Strenght;
            float _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float, _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float);
            float _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float;
            Unity_Add_float(_Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float, _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float);
            float _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float;
            Unity_Add_float(float(1), _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float);
            float _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float;
            Unity_Divide_float(_Add_b109669985f848f487a0dd38a9421be2_Out_2_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float, _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float);
            float3 _Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float.xxx), _Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3);
            float _Property_1678667631e2404b948823a2a19e8511_Out_0_Float = _Noise_Height;
            float3 _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3, (_Property_1678667631e2404b948823a2a19e8511_Out_0_Float.xxx), _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3);
            float3 _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3, _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3);
            float3 _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3;
            Unity_Add_float3(_Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3, _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3, _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3);
            description.Position = _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float);
            float4 _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_275ad52e843942b49d76a58decbed093_R_1_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[0];
            float _Split_275ad52e843942b49d76a58decbed093_G_2_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[1];
            float _Split_275ad52e843942b49d76a58decbed093_B_3_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[2];
            float _Split_275ad52e843942b49d76a58decbed093_A_4_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[3];
            float _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float;
            Unity_Subtract_float(_Split_275ad52e843942b49d76a58decbed093_A_4_Float, float(1), _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float);
            float _Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float, _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float, _Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float);
            float _Property_a8180489db804f679d140893d579b48e_Out_0_Float = _Fade_Depth;
            float _Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float;
            Unity_Divide_float(_Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float, _Property_a8180489db804f679d140893d579b48e_Out_0_Float, _Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float);
            float _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float;
            Unity_Saturate_float(_Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float, _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float);
            surface.Alpha = _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
             float3 normalWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Noise_Speed;
        float _Noise_Height;
        float4 _Noise_Remap;
        float4 _Color_Peak;
        float4 _Color_Valley;
        float _Noise_egde_1;
        float _Noise_edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Base_Speed;
        float _Base_Strenght;
        float _Emmision_Strenght;
        float _Curvature_Radius;
        float _Fresnel_Power;
        float _FrenselOpacity;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float);
            float _Property_0ce616d0ca0c457c8456d3015b06b9db_Out_0_Float = _Curvature_Radius;
            float _Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float;
            Unity_Divide_float(_Distance_778ddc5822b547cdbb40cc9dbe9384b3_Out_2_Float, _Property_0ce616d0ca0c457c8456d3015b06b9db_Out_0_Float, _Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float);
            float _Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float;
            Unity_Power_float(_Divide_f05b25dafced489baef6edbcee70184e_Out_2_Float, float(3), _Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float);
            float3 _Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_62c28c9cc495407b95a98b65c65c1d94_Out_2_Float.xxx), _Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3);
            float _Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float = _Noise_egde_1;
            float _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float = _Noise_edge_2;
            float4 _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4 = _Rotate_Projection;
            float _Split_96447af7694c48dda519bfc5db262513_R_1_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[0];
            float _Split_96447af7694c48dda519bfc5db262513_G_2_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[1];
            float _Split_96447af7694c48dda519bfc5db262513_B_3_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[2];
            float _Split_96447af7694c48dda519bfc5db262513_A_4_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[3];
            float3 _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4.xyz), _Split_96447af7694c48dda519bfc5db262513_A_4_Float, _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3);
            float _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float = _Noise_Speed;
            float _Multiply_344384a91f4a493a9688557729416887_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float, _Multiply_344384a91f4a493a9688557729416887_Out_2_Float);
            float2 _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_344384a91f4a493a9688557729416887_Out_2_Float.xx), _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2);
            float _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float = _Noise_Scale;
            float _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float);
            float2 _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2);
            float _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float);
            float _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float;
            Unity_Add_float(_GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float, _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float);
            float _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float;
            Unity_Divide_float(_Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float, float(2), _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float);
            float _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float;
            Unity_Saturate_float(_Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float, _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float);
            float _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float = _Noise_Power;
            float _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float;
            Unity_Power_float(_Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float, _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float, _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float);
            float4 _Property_062c88217e21495993819b1283de5996_Out_0_Vector4 = _Noise_Remap;
            float _Split_10a48c3e20374baca2339a6864cc7239_R_1_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[0];
            float _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[1];
            float _Split_10a48c3e20374baca2339a6864cc7239_B_3_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[2];
            float _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[3];
            float4 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4;
            float3 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3;
            float2 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_R_1_Float, _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float, float(0), float(0), _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2);
            float4 _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4;
            float3 _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3;
            float2 _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_B_3_Float, _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float, float(0), float(0), _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4, _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2);
            float _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float;
            Unity_Remap_float(_Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2, _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float);
            float _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float;
            Unity_Absolute_float(_Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float);
            float _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float;
            Unity_Smoothstep_float(_Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float, _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float, _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float);
            float _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float = _Base_Speed;
            float _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float, _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float);
            float2 _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float.xx), _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2);
            float _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float = _Base_Scale;
            float _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2, _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float, _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float);
            float _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float = _Base_Strenght;
            float _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float, _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float);
            float _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float;
            Unity_Add_float(_Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float, _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float);
            float _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float;
            Unity_Add_float(float(1), _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float);
            float _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float;
            Unity_Divide_float(_Add_b109669985f848f487a0dd38a9421be2_Out_2_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float, _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float);
            float3 _Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float.xxx), _Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3);
            float _Property_1678667631e2404b948823a2a19e8511_Out_0_Float = _Noise_Height;
            float3 _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_dbea4d25af1844a18fb02d7a0701c036_Out_2_Vector3, (_Property_1678667631e2404b948823a2a19e8511_Out_0_Float.xxx), _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3);
            float3 _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_5b10a5a47fac4f3d9a94db7f8838037c_Out_2_Vector3, _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3);
            float3 _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3;
            Unity_Add_float3(_Multiply_05a81bf16baa46f9b18311be02b87381_Out_2_Vector3, _Add_f40dc436ed494381adcea6083c978950_Out_2_Vector3, _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3);
            description.Position = _Add_c3a1d36d2fb143d6b9c9f179b114d63d_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_cd893287511d4118b9d44e315a046048_Out_0_Vector4 = _Color_Valley;
            float4 _Property_78c7ae34f64a4d8b8d053036ede212b8_Out_0_Vector4 = _Color_Peak;
            float _Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float = _Noise_egde_1;
            float _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float = _Noise_edge_2;
            float4 _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4 = _Rotate_Projection;
            float _Split_96447af7694c48dda519bfc5db262513_R_1_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[0];
            float _Split_96447af7694c48dda519bfc5db262513_G_2_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[1];
            float _Split_96447af7694c48dda519bfc5db262513_B_3_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[2];
            float _Split_96447af7694c48dda519bfc5db262513_A_4_Float = _Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4[3];
            float3 _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_c03bbfb07d014fee819cef922be97df0_Out_0_Vector4.xyz), _Split_96447af7694c48dda519bfc5db262513_A_4_Float, _RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3);
            float _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float = _Noise_Speed;
            float _Multiply_344384a91f4a493a9688557729416887_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_45f82c98acdc4089bf3f773da40df3e1_Out_0_Float, _Multiply_344384a91f4a493a9688557729416887_Out_2_Float);
            float2 _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_344384a91f4a493a9688557729416887_Out_2_Float.xx), _TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2);
            float _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float = _Noise_Scale;
            float _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_18f1ac6f0239400faedd8ab5a9a635ec_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float);
            float2 _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2);
            float _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_bd8b758bf6fe4eebb545576188e38ede_Out_3_Vector2, _Property_a793a346ad414f50ac700d77d0eb342f_Out_0_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float);
            float _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float;
            Unity_Add_float(_GradientNoise_fe1f0a2c882d4867a1c9d58e50c2d93b_Out_2_Float, _GradientNoise_319480b794a04cd6b49e1c0f68a167f8_Out_2_Float, _Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float);
            float _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float;
            Unity_Divide_float(_Add_f06a4bf2871a4eb0b35e4e7d12e6a6a0_Out_2_Float, float(2), _Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float);
            float _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float;
            Unity_Saturate_float(_Divide_f3182c47e90a4da08aead387c375df29_Out_2_Float, _Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float);
            float _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float = _Noise_Power;
            float _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float;
            Unity_Power_float(_Saturate_0604cbda1d2b40c9902b0230b4984599_Out_1_Float, _Property_310facfe9e9c4ad0ae07082930de67c7_Out_0_Float, _Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float);
            float4 _Property_062c88217e21495993819b1283de5996_Out_0_Vector4 = _Noise_Remap;
            float _Split_10a48c3e20374baca2339a6864cc7239_R_1_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[0];
            float _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[1];
            float _Split_10a48c3e20374baca2339a6864cc7239_B_3_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[2];
            float _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float = _Property_062c88217e21495993819b1283de5996_Out_0_Vector4[3];
            float4 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4;
            float3 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3;
            float2 _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_R_1_Float, _Split_10a48c3e20374baca2339a6864cc7239_G_2_Float, float(0), float(0), _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGBA_4_Vector4, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RGB_5_Vector3, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2);
            float4 _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4;
            float3 _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3;
            float2 _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2;
            Unity_Combine_float(_Split_10a48c3e20374baca2339a6864cc7239_B_3_Float, _Split_10a48c3e20374baca2339a6864cc7239_A_4_Float, float(0), float(0), _Combine_134e3c4590d34067b308d3dc41545b9e_RGBA_4_Vector4, _Combine_134e3c4590d34067b308d3dc41545b9e_RGB_5_Vector3, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2);
            float _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float;
            Unity_Remap_float(_Power_83c77760b4844d73b2a8a7c4c84d4057_Out_2_Float, _Combine_0eea0d1deea44b73bd34140b4ce3b32b_RG_6_Vector2, _Combine_134e3c4590d34067b308d3dc41545b9e_RG_6_Vector2, _Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float);
            float _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float;
            Unity_Absolute_float(_Remap_92a8a28b99394c35af63e0ba2cf56bc2_Out_3_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float);
            float _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float;
            Unity_Smoothstep_float(_Property_20d53adbb38e4996b98337f6f5731ec1_Out_0_Float, _Property_db2c37f09f4e464e80374ddb012516e7_Out_0_Float, _Absolute_784c168daf544c9c985fd90c082fd4e8_Out_1_Float, _Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float);
            float _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float = _Base_Speed;
            float _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_3270b36aaf874acb9216f0765eb9a2a9_Out_0_Float, _Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float);
            float2 _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_daf481b58a824bbf8217968948ad27ce_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_a6ac7523dff045308910621a64307a2b_Out_2_Float.xx), _TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2);
            float _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float = _Base_Scale;
            float _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_98d09ef1657f4a6d924dd4f85e220f29_Out_3_Vector2, _Property_6dbfe8299f8c4242bf4d47ca5445d578_Out_0_Float, _GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float);
            float _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float = _Base_Strenght;
            float _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_fb269bd65639403eb963de78c44f74a7_Out_2_Float, _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float);
            float _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float;
            Unity_Add_float(_Smoothstep_db0bd94b91b14cf69f5b5561052b01d6_Out_3_Float, _Multiply_bb14701ccfcf4f62aed0595a4a4e16c7_Out_2_Float, _Add_b109669985f848f487a0dd38a9421be2_Out_2_Float);
            float _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float;
            Unity_Add_float(float(1), _Property_0f570a1c3d544af7bee4c80464461399_Out_0_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float);
            float _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float;
            Unity_Divide_float(_Add_b109669985f848f487a0dd38a9421be2_Out_2_Float, _Add_2a9e88ba051246e39f7dad04658e755e_Out_2_Float, _Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float);
            float4 _Lerp_4090d82a4dc543adb198ac95e3cdd705_Out_3_Vector4;
            Unity_Lerp_float4(_Property_cd893287511d4118b9d44e315a046048_Out_0_Vector4, _Property_78c7ae34f64a4d8b8d053036ede212b8_Out_0_Vector4, (_Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float.xxxx), _Lerp_4090d82a4dc543adb198ac95e3cdd705_Out_3_Vector4);
            float _Property_75a490a070f34bafa1845ee47423c5c1_Out_0_Float = _Fresnel_Power;
            float _FresnelEffect_0e41833cbb1e4580aea61b7d6702ae45_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_75a490a070f34bafa1845ee47423c5c1_Out_0_Float, _FresnelEffect_0e41833cbb1e4580aea61b7d6702ae45_Out_3_Float);
            float _Multiply_bda9335a7d344c6993716e390ed8e4ed_Out_2_Float;
            Unity_Multiply_float_float(_Divide_cf951a7f46224ca29bbe9b651ba0f4cc_Out_2_Float, _FresnelEffect_0e41833cbb1e4580aea61b7d6702ae45_Out_3_Float, _Multiply_bda9335a7d344c6993716e390ed8e4ed_Out_2_Float);
            float _Property_717ba187ade246b392a6efd4df013a1c_Out_0_Float = _FrenselOpacity;
            float _Multiply_1e98a2564ce4440fabd73dc21ccf282d_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_bda9335a7d344c6993716e390ed8e4ed_Out_2_Float, _Property_717ba187ade246b392a6efd4df013a1c_Out_0_Float, _Multiply_1e98a2564ce4440fabd73dc21ccf282d_Out_2_Float);
            float4 _Add_8e88b06ab85e4daeb32c624835cda120_Out_2_Vector4;
            Unity_Add_float4(_Lerp_4090d82a4dc543adb198ac95e3cdd705_Out_3_Vector4, (_Multiply_1e98a2564ce4440fabd73dc21ccf282d_Out_2_Float.xxxx), _Add_8e88b06ab85e4daeb32c624835cda120_Out_2_Vector4);
            float _SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float);
            float4 _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_275ad52e843942b49d76a58decbed093_R_1_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[0];
            float _Split_275ad52e843942b49d76a58decbed093_G_2_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[1];
            float _Split_275ad52e843942b49d76a58decbed093_B_3_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[2];
            float _Split_275ad52e843942b49d76a58decbed093_A_4_Float = _ScreenPosition_8e688784ae614aa3b21844a52ac7962e_Out_0_Vector4[3];
            float _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float;
            Unity_Subtract_float(_Split_275ad52e843942b49d76a58decbed093_A_4_Float, float(1), _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float);
            float _Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_39561ea961fe44e2a028913840534cb7_Out_1_Float, _Subtract_52c236fa5ff64666ae31575af1be74db_Out_2_Float, _Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float);
            float _Property_a8180489db804f679d140893d579b48e_Out_0_Float = _Fade_Depth;
            float _Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float;
            Unity_Divide_float(_Subtract_56027556a6004727b00454b78dc65c26_Out_2_Float, _Property_a8180489db804f679d140893d579b48e_Out_0_Float, _Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float);
            float _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float;
            Unity_Saturate_float(_Divide_3161475e91ef4d27bf639b5ea982c321_Out_2_Float, _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float);
            surface.BaseColor = (_Add_8e88b06ab85e4daeb32c624835cda120_Out_2_Vector4.xyz);
            surface.Alpha = _Saturate_d5b5a9e14ff84a5d8f2d199a55bbcd88_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphUnlitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}