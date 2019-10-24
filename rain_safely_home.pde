/*
  Name: Eva Yan
  Class: Game Programming I
  Professor: Professor Chung
  Title: Midterm Game - "Rain Safely Home"
  Date: Thurs, October 24
*/

//Name and initialize variables here
//Obstacle vars
ArrayList<Raincloud> rainclouds = new ArrayList<Raincloud>(); 

//Player vars
Player myPlayer;

//UI/Graphics
PFont healthFont;
PFont startFont;
PImage[] drops = new PImage[11];
int score;
UI thisUI;

//Goal
color myGoalColor = color(0, 255, 17);
Goal myGoal = new Goal(780, 780, myGoalColor);

//Lightning
ArrayList<LightningLine> lightningLines = new ArrayList<LightningLine>();
float lightningChance;
ArrayList<Raincloud> raincloudsLeftToBeStruck = new ArrayList<Raincloud>();

//Key input vars for player movement
boolean dirUp;
boolean dirDown;
boolean dirLeft;
boolean dirRight;

//Game States
boolean hasStarted = false;
boolean hasStartedGameOnce = false;
boolean isGameover = false;

//Sound
import processing.sound.*;
SoundFile bgm;
String bgmName = "bg.wav";
String path;

void setup() {
  size(800, 800); //cannot be a variable 
  surface.setTitle("Rain Safely Home");
    
  //sound
  path = sketchPath(bgmName);
  bgm = new SoundFile(this, path);
  bgm.play();
  bgm.loop();
  
  startFont = createFont("dpcomic.regular.ttf", 90);
  DrawStartScreen();
}

void draw () {
  //Start button has not been clicked, so display the Start screen
  if(!hasStarted) {
    CheckStartScreen();
    DrawStartScreen();
  }
  
  //Start button has been clicked, so display the game
  else {
    //Make sure to setup the game and initiate everything once
    if(!hasStartedGameOnce) {
      SetupGame();
    }
    
    //After initiation complete, go into the regular game draw cycle
    else if (hasStarted) {
      //Prep goes here
      Prep();
      
      //Enemy/Obstacle functions go here
      MoveAllRainclouds();
      MoveAllRainbugs();
      DrawAllRainclouds();
      DrawTheLightningLines();
      
      //Take keyboard inputs
      ReadAndPassToPlayer();
      //Draw myPlayer at new location after it gets inputs and moves in response
      myPlayer.DrawPlayer();
      
      //Draw goal
      myGoal.DisplaySelf();
      
      //Cleanup goes here
      Cleanup();
    }
  }
  
  if(isGameover) {
    CheckGameoverScreen();
    DrawGameoverScreen();
  }
}

void SetupGame() {
  background(50);
    
  //player
  myPlayer = new Player(20, 20, 20, 500);

  
  //UI
  healthFont = createFont("Cheri.TTF", 32);
  score = 0;
  thisUI = new UI();
  
  //Rainclouds
  CreateRainclouds();
  drops[0] = loadImage("rain00.gif");
  drops[1] = loadImage("rain01.gif");
  drops[2] = loadImage("rain02.gif");
  drops[3] = loadImage("rain03.gif");
  drops[4] = loadImage("rain04.gif");
  drops[5] = loadImage("rain05.gif");
  drops[6] = loadImage("rain06.gif");
  drops[7] = loadImage("rain07.gif");
  drops[8] = loadImage("rain08.gif");
  drops[9] = loadImage("rain09.gif");
  drops[10] = loadImage("rain10.gif");
  
  for(int i = 0; i < rainclouds.size(); i++) {
    Raincloud r = rainclouds.get(i);
    r.initialTimeSpawn = millis();
  }
    
  //Lightning
  //Initiate the arraylist of rainclouds still left o be struck with the full list of rainclouds
  for(int i = 0; i < rainclouds.size(); i++) {
    raincloudsLeftToBeStruck.add(rainclouds.get(i));
  }
 
  hasStartedGameOnce = true;
}

//Occurs before everything
void Prep() {
  //Clear background
  //background(235); //currently just solid light grey
  background(50);
}

//Occurs after everything
void Cleanup() {
  thisUI.display("health");
  thisUI.display("score");
  CheckIfGameIsOver();
}

//Key inputs and movement functions go under here
void keyPressed() {
  //Player movement
  if (key == 'W' || key == 'w') { dirUp = true; } 
  if (key == 'S' || key == 's') { dirDown = true; }
  if (key == 'A' || key == 'a') { dirLeft = true; }
  if (key == 'D' || key == 'd') { dirRight = true; }
}

void keyReleased()
{
  //Player movement
  if (key == 'W' || key == 'w')
    dirUp = false;
  if (key == 'S' || key == 's')
    dirDown = false;
  if (key == 'A' || key == 'a')
    dirLeft = false;
  if (key == 'D' || key == 'd')
    dirRight = false;
}

void ReadAndPassToPlayer() {
  PVector directionToMovePlayer = new PVector();
  
  if (dirUp) 
    directionToMovePlayer.y -= 1; 
  if (dirDown) 
    directionToMovePlayer.y += 1; 
  if (dirLeft) 
    directionToMovePlayer.x -= 1; 
  if (dirRight)  
    directionToMovePlayer.x += 1;
   
  myPlayer.MovePlayer(directionToMovePlayer.x, directionToMovePlayer.y);
}

//Rainclouds
//Create them
void CreateRainclouds() {
  //possibly change to place them randomly, and spawn?
  //currently hand-placed
  rainclouds.add(new Raincloud(150, 150, -3, 80, 0));
  rainclouds.add(new Raincloud(350, 600, 2, 80, 1));
  rainclouds.add(new Raincloud(450, 300, 2, 80, 2));
  rainclouds.add(new Raincloud(200, 550, -2, 80, 3));
  rainclouds.add(new Raincloud(600, 450, 4, 80, 4));
  rainclouds.add(new Raincloud(300, 400, 3, 80, 5));
  rainclouds.add(new Raincloud(700, 200, 3, 80, 6));
  rainclouds.add(new Raincloud(700, 600, -4, 80, 7));
}

//Move them all
void MoveAllRainclouds() {
 for(int i = 0; i < rainclouds.size(); i++) {
   Raincloud thisCloud = rainclouds.get(i);
   thisCloud.MoveRaincloud();
 }
}

//Draw them
void DrawAllRainclouds() {
  for(int i = 0; i < rainclouds.size(); i++) {
    Raincloud thisCloud = rainclouds.get(i);
    thisCloud.DrawRaincloud();
  }
}

//Lightning
//This all can be a lot more optimized in the future

float lightningTimerOffset = 0;
float lightningTimer;
boolean isTimeForALightningStrike = false;
boolean hasReachedSizeLimit = false; 

void DrawTheLightningLines() { 
  //Occurs once every 10 in-game seconds
  lightningTimer = millis();
  println(lightningTimer, lightningTimerOffset);
  if(lightningTimer - lightningTimerOffset >= 10000) {
    println(lightningTimer - lightningTimerOffset);
    lightningTimerOffset = millis();
    isTimeForALightningStrike = true;
  } else {
      isTimeForALightningStrike = false; 
  }
  
  if(isTimeForALightningStrike) {
    for(int i = 0; i < rainclouds.size() - 1; i++) {
      if(raincloudsLeftToBeStruck.size() == 1) 
        hasReachedSizeLimit = true;
      else
        hasReachedSizeLimit = false;
      
      if(!hasReachedSizeLimit) {
        //choose origin raincloud
        int chooseRandomRaincloud = int(random(raincloudsLeftToBeStruck.size()));
        Raincloud originRaincloud = raincloudsLeftToBeStruck.get(chooseRandomRaincloud);
        
        //delete it from rainclouds left to be struck
        raincloudsLeftToBeStruck.remove(chooseRandomRaincloud);
        
        //find closest raincloud
        Raincloud firstRaincloud = raincloudsLeftToBeStruck.get(0); //initiate distance with first distance to compare
        float closestDist = dist(originRaincloud.pos.x, originRaincloud.pos.y, firstRaincloud.pos.x, firstRaincloud.pos.y);
        int closestRaincloudID = 0;
        for(int j = 1; j < raincloudsLeftToBeStruck.size(); j++) {
            Raincloud thisRaincloud = raincloudsLeftToBeStruck.get(j);
            float testDist = dist(originRaincloud.pos.x, originRaincloud.pos.y, thisRaincloud.pos.x, thisRaincloud.pos.y);
            if(testDist < closestDist) {
              closestDist = testDist; 
              closestRaincloudID = j;
            }
        }
        
        Raincloud closestRaincloudToOriginRaincloud = raincloudsLeftToBeStruck.get(closestRaincloudID);
        
        //adds to array of lightning lines
        lightningLines.add(new LightningLine(originRaincloud.pos.x, originRaincloud.pos.y, 
          closestRaincloudToOriginRaincloud.pos.x, closestRaincloudToOriginRaincloud.pos.y));
        //draw the lightning lines
        LightningLine l = lightningLines.get(i);
        l.DisplaySelf();
        }
      } 
    isTimeForALightningStrike = false;
    //reset lightning
    for(int i = lightningLines.size() - 1; i >= 0; i--) {
      lightningLines.remove(i);
    }
    for(int i = raincloudsLeftToBeStruck.size() - 1; i >= 0; i--) {
      raincloudsLeftToBeStruck.remove(i);
    }
    //reset raincloud counter
    for(int i = 0; i < rainclouds.size(); i++) {
      raincloudsLeftToBeStruck.add(rainclouds.get(i));
    }
  }
}

//Rainbugs
void MoveAllRainbugs() {
  for(int i = 0; i < rainclouds.size(); i++) {
    Raincloud rc = rainclouds.get(i);
    for(int j = 0; j < rc.rainbugs.size(); j++) {
      rc.rainbugs.get(j).MoveAround();
    }
  }
}

//Game-over and Start-screen and stuff
//Very simple start screen with START button
color startButtonColor = color(26, 26, 26);  //Dark grey START box color
color startTextColor = color(219, 60, 7); //START text orange-red color
void DrawStartScreen() {
  //other stuff
  background(50);
  textAlign(CENTER);
  textFont(startFont);
  fill(78, 236, 245);
  text("Rain Safely Home", width/2, height/2);
  
  //button
  fill(startButtonColor);
  rect(width/2 - 100, height/2 + 75, 200, 75); 
  fill(startTextColor);
  textSize(45);
  text("Start", width/2, height/2 + 125.5);
}

void CheckStartScreen() {
  //if on start button
  if((mouseX >= (width/2 - 100)) 
  && (mouseX <= (width/2 + 100)) 
  && (mouseY >= (height/2 + 75)) 
  && (mouseY <= (height/2 + 75*2))) {
    stroke(219, 60, 7);
    startButtonColor = color(60, 60, 60);
    startTextColor = color(78, 236, 245);
  }
  else {
    noStroke();
    startButtonColor = color(26, 26, 26);
    startTextColor = color(219, 60, 7);
  }
}

//Very very simple Game-over screen with RESTART button
color gameoverButtonColor = color(26, 26, 26);  //Dark grey GAMEOVER box color
color gameoverTextColor = color(219, 60, 7); //GAMEOVER text orange-red color
void DrawGameoverScreen() {
  //other stuff
  background(50);
  textAlign(CENTER);
  textFont(startFont);
  fill(78, 236, 245);
  text("Game over!", width/2, height/2);
  
  //restart button
  fill(gameoverButtonColor);
  rect(width/2 - 100, height/2 + 75, 200, 75); 
  fill(gameoverTextColor);
  textSize(45);
  text("Restart", width/2, height/2 + 125.5);
  
  //score display
  noStroke();
  fill(219, 60, 7);
  rect(width/2 - 100, height/2 - 250, 200, 90);
  fill(255);
  textFont(healthFont);
  textSize(85);
  text(thisUI.score, width/2, height/2 - 175);
}

void CheckGameoverScreen() {
  strokeWeight(1);
  if((mouseX >= (width/2 - 100)) 
  && (mouseX <= (width/2 + 100)) 
  && (mouseY >= (height/2 + 75)) 
  && (mouseY <= (height/2 + 75*2))) {
    stroke(219, 60, 7);
    gameoverButtonColor = color(60, 60, 60);
    gameoverTextColor = color(78, 236, 245);
  }
  else {
    noStroke();
    gameoverButtonColor = color(26, 26, 26);
    gameoverTextColor = color(219, 60, 7);
  }
}

//Check if in a state to be gameover
void CheckIfGameIsOver() {
  if(myPlayer.health <= 0) {
    isGameover = true;
  }
}

//Need to reset everything when you restart
//Must loop BACKWARDS to hit everything to remove
void ResetGame() {
  for(int i = 0; i < rainclouds.size(); i++) {
    Raincloud thisRaincloud = rainclouds.get(i);
    for(int j = thisRaincloud.rainbugs.size() - 1; j >= 0; j--) {
      thisRaincloud.rainbugs.remove(j);
    }
  }
  
  for(int i = rainclouds.size() - 1; i >= 0; i--) {
    rainclouds.remove(i);
  }
  
  for(int i = lightningLines.size() - 1; i >= 0; i--) {
    lightningLines.remove(i);
  }
  
  strokeWeight(1);
}

void mouseClicked() {
  if(!hasStarted) {
    //if clicked on start button
    if((mouseX >= (width/2 - 100)) 
    && (mouseX <= (width/2 + 100)) 
    && (mouseY >= (height/2 + 75)) 
    && (mouseY <= (height/2 + 75*2))) {
      startButtonColor = color(168, 255, 252);   
      hasStarted = true;
    }
  }
  
  if(isGameover) {
    //if clicked on restart button
    if((mouseX >= (width/2 - 100)) 
    && (mouseX <= (width/2 + 100)) 
    && (mouseY >= (height/2 + 75)) 
    && (mouseY <= (height/2 + 75*2))) {
      startButtonColor = color(168, 255, 252);
      hasStarted = false;
      isGameover = false;
      hasStartedGameOnce = false;
      myGoal.pos.x = 780;
      myGoal.pos.y = 780;
      ResetGame();
    }
  }
}
