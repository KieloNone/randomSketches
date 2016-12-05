#version 330
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform vec3 lightNormal;
uniform mat4 modelview;


uniform float time;
uniform float dirX[9];
uniform float dirY[9];
uniform float amplitude[9];
uniform float frequency[9];
uniform float speed[9];
uniform int numWaves;
uniform float Q;


layout (location = 0) in vec4 vertex;
layout (location = 1) in vec4 color;
layout (location = 2) in vec3 normal;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec2 vertTexCoord;
varying vec2 vertTexCoordDepth;
varying float depthZ;

float reflectance(vec3 n, vec3 v) {
    float cosi=dot(n,v);
    float sini=sqrt(1.0-cosi*cosi);
    float sint=1.0/1.33*sini;
    float cost=sqrt(1.0-sint*sint);

    //s and p polarized waves
    float rs=(cosi-1.33*cost)/(cosi+1.33*cost);
    float rp=(cost-1.33*cosi)/(cost+1.33*cosi);
    float R=(rs*rs+rp*rp)*0.5;
    return R;
}

vec3 gerstnerWave(vec2 pos, float wj, float thetat,int j){
    float sis=wj*dot(vec2(dirX[j],dirY[j]), pos)+thetat;
    float cosj=cos(sis);
    float sinj=sin(sis);
    vec3 waveout;
    //float Qj=Q/(wj*amplitude[j]*numWaves);
    waveout.x=Q/numWaves*dirX[j]*cosj;
    waveout.z=Q/numWaves*dirY[j]*cosj;
    waveout.y=amplitude[j]*sinj;
    return waveout;


}
vec3 gerstnerN(vec2 pos, float wj, float thetat,int j){
    float sis=wj*dot(vec2(dirX[j],dirY[j]), pos)+thetat;
    float cosj=cos(sis);
    float sinj=sin(sis);
    vec3 waveout;
    waveout.x=dirX[j]*wj*amplitude[j]*cosj;
    waveout.z=dirY[j]*wj*amplitude[j]*cosj;
    waveout.y=Q/numWaves*sinj;
    return waveout;


}


vec3 wave(vec3 pos){
    vec3 P=vec3(0);
    vec3 N=vec3(0);
    for (int j=0; j< 9; j++){
        float wj=frequency[j];
        float thetat=speed[j]*wj*time;
        P=P+gerstnerWave(pos.xz, wj, thetat,j);
    }
    P.x=P.x+pos.x;
    P.z=P.z+pos.z;

    for (int j=0; j<9;j++){
         float wj=frequency[j];
         float thetat=speed[j]*wj*time;
         N=N-gerstnerN(P.xz, wj, thetat,j);

    }
    N.y=1.0+N.y;

    vertNormal = normalize(normalMatrix*N);
    return P;

}

vec2 getCoords(vec4 position){
    vec2 coord;
    coord.x=position.x/position.w*0.5+0.5;
    coord.y=position.y/position.w*0.5+0.5;
    return coord;
}


void main() {
    vertColor=color;
    //disturbing the plane to create wave like behaviour
    vec3 P= wave(vertex.xyz);

    vec3 ecVert=normalize(vec3(modelview*vec4(P,1)));
    float R=reflectance(vertNormal, -normalize(vec3(0.0,0.0,0.0)-ecVert));
    vertColor=vec4(color.xyz,R);
    vec4 position=transform*vec4(P,vertex.w);
    vec4 position2=transform*vertex;

    gl_Position = position;
    vertTexCoord=getCoords(position2);
    vertTexCoordDepth=getCoords(position);
    //makes the water "fade in" to the background
    depthZ=max(0,(position2.z-1200.0))/200;

}

