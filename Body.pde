import java.util.Queue;
import java.util.ArrayDeque;

public class Body {
  private int maxAllowedTrailSize = 1000;
  Queue<PVector> trail = new ArrayDeque<>();
  PVector pos, vel;
  float mass, radius = 10;
  color bodyColor;
  boolean showTrail;
  
  public Body(PVector pos, PVector vel, float radius, color bodyColor, float mass, boolean showTrail) {
    this.vel = vel;
    this.pos = pos;
    this.radius = radius;
    this.bodyColor = bodyColor;
    this.mass = mass;
    this.showTrail = showTrail;
    enqueue(pos.copy());
  }
  
  private void enqueue(PVector p) {
    if (trail.size() >= maxAllowedTrailSize) {
      trail.poll();
    }
    trail.offer(p);
  }
  
  public float getMass() {
    return mass;
  }
  
  public PVector getPos() {
    return pos;  
  }
  
  public float getRadius() {
    return radius;
  }
  
  public void show() {
    fill(bodyColor);
    noStroke();
    circle(pos.x, pos.y, radius * 2); 
    
    // trail
    if (showTrail) {
      for (PVector p : trail) {
        fill(bodyColor);
        circle(p.x, p.y, 1); 
      }
    }
  }
  
  public void updatePosDueToGravity(PVector fog) {
    // update velocity due to force of gravity (fog)
    vel.add(fog);
    
    // update pos
    pos.add(vel);
    
    // add pos to trail
    enqueue(pos.copy());
  }
}
