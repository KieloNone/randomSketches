#version 330

out vec4 FragColor;

uniform sampler2D scene;
uniform sampler2D tex1;
uniform sampler2D pd;
uniform sampler2D tf;
varying vec2 bgCoord;

//I wanted to do all in just 2 different fragment shaders, so I needed to hardcode 
//the background colors

//for adding the textures
float modifyColor(float C,float d){
    float Cout=C-(C-C*C)*(d-1.0);
    return Cout;
}

//adding background color (hard coded)
vec3 colorOut(vec4 color){
    vec3 colorO =color.rgb+vec3(0.9,0.9,0.85)*(1.0-color.a);
    return colorO;

}

vec3 addTexture(vec3 color, sampler2D tex ){
    vec3 T=texture2D(tex,bgCoord).rgb;
    float beta=1.0;
    float d=1.0+beta*(T.r-0.5);
    vec3 colorOut;
    colorOut.r=modifyColor(color.r,d);
    colorOut.g=modifyColor(color.g,d);
    colorOut.b=modifyColor(color.b,d);

    return colorOut;
}

//distortion based on the watercolor canvas
vec2 distortion(){
    //TODO: check the coordinates to be ok
    
    vec2 T;
    T.x=texture2D(tex1,bgCoord).r-texture2D(tex1,vec2(bgCoord.x-2.0*0.00147,bgCoord.y)).r;
    T.x+=texture2D(tex1,bgCoord).r-texture2D(tex1,vec2(bgCoord.x+2.0*0.00147,bgCoord.y)).r;
    T.y=texture2D(tex1,bgCoord).r-texture2D(tex1,vec2(bgCoord.x,bgCoord.y-2.0*0.002)).r;
    T.y+=texture2D(tex1,bgCoord).r-texture2D(tex1,vec2(bgCoord.x,bgCoord.y+2.0*0.002)).r;

    vec2 coord;
    coord.x=bgCoord.x+0.005*T.x;
    coord.y=bgCoord.y+0.0068*T.y;
    return coord;
}

float edgeDarkening(vec2 dP,vec2 Coord){
    //this might be better done in another pass...
    vec3 colorp=colorOut(texture2D(scene,Coord+dP));
    vec3 colorm=colorOut(texture2D(scene,Coord-dP));
    vec3 grad = colorp-colorm;
    return
    1.0-(abs(grad.r)+abs(grad.g)+abs(grad.b))/3.0;

}


void main(){
    
    //moving the coordinates based on canvas depth
    vec2 dCoord=distortion();
    
    vec4 sceneColor=texture2D(scene,dCoord);
    vec3 color = vec3(0.1);
    color=sceneColor.rgb*edgeDarkening(vec2(0.00147,0.002),dCoord);
    color=addTexture(color,pd);
    color=addTexture(color,tf);
    //adding background color
    color+=vec3(0.9,0.9,0.85)*(1.0-sceneColor.a);
    color=addTexture(color,tex1);
    FragColor=vec4(color,1.0);

}

