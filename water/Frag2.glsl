varying vec2 vertTexCoord;
varying vec4 vertColor;
varying float depth;
uniform int depthOn;
uniform sampler2D heightmap;

void main() {
    float
    color=vec4(texture2D(heightmap,vertTexCoord).rgb,1).r;
    color=max(0.40,color);

    if(depthOn < 1){
        // in this case draw the hills with hardcoded color
        // and make them more opaque when moving further
        // away from the screen
        gl_FragColor=vec4(vec3(color),depth)*vec4(0.9,0.9,0.8,1.0);
        }
    else {
        //output the depth value
        gl_FragColor=vec4(vec3(depth),1);
        }
}

