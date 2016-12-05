#version 330
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
// the final pass
uniform vec3 lightDiffuse;
uniform vec3 lightNormal;
uniform sampler2D scene1;
uniform sampler2D depthS;


varying vec4 vertColor;
varying vec3 vertNormal;
varying vec2 vertTexCoord;
varying vec2 vertTexCoordDepth;
varying float depthZ;

void main(){
    //fetch colors from the previously rendered scene
    //reflection, this is a bit of a hack. I've used the unmodified texture coordinates
    //i.e. directly from undisturbed plane to create a bit wobbly reflection
    //in addition, the y-coordinate is "reversed" around the waterline to get reflection
    vec2 Rtex=vec2(vertTexCoord.x,0.65-vertTexCoord.y);
    vec4 R1=texture2D(scene1,Rtex);
    //refraction, just fetch the scene at the disturbed plane
    vec4 R2=texture2D(scene1,vertTexCoordDepth);
    //depth, just fetch the scene at the disturbed plane
    vec3 depth=texture2D(depthS,vertTexCoordDepth).rgb;
    //vertColor.a has the reflection coefficient of the water
    vec3 reflectColor=R1.rgb*vertColor.a;
    vec3 refractColor=R2.rgb*(1-vertColor.a)*depth;
    vec3 color=reflectColor+vertColor.rgb*refractColor;
    gl_FragColor=vec4(color,1.0-depthZ);

}
