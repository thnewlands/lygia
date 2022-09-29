
#include "../math/powFast.hlsl"
#include "../color/tonemap.hlsl"

#include "fakeCube.hlsl"
#include "toShininess.hlsl"

/*
original_author: Patricio Gonzalez Vivo
description: get enviroment map light comming from a normal direction and acording to some roughness/metallic value. If there is no SCENE_CUBEMAP texture it creates a fake cube
use: <float3> envMap(<float3> _normal, <float> _roughness [, <float> _metallic])
options:
    - SCENE_CUBEMAP: pointing to the cubemap texture
    - ENVMAP_MAX_MIP_LEVEL: defualt 8
*/

#ifndef SAMPLE_CUBE_FNC
#define SAMPLE_CUBE_FNC(CUBEMAP, NORM, LOD) texCube(CUBEMAP, NORM, LOD)
#endif

#ifndef ENVMAP_MAX_MIP_LEVEL
#define ENVMAP_MAX_MIP_LEVEL 3.0
#endif

#ifndef FNC_ENVMAP
#define FNC_ENVMAP
float3 envMap(float3 _normal, float _roughness, float _metallic) {
#if defined(SCENE_CUBEMAP)
    float lod = ENVMAP_MAX_MIP_LEVEL * _roughness;
    return SAMPLE_CUBE_FNC( SCENE_CUBEMAP, _normal, lod).rgb;
#else
    return fakeCube(_normal, toShininess(_roughness, _metallic));
#endif
}

float3 envMap(float3 _normal, float _roughness) {
    return envMap(_normal, _roughness, 1.0);
}
#endif