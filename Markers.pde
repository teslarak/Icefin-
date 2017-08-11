class Marker{
  float xPos, yPos;
  
  void markerDraw(){
    noStroke();
    fill(214, 2, 2);
    ellipse(this.xPos, this.yPos, 7, 7);
  }
  
}