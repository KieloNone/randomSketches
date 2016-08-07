import moonlander.library.*;
import ddf.minim.*;

Moonlander moonlander;
PVector lightDir =new PVector();
PVector lightDir2 =new PVector();
PVector lightPos =new PVector();
float lightFOV;
PShader shadowShader; PShader defaultShader;PShader lightShader;
PGraphics shadowMap; PGraphics shadowMap2;

int cameraView=0;

void setup(){
  moonlander = Moonlander.initWithSoundtrack(this, "../sketch1/data/Himatsu.mp3", 92, 8);
  size(840, 480, P3D); 
  initShadowPass();
  initDefautPass();
  lightShader=loadShader("lightSource.glsl");
  moonlander.start();
  
  lightDir2.x= -1.0; lightDir2.y=1.0; lightDir2.z=-0.1;
  lightDir2.normalize();
}

void draw()
{
  moonlander.update();
  float moon = moonlander.getIntValue("track1");
  lightDir.x= 1.0; lightDir.y=1.0; lightDir.z=0.0;
  lightDir.normalize();
  lightPos.x= moon;lightPos.y=40.0;lightPos.z=0.0;
  lightFOV=PI*0.35;
  
  shadowMap.beginDraw();
  shadowMap.camera(lightPos.x, lightPos.y, lightPos.z,(lightPos.x+lightDir.x), (lightPos.y+lightDir.y), (lightPos.z+lightDir.z), 0,1,0 );
  float cameraZ = (height/2.0) / tan(lightFOV/2.0);
  //camera FOV is the total opening angle
  shadowMap.perspective(2.0*lightFOV, float(width)/float(height), cameraZ/10.0, cameraZ*10.0);
  shadowMap.background(0xffffffff); // Will set the depth to 1.0 (maximum depth)
  renderLandscape(shadowMap,false);
  shadowMap.endDraw();
  shadowMap.updatePixels();
  
  //parameters for shadowmap and different canvas:
  //shadowMap2 = createGraphics(2048, 2048, P3D);
  //canvas.camera(500,-10,0,500+lightDir2.x,-10+lightDir2.y,0+lightDir2.z,0,1,0);
  //canvas.ortho(-400, 400, -500, 500, 10, 900);
  //
  shadowMap2.beginDraw();
  shadowMap2.camera(400,0, 50,(400+lightDir2.x), (0+lightDir2.y), (50+lightDir2.z), 0,1,0 );
  shadowMap2.ortho(-400, 400, -500, 500, 10, 900);
  shadowMap2.background(0xffffffff); // Will set the depth to 1.0 (maximum depth)
  renderLandscape(shadowMap2,false);
  shadowMap2.endDraw();
  shadowMap2.updatePixels();
 
 shader(defaultShader);
  // Update the shadow transformation matrix and send it, the light
  // direction normal and the shadow map to the default shader.
  updateDefaultShader();
 
  // Render default pass
  background(0);
  renderLandscape(g,true);
  shader(lightShader);
  
  pushMatrix();
    fill(255);
    translate(lightPos.x, lightPos.y, lightPos.z);
    sphere(5);
  popMatrix();
  
  
}

void renderLandscape(PGraphics canvas,boolean defaultPass)
{
  float moon2 = moonlander.getIntValue("track2");
  if(defaultPass)
  {
    //
    float cameraZ = (height/2.0) / tan(lightFOV/2.0);
    if(moon2>10 || (cameraView==1))
    {
       canvas.perspective(lightFOV*2.0, float(width)/float(height), 
            cameraZ/10.0, cameraZ*10.0);
       //lightFOV is opening angle (not the total cone angle)
      canvas.camera(lightPos.x, lightPos.y, lightPos.z,(lightPos.x+lightDir.x), (lightPos.y+lightDir.y), (lightPos.z+lightDir.z), 0,1,0 );
      
    }
      else if(cameraView==0)
      {
      canvas.camera();
      canvas.perspective(PI/2.5, float(width)/float(height), 
            cameraZ/10.0, cameraZ*10.0);
      }
      else
      {
        //canvas.camera(800,200,-100,800+lightDir2.x,200+lightDir2.y,-100+lightDir2.z,0,1,0);
        //canvas.ortho(-400, 400, -200, 200, 10, 400);
        canvas.camera(400,0,0,400+lightDir2.x,0+lightDir2.y,0+lightDir2.z,0,1,0);
        canvas.ortho(-400, 400, -500, 500, 10, 900);
      }
      canvas.spotLight(200, 255, 245, lightPos.x, lightPos.y, lightPos.z,lightDir.x,lightDir.y,lightDir.z,lightFOV,cos(lightFOV*0.5));
      canvas.directionalLight(200,255,200,lightDir2.x,lightDir2.y,lightDir2.z);
  }
    
    
    //canvas.pushMatrix();
    //  canvas.translate(moon,40,-50);
    //  canvas.sphere(5);
    //canvas.popMatrix();
    
    
    canvas.pushMatrix();
      canvas.translate(435, 240, 36);
      canvas.sphere(5);
    canvas.popMatrix();

    canvas.pushMatrix();
      canvas.translate(0,240,0);
      fill(200,255,200);
      canvas.box(10.0,600,600.0);
    canvas.popMatrix();
    
    canvas.pushMatrix();
      canvas.translate(800.0,240,0);
      canvas.box(10.0,600,600.0);
    canvas.popMatrix();
    
    canvas.pushMatrix();
      canvas.translate(400,420,0);
      canvas.box(800,10,600.0);
    canvas.popMatrix();
    
    canvas.pushMatrix();
      canvas.translate(420,240,-200);
      canvas.box(1000,600,10.0);
    canvas.popMatrix();
  
    canvas.pushMatrix();
    fill(200,200,255);
    canvas.translate(200,200,0);
    canvas.sphere(40);
    canvas.popMatrix();

    canvas.pushMatrix();
    canvas.translate(600,200,0);
    canvas.rotateX(-45);
    canvas.sphere(40);
    canvas.popMatrix();
    

}

public void keyPressed() {
    if(key != CODED) {
        if(key >= '0' && key < '3')
            cameraView = key - '0';
    }
}

void initShadowPass()
{
  //For spotlight
  shadowShader=loadShader("ShadowFrag.glsl", "ShadowVert.glsl");
  shadowMap = createGraphics(2048, 2048, P3D);
  shadowMap.noSmooth(); // Antialiasing on the shadowMap leads to weird artifacts
  //shadowMap.loadPixels(); // Will interfere with noSmooth() (probably a bug in Processing)
  shadowMap.beginDraw();
  shadowMap.noStroke();
  shadowMap.shader(shadowShader);
  shadowMap.endDraw();
  
  //For directional light
  shadowMap2 = createGraphics(2048, 2048, P3D);
  shadowMap2.noSmooth(); // Antialiasing on the shadowMap leads to weird artifacts
  shadowMap2.beginDraw();
  shadowMap2.noStroke();
  shadowMap2.shader(shadowShader); //testing whether you can use the same shader with different PGraphics object
  shadowMap2.ortho(-200, 200, -200, 200, 10, 400); // Setup orthogonal view matrix for the directional light
  shadowMap2.endDraw();
  
}

void initDefautPass()
{
    defaultShader=loadShader("defaultFrag.glsl", "defaultVert.glsl");
    shader(defaultShader);
    noStroke();
    float fov = PI/3.0;
    float cameraZ = (height/2.0) / tan(fov/2.0);
    perspective(fov, float(width)/float(height), 
            cameraZ/10.0, cameraZ*10.0);
    
}

//copy from interwebs
void updateDefaultShader() {
 
  //This function is copied from interwebs
  
    // Bias matrix to move homogeneous shadowCoords into the UV texture space
    //EM: i.e. linearly move point from range [-1,1] to range [0,1]
    PMatrix3D shadowTransform = new PMatrix3D(
        0.5, 0.0, 0.0, 0.5, 
        0.0, 0.5, 0.0, 0.5, 
        0.0, 0.0, 0.5, 0.5, 
        0.0, 0.0, 0.0, 1.0
    );
   PMatrix3D shadowTransform2 = new PMatrix3D(
        0.5, 0.0, 0.0, 0.5, 
        0.0, 0.5, 0.0, 0.5, 
        0.0, 0.0, 0.5, 0.5, 
        0.0, 0.0, 0.0, 1.0
    );
   
   
    // Apply project modelview matrix from the shadow pass (light direction)
    // EM: (i.e. the worldSpace transformation matrix which transform the vertex to light coordinates)
    shadowTransform.apply(((PGraphicsOpenGL)shadowMap).projmodelview);
    shadowTransform2.apply(((PGraphicsOpenGL)shadowMap2).projmodelview);
 
    // Apply the inverted modelview matrix from the default pass to get the original vertex
    // positions inside the shader. This is needed because Processing is pre-multiplying
    // the vertices by the modelview matrix (for better performance).
    //EM: is not strictly needed if you write your own vertex shader (and if you assume vertex normals are at the beginning in 
    //vertex space
    PMatrix3D modelviewInv = ((PGraphicsOpenGL)g).modelviewInv;
    shadowTransform.apply(modelviewInv);
    shadowTransform2.apply(modelviewInv);
 
    // Convert column-minor PMatrix to column-major GLMatrix and send it to the shader.
    // PShader.set(String, PMatrix3D) doesn't convert the matrix for some reason.
    // EM: This is most probably just ^T?
    defaultShader.set("shadowTransform", new PMatrix3D(
        shadowTransform.m00, shadowTransform.m10, shadowTransform.m20, shadowTransform.m30, 
        shadowTransform.m01, shadowTransform.m11, shadowTransform.m21, shadowTransform.m31, 
        shadowTransform.m02, shadowTransform.m12, shadowTransform.m22, shadowTransform.m32, 
        shadowTransform.m03, shadowTransform.m13, shadowTransform.m23, shadowTransform.m33
    ));
    
        defaultShader.set("shadowTransform2", new PMatrix3D(
        shadowTransform2.m00, shadowTransform2.m10, shadowTransform2.m20, shadowTransform2.m30, 
        shadowTransform2.m01, shadowTransform2.m11, shadowTransform2.m21, shadowTransform2.m31, 
        shadowTransform2.m02, shadowTransform2.m12, shadowTransform2.m22, shadowTransform2.m32, 
        shadowTransform2.m03, shadowTransform2.m13, shadowTransform2.m23, shadowTransform2.m33
    ));

    // Send the shadowmap to the default shader
    defaultShader.set("shadowMap", shadowMap);
    defaultShader.set("shadowMap2", shadowMap2);
 
}