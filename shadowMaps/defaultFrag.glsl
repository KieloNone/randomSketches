#version 330
uniform vec3 lightNormal[8];
uniform vec3 lightDiffuse[8];
uniform vec2 lightSpot[8];
uniform vec4 lightPosition[8];

//sample around the pixel to get smoother shadows
//that we have a poisson disk
const vec2 poissonDisk[9] = vec2[] (
    vec2(0.95581, -0.18159), vec2(0.50147, -0.35807), vec2(0.69607, 0.35559),
    vec2(-0.0036825, -0.59150),vec2(0.15930,0.089750), vec2(-0.65031, 0.058189),
    vec2(0.11915, 0.78449),  vec2(-0.34296, 0.51575), vec2(-0.60380, -0.41527)
);

float unpackDepth(vec4 color){
    return color.r +color.g/255.0;
}


uniform sampler2D shadowMap;
uniform sampler2D shadowMap2;

varying vec4 vertColor;
varying vec4 shadowCoord;
varying vec4 shadowCoord2;
varying vec3 vertNormal;
varying vec4 vertPosition;

vec4 diffuse(int spotlight,int j)
{  
     
    vec3 dirToLight=normalize(lightPosition[j].xyz-vertPosition.xyz);
    vec4 diffuseL = vec4(0,0,0,1);
    //spotlight
    if(spotlight>0){
        
        float NN = max(0.0,dot(-lightNormal[j],dirToLight));
        vec3 color=vec3(0,0,0);
        if(NN > lightSpot[j].x)
         {
             //using concentration parameter to define the hotspot angle (or it's cosine)
             //most probably not the way processing intended this to be done
             float diff = lightSpot[j].y-lightSpot[j].x;
             if((diff>0.0) && (NN<lightSpot[j].y))
             {
                 float attenuation=(NN-lightSpot[j].x)/diff;
                 color=max(0.0,dot(dirToLight,vertNormal))*lightDiffuse[j]*attenuation;
             }
             else
             {
                 color=max(0.0,dot(dirToLight,vertNormal))*lightDiffuse[j];
             }
            diffuseL = vertColor*vec4(color,1.0);
         }
    }
    else {
        vec3 color=max(0.0,dot(-lightNormal[j],vertNormal))*lightDiffuse[j];
        diffuseL=vec4(color,1.0);
    }
        
    
    return diffuseL;
}

float shadow(vec4 shadowC,sampler2D shadowM)
{
    vec3 shadowCoordProj = shadowC.xyz/shadowC.w;
    float d1=shadowCoordProj.z;
    float visibility=1.0;
    for( int n=0;n<9;n++)
    {
        float d0=unpackDepth(texture2D(shadowM,shadowCoordProj.xy + poissonDisk[n] / 512.0));
        //step=gives 0 if texture < shadowCoordProj.z
        //and 1.0 otherwise
        visibility +=step(shadowCoordProj.z, d0);
    }
        
    return visibility;
}


void main() {

    
    vec4 spotVertColor=diffuse(1,0);
    vec4 dirVertColor=diffuse(0,1);
    
    float vs=shadow(shadowCoord,shadowMap);
    float vs2=shadow(shadowCoord2,shadowMap2);

    vec4 color=vec4(spotVertColor.rgb*vs*0.05556,spotVertColor.a);
    color+=vec4(dirVertColor.rgb*vs2*0.05556,dirVertColor.a);
    gl_FragColor =color;
    
    
    
}
