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
//uniform vec3 lightNormal[8];

varying vec4 vertColor;
varying vec3 vertNormal;
varying float fractionIn;
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

vec4 diffuse(vec3 dirL,int j)
{
    vec3 color=max(0.0,dot(dirL,vertNormal))*lightDiffuse[j];
    return vec4(color,1.0);
}


vec4 lightCalc(int Nlight,vec4 color0) {
    vec4 color;
    color=vec4(0,0,0,0);
    for(int j=0;j<1;j++) {
        vec3 dirL=normalize(lightPosition[j].xyz-ecVertex);
        color+=color0*diffuse(dirL,j);
    }
    return color;


}


void main() {
    float intensity;
    vec4 color0=vertColor*texture2D(texture, vertTexCoord.st);
    vec4 color=vec4(0,0,0,0);
    //color = color0;
    //color =color0*vec4(ambient(3),1.0);
    //color+=lightCalc(3,color0);
    float col=dot(vertNormal,vec3(0,0,1));
    if(col<0)
        color=vec4(-col,0,0,1.0);
        else
        color=vec4(0,col,0,1.0);
    gl_FragColor=color;
}
