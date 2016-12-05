#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_COLOR_SHADER

uniform sampler2D gradSampler;
uniform sampler2D permSampler;
varying vec2 bgCoord;
varying vec4 vertPosition;

float lerp(float a, float b, float x){
    return a+x*(b-a);
}


//0 at 0 and 1 at 1, nice little curve in between
vec3 fade(vec3 t) {
    return t * t * t * (t * (t * 6 - 15) + 10);
}

float grad(float x, vec3 p){
    vec3 aa=texture2D(gradSampler, vec2(x,0)).xyz;
    aa=(aa-0.5)*2;
    return dot(aa,p);
}

float perm(float x)
{
    float a=texture2D(permSampler,vec2(x/256,0)).r;
    return a*255.0;
}


float inoise3(vec3 p) {
    //calculating the unitcube for the point
    vec3 pi = mod(floor(p),256);//mod(floor(p),256);
    vec3 pf = fract(p);//p-floor(p);

    vec3 f = fade(pf);

    //hashing some random coordinates 
    //(randomly assigning one of the 16:n directional vectors to each four corners)
   
    float aaa = perm(perm(perm(pi.x)      + pi.y)     +pi.z)/256.0; 
    float aba = perm(perm(perm(pi.x)      + pi.y+1)  +pi.z)/256.0;
    float aab = perm(perm(perm(pi.x)      + pi.y)     +pi.z+1)/256.0;
    float abb = perm(perm(perm(pi.x)      + pi.y+1)   +pi.z+1)/256.0;
    float baa = perm(perm(perm(pi.x+1)    + pi.y)     +pi.z)/256.0;
    float bba = perm(perm(perm(pi.x+1)    + pi.y+1)   +pi.z)/256.0;
    float bab = perm(perm(perm(pi.x+1)    + pi.y)     +pi.z+1)/256.0;
    float bbb = perm(perm(perm(pi.x+1)    + pi.y+1)   +pi.z+1)/256.0;
    
    float x1 = lerp(grad(aaa,pf),                grad(baa,pf + vec3(-1.0,0,   0)), f.x);
    float x2 = lerp(grad(aba,pf+vec3(0,-1.0,0)), grad(bba,pf + vec3(-1.0,-1.0,0)), f.x);
    float y1 = lerp(x1,x2, f.y);
    x1 = lerp(grad(aab,pf+vec3(0,0, -1.0)),     grad(bab,pf + vec3(-1.0,0,-1.0  )), f.x);
    x2 = lerp(grad(abb,pf+vec3(0,-1.0,-1.0)),   grad(bbb,pf + vec3(-1.0,-1.0,-1.0)), f.x);
    float y2=lerp(x1,x2,f.y);
    
    return (lerp(y1,y2,f.z)+1.0)/2.0;
    //return lerp(y1,y2,f.z);

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
    float total=0.0;
    vec3 col;
   
    vec3 p=vertPosition.xyz;
    if(vertPosition.x < 5) {
        if(vertPosition.y>5) {
            total += warping1D(vec3(p.xy*0.004,p.z))*1.0;
            total += warping1D(vec3(p.xy*0.01,p.z))*0.5;
            total=total/1.5;
            col=vec3(total);
        }else {
            total = warping2D(vec3(p.xy*0.004,p.z), 2.0)*0.5;
            col=vec3(total*0.9,total,total*0.9);
            total = warping2D(vec3(p.xy*0.01,p.z),4.0)*0.7;
            col+=vec3(total);
            col=min(col,vec3(1.0));///1.5;
            //total += warping2D(p*0.04)*0.25;
            //total=total/1.5;
            //col=vec3(total);

        }
    } else {
        if( p.y> 5) {
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

    //there is a bug in my radeon gallium drivers related to for loops... (the one below does not work)
    //https://developer.blender.org/T48880

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

      //float aa=perlin(vec3(vertPosition.xy*0.01,vertPosition.z));
      gl_FragColor = simpleSum();//vec4(vec3(aa),1.0);

}

