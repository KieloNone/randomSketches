import moonlander.library.*;
import ddf.minim.*;

// Pointlight, ambient, diffuse and Blinn-Phong shading

Moonlander moonlander;
PShader toon; PShader toon2;
PShape s;

void setup(){
  moonlander = Moonlander.initWithSoundtrack(this, "data/Himatsu.mp3", 92, 8);
  size(840, 480, P3D); 
  noStroke();
  fill(204);
  toon = loadShader("Frag1.glsl", "Vert1.glsl");
  toon2 = loadShader("Frag2.glsl", "Vert2.glsl");
  toon.set("fraction", 1.0);
  toon2.set("fraction", 1.0);
  moonlander.start();
   s = loadShape("data/rinkula.obj");
   s.scale(30.0);
}

void draw()
{
  moonlander.update();
  float moon = moonlander.getIntValue("track1");
  background(0);
  shader(toon);
  toon.set("fraction", 100.0);
  koruinit(moon);
  
}

void koruinit(float moon)
{
   float moon2 = moonlander.getIntValue("track2");
    toon.set("fraction", 100.0);
    toon2.set("fraction", 100.0);
    lighting();
    lightFalloff(1.0, 1.0, 0);
    pointLight(35, 202, 126, moon, 40, -50);
    lightFalloff(0.5, 0.3, 0.1);
    pointLight(151, 102, 126, 435, 240, 36);
    
    
    pushMatrix();
      translate(moon,40,-50);
      sphere(5);
    popMatrix();
    
    
    pushMatrix();
      translate(435, 240, 36);
      sphere(5);
    popMatrix();
    
    pushMatrix();
      translate(0,240,0);
      box(10.0,600,600.0);
    popMatrix();
    
    pushMatrix();
      translate(800.0,240,0);
      box(10.0,600,600.0);
    popMatrix();
    
    pushMatrix();
      translate(400,420,0);
      box(800,10,600.0);
    popMatrix();
    
    pushMatrix();
      translate(420,240,-450);
      box(1000,600,600.0);
    popMatrix();
    
    pushMatrix();
    translate(200,200,0);
    sphere(40);
    popMatrix();

    pushMatrix();
    translate(600,200,0);
    rotateX(-45);
    sphere(40);
    popMatrix();

    if(moon2>10)
      resetShader();
    else
      shader(toon2);
    pushMatrix();
    translate(600,200,0);
    rotateX(-45);
    shape(s,0,0);
    popMatrix();
}

void lighting()
{
    float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), 
            cameraZ/10.0, cameraZ*10.0);
  //ambientLight(120,150,180);
  ambientLight(0,5.0,5.0);
  //spotLight(0, 255, 0, width/2, height/2, 400, 0, 0, -1, PI/4, 2);
  //directionalLight(255, 255, 100, 0, -1, 0);
}