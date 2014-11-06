import java.util.ArrayList;

SpaceShip player; 
ArrayList<Asteroid> objects;
ArrayList<Bullet> bullets;
Asteroid test;
int savedTime, totalTime, elapsed, visibleObjects;


public void setup() 
{
  size(600, 600);
  started=false;
  gameOver=false;
  textAlign(CENTER);
  textSize(36);
  player = new SpaceShip(width/2, height/2);
  objects = new ArrayList<Asteroid>();
  bullets = new ArrayList<Bullet>();
  totalTime=1000;
  savedTime=millis();
  visibleObjects=0;
}

public void draw() 
{
  background(0);
  if(started==false){
    for(int i=0; i<difficulty; i++){
      objects.add(new Asteroid(Math.random()*width, Math.random()*height, 45, 3));
    }
    visibleObjects=objects.size();
    if(difficulty>0){
        started=true;
    }
  }
  if(started==true){
    text("Lives: "+str(player.getLives()), 100, 50);
    for(int i = player.getLives(); i>0; i--){
      pushMatrix();
      translate(i*25+50, 75);
      beginShape();
      vertex(-4,-8);
      vertex(0, 8);
      vertex(4, -8);
      vertex(0, -2);
      endShape(CLOSE);
      popMatrix();
    }
    int playerY = player.getY();
    int playerX = player.getX();
    elapsed = millis()-savedTime;
    if(visibleObjects<objects.size()-1 && elapsed>totalTime){
      visibleObjects+=1;
      savedTime=millis();
    }
    if(visibleObjects>objects.size()-1){
      visibleObjects=objects.size()-1;
    }
    for(int i=visibleObjects; i>0; i--){
      Asteroid asteroid = objects.get(i);
      asteroid.move();
      asteroid.show();
      int selfX = asteroid.getX();
      int selfY = asteroid.getY();
      for(int n=bullets.size()-1; n>0; n--){
        Bullet bullet = bullets.get(n);
        int bulletX = bullet.getX();
        int bulletY = bullet.getY();
        if(bulletY<selfY+30 && bulletY>selfY-30 && bulletX<selfX+30 && bulletX>selfX-30){
          asteroid.hit(i);
          bullets.remove(n);
        }
      }
      if(playerY<selfY+30 && playerY>selfY-30 && playerX<selfX+30 && playerX>selfX-30){
        player.hit();
      }
    }
    if(keyPressed==true){
      switch(str(key)){
        case moveUp:
          player.accelerate(0.1);
          break;
        case moveRight:
          player.rotate(-5);
          break;
        case moveLeft:
          player.rotate(5);
          break;
      }
    }
    for(int i=bullets.size()-1; i>0; i--){
      Bullet bullet = bullets.get(i);
      bullet.move();
      bullet.show();
      boolean died = bullet.checkLifespan();
      if(died==true){
        bullets.remove(i);
      }
    }
    player.move();
    player.show();
    if(player.getLives()<0){
      background(0);
      text("Game Over", width/2, height/2);
      gameOver=true;
    }
    if(objects.size()-1==0){
      background(0);
      text("You Won!", width/2, height/2);
      gameOver=true;
    }
  }
  if(gameOver==true){
      //alert(rePlay);
    if(rePlay==true){
        //alert('replay');
        replay();
        rePlay=false;
    }
  }
}
public void keyReleased(){
  if(key==' '){
    double dir = player.getPointDirection();
    bullets.add(new Bullet(player.getX(), player.getY(), dir));
  }
}
class SpaceShip extends Floater  
{   
  private int lives;
    SpaceShip(double xPos, double yPos){
      lives=3;
      corners = 4;
      xCorners = new int[corners];
      yCorners = new int[corners];
      xCorners[0] = -8;
      yCorners[0] = -8;
      xCorners[1] = 16;
      yCorners[1] = 0;
      xCorners[2] = -8;
      yCorners[2] = 8;
      xCorners[3] = -2;
      yCorners[3] = 0;
      myCenterX=xPos;
      myCenterY=yPos;
      myDirectionX=0;
      myDirectionY=0;
      myPointDirection=0;
      myColor = 255;
    }
  public void setX(int x){myCenterX=x;};  
  public int getX(){return (int)myCenterX;};   
  public void setY(int y){myCenterY=y;};   
  public int getY(){return (int)myCenterY;};   
  public void setDirectionX(double x){myDirectionX=x;};   
  public double getDirectionX(){return myDirectionX;};   
  public void setDirectionY(double y){myDirectionY=y;};   
  public double getDirectionY(){return myDirectionY;};   
  public void setPointDirection(int degrees){myPointDirection=degrees;};   
  public double getPointDirection(){return myPointDirection;};
  public int getLives(){return lives;}; 
  public void setLives(int l){lives=l;};
  public void hit(){
    this.setX(width/2);
    this.setY(height/2);
    this.setDirectionX(0);
    this.setDirectionY(0);
    lives--;
  }
}


abstract class Floater //Do NOT modify the Floater class! Make changes in the SpaceShip class 
{   
  protected int corners;  //the number of corners, a triangular floater has 3   
  protected int[] xCorners;   
  protected int[] yCorners;   
  protected int myColor;   
  protected double myCenterX, myCenterY; //holds center coordinates   
  protected double myDirectionX, myDirectionY; //holds x and y coordinates of the vector for direction of travel   
  protected double myPointDirection; //holds current direction the ship is pointing in degrees    
  abstract public void setX(int x);  
  abstract public int getX();   
  abstract public void setY(int y);   
  abstract public int getY();   
  abstract public void setDirectionX(double x);   
  abstract public double getDirectionX();   
  abstract public void setDirectionY(double y);   
  abstract public double getDirectionY();   
  abstract public void setPointDirection(int degrees);   
  abstract public double getPointDirection(); 

  //Accelerates the floater in the direction it is pointing (myPointDirection)   
  public void accelerate (double dAmount)   
  {          
    //convert the current direction the floater is pointing to radians    
    double dRadians =myPointDirection*(Math.PI/180);     
    //change coordinates of direction of travel    
    myDirectionX += ((dAmount) * Math.cos(dRadians));    
    myDirectionY += ((dAmount) * Math.sin(dRadians));       
  }   
  public void rotate (int nDegreesOfRotation)   
  {     
    //rotates the floater by a given number of degrees    
    myPointDirection+=nDegreesOfRotation;   
  }   
  public void move ()   //move the floater in the current direction of travel
  {      
    //change the x and y coordinates by myDirectionX and myDirectionY       
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;     

    //wrap around screen    
    if(myCenterX >width)
    {     
      myCenterX = 0;    
    }    
    else if (myCenterX<0)
    {     
      myCenterX = width;    
    }    
    if(myCenterY >height)
    {    
      myCenterY = 0;    
    }   
    else if (myCenterY < 0)
    {     
      myCenterY = height;    
    }   
  }   
  public void show ()  //Draws the floater at the current position  
  {             
    fill(myColor);   
    stroke(myColor);    
    //convert degrees to radians for sin and cos         
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for(int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI]* Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI]* Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated,yRotatedTranslated);    
    }   
    endShape(CLOSE);  
  }   
} 


class Asteroid extends Floater {
  private int myRotate;
  private int myStage;
  private float size;
  Asteroid(double xPos, double yPos, float wid, int stage){
    size = wid;
    myStage = stage;
    corners = 8;
    xCorners = new int[corners];
    yCorners = new int[corners];
    xCorners[0] = (int)(-size+(int)(Math.random()*20-10));
    yCorners[0] = 0+(int)(Math.random()*20-10);
    xCorners[1] = (int)(-size/3*2+(int)(Math.random()*20-10));
    yCorners[1] = (int)(-size/3*2+(int)(Math.random()*20-10));
    xCorners[2] = 0+(int)(Math.random()*20-10);
    yCorners[2] = (int)(-size+(int)(Math.random()*20-10));
    xCorners[3] = (int)(size/3*2+(int)(Math.random()*20-10));
    yCorners[3] = (int)(-size/3*2+(int)(Math.random()*20-10));
    xCorners[4] = (int)(size+(int)(Math.random()*20-10));
    yCorners[4] = 0+(int)(Math.random()*20-10);
    xCorners[5] = (int)(size/3*2+(int)(Math.random()*20-10)); 
    yCorners[5] = (int)(size/3*2+(int)(Math.random()*20-10));
    xCorners[6] = 0+(int)(Math.random()*20-10);
    yCorners[6] = (int)(size+(int)(Math.random()*20-10));
    xCorners[7] = (int)(-size/3*2+(int)(Math.random()*20-10));
    yCorners[7] = (int)(size/3*2+(int)(Math.random()*20-10));
    myCenterX=xPos;
    myCenterY=yPos;
    myDirectionX=Math.random()*3+0.5;
    myDirectionY=Math.random()*3+0.5;
    myPointDirection=0;
    myColor = 255;
    myRotate = (int)(Math.random()*2+1);
  }
  public void setX(int x){myCenterX=x;};  
  public int getX(){return (int)myCenterX;};   
  public void setY(int y){myCenterY=y;};   
  public int getY(){return (int)myCenterY;};   
  public void setDirectionX(double x){myDirectionX=x;};   
  public double getDirectionX(){return myDirectionX;};   
  public void setDirectionY(double y){myDirectionY=y;};   
  public double getDirectionY(){return myDirectionY;};   
  public void setPointDirection(int degrees){myPointDirection=degrees;};   
  public double getPointDirection(){return myPointDirection;};
  public void hit(int n){
    myStage-=1;
    if(myStage>0){
      size = size/2;
      objects.remove(n);
      objects.add(n, new Asteroid(myCenterX, myCenterY, size, myStage));
      objects.add(n+1, new Asteroid(myCenterX, myCenterY, size, myStage));
    } else{
      objects.remove(n);
    }
    
  }
  public void move(){
   this.rotate(myRotate);
   myCenterX += myDirectionX;    
   myCenterY += myDirectionY;     

     //wrap around screen    
     if(myCenterX >width)
     {     
       myCenterX = 0;    
     }    
     else if (myCenterX<0)
     {     
       myCenterX = width;    
     }    
     if(myCenterY >height)
     {    
       myCenterY = 0;    
     }   
     else if (myCenterY < 0)
     {     
       myCenterY = height;    
   }
 }   
}



class Bullet extends Floater {
  private double dRadians;
  private float lifespan, time;
  Bullet(double xPos, double yPos, double direction){
    dRadians=direction*(Math.PI/180);
    corners = 3;
    xCorners = new int[corners];
    yCorners = new int[corners];
    xCorners[0] = -2;
    yCorners[0] = -2;
    xCorners[1] = 2;
    yCorners[1] = 0;
    xCorners[2] = -2;
    yCorners[2] = 2;
    myCenterX=xPos;
    myCenterY=yPos;
    myDirectionX=6*Math.cos(dRadians);
    myDirectionY=6*Math.sin(dRadians);
    myPointDirection=direction;
    myColor = 255;
    lifespan=1000;
    time=millis();
  }
  public void setX(int x){myCenterX=x;};  
  public int getX(){return (int)myCenterX;};   
  public void setY(int y){myCenterY=y;};   
  public int getY(){return (int)myCenterY;};   
  public void setDirectionX(double x){myDirectionX=x;};   
  public double getDirectionX(){return myDirectionX;};   
  public void setDirectionY(double y){myDirectionY=y;};   
  public double getDirectionY(){return myDirectionY;};   
  public void setPointDirection(int degrees){myPointDirection=degrees;};   
  public double getPointDirection(){return myPointDirection;}; 
  public boolean checkLifespan(){
    if(millis()-time>lifespan){
      return true;
    } else {
      return false;
    }
  }
}

class Button {
  private int x, y, len, wid;
  private String value;
  private boolean clicked;
  Button(int xpos, int ypos, int len1, int wid1, String val){
    x=xpos;
    y=ypos;
    len=len1;
    wid=wid1;
    value = val;
    clicked=false;
  }
  public void show(){
    strokeWeight(1);
    textAlign(CENTER);
    textSize(16);
    stroke(0);
    fill(#D3E3DF);
    rectMode(CORNER);
    rect(x, y, len, wid, 4);
    fill(0);
    text(value, x+wid/2*3, y+15);
    rectMode(CENTER);
  }
  public Boolean checkForMouse(){
    if(mousePressed==true){
      if(mouseX>x && mouseX<x+len && mouseY>y && mouseY<y+wid){
        clicked=true;
        started=true;
      } else {
        clicked=false;
      }
    }
    return clicked;
  }
  public void unClick(){
    clicked=false;
  }
}

public void replay(){
  objects.clear();
  bullets.clear();
  savedTime=millis();
  visibleObjects=0;
  player.setDirectionX(0);
  player.setDirectionY(0);
  player.setPointDirection(0);
  player.setX(width/2);
  player.setY(height/2);
  player.setLives(3);
  started=false;
}