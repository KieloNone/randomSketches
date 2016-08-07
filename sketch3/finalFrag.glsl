#version 330

//actually using glsl 330
out vec4 FragColor;

uniform sampler2D scene;
uniform sampler2D bloomBlur;
varying vec2 bgCoord;



void main(){
    vec3 hdrColor=texture2D(scene,bgCoord).rgb;
    vec3 bloomColor=texture2D(bloomBlur,bgCoord).rgb;
    //additive blending
    hdrColor+=bloomColor;
    FragColor=vec4(hdrColor.r,hdrColor.g,hdrColor.b,1.0);

}

