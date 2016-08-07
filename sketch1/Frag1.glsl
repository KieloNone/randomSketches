#version 330
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_LIGHT_SHADER
uniform int lightCount;
uniform vec4 lightPosition[8]; //in eye (world?) coordinates
uniform vec3 lightAmbient[8];
uniform vec3 lightDiffuse[8];
uniform vec3 lightSpecular[8];
uniform vec3 lightFalloff[8];
//uniform vec3 lightNormal[8];

varying vec4 vertColor;
varying vec3 vertNormal;
//varying vec3 vertLightDir;
varying float fractionIn;
varying vec3 ecVertex;

vec4 ambient(int Nlight) {
    vec3 colorAmbient3=vec3(0,0,0);
    for (int j=0; j<Nlight; j++)
    {
        colorAmbient3+=lightAmbient[j];
    }
    vec4 colorAmbient=vertColor*vec4(colorAmbient3,1.0);
    return colorAmbient;
}

vec4 diffuse(vec3 dirL,int j)
{
    vec3 color=max(0.0,dot(dirL,vertNormal))*lightDiffuse[j];
    vec4 diffuseL = vertColor*vec4(color,1.0);
    return diffuseL;
}

vec4 specularBlinnPhong(vec3 dirL, int j)
{
    //from camera to vertex
    vec3 dirV=normalize(vec3(0.0,0.0,0.0)-ecVertex);
    vec3 halfw=normalize(dirL+dirV);
    vec3
    color=pow(max(0.0,dot(halfw,vertNormal)),fractionIn)*lightDiffuse[j];
    return vertColor*vec4(color,1.0);
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

vec4 lightCalc(int Nlight) {
    vec4 color;
    color=vec4(0,0,0,0);
    for(int j=1;j<Nlight;j++) {
        vec3 dirL=lightPosition[j].xyz-ecVertex;
        float att=lightAtt(dirL,j);
        dirL=normalize(dirL);
        color+=diffuse(dirL,j)*att;
        color+=specularBlinnPhong(dirL,j)*att;
    }
    return color;


}


void main() {
    float intensity;
    vec4 color;
    color=ambient(3)+lightCalc(3);
    gl_FragColor=color;
}
