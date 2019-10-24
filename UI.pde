class UI {
  //class variables
  PVector healthPos;
  PVector scorePos;
  int score;
  
  //constructor
  UI() {
    healthPos = new PVector(700, 40);
    scorePos = new PVector(40, 40);
    score = 0;
  }
  
  //member functions
  void display(String whatToDisplay) {
    fill(255, 0, 0);
    textFont(healthFont);
    textSize(32);
    
    if(whatToDisplay == "health") {
      text("HP: " + myPlayer.health, healthPos.x, healthPos.y);
    }
    if(whatToDisplay == "score") {
      text(score, scorePos.x, scorePos.y);
    }
  }
  
  void shake(String whatToShake) {
    if(whatToShake == "health") {
        fill(255, 0, 0, 100);
        healthPos.x += random(-8, 8);
        healthPos.y += random(-8, 8);
        thisUI.display("health");
      
      //reset
      healthPos.x = 700;
      healthPos.y = 40;
    }
    
    //Probably won't use the below
    if(whatToShake == "score") {
      for(int i = 0; i < 10; i++) {
        scorePos.x += random(-10, 10);
        scorePos.y += random(-10, 10);
        thisUI.display("health");
      }
      //reset
      scorePos.x = 700;
      scorePos.y = 40;
    }  
  }
}
