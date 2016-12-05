uniform mat4 transform;
uniform mat4 texMatrix;
uniform mat4 modelview;

uniform sampler2D heightmap;
uniform int depthOn;


attribute vec4 vertex;
attribute vec4 color;
attribute vec2 texCoord;

varying vec4 vertColor;
varying vec2 vertTexCoord;
varying float depth;




void main() {
    //getting texture coordinates
    vertTexCoord = (texMatrix*vec4(texCoord, 1.0,1.0)).xy;
    //reading shore hight from texture
    float height=texture2D(heightmap,vertTexCoord).r;
    //distubing the plane with the hight read from the    //texture
    vec4 tempVert=vec4(vertex.x,vertex.y-600.0*height,vertex.zw);
    vec4 position = transform*tempVert;
    gl_Position = position;

    vertColor=color;
    
    //calculating the distance from the surface of the water
    //to the bottom of the river or the distance from the
    //screen to the hills
    //some hardcoded numbers to make the scene look ok
    if(depthOn >0){
        vec4 posMV=modelview*tempVert;
        depth=1.0-(posMV.y-260.0)/230.0;
    }
    else {
         depth=1.0-max(0,(position.z-1300.0))/400;

    }
    gl_Position = position;

}

