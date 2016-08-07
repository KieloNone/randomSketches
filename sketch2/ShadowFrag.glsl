//from the interwebs

//putting desimals to the second value, maybe this gives us
//more room (is gl_FracColor from 0 to 255 or 0 to 1.0?
vec4 packDepth(float depth){
    float depthFrac = fract(depth*255.0);
    return vec4(depth-depthFrac/255.0,depthFrac,1.0,1.0);
}

void main(){
    gl_FragColor=packDepth(gl_FragCoord.z);
}
