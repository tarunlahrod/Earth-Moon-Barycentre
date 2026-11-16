import processing.event.MouseEvent;

float zoom = 1.0;
Body earth, moon;
float G = 0.001;

PVector fogOnADueToB(Body A, Body B) {
  PVector posA = A.getPos();
  float mA = A.getMass();
  float radiusA = A.getRadius();
  
  PVector posB = B.getPos();
  float mB = B.getMass();
  float radiusB = B.getRadius();
  
  PVector dir = PVector.sub(posB, posA);
  
  // dividing mag by 10 to prevent explosion. Reducing r to 10%
  float r = dir.mag() / 100;
  
  // make dir a unit vector (so that we can scaler multiply it with gravitation magnitude and get the direction)
  dir.normalize();
  
  // normalise r to prevent explosion
  r = max(r, radiusA + radiusB);
  
  float magnitude = (G * mA * mB) / (r * r);
  println("magnitude: " + magnitude);
  
  return PVector.mult(dir, magnitude);
}

PVector centerOfMass(Body a, Body b) {
  float totalMass = a.getMass() + b.getMass();
  
  float x = (a.getPos().x * a.getMass() + b.getPos().x * b.getMass()) / totalMass;
  float y = (a.getPos().y * a.getMass() + b.getPos().y * b.getMass()) / totalMass;
  
  return new PVector(x, y);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  zoom *= 1.0 - e * 0.05;

  zoom = constrain(zoom, 0.1, 10); // limits
}

void translateAndZoom(PVector p) {
  translate(width/2, height/2);
  scale(zoom);
  translate(-p.x, -p.y);
}

void setup() {
  size(1200, 800);
  background(0);
  
  earth = new Body(
    new PVector(width/2, height/2), 
    new PVector(0, 0),
    3.67, 
    color(0, 100, 255),
    81,
    true
  );
  
  moon = new Body(
    new PVector(width/2 + 221.25, height/2), 
    new PVector(0, -1),
    1, 
    color(100, 100, 100),
    1,
    true
  );
}

void drawX(PVector p, float size) {
  stroke(color(255, 255, 0));
  strokeWeight(0.5);
  
  line(p.x - size, p.y - size,
       p.x + size, p.y + size);

  line(p.x - size, p.y + size,
       p.x + size, p.y - size);
}

void draw() {
  background(0);
  
  PVector fogEarth = fogOnADueToB(earth, moon);
  PVector fogMoon = fogOnADueToB(moon, earth);

  earth.updatePosDueToGravity(fogEarth);
  moon.updatePosDueToGravity(fogMoon);
  
  // translate the camera to COM of the system
  PVector com = centerOfMass(earth, moon);
  translateAndZoom(com);
  
  earth.show();
  moon.show();
  
  // draw COM
  drawX(com, 1);
}
