#version 330
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform vec3 lightNormal;
uniform float fraction; // input parameter from processing
uniform mat4 modelview; // to camera space
uniform mat4 texMatrix;

attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 ecVertex;
varying float fractionIn;
varying vec3 dirToLight;
varying vec4 vertTexCoord;

void main() {
    gl_Position = transform*vertex;
    vertColor = color;
    fractionIn=fraction;
    vertNormal=normalize(normalMatrix*normal);
    ecVertex=vec3(modelview*vertex);
    vertTexCoord = texMatrix*vec4(texCoord, 1.0,1.0);

}

