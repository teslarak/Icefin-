import controlP5.*;

ControlP5 cp5;
int time;
PImage sonarFront;
PImage sonarSide;
PImage video;
float circleY1, circleY2;
float sonarFrontX, sonarFrontY = 500;
float sonarSideX, sonarSideY;
ArrayList<Marker> markerList = new ArrayList();
color blue = color(24, 32, 79);
color active = color(139, 152, 229);
PFont font = createFont("arial", 15);
int alignX = 930;
PVector p1;
String hDirection = "NE"; //horizontal compass

void setup() {
  //fullScreen();
  size(1440, 900);
  imageMode(CENTER);
  cp5 = new ControlP5(this);

  controlp5Setup();
  sonarFront = loadImage("sonar.png");
  video =  loadImage("video.jpg");
  sonarSide = sonarFront;
}

void draw() {
  p1 = new PVector(cos(frameCount*0.1)*50, sin(frameCount*0.1)*50);
  background(30, 30, 30);
  noTint();
  image(video, width/2, height/2, width, height);
  image(sonarSide, sonarSideX, sonarSideY, 500, 300);
  tint(204, 153, 0);
  image(sonarFront, sonarFrontX, sonarFrontY, 500, 300);
  noStroke();
  fill(blue);
  rect(0, 0, width, 20);
  int time = millis();
  fill(255);
  text("Run number 1 || " + day() + "/" + month() + "/" + year() + " || Millis since start: " + time, 5, 15);
  text("Icefin Status Monitor", width/2-60, 15);
  testChart1.push("incoming", (sin(frameCount*0.1)*10));
  mouseOver();
  for (Marker m : markerList) {
    m.markerDraw();
  }
  if (Sensor7.isOpen()) text(random(100), 200, 100);
  text("DO " + random(100), width-100, height-75);
  text("Concn.\n" + random(100), width-100, height-105);
  text(hDirection, width/2-7, 730);
  line(width/2+p1.x,height/2+p1.y,width/2-p1.x,height/2-p1.y);
  noFill();
  ellipse(width/2, height/2, 15, 15);
}

void mouseOver() {
  noFill();
  stroke(214, 2, 2);
  strokeWeight(2);
  if (mouseX > alignX && mouseX < 900 && mouseY > 55 && mouseY < 355) {
    circleY1 = map(mouseY, 55, 355, 375, 675);
    ellipse(mouseX, circleY1, 15, 15);
  }
  if (mouseX > alignX && mouseX < 900 && mouseY > 375 && mouseY < 675) {
    circleY2 = map(mouseY, 375, 675, 55, 355);
    ellipse(mouseX, circleY2, 15, 15);
  }
}

void mousePressed() {
  if (mouseX > alignX && mouseX < 900 && mouseY > 55 && mouseY < 355) {
    Marker tempMarker = new Marker();
    tempMarker.xPos = mouseX;
    tempMarker.yPos = circleY1;
    markerList.add(tempMarker);
  }
  if (mouseX > alignX && mouseX < 900 && mouseY > 375 && mouseY < 675) {
    Marker tempMarker = new Marker();
    tempMarker.xPos = mouseX;
    tempMarker.yPos = circleY2;
    markerList.add(tempMarker);
  }
}

void mouseDragged() {
  if (pmouseX > sonarSideX - 250 && pmouseX < sonarSideX + 250 && pmouseY > sonarSideY - 250 && pmouseY < sonarSideY + 250) {
    sonarSideX = mouseX;
    sonarSideY = mouseY;
  } else if (pmouseX > sonarFrontX - 250 && pmouseX < sonarFrontX + 250 && pmouseY > sonarFrontY - 250 && pmouseY < sonarFrontY + 250) {
    sonarFrontX = mouseX;
    sonarFrontY = mouseY;
  }
}