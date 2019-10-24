class Raincloud {
  //Class variables
  //personal vars
  PVector pos; 
  PVector rangeBox; //the range of the simple line along which the basic cloud moves
  float dim; //diameter of radius circle
  color radiusCircleColor = color(63, 154, 181, 85); //color of radius circle
  
  int id;
  
  //movement stuff
  float speed; //how fast it's moving per frame
  int wanderTimer; //determines how long the cloud stays at each corner
  int timeVal; //contains the state of wanderings
  float moveTimer;
  float timerOffset;
  PVector[] cornerPos = new PVector[4];
  
  //each cloud controls spawning its "own" rainbugs
  ArrayList<Rainbug> rainbugs = new ArrayList<Rainbug>();
  int initialTimeSpawn;
  int intervalSpawn;
  int initialTimeRemove; 
  int intervalRemove;
  
  //references  
  PVector playerPos;
  Player mainPlayer;
  
  //Constructor to create rainbug
  Raincloud(float posX, float posY, float s, float d, int myID) {
    pos = new PVector(posX, posY);
    rangeBox = new PVector(posX - 100, posX + 100); //simpler modified
    speed = s;
    dim = d;
    
    id = myID;
    
    wanderTimer = 1000;
    timeVal = 0;
    cornerPos[0] = new PVector(posX, posY);
    cornerPos[1] = new PVector(posX - 100, posY);
    cornerPos[2] = new PVector(posX - 100, posY + 100);
    cornerPos[3] = new PVector(posX, posY + 100);
    
    mainPlayer = myPlayer;
    intervalRemove = int(random(2000, 4000));
    intervalSpawn = int(random(1000, 3000));
  }

  //Member functions
  //This function just draws the raincloud at its current position
  void DrawRaincloud() {
    //Raincloud storm radius is large-ish blue-grey circle
    noStroke();
    fill(radiusCircleColor); 
    circle(pos.x, pos.y, dim); //radius 40, width 80
    
    //Raincloud drops go here
    image(drops[frameCount%11], pos.x - 20, pos.y, 40, 30);
    
    //Raincloud center is cloud-shaped and medium blue
    noStroke();
    fill(16, 186, 220); //medium blue color
    line(pos.x-20, pos.y, pos.x+20, pos.y); //bottom of cloud
    arc(pos.x-15, pos.y, 10, 10, PI, TWO_PI); //1st small bump
    arc(pos.x, pos.y, 25, 25, PI, TWO_PI); //big middle bump
    arc(pos.x+15, pos.y, 10, 10, PI, TWO_PI); //2nd small bump
  }

  void TrackPlayerLocation(PVector playerPosition) {
    playerPos = playerPosition;
  }
  
  //Spawn rainbugs
  void spawnRainbugs() {
    //Rainbugs are "die" aka are removed if they go off screen
    for(int i = 0; i < rainbugs.size(); i++) {
      Rainbug r = rainbugs.get(i);
      if((r.pos.x <= 0) || (r.pos.x >= width) || (r.pos.y <= 0) || (r.pos.y >= height)) {
        rainbugs.remove(i);
      }
    }
    
    //Trig to get random point on circumference
    float spawnAngle = random(0, TWO_PI); 
    float radius = 40;
    float offset = 5; //so it's not directly on the raincloud's radius circle
    float xAngle = cos(spawnAngle) * radius;
    float yAngle = sin(spawnAngle) * radius;
    
    //Rainbugs only spawn if there are less than 3 (per raincloud) on screen atm
    //They spawn not immediately but after an interval of somewhere between 1 and 3 seconds, randomly chosen
    if(rainbugs.size() < 3) { //3 per cloud max at a time
      if(millis() - initialTimeSpawn > intervalSpawn) {
        initialTimeSpawn = millis();
        intervalSpawn = int(random(1000, 3000));
        rainbugs.add(new Rainbug(pos.x + xAngle + offset, 
                     pos.y + yAngle + offset, 10, spawnAngle));
      }
    }
  }
  
  //Move
  void MoveRaincloud() {
    DrawAllMyRainbugs();
    
    //Box version:
    if(timeVal == 0) 
        timeVal = 1;
    
    
    if(timeVal == 1) {
      //Not yet at corner 1
      if(pos.x > cornerPos[1].x) {
        //want everyone to go left
        if(speed < 0) {
          pos.x += speed * 0.6;
        }
        else {
          pos.x -= speed * 0.6;
        }
      }
      //At corner 1
      else if((pos.x <= cornerPos[1].x) && (pos.y <= cornerPos[1].y)) {
          timeVal = 2;
      }
    }
      
    if(timeVal == 2) {
      //Not yet at corner 2
      if(pos.y < cornerPos[2].y) {
        if(speed < 0) {
          //want to go down
          pos.y -= speed * 1.3;
        }
        else 
          pos.y += speed * 1.3;
      }
      //At corner 2
      else if(pos.y >= cornerPos[2].y) {
          timeVal = 3;
      }
    }
      
    if(timeVal == 3) {
      //Not yet at corner 3
      if(pos.x < cornerPos[3].x) {
        if(speed < 0) {
          //want to go right
          pos.x -= speed * 1.6;
        }
        else 
          pos.x += speed * 1.6;
      }
      //At corner 3
      else if(pos.x >= cornerPos[3].x) {
        timeVal = 4; 
      }
    } 
    
    if(timeVal == 4) {
      //Not yet back at corner 0
      if(pos.y > cornerPos[0].y) {
        if(speed < 0) {
          //want to go up
          pos.y += speed; 
        }
        else
          pos.y -= speed;
      }
      //Back at corner 0
      else if(pos.y <= cornerPos[0].y) {
        timeVal = 0;
      }
    }
  }
  
  void DrawAllMyRainbugs() {
    spawnRainbugs();
    for(int i = 0; i < rainbugs.size(); i++) {
      Rainbug r = rainbugs.get(i);
      r.DrawRainbug();
    }
  }
}
