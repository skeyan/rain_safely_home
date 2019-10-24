class Player {
  //Class variables
  PVector pos; //position/coords of player
  float dim; //size of player (mostly constant)
  color f; //fill color
  int health;
  ArrayList<Rainbug> rainbugsTouching = new ArrayList<Rainbug>();
  
  //Constructor to create player
  Player(float posX, float posY, int dimension, int h) {
   pos = new PVector(posX, posY);
   dim = dimension;
   health = h;
   f = color(255, 0, 0);
  }

  //Member functions
  void DrawPlayer() {
    //Player is a red circle ('fire sprite')    
    noStroke();
    fill(f);
    circle(pos.x, pos.y, dim);
  }
  
  void MovePlayer(float x, float y) {
    float factor; //speed multiplier
    factor = 3;
    
    CheckCollisions();
    
    //Change position of coords
    pos.x += (x * factor);
    pos.y += (y * factor);
    
    //Can't go out of the screen
    pos.x = constrain(pos.x, dim/2, width - dim/2);
    pos.y = constrain(pos.y, dim/2, height - dim/2);
  }
  
  void CheckCollisions() {
    //Clouds 
    //Check if player is touching any of the rainclouds, so loop through them
    for(int i = 0; i < rainclouds.size(); i++) {
      Raincloud thisCloud = rainclouds.get(i);
      
      //this is the accurate version, you may want to get the slightly inaccurate version to make the player
      if(DidTheseCirclesTouch(pos, thisCloud.pos, dim/2, thisCloud.dim/2)) {
        health -= 5;
        thisCloud.radiusCircleColor = color(255, 255, 0, 90); //turn yellow
      }
      else {
        thisCloud.radiusCircleColor = color(63, 154, 181, 85);
      }
    }
    
            
    
    //Rainbugs
    //Check if player is touching any rainbug, so loop through them (get through rainclouds first)
    for(int i = 0; i < rainclouds.size(); i++) {
      Raincloud rc = rainclouds.get(i);
      for(int j = 0; j < rc.rainbugs.size(); j++) {
        Rainbug rb = rc.rainbugs.get(j);
        
        if(DidTheseCirclesTouch(pos, rb.pos, dim/2, rb.dim/2)) {
          health -= 1;
          thisUI.shake("health"); //needs work
          rainbugsTouching.add(rb);
          rb.myColor = color(255, 255, 0);
        } 
        else {
          rb.myColor = color(0, 0, 255);
        }
      }  
    }
    //Turn yellow if there's a rainbug it's touching
    //Otherwise, the player color would automatically reset if it's not touching all rainbugs at once
    if(rainbugsTouching.size() != 0) {
      f = color(255, 255, 0); 
    } 
    else {
      f = color(255, 0, 0);
    }
    //Reset the arraylist for rainbugs the player is touching for new draw
    for(int i = 0; i < rainbugsTouching.size(); i++) {
      rainbugsTouching.remove(i); 
    }
    
    //Lightning strikes
    //Collision detecting for lightning strikes
    for(int i = 0; i < lightningLines.size(); i++) {
      LightningLine l = lightningLines.get(i);
      if(isCircleInLine(l.posStart.x, l.posStart.y, l.posEnd.x, l.posStart.y, pos.x, pos.y, dim/2)) {
        health = 0; //you GET FRIED (automatically lose) if you touch a lightning strike
      }
    }
  }
    
  //New more robust collision detection system for CIRCLES only
  boolean DidTheseCirclesTouch(PVector posA, PVector posB, float rA, float rB) {
    float theDistanceAtWhichTheCollisionMustHaveHappened = rA + rB;
      
    float distanceBetweenCirclesActual = 
      dist(posA.x, posA.y, posB.x, posB.y);
      
      if (theDistanceAtWhichTheCollisionMustHaveHappened > distanceBetweenCirclesActual)
        return true;
      else 
        return false;
  }
  
  boolean isPointInCircle(float px, float py, float cx, float cy, float r) {
    // get distance between the point and circle's center
    float distance = dist(px, py, cx, cy);
  
    // if the distance is less than the circle's radius,
    //the point is inside
    if (distance <= r)
      return true;
    else 
      return false;
  }
  
  boolean isPointInLine(float x1, float y1, float x2, float y2, float px, float py) {
    // get distance from the point to the two ends of the line
    float d1 = dist(px,py, x1,y1);
    float d2 = dist(px,py, x2,y2);
  
    // get the length of the line
    float lineLen = dist(x1,y1, x2,y2);
  
    // since floats are so minutely accurate, add a little buffer zone that will give collision
    float buffer = 0.1;    // higher # = less accurate
    
    // if the two distances are equal to the line's length, the point is on the line
    // the buffer is here to give a range instead of one #
    if ((d1+d2 >= lineLen-buffer) && (d1+d2 <= lineLen+buffer))
      return true;
    else
      return false;
  }
  
  boolean isCircleInLine(float x1, float y1, float x2, float y2, float cx, float cy, float r) {
    // is either end INSIDE the circle?
    // if so, return true immediately
    boolean inside1 = isPointInCircle(x1,y1, cx,cy,r);
    boolean inside2 = isPointInCircle(x2,y2, cx,cy,r);
    if (inside1 || inside2) 
      return true;
  
    // get length of the line
    float len = dist(x1,y1, x2,y2);
  
    // get dot product of the line and circle
    float dot = ( ((cx-x1)*(x2-x1)) + ((cy-y1)*(y2-y1)) ) / pow(len,2);
  
    // find the closest point on the line
    float closestX = x1 + (dot * (x2-x1));
    float closestY = y1 + (dot * (y2-y1));
  
    // is this point actually on the line segment?
    // if so keep going, but if not, return false
    boolean onSegment = isPointInLine(x1, y1, x2, y2, closestX, closestY);
    if (!onSegment) 
      return false;
  
    // get distance to closest point
    float distance = dist(cx, cy, closestX, closestY);
  
    if (distance <= r) 
      return true;
    else
      return false;
  }
}
