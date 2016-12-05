import moonlander.library.*;
import ddf.minim.*;

//this uses the perlin noise created in perlinNoise
//the main point of this sketch is to create water

//http://http.developer.nvidia.com/GPUGems/gpugems_ch01.html
//http://www.jayconrod.com/posts/34/water-simulation-in-glsl
//http://blog.bonzaisoftware.com/tnp/gl-water-tutorial/

float a=0;
PGraphics scene1;PGraphics depth1;
PShader shader1;PShader shader2;
PShape grid;
PShape shore;
PImage shoreImg;

int numWaves = 9;
float[] dirx=new float[numWaves];
float[] diry=new float[numWaves];
float[] amplitude=new float[numWaves];
float[] f=new float[numWaves];
float[] speed=new float[numWaves];

void setup(){
  size(840, 480, P3D);
  
  shader1=loadShader("Frag.glsl","Vert.glsl");
  shader2=loadShader("Frag2.glsl","Vert2.glsl");
  //grid=createGrid(301,301,840,1000);
  grid=createGrid(701,701,2000,1000);
  shore=createGrid(701,701,2000,1000);
  shoreImg=loadImage("shore.png");
  preset();
  

}

void draw(){
  clear();
  //this could be done with fewer shader passes, if I'd know how to make
  //processing to write to multiple output textures simultaneously 
  shader2.set("heightmap",shoreImg);
  shader2.set("depthOn",0);
  scene1.beginDraw();
  scene1.background(150,200,255);
  scene1.translate(-1000,-100,-200);
  scene1.scale(1.5,1);
  scene1.translate(0,860,0);
  scene1.shape(shore);
  scene1.endDraw();
  scene1.updatePixels();
  
  shader2.set("depthOn",1);
  depth1.beginDraw();
  depth1.translate(-1000,-100,-200);
  depth1.scale(1.5,1);
  depth1.translate(0,860,0);
  depth1.shape(shore);
  depth1.endDraw();
  depth1.updatePixels();
  
  background(150,200,255);
  shader2.set("depthOn",0);
  shader(shader2);
  pushMatrix();
  translate(-1000,-100,-200);
  scale(1.5,1);
  translate(0,860,0);
  shape(shore);
  popMatrix();
  
  
  shader(shader1);
  shader1.set("Q",0.01);
  shader1.set("dirX",dirx);
  shader1.set("dirY",diry);
  shader1.set("amplitude",amplitude);
  shader1.set("speed",speed);
  shader1.set("frequency",f);
  shader1.set("time",a);
  shader1.set("numWaves",numWaves);
  shader1.set("scene1",scene1);
  shader1.set("depthS",depth1);

  directionalLight(200,200,200,0,-1,0);
  pushMatrix();
  translate(-800,500,0);
  scale(1.5,1);
  shape(grid);
  popMatrix();



  a+=0.005;
}


void preset(){
  float g=9.8;
  float Lmed=30000;
  float Amed=1.5;
  float AperL=Amed/Lmed;
  float angle0=0.1*PI;
  float angleD=PI;
  for (int j=0; j<numWaves;j++){
    float angle=angleD+random(-angle0,angle0);
    dirx[j]=cos(angle);
    diry[j]=-sin(angle);
    float temp=random(0,1);
    float L=Lmed*(3.0/2.0*temp+0.5);
    amplitude[j]=AperL*L;
    float k=2*PI/L;
    //deep water dispersion relation
    f[j]=sqrt(g*k);
    speed[j]=f[j]/k;
  }
  
  scene1=createGraphics(840,480,P3D);
  scene1.beginDraw();
  scene1.noStroke();
  scene1.shader(shader2);
  scene1.endDraw();
  
  depth1=createGraphics(840,480,P3D);
  depth1.beginDraw();
  depth1.noStroke();
  depth1.shader(shader2);
  depth1.endDraw();
}

PShape createGrid( int nx, int ny, float x, float y) {
  PShape sh = createShape();
  sh.beginShape(TRIANGLES);
  sh.noStroke();
  //sh.fill(0,180,255);
  sh.fill(200,200,255);

  float stepx = x/nx;
  float stepy = y/ny;
  
  float stepu=1.0/nx;
  float stepv=1.0/nx;
  
  for (int yi=0; yi<(ny-1); yi++) {
    for (int xi = 0; xi <= (nx-1); xi++) {
  
      
      sh.normal(0, -1, 0);
      sh.vertex(xi*stepx, 0, -yi*stepy,  xi*stepu, yi*stepv);
      sh.vertex((xi+1)*stepx, 0, -yi*stepy,  (xi+1)*stepu, yi*stepv);
      sh.vertex(xi*stepx, 0, -(yi+1)*stepy,  xi*stepu, (yi+1)*stepv);
      
      sh.vertex(xi*stepx, 0, -(yi+1)*stepy,  xi*stepu, (yi+1)*stepv);
      sh.vertex((xi+1)*stepx, 0, -yi*stepy,  (xi+1)*stepu, yi*stepv);
      sh.vertex((xi+1)*stepx, 0, -(yi+1)*stepy,  (xi+1)*stepu, (yi+1)*stepv);
      
    }
  }
  sh.endShape(); 
  return sh;
}