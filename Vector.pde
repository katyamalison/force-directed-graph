import java.lang.Math;

class Vector {
  float x, y;
  
  Vector() {
    x = 0;
    y = 0;
  }
  
  //x1 and y1 must be the x y coords of the origin of the vector
  Vector(float x1, float y1, float x2, float y2, float force){
    float hypoteneuse = dist(x1, y1, x2, y2);
    
    float unit_x, unit_y;
    unit_x = (x2 - x1) / hypoteneuse;
    unit_y = (y2 - y1) / hypoteneuse;
    
    x = unit_x * force;
    y = unit_y * force; 
  }
  
  public void printVector() {
    println("(" + x + ", " + y + ")");
  }
  
  public float getX() {
    return x;
  }
  
  public float getY() {
    return y;
  }
  
  public void addVector(Vector v) {
    x += v.getX();
    y += v.getY();
  }
  
  public void multiplyFloat(float f) {
    x = x * f;
    y = y * f;
  }

}