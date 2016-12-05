#version 330
uniform mat4 transform;
attribute vec4 vertex;

varying vec2 bgCoord;

vec2 getCoords(vec4 position){
    vec2 coord;
    coord.x=position.x/position.w*0.5+0.5;
    coord.y=position.y/position.w*0.5+0.5;
    return coord;
}


void main() {
    vec4 position=transform*vertex;
    bgCoord=getCoords(position);
    gl_Position=position;
}

