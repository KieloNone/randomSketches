//import moonlander.library.*;
//import ddf.minim.*;

float a=0;

PShader shader1; PShader shader2;PShader shader3; PShader shader4;
PGraphics grad; PGraphics permutation; PGraphics shade;
PVector cameraPos;PVector cameraPos0;
int mode=1;
PShape mountain; PShape sky;PShape water;

// http://http.developer.nvidia.com/GPUGems2/gpugems2_chapter26.html
// https://flafla2.github.io/2014/08/09/perlinnoise.html
// and especially:
// http://www.iquilezles.org/www/articles/warp/warp.htm

//toggle between the pure perlin noise and it's implementation with '0' and '1'

void setup(){
  size(840, 840, P3D);
  //textureWrap(REPEAT);
  shader1=loadShader("Frag2.glsl","Vert.glsl");
  //initTextures();
  shader4=loadShader("SFrag.glsl","SVert.glsl");
  initShaders();
  PVector colorIn=new PVector(255,255,240);
  mountain=createGrid(701, 701, 1000, 1000, 0, 0.51,colorIn,260.0);
  colorIn.z=255;
  sky=createGrid(71, 71, 1200, 1200, 0.51, 0.51,colorIn,260.0);
  water=createGrid(31, 31, 120, 120, 0, 0,colorIn,260);
  cameraPos=new PVector(width/2,height/2,(height/2.0) / tan(PI*30.0 / 180.0));
  cameraPos0=new PVector(width/2,height/2,(height/2.0) / tan(PI*30.0 / 180.0));
  
  

}

void draw()
{
  // Render default pass
  shader3.set("time",a);
  if(mode==0){
    camera();
    noStroke();
    //shader1.set("gradSampler",grad);
    //shader1.set("permSampler",permutation);
    shader(shader3);
    rect(0.0,0.0,840,840);
    save("temp.png");
  }else{
    
    shade.beginDraw();
    shade.rect(0.0,0.0,840,840);
    shade.endDraw();
    shade.updatePixels();
    
    shader4.set("textureIn", shade);
    float lightFOV=PI/3.0;
    float cameraZ = (height/2.0) / tan(lightFOV/2.0);
    perspective(lightFOV, float(width)/float(height), cameraZ/10.0, cameraZ*10.0);
       //lightFOV is opening angle (not the total cone angle)
    camera(cameraPos.x, cameraPos.y, cameraPos.z,cameraPos.x+width/2-cameraPos0.x, cameraPos.y+height-cameraPos0.y, cameraPos.z-cameraPos0.z, 0,1,0 );
    shader(shader4);
    background(0);
    
    

    pushMatrix();
      translate(-200,860,700);
      shape(mountain);
    popMatrix();

    
    pushMatrix();
       //translate(-500,-600,-500);
       translate(-200,0,-200);
       rotateX(0.5*PI);
       shape(sky);
    popMatrix();
    
    pushMatrix();
      translate(270,760,270);
      shape(water);
    popMatrix();
  
    pushMatrix();
      translate(270,790,440);
      scale(1.5);
      rotateX(-PI/15.0);
      shape(water);
    popMatrix();
    
    pushMatrix();
      translate(300,785,500);
      shape(water);
    popMatrix();
    
    
  }
  
  a+=0.01;
  //cameraPos.z=-170+(height/2) / tan(PI*30.0 / 180.0)*(1+0.1*sin(a));
  

  
}

void initTextures(){
   //TODO: this function creates the "randomly distributed numbers" and 
   //writes them to 2D textures, but there are still some bugs and therefore
   //this code is not currently in use
  
  shader2=loadShader("PointFrag.glsl", "PointVert.glsl");
  float[] gradV = {  
  1,1,0,    -1,1,0,    1,-1,0,    -1,-1,0,
  1,0,1,    -1,0,1,    1,0,-1,    -1,0,-1,
  0,1,1,    0,-1,1,    0,1,-1,    0,-1,-1,
  1,1,0,    0,-1,1,    -1,1,0,    0,-1,-1};
  grad=createGraphics(16,1,P2D);
  //grad.shader(shader2);
  //shader2.set("flag", 1);
  grad.beginDraw();

  grad.strokeWeight(2);
  for (int j=0; j<16; j++){
    grad.stroke(gradV[j*3]*255.0,gradV[j*3+1]*255.0,gradV[j*3+2]*255.0);
    grad.point(j,0);
  }
  grad.endDraw();
  grad.updatePixels();
  

  float[] permV={151,160,137,91,90,15,131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
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
};
  
    //shader2.set("flag", -1);
    permutation=createGraphics(256,1,P2D);
    //permutation.shader(shader2);
    permutation.beginDraw();
    permutation.strokeWeight(2);
    for (int j=0; j<256; j++){
      permutation.stroke(permV[j]);
      permutation.point(j,0);
    }
    
    permutation.endDraw();
    permutation.updatePixels();
    
    
}
public void keyPressed(){
  if(key !=CODED){
    if(key == '0') {
      mode=0;
    } else if (key=='1') {
      mode=1;
    }
  }
}

PShape createGrid( int nx, int ny, float x, float y, float ustart, float vstart, PVector colorIn, float alpha) {
  PShape sh = createShape();
  sh.beginShape(TRIANGLES);
  sh.noStroke();
  if(alpha> 255)
    sh.fill(colorIn.x,colorIn.y, colorIn.z);
    else
    sh.fill(colorIn.x,colorIn.y, colorIn.z,alpha);
    

  float stepx = x/nx;
  float stepy = y/ny;
  float stepu = 0.48/nx;
  float stepv = 0.48/ny;
  
  for (int yi=0; yi<(ny-1); yi++) {
    for (int xi = 0; xi <= (nx-1); xi++) {
  
      
      
      sh.normal(0, -1, 0);
      sh.vertex(xi*stepx,     0, -yi*stepy,     ustart+xi*stepu,      vstart+yi*stepv);
      sh.vertex((xi+1)*stepx, 0, -yi*stepy,     ustart+(xi+1)*stepu,  vstart+yi*stepv);
      sh.vertex(xi*stepx,     0, -(yi+1)*stepy, ustart+xi*stepu,      vstart+(yi+1)*stepv);
      
      sh.vertex(xi*stepx, 0, -(yi+1)*stepy,     ustart+xi*stepu,     vstart+(yi+1)*stepv);
      sh.vertex((xi+1)*stepx, 0, -yi*stepy,     ustart+(xi+1)*stepu, vstart+yi*stepv);
      sh.vertex((xi+1)*stepx, 0, -(yi+1)*stepy, ustart+(xi+1)*stepu, vstart+(yi+1)*stepv);
      
    }
  }
  sh.endShape(); 
  return sh;
}


void initShaders(){
  shader3=loadShader("Frag2.glsl", "Vert.glsl");
  shade=createGraphics(840,840,P3D);
  shade.beginDraw();
  shade.noStroke();
  shade.shader(shader3);
  shade.endDraw();

  
}


    