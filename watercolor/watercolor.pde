//import moonlander.library.*;
//import ddf.minim.*;
PShape s;
float a=0;float b=0;
boolean flag=true;
PGraphics scene;PShader sceneShader;
PImage tex1;PImage tf;PImage pd;
PShader finalShader;
PVector screenSize =new PVector();

//watercolor effect based on A. Bousseau et. al "Interactive watercolor rendering with temporal coherence and abstraction"
//see attachments


//the pigment_distortion.jpeg and turbulent_flow.jpeg are from internet

void setup(){
  size(840, 480, P3D);
  screenSize.x=840;screenSize.y=480;
  noStroke();
  s=createCan(100,200,300);
  initShaders();
  tex1=loadImage("data/akvarelli_002.png");
  //the following two textures are stolen from google image search
  //TODO: create your own noise for turbulent flow and pigment distortion
  tf=loadImage("data/turbulent_flow.jpeg");
  pd=loadImage("pigment_distortion.jpeg");
  
  
}
void draw(){
    scene.beginDraw();
    sceneShader.set("time",b);
    drawScene(scene);
    scene.endDraw();
    scene.updatePixels();
   
    finalShader.set("scene",scene);
    finalShader.set("tex1",tex1);
    finalShader.set("pd",pd);
    finalShader.set("tf",tf);
    shader(finalShader);
    bgshading(g);
    
    
    if(flag){
    a+=0.003;
    if(a>PI/4)
      flag=false;
  }
  else{
    a-=0.003;
    if(a<-PI/4)
      flag=true;
  }
  b+=0.05;
  
}

void drawScene(PGraphics canvas)
{
  canvas.clear();
  canvas.ambientLight(100,100,100);
  canvas.pointLight(150, 150, 150, 500, 50, 200);

  
  canvas.pushMatrix();
  canvas.translate(400,250,0);
  canvas.rotateY(a);
  canvas.shape(s);
  canvas.popMatrix();
   
  
}

void bgshading(PGraphics canvas)
{
  canvas.clear();
  canvas.pushMatrix();
  canvas.rect(0.0,0.0,screenSize.x,screenSize.y);
  canvas.popMatrix();
}

void initShaders()
{
  sceneShader=loadShader("Frag1.glsl", "Vert1.glsl");
  scene=createGraphics((int)screenSize.x,(int)screenSize.y,P3D);
  scene.beginDraw();
  scene.noStroke();
  scene.shader(sceneShader);
  scene.endDraw();
  
  finalShader=loadShader("finalFrag.glsl","Vert2.glsl");
}

PShape createCan(float r, float h, int detail) {
  //stolen from tutorial =)
  //creating a can with halfsphere hat
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  sh.fill(180,255,255);
    float anglei = TWO_PI / detail;
  float anglej = PI / 20.0;

  for (int j=0; j<9; j++) {
    for (int i = 0; i <= detail; i++) {
      float x = sin(i * anglei);
      float z = cos(i * anglei);
      float y = sin(j*anglej);
      float r1=r*cos(j*anglej);
      float x2 = sin((i+1) * anglei);
      float z2 = cos((i+1) * anglei);
      float y2 = sin((j+1)*anglej);
      float r2 = r*cos((j+1)*anglej);
      sh.normal(x, -y*r/r1, z);
      sh.vertex(x * r1, -h/2-y*r, z * r1);
      sh.normal(x2, -y2*r/r2, z2);
      sh.vertex(x2 * r2, -h/2-y2*r, z2 * r2);
    }
  }

  int hi=8;
  //sh.texture(tex);
  float angle = TWO_PI / detail;
  for (int j=0; j<hi;j++){
    float aa=-h/2.0+h*float(j)/float(hi);
    float bb=-h/2.0+h*float(j+1)/float(hi);
    for (int i = 0; i <= detail; i++) {
      float x = sin(i * angle); 
      float z = cos(i * angle);
      float u = float(i) / detail;
      sh.normal(x, 0, z);
      sh.vertex(x * r, aa , z * r,u,0);
      sh.vertex(x * r, bb, z * r,u,1);
    }
    print(aa+"\n");
  }
  sh.endShape(); 
  return sh;
}