//import moonlander.library.*;
//import ddf.minim.*;

//Moonlander moonlander;

//2D Splines

//The program will start with planc line, use '+' and '-' keys to move between points 
//and mouse to put the points in different places in the screen.
//Use 's' to save current spline to "testi.txt" and 'l' to load the last saved spline.
//There are a few ready made spline things here. These can be accessed via 'a', 'i' and 'k'.
//These will appear with solid lines, you can move back to point presentation with 'd'


int N=73;
int steps=20;
int N2=N*steps;
PVector[] P=new PVector[N];
PVector[] P2=new PVector[N];
PVector[] Pnew=new PVector[N];
PVector[] Spline=new PVector[N2];
PImage kala;
int Pind = 0;
int time=0;
float time2=0;

int flag=1;

void setup(){
  //moonlander = Moonlander.initWithSoundtrack(this, "../sketch1/data/Himatsu.mp3", 92, 8);
  size(840, 480, P3D); 
  //moonlander.start();
  background(0);
  initVectors();
  CRP(P,Spline);
  kala=loadImage("data/kala.png");
  
}

void draw()
{
  clear();
  //moonlander.update();
  background(0);
  //float moon = moonlander.getIntValue("track1");
  if(flag==0)
  {
    //drawing the spline
    stroke(255);
    strokeWeight(2);
      for (int j=0;j<N2;j++)
    {
      point(Spline[j].x,Spline[j].y);
    }
    stroke(255,0,0);
    for (int j=0;j<N;j++)
    {
      point(P[j].x,P[j].y);
    }
    strokeWeight(4);
    stroke(255,100,0);
    point(P[Pind].x,P[Pind].y);
  }
  //the rest of these are for the animations
  else if(flag==1)
  {
    stroke(255);
    strokeWeight(2);
    for (int j=0;j<(time-65);j++)
    {
      //point(Spline[j].x,Spline[j].y);
      line(Spline[j].x,Spline[j].y,Spline[j+1].x,Spline[j+1].y);
    }
    
    if(time<N2-1)
      time=time+5;
     if(time>N2)
       time=N2;
  }
  else if(flag==2)
  {
    stroke(255);
    strokeWeight(2);
    for(int j=0;j<N;j++)
    {
      Pnew[j].x=time2*P2[j].x+(1.0-time2)*P[j].x;
      Pnew[j].y=time2*P2[j].y+(1.0-time2)*P[j].y;
    }
    CRP(Pnew,Spline);
    
    for (int j=0;j<(N2-65);j++)
    {
      line(Spline[j].x,Spline[j].y,Spline[j+1].x,Spline[j+1].y);
    }
    
    time2+=0.005;
    if(time2>1.0)
      time2=1.0;
    
  }
  else 
  {
    stroke(255);
    strokeWeight(2);
    for (int j=0;j<(N2-65);j++)
    {
      line(Spline[j].x,Spline[j].y,Spline[j+1].x,Spline[j+1].y);
    }
    
    stroke(0,255,0);
    strokeWeight(2);
    
    /*
    stroke(255,1,1);
    strokeWeight(5);
    point(Spline[time].x,Spline[time].y);
    if(time>100)
      point(Spline[time-100].x,Spline[time-100].y);
    */
    float col=1;
    float col2=1;
    if(time>100)
    {
      col=Spline[time].x-Spline[time-100].x;
      col2=Spline[time].y-Spline[time-100].y;
      col=col/sqrt(col*col+col2*col2);
    //col2=col2/sqrt(col*col+col2*col2);
    }
    
    strokeWeight(2);
    for(int j=1;j<101;j++)
    {
     if(time-j<0)
        break;
      stroke(0,0,255);
      line(Spline[time-j].x,Spline[time-j].y,Spline[time-j+1].x,Spline[time-j+1].y);
    }
    for(int j=1;j<50;j++)
    {
      if(time-j-100<0)
        break;
      
      stroke(5.0*j,5.0*j,255);
      line(Spline[time-j-100].x,Spline[time-j-100].y,Spline[time-j+1-100].x,Spline[time-j+1-100].y);
    }
    
    pushMatrix();
      translate(Spline[time].x,Spline[time].y,0);
      if(col2>0)
        rotateZ(acos(col));
      else
        rotateZ(-acos(col));
        image(kala,-70,-70,70,70);
    popMatrix();
    if(col2>0)
      time=time+2;
      else
      time=time+1;
    if(time>N2-65)
      time=N2-65;
  }
}

public void keyPressed(){
  if(key !=CODED){
    if(key == '+')
      Pind++;
    else if(key=='-')
       Pind--;
    else if (key=='s')
        saveSpline("testi.txt");
    else if (key=='l')
    {
         loadSpline("testi.txt",P);
         CRP(P,Spline);
    }
    else if(key=='a')
    {
        time =0;
        flag=1;
        loadSpline("helloWorld.txt",P);
        CRP(P,Spline);
    }
    else if (key=='d')
        flag=0;
    else if(key=='i')
       {
         flag=2;
         time2=0.0;
         loadSpline("helloWorld.txt",P);
         CRP(P,Spline);
         
         loadSpline("maasto.txt",P2);
         P2[0].x=-300;
         P2[1].x=-100;
         P2[2].x=0;
         P2[N-1].x=1100;
         P2[N-2].x=1000;
         CRP(P2,Spline);
       }
    else if(key=='k')
       {
         
         flag=3;
         loadSpline("maasto.txt",P2);
         P2[0].x=-300;
         P2[1].x=-100;
         P2[2].x=0;
         P2[N-1].x=1100;
         P2[N-2].x=1000;
         CRP(P2,Spline);
         time=0;
       }   
      
  }
}

public void mousePressed(){
  P[Pind].x=mouseX; P[Pind].y=mouseY;
  CRP(P,Spline);
}

void initVectors()
{
  for (int j=0; j<N; j++){
    P[j]=new PVector();
    P2[j]=new PVector();
    Pnew[j]=new PVector();
    P[j].x=j*840.0/N;
    //P[j].y=j*480.0/N;
    P[j].y=240.0;
  }
  
  for (int j=0;j<N2;j++){
    Spline[j]=new PVector();
  }
}

// This one will be called, if you wish to create bezier curves
void BezierP(PVector[] Pin,PVector[] SplineIn)
{
  //NOTE P.size should be 3n+1!
  int NN=(N-1)/3;
  for (int j=0;j<NN;j++){
    PVector[] temp=coreBezier(Pin[3*j],Pin[3*j+1],Pin[3*j+2],Pin[3*j+3],steps);
    for(int k=0;k<steps;k++)
    {
      SplineIn[j*steps+k]=temp[k];
    }
  }
}

//this will be called if one want's to use Catmull-Rom splines
void CRP(PVector[] Pin, PVector SplineIn[])
{
  //NOTE P.size should be 3n+1!
  for (int j=0;j<N-3;j++){
    PVector[] temp=coreCR(Pin[j],Pin[j+1],Pin[j+2],Pin[j+3],steps);
    for(int k=0;k<steps;k++)
    {
      SplineIn[j*steps+k]=temp[k];
    }
  }
}



//this is the core routine for the bezier curves
PVector[] coreBezier(PVector p0,PVector p1,PVector p2,PVector p3, int stepsin){
  PVector[] curve = new PVector[steps];
  float tstep=1.0/(float)stepsin;
  float t=0.0;
  for (int j = 0; j< stepsin; j++)
  {
    //better done with matrix algebra. TODO: how to use matrixes in processing
    float ti=t; float ti2=ti*ti; float ti3=ti*ti2;
    //Bernstein polynomials (for Bezier)
    
    float B0=1.0-3.0*ti+3.0*ti2-ti3;
    float B1=3.0*ti-6.0*ti2+3.0*ti3;
    float B2=3.0*ti2-3.0*ti3;
    float B3=ti3;
    
    
    //B-spline
    /*
    float B0=(1.0-3.0*ti+3.0*ti2-ti3)*0.1666666;
    float B1=(4.0-6.0*ti2+3.0*ti3)*0.1666666;
    float B2=(1.0+3.0*ti+3.0*ti2-3.0*ti3)*0.1666666;
    float B3=ti3*0.1666666;
    */
    //
    curve[j]=new PVector();
    curve[j].x=B0*p0.x+B1*p1.x+B2*p2.x+B3*p3.x;
    curve[j].y=B0*p0.y+B1*p1.y+B2*p2.y+B3*p3.y;
    
    //print(j, " ", ti, "\n");
    t=t+tstep;
  }
  
  return curve;
}

//core routine for catmull-rom type spline curve
PVector[] coreCR(PVector p0,PVector p1,PVector p2,PVector p3, int stepsin){
  PVector[] curve = new PVector[steps];
  float tstep=1.0/(float)stepsin;
  float t=0.0;
  for (int j = 0; j< stepsin; j++)
  {
    //better done with matrix algebra. TODO: how to use matrixes in processing
    float ti=t; float ti2=ti*ti; float ti3=ti*ti2;

    //Catmull-Rom polynomials (for splines that interpolate the control points)
    float B0=(-ti+2.0*ti2-ti3)*0.5;
    float B1=(2.0-5.0*ti2+3.0*ti3)*0.5;
    float B2=(ti+4.0*ti2-3.0*ti3)*0.5;
    float B3=(-ti2+ti3)*0.5;

    curve[j]=new PVector();
    curve[j].x=B0*p0.x+B1*p1.x+B2*p2.x+B3*p3.x;
    curve[j].y=B0*p0.y+B1*p1.y+B2*p2.y+B3*p3.y;
    
    //print(j, " ", ti, "\n");
    t=t+tstep;
  }
  
  return curve;
}

void saveSpline(String filename)
{
  String[] data = new String[N];
  for(int j=0; j<N;j++)
  {
    data[j]=str(P[j].x)+","+str(P[j].y);
  }
  saveStrings(filename, data);
}

void loadSpline(String filename,PVector[] Pin)
{
  String[] lines = loadStrings(filename);
  int Ntemp=lines.length;
  if(Ntemp>N)
    Ntemp=N;
  for(int j=0; j<Ntemp; j++)
  {
    String[] temp=split(lines[j],",");
    Pin[j].x=float(temp[0]);
    Pin[j].y=float(temp[1]);
  }
  
}