//import moonlander.library.*;
//import ddf.minim.*;

//Bloom/Glow filter based on:
// http://http.developer.nvidia.com/GPUGems/gpugems_ch21.html and http://learnopengl.com/?_escaped_fragment_=Advanced-Lighting/Bloom#!Advanced-Lighting/Bloom

//Moonlander moonlander;
PShader defaultShaderO; PShader bloom1Shader;PShader gaussianBlurShader; PShader finalShader;
PShader tex;
PGraphics bloom1; PGraphics gaussianBlur; PGraphics defaultSO;
PShape s1;PShape s2;
PVector screenSize =new PVector();
PImage testi;
float t=0;

void setup(){
  //moonlander = Moonlander.initWithSoundtrack(this, "data/peippolaulaa.mp3", 92, 8);
  size(840, 480, P3D); 
  screenSize.x=840;screenSize.y=480;
  noStroke();
  //moonlander.start();
  initBloomShaders();
  s1 = loadShape("data/testi.obj");
  s1.scale(60.0);
  s2 = loadShape("data/testi2.obj");
  s2.scale(60.0);
     
}

void draw()
{
  //moonlander.update();
  //float moon = moonlander.getIntValue("track1");
  //drawing(moon);
  drawing(t);
  t+=0.1;

  
}

void drawing(float moon)
{

  //render default scene
  defaultSO.beginDraw();
  skene(defaultSO, moon,true);
  defaultSO.endDraw();
  defaultSO.updatePixels();
  
  //render the scene, where you will add bloom
  //in my case I have used the opacity of the texture as a parameter how much the part in the texture 
  // should have bloom
  bloom1.beginDraw();
  skene(bloom1, moon,false);
  bloom1.endDraw();
  bloom1.updatePixels();
  
  
  //add gaussian blur to the texture to be bloomed (this will create the bloom effect)
  gaussianBlurShader.set("scene", bloom1);
  gaussianBlurShader.set("horizontal",true);
  gaussianBlur.beginDraw();
  bgshading(gaussianBlur);
  gaussianBlur.endDraw();
  gaussianBlur.updatePixels();
  
  gaussianBlurShader.set("scene", gaussianBlur);
  gaussianBlurShader.set("horizontal",false);
  gaussianBlur.beginDraw();
  bgshading(gaussianBlur);
  gaussianBlur.endDraw();
  gaussianBlur.updatePixels();
  
  
  //combine the default scene and bloom scene
  finalShader.set("scene",defaultSO);
  finalShader.set("bloomBlur",gaussianBlur);
  shader(finalShader);
  bgshading(g);
  
  
  
}

void skene(PGraphics canvas, float moon,boolean defaultPass)
{
    if(defaultPass){
    canvas.ambientLight(200,200,200);
}
  
  canvas.background(0);
  canvas.pushMatrix();
    canvas.translate(220,240,0);
    canvas.rotateY(moon/50.0*2*PI);
    canvas.rotateX(PI);
    canvas.shape(s1,0,0);
  canvas.popMatrix();
  
    canvas.pushMatrix();
    canvas.translate(620,240,0);
    canvas.rotateY(moon/50.0*2*PI);
    canvas.rotateX(PI);
    canvas.shape(s2,0,0);
  canvas.popMatrix();
}



void bgshading(PGraphics canvas)
{
  canvas.pushMatrix();
  canvas.rect(0.0,0.0,screenSize.x,screenSize.y);
  canvas.popMatrix();
}

void initBloomShaders()
{
  gaussianBlurShader=loadShader("gaussianBlurFrag.glsl","gaussianBlurVert.glsl");
  gaussianBlur=createGraphics((int)screenSize.x,(int)screenSize.y,P3D);
  gaussianBlur.beginDraw();
  gaussianBlur.noStroke();
  gaussianBlur.shader(gaussianBlurShader);
  gaussianBlur.endDraw();
  
  bloom1Shader=loadShader("Bloom1Frag.glsl");
  bloom1=createGraphics((int)screenSize.x,(int)screenSize.y,P3D);
  bloom1.beginDraw();
  bloom1.noStroke();
  bloom1.shader(bloom1Shader);
  bloom1.endDraw();
  
  defaultShaderO=loadShader("TexFrag.glsl","TexVert.glsl");
  defaultSO=createGraphics((int)screenSize.x,(int)screenSize.y,P3D);
  defaultSO.beginDraw();
  defaultSO.noStroke();//
  defaultSO.shader(defaultShaderO);
  defaultSO.endDraw();
  
  finalShader=loadShader("finalFrag.glsl","gaussianBlurVert.glsl");
}