#version 330
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform vec3 lightNormal;
uniform mat4 modelview;
uniform float time;

layout (location = 0) in vec4 vertex;
layout (location = 1) in vec4 color;
layout (location = 2) in vec3 normal;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 ecVertex;
varying vec3 ocVertex;
varying vec3 dirToLight;
varying float shadowIntensity;

vec4 sinewave() {
    vec4 vert=vertex;
    vec2 v=normalize(vert.xz);
    float aa=1.1;
    float bb=1.0;
    // let's make the "ripples" of the hem
    if(vert.y>=-50){
        float height=max((vert.y+50),0);
        //the hem gets wider when we move downwards
        aa=(110.0+0.07*height*cos(10.0*acos(v.x)))/100.0;
        //adding sinewave to the hem
        bb=(1.0+0.1*height*sin(time+vert.y));

    }
    //creating "shadows" to the hem
    shadowIntensity=min(aa*4.7-4.165,1.0);
    vert.z=vert.z*aa;
    vert.x=(vert.x+bb)*aa;
    
    return vert;
}



void main() {
    vec4 vert= sinewave();
    vertNormal=normalize(normalMatrix*normal);
    ecVertex=vec3(modelview*vert);
    ocVertex=vert.xyz;
    vertColor=color;
    gl_Position = transform*vert;

}

