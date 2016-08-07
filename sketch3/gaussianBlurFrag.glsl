#version 330
uniform bool horizontal;

varying vec2 bgCoord;
uniform sampler2D scene;
uniform sampler2D testi;

//uniform float weight[5] = float[] (0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216);
uniform float weight[10] = float[] (0.128691,0.122167,0.104512,0.080572,0.055977,0.035046,
0.019774,0.010054,0.004606,0.001902);


void main() {
    vec2 tex_offset = 1.0 / textureSize(scene, 0);
    vec2 coord=bgCoord;
    vec3 result = texture2D(scene,coord).rgb*weight[0];
    if(horizontal)
    {
        for(int i=1;i<10;i++){
            result+=texture2D(scene,coord+vec2(tex_offset.x*i,0.0)).rgb*weight[i];
            result+=texture2D(scene,coord-vec2(tex_offset.x*i,0.0)).rgb*weight[i];
        }
    }
    else
    {
        for(int i=1;i<10;i++){
            result+=texture2D(scene,coord+vec2(0.0,tex_offset.y*i)).rgb*weight[i];
            result+=texture2D(scene,coord-vec2(0.0,tex_offset.x*i)).rgb*weight[i];
        }

    }
    gl_FragColor=vec4(result,1.0);
}
