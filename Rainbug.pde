class Rainbug {
  //Class variables
  //personal vars
  PVector pos;
  int dim;
  float spawnAngle;
  float speed;
  color myColor;
 
  
  //Constructors to create rainbug
  Rainbug(float posX, float posY, int d, float sA) {
    pos = new PVector(posX, posY);
    dim = d;
    //Initialize player position to store info coming in later
    spawnAngle = sA;
    speed = 2;
    myColor = color(0, 0, 255);
  }
  
  //Member functions
  void DrawRainbug() {
    //Rainbug is a smaller blue circle
    noStroke();
    if(amNearPlayer())
      myColor = color(3, 227, 252);
    else
      myColor = color(0, 0, 255);
      
    fill(myColor);
    circle(pos.x, pos.y, dim); //width 10, radius 5
  }
  
  //Movement stuff goes below:
  void MoveAround() {
    //If within 85 px of player, will gravitate towards player at the same speed as normal
    //The rainbug takes the shortest route there, so it's likely that a bunch of rainbugs will wind up
    //bunching up 
    if(!amNearPlayer()) {
      //Not in range of player/not alerted
      float xDir = cos(spawnAngle) * speed;
      float yDir = sin(spawnAngle) * speed;
    
      pos.x += xDir;
      pos.y += yDir;
    }
    else {
      //In range of player/alerted
      MoveTowardsPlayer();
    }

  }
  
  //Only when player is within a certain radius of the rainbug, this occurs
  void MoveTowardsPlayer() {

    //Calculate movement
    //direction = destination - origin
    PVector direction = new PVector (myPlayer.pos.x - pos.x, myPlayer.pos.y - pos.y);
    
    //magnitude = dist of direction
    float magnitude = dist(direction.x, direction.y, 0, 0);
    
    //normalized direction = direction / magnitude
    PVector normDirection = new PVector();
    normDirection.x = direction.x / magnitude;
    normDirection.y = direction.y / magnitude;
    
    //"move" via coordinates
    pos.x += normDirection.x * speed;
    pos.y += normDirection.y * speed;
}
  
  boolean amNearPlayer() {
    if(dist(pos.x, pos.y, myPlayer.pos.x, myPlayer.pos.y) <= 85) {
      return true;
    }
    else { return false; }
  }
}
