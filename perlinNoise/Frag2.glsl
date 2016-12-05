#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_COLOR_SHADER


varying vec2 bgCoord;
varying vec4 vertPosition;

float lerp(float a, float b, float x){
    return a+x*(b-a);
}
//tutorials say, that this should be it's own texture...
//Hash lookup table as defined by Ken Perlin. 
//This is randomly arranged array of all numbers from 0-255 inclusive
uniform int permutation[256] = int[](
     151,160,137,91,90,15,131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
    190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
    88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
    77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
    102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
    135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
    5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
    223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
    129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
    251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
    49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
    138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
);

int getPermutation(float x){
    int xi = int(x);

    if(xi>255)
        xi=int(mod(xi,256));

    return permutation[xi];


}

uniform vec3 g[16] = vec3[](
  vec3(1,1,0),    vec3(-1,1,0),    vec3(1,-1,0),    vec3(-1,-1,0),
  vec3(1,0,1),    vec3(-1,0,1),    vec3(1,0,-1),    vec3(-1,0,-1),
  vec3(0,1,1),    vec3(0,-1,1),    vec3(0,1,-1),    vec3(0,-1,-1),
  vec3(1,1,0),    vec3(0,-1,1),    vec3(-1,1,0),    vec3(0,-1,-1)

);
uniform vec2 g2[4] = vec2[](
  vec2(1,1),    vec2(-1,1),    vec2(1,-1),    vec2(-1,-1)
);


float getGradient(float x, vec3 p) {
    int index=int(x*16);
    vec3 dir=g[index];
    return dot(dir,p);

}


float getGradient(float x, vec2 p) {
    int index=int(x*4);
    vec2 dir=g2[index];
    return dot(dir,p);

}


//0 at 0 and 1 at 1, nice little curve in between
vec3 fade(vec3 t) {
    return t * t * t * (t * (t * 6 - 15) + 10);
}

vec2 fade2(vec2 t) {
        return t * t * t * (t * (t * 6 - 15) + 10);
}

float inoise3(vec3 p) {
    //calculating the unitcube for the point
    vec3 pi = mod(floor(p),256);
    //calculating the position inside the unitcube
    vec3 pf = fract(p);//p-floor(p);

    vec3 f = fade(pf);

    //hashing some random coordinates 
    //(randomly assigning one of the 16:n directional vectors to each four corners)

    float aaa = getPermutation(getPermutation(getPermutation(pi.x)      + pi.y)     +pi.z)/255.0; 
    float aba = getPermutation(getPermutation(getPermutation(pi.x)      + pi.y+1)  +pi.z)/255.0;
    float aab = getPermutation(getPermutation(getPermutation(pi.x)      + pi.y)     +pi.z+1)/255.0;
    float abb = getPermutation(getPermutation(getPermutation(pi.x)      + pi.y+1)   +pi.z+1)/255.0;
    float baa = getPermutation(getPermutation(getPermutation(pi.x+1)    + pi.y)     +pi.z)/255.0;
    float bba = getPermutation(getPermutation(getPermutation(pi.x+1)    + pi.y+1)   +pi.z)/255.0;
    float bab = getPermutation(getPermutation(getPermutation(pi.x+1)    + pi.y)     +pi.z+1)/255.0;
    float bbb = getPermutation(getPermutation(getPermutation(pi.x+1)    + pi.y+1)   +pi.z+1)/255.0;
    
    float x1 = lerp(getGradient(aaa,pf),                getGradient(baa,pf + vec3(-1.0,0,   0)), f.x);
    float x2 = lerp(getGradient(aba,pf+vec3(0,-1.0,0)), getGradient(bba,pf + vec3(-1.0,-1.0,0)), f.x);
    float y1 = lerp(x1,x2, f.y);
    x1 = lerp(getGradient(aab,pf+vec3(0,0, -1.0)), getGradient(bab,pf + vec3(-1.0,0,-1.0  )), f.x);
    x2 = lerp(getGradient(abb,pf+vec3(0,-1.0,-1.0)), getGradient(bbb,pf + vec3(-1.0,-1.0,-1.0)), f.x);
    float y2=lerp(x1,x2,f.y);
    
    return (lerp(y1,y2,f.z)+1.0)/2.0;
    //return lerp(y1,y2,f.z);
}

float inoise2(vec2 p) {
    //calculating the unitcube for the point
    vec2 pi = mod(floor(p),256);
    vec2 pf = fract(p);

    vec2 f = fade2(pf);

    //hashing some random coordinates 
    //(randomly assigning one of the 16:n directional vectors to each four corners)

    float aa = getPermutation(getPermutation(getPermutation(pi.x)      + pi.y))/255.0;
    float ab = getPermutation(getPermutation(getPermutation(pi.x)      + pi.y+1))/255.0;
    float ba = getPermutation(getPermutation(getPermutation(pi.x+1)    + pi.y))/255.0;
    float bb = getPermutation(getPermutation(getPermutation(pi.x+1)    + pi.y+1))/255.0;

    float x1 = lerp(getGradient(aa,pf),                getGradient(ba,pf + vec2(-1.0, 0)), f.x);
    float x2 = lerp(getGradient(ab,pf+vec2(0,-1.0)), getGradient(bb,pf + vec2(-1.0,-1.0)), f.x);
    float y1 = lerp(x1,x2, f.y);

    return (y1+1.0)/2.0;
}


float warping1D(vec3 p){
    vec3 q = vec3(inoise3(p+vec3(0)),inoise3(p+vec3(5.2,1.3,0.0)),inoise3(p+vec3(1.7,9.2,2.0)));

    float total = inoise3(p+4.0*q);
    return total;
}

float warping2D(vec3 p, float a){
    vec3 q = vec3(inoise3(p+vec3(0)),inoise3(p+vec3(5.2,1.3,0.0)),inoise3(p+vec3(1.7,9.2,2.0)));
    vec3 r = vec3(inoise3(p+a*q+vec3(4.1,1.7,9.2)),
                  inoise3(p+a*q+vec3(8.3,2.8,1.4)),
                  inoise3(p+a*q+vec3(1.7,2.7,4.0)));

    float total = inoise3(p+a*r);
    return total;
}

vec4 simpleSum(){
    //some hardcoded values that look ok
    float total=0.0;
    vec3 col;
   
    vec3 p=vertPosition.xyz;
    if(vertPosition.x <= 5) {
       if(vertPosition.y>=5) {
            total += inoise2(p.xy*0.01)*1.0;
            total += inoise2(p.xy*0.02)*0.2;
            total += inoise2(p.xy*0.04)*0.1;
            total=total/1.3;
            col = vec3(total);


        }else {
            total += warping1D(vec3(p.xy*0.004,p.z))*1.0;
            total += warping1D(vec3(p.xy*0.01,p.z))*0.5;
            total=total/1.5;
            col=(vec3(0,0,0.5)+vec3(total))*0.7;

        }
    } else {
        if( p.y>= 5) {
            total += inoise3(vec3(p.xy*0.01,p.z))*1.0;
            total += inoise3(vec3(p.xy*0.02,p.z))*0.2;
            total += inoise3(vec3(p.xy*0.04,p.z))*0.1;
            total=total/1.3;
            col = vec3(0.3+total,0.3+total,1.3);
            col=col/1.3;
        } else {
            total = inoise3(vec3(p.xy*0.01,p.z))*1.0;
            total += inoise3(vec3(p.xy*0.04,p.z))*0.5;
            float xyValue=p.x*0.05+p.y*0.05+7.0*total;
            float col0=abs(sin(3.14*xyValue));
            total = inoise3(vec3(p.xy*0.005,p.z))*1.0;
            col0=(total+col0)*0.5;
            col=vec3(col0,0.3+col0,0.3+col0);
            col=col/1.1;
        }
 
    }

    //there is a bug in my radeon gallium drivers related to for loops... (therefore
    // the code below does not work)
    //see https://developer.blender.org/T48880

    /*
    for (int k=0; k<2; k++) {
        total += warping1D(p*frequency)*amplitude;//inoise3(vertPosition.xyz*frequency)*amplitude;
       // total += inoise3(p*frequency)*amplitude;
        maxValue+=amplitude;

        amplitude*=0.5;
        frequency*=2;
        index=k;

    }
    total=total/maxValue;
    */
    return vec4(col,1.0);


}



void main() {  

  gl_FragColor = simpleSum();  
}

