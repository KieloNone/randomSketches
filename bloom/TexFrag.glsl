#version 330
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXLIGHT_SHADER
uniform int lightCount;
uniform vec4 lightPosition[8]; //in eye (world?) coordinates
uniform vec3 lightAmbient[8];
uniform vec3 lightDiffuse[8];
uniform vec3 lightSpecular[8];
uniform vec3 lightFalloff[8];

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 ecVertex;
varying vec4 vertTexCoord;

uniform sampler2D texture;

vec3 ambient(int Nlight) {
    vec3 colorAmbient3=vec3(0,0,0);
    for (int j=0; j<Nlight; j++)
    {
        colorAmbient3+=lightAmbient[j];
    }
    return colorAmbient3;
}




void main() {
    vec4 color0=vertColor*vec4(texture2D(texture, vertTexCoord.st).rgb,1.0);
    vec4 color=vec4(0,0,0,0);
    color =color0*vec4(ambient(1),1.0);
    gl_FragColor=color;
}
