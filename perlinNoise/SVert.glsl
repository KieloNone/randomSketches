uniform mat4 transform;
uniform mat4 modelview;
uniform float time;
uniform mat4 texMatrix;

attribute vec4 vertex;
attribute vec4 color;
attribute vec2 texCoord;

varying vec4 vertTexCoord;
varying vec4 vertColor;
uniform sampler2D textureIn;

vec4 mountain(vec2 tex, vec4 position){
    vec4 positionOut=position;
    if((tex.x<0.5) && (tex.y>0.5)) 
    {
        float height=texture2D(textureIn,vertTexCoord.st).r;
        positionOut.y+=500.0*height;

    }
    return positionOut;
}


void main() {
        vertTexCoord = texMatrix*vec4(texCoord, 1.0,1.0);
        vec4 position = transform*vertex;
        position=mountain(texCoord, position);
        vertColor=color;
        gl_Position = position;

}

