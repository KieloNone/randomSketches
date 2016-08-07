#version 330
uniform mat4 transform; //to camera space
uniform mat4 modelview; //to world space
uniform mat3 normalMatrix; //to world space
uniform mat4 shadowTransform; //to light space
uniform mat4 shadowTransform2; //to light space

attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;

varying vec4 vertColor;
varying vec4 shadowCoord;
varying vec4 shadowCoord2;
varying vec3 vertNormal;
varying vec4 vertPosition;

void main() {
    vertColor=color;
    vertPosition = modelview*vertex;
    vertNormal = normalize(normalMatrix*normal);
    //generally it is more efficient to compute dirToLight here?
    //however in this scene the results are not precise enough
    //dirToLight = normalize(lightPosition.xyz/lightPosition.w-vertPosition.xyz/vertPosition.w);
    shadowCoord = shadowTransform*(vertPosition +6.0*vec4(vertNormal,0.0));
    shadowCoord2 = shadowTransform2*(vertPosition +6.0*vec4(vertNormal,0.0));
    gl_Position = transform*vertex;
}
