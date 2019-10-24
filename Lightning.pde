class LightningLine {
  //class variables
  float l_thickness;
  color l_color;
  PVector posStart = new PVector();
  PVector posEnd = new PVector();
  
  //constructor
  LightningLine(float startposX, float startposY, float endposX, float endposY) {
    posStart.x = startposX;
    posStart.y = startposY;
    posEnd.x = endposX;
    posEnd.y = endposY;
    
    l_thickness = 5;
    l_color = color(255, 255, 0, 255);
  }
  
  //member functions
  void DisplaySelf() {
    strokeWeight(l_thickness);
    stroke(l_color);
    line(posStart.x, posStart.y, posEnd.x, posEnd.y);
  }
}
