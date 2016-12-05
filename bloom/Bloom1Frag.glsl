#version 330
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEX_SHADER
//uniform vec3 lightNormal[8];

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform sampler2D texture;



void main() {
    vec4 color0 = texture2D(texture,vertTexCoord.st);
    float a=color0.a;
    //workaround for the fact that if you set the image to full transparency in gimp,
    //all the colors dissapear
    if(a<0.2)
        a=0.0;
    vec4 color=vec4(color0.rgb,1.0)*vec4(a,a,a,1);
    gl_FragColor=color;
}
