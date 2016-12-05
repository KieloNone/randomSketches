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

uniform float time;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 ecVertex;
varying vec3 ocVertex;
varying float shadowIntensity;

float toon1(float intensity){
    float hue;
    if (intensity > 0.95) {
    hue = 1.0;
    //}else if (intensity > 0.75){
    //hue =0.8;
    } else if (intensity > 0.5) {
    hue = 0.7;
    } else if (intensity > 0.25) {
    hue=0.4;
    } else {
    hue=0.2;
    }
    return hue;

}
//not a real toon shader, but does the trig (used for the hem of the ghost)
float toon2(float intensity){//(vec4 color) {
    float hue;
    if(intensity >0.8)
        hue=1.0;
    else if (intensity > 0.7)
        hue = 0.9;
    else if (intensity>0.2)
        hue=0.8;
    else
        hue=0.7;
    return hue;

}



vec4 ambient(int Nlight) {
    vec3 colorAmbient3=vec3(0,0,0);
    for (int j=0; j<Nlight; j++)
    {
        colorAmbient3+=lightAmbient[j];
    }
    vec4 colorAmbient=vec4(colorAmbient3,1.0);
    return colorAmbient;
}

vec4 diffuse(vec3 dirL,int j)
{
    float intensity=max(0.0,dot(dirL,vertNormal));
    vec3 color=toon1(intensity)*lightDiffuse[j];
    vec4 diffuseL = vec4(color,1.0);
    return diffuseL;
}


vec4 eyes() {

    float b;
    if(abs(cos(time*0.1))<0.1)
        b=(1-max(0.0,min(1.0,cos(2*time)*1.2)))*49.0;
    else
        b=49;
    float square=(ocVertex.y+100.0)*(ocVertex.y+100.0);
    float square2=(ocVertex.x+20.0)*(ocVertex.x+20.0);
    float square3=(ocVertex.x-20.0)*(ocVertex.x-20.0);
    if (((square/b+square2/49.0)<1) || ((square/b+square3/49.0)<1)) {

        if(((square+square2)<9) || ((square+square3)<9)) 
            return vec4(0.5);
        else
            return vec4(0,1,0,1);
    }
    else if(((square/(b+1)+square2/49.0)<1.2) || ((square/(b+1)+square3/49.0)<1.2)) 
        return vec4(0.5);
    else
        return vec4(1,1,1,1);
}

vec4 lightCalc(int Nlight) {
    vec4 color;
    color=vec4(0,0,0,0);
    for(int j=0;j<Nlight;j++) {
        vec3 dirL=lightPosition[j].xyz-ecVertex;
        dirL=normalize(dirL);
        color+=diffuse(dirL,j);
    }
    return color;


}

void main() {
    float intensity;
    vec4 color;
    vec4 diffuse=lightCalc(2);
    color=vertColor*(ambient(2)+diffuse);
    vec4 eyeColor=eyes();
    color=vec4(color.xyz*toon2(shadowIntensity)*eyeColor.xyz,color.w);
    gl_FragColor=color;
}
