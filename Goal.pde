class Goal {
  //class variables
  PVector pos = new PVector();
  color goalColor;
  float dim; //diameter, not radius
  
  //constructor
  Goal(float posX, float posY, color gC) {
     pos.x = posX;
     pos.y = posY;
     goalColor = gC;
     dim = 20; 
  }
  
  //member functions
  void DisplaySelf() {
    if(IsTouchingPlayer(pos, myPlayer.pos, dim/2, myPlayer.dim/2)) {
      thisUI.score += 150;
      MoveToRandomPlace();
    }
    
    noStroke();
    fill(goalColor);
    //make it a circle to keep things simple, but could also be a square
    circle(pos.x, pos.y, dim);
  }
  
  void MoveToRandomPlace() {
    //how to make it move to a random distant place?
    pos.x = random(20, width - 20);
    pos.y = random(20, height - 20);
  }
  
  boolean IsTouchingPlayer(PVector posA, PVector posB, float rA, float rB) {
    float theDistanceAtWhichTheCollisionMustHaveHappened = rA + rB;
      
    float distanceBetweenCirclesActual = 
      dist(posA.x, posA.y, posB.x, posB.y);
      
      if (theDistanceAtWhichTheCollisionMustHaveHappened > distanceBetweenCirclesActual)
        return true;
      else 
        return false;
  }
}
