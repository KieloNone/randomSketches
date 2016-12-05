#version 330
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform vec3 lightNormal;
uniform float fraction;
uniform mat4 modelview;

layout (location = 0) in vec4 vertex;
layout (location = 1) in vec4 color;
layout (location = 2) in vec3 normal;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 ecVertex;
varying float fractionIn;
varying vec3 dirToLight;

void main() {
    gl_Position = transform*vertex;
    vertColor = color;
    fractionIn=fraction;
    vertNormal=normalize(normalMatrix*normal);
    ecVertex=vec3(modelview*vertex);

}

