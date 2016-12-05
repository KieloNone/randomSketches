uniform mat4 transform;
uniform mat4 modelview;
uniform float time;

attribute vec4 vertex;
attribute vec4 color;

varying vec2 bgCoord;
varying vec4 vertPosition;

vec2 getCoords(vec4 position){
    vec2 coord;
    coord.x=position.x/position.w*0.5+0.5;
    coord.y=position.y/position.w*0.5+0.5;
    return coord;
}



void main() {
    vec4 position = transform*vertex;
    gl_Position = position;
    bgCoord = getCoords(position);
    vertPosition=vec4(position.xy, time,1);//modelview*vertex;

}

