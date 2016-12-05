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

vec4 ambient(int Nlight,vec4 color0) {
    vec3 colorAmbient3=vec3(0,0,0);
    for (int j=0; j<Nlight; j++)
    {
        colorAmbient3+=lightAmbient[j];
    }
    return color0*vec4(colorAmbient3,1);
}
float lightAtt(vec3 dirL, int j)
{
    float dist=dot(dirL,dirL)*0.00001;
    dist = lightFalloff[j].x*dist+lightFalloff[j].y*sqrt(dist)+lightFalloff[j].z;

    if(dist>0.0)
        return min(1.0/dist,1.0);
        else
        return 0.5;

}


vec4 diffuse(vec3 dirL,int j)
{
    vec3 color=max(0.0,dot(dirL,vertNormal))*lightDiffuse[j];
    return vec4(color,1.0);
}
vec4 specularBlinnPhong(vec3 dirL, vec3 dirV,int j)
{
    vec3 halfw=normalize(dirL+dirV);
    vec3
    color=pow(max(0.0,dot(halfw,vertNormal)),fractionIn)*lightDiffuse[j];
    return vec4(color,1.0);
}


vec4 lightCalc(int Nlight,vec4 color0) {
    vec4 color;
    color=vec4(0,0,0,0);
    vec3 dirV=normalize(vec3(0.0,0.0,0.0)-ecVertex);
    float VdotN=max(0,dot(dirV,vertNormal));
    for(int j=0;j<Nlight;j++) {
        vec3 dirL=lightPosition[j].xyz-ecVertex;
        float att=lightAtt(dirL,j);
        dirL=normalize(dirL);
        color+=color0*diffuse(dirL,j)*att;
        color+=color0*specularBlinnPhong(dirL,dirV,j)*att;

    }
    return color*VdotN;


}


void main() {
    float intensity;
    vec4 color0=vertColor*texture2D(texture, vertTexCoord.st);
    vec4 color=vec4(0,0,0,0);
    color = color0;
    color=ambient(3,color0)+lightCalc(3,color0);
    gl_FragColor=color;
}
