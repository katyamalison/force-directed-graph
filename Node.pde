import java.util.List;
import java.util.Random;

int MASS_CONST = 20;
float HOOKE_CONST = .0055555;
float COUL_CONST = 8000;
float DAMPENING = 0.9;
color NORM = #b0026b;
color HIGHLIGHT = #fdcbcb;
color BACON = #f456ab;

class Node {
  int node_id;
  int mass;
  float x, y;
  float xOffset, yOffset;
  float unit_area, diameter;
  
  boolean visited, locked, connected;
  color clr;
  List<Connection> connections;
  Vector force_vector;
  
  Node(float x_coord, float y_coord, int cen_mass) {
    x = x_coord;
    y = y_coord;
    mass = cen_mass;
  }
  
  Node(int id, int m) {
    Random randy = new Random();
    
    node_id = id;
    mass = m;
    unit_area = PI * ((MASS_CONST / 2) * (MASS_CONST / 2));
    diameter = 2 * sqrt(mass * unit_area / PI);
    visited = false;
    locked = false;
    connections = new ArrayList<Connection>();
    force_vector = new Vector();
    clr = NORM;
    connected = false;
    
    // add values of circle size so that doesnt go off screen
    x = randy.nextInt(width);
    y = randy.nextInt(height);
    boundPosition();
    
  }
  
  int getId() {
   return node_id; 
  }
  
  int getMass() {
   return mass; 
  }
  
  float getX() {
   return x; 
  }
  
  float getY() {
   return y; 
  }
  
  float getNetForce() {
   return sqrt((force_vector.x * force_vector.x) + (force_vector.y * force_vector.y));
  }
  
  boolean isVisited() {
   return visited; 
  }
  
  void setNormColor() {
   clr = NORM;
  }
  
  void visited() {
    visited = true;
  }
  
  void boundPosition() {
   if(x + (diameter / 2) > width)
     x = width - (diameter / 2);
     

  if(x - (diameter / 2) < 0)
    x = (diameter / 2);
    
  if(y + (diameter / 2) > height) {
    y = height - (diameter / 2);
    //println("y = " + y + " height = " + height + " diameter =" + diameter);
  }
    
    
  if(y - (diameter / 2) < 0)
    y = (diameter / 2);
     
     
  }
  
  void display_nodes() {
    fill(clr);
    ellipse(x, y, diameter, diameter);
  }
  
  void displayData() {
    String txt = makeText();
    
    textSize(12);
    float text_width = textWidth(txt);
    
    fill(#ffffff);
    rect(mouseX, mouseY, text_width + 10, 25);
    fill(#000000);
    text(txt, mouseX + 5, mouseY + 15);
  
  }
  
  String makeText() {
    return "(id: " + node_id + ", mass: " + mass + ")";
  }
  
  void display_connections() {
    for (int i = 0; i < connections.size(); i++) {
      connections.get(i).display(x, y);
    }
  }
  
  void addConnection(Node neighbor, float springlen) {
    connections.add(new Connection(neighbor, springlen));
  }
  
  boolean inside() {
    if (dist(x, y, mouseX, mouseY) <= diameter/2) 
      return true;
    return false;
  }
  
  void highlight() {
    if(connected) {
      return;
    }
    
    if (inside() && !isLocked())
      clr = HIGHLIGHT;
    else 
      clr = NORM;
  }
  
  void baconHighlight() {
   clr = HIGHLIGHT; 
  }
  
  void baconColor() {
   clr = BACON; 
  }
  
  void lock() {
    if (inside()) {
      locked = true;
      xOffset = mouseX-x; 
      yOffset = mouseY-y; 
     } else locked = false;
  }
  
  void unlock() {
    locked = false;
  }
  
  boolean isLocked() {
    return locked;
  }
  
  void move() {
    x = mouseX-xOffset; 
    y = mouseY-yOffset;
    boundPosition();
  }
  
  float calcHooke(float x_neighbor, float y_neighbor){
    float delta_length = dist(x, y, x_neighbor, y_neighbor);
    
    return HOOKE_CONST * delta_length;
  }
  
  float calcCoulomb(float x_neighbor, float y_neighbor){
    float distance = dist(x, y, x_neighbor, y_neighbor);
    
    return COUL_CONST / (distance * distance);
  }
  
  float calcHookeVector() {
    for (int i = 0; i < connections.size(); i++) {
      Vector vector;
      
      float neighbor_x = connections.get(i).getNeighborX();
      float neighbor_y = connections.get(i).getNeighborY();
      float edge_len = dist(x, y, neighbor_x, neighbor_y);
      
      boolean compressed = edge_len < connections.get(i).getDefaultEdge();
      
      float force = calcHooke(neighbor_x, neighbor_y);
      
      if (compressed) vector = new Vector(neighbor_x, neighbor_y, x, y, force);
      else vector = new Vector(x, y, neighbor_x, neighbor_y, force);
      
      force_vector.addVector(vector);
      //force_vector.printVector();
 
      //println("force: " + force);
    }
    return getNetForce();
  }
  
  
void calcCoulombVector(Node node) {
    Vector vector;
    
    float neighbor_x = node.getX();
    float neighbor_y = node.getY();
    
    float force = calcCoulomb(neighbor_x, neighbor_y);
    
    vector = new Vector(neighbor_x, neighbor_y, x, y, force);

    
    force_vector.addVector(vector);
  }
  
  //void calcCoulombVector(Node node, boolean attract) {
  //  Vector vector;
    
  //  float neighbor_x = node.getX();
  //  float neighbor_y = node.getY();
    
  //  float force = calcCoulomb(neighbor_x, neighbor_y);
    
  //  if(!attract) {
  //    vector = new Vector(neighbor_x, neighbor_y, x, y, force);
  //  }
  //  else {
  //    vector = new Vector(x, y, neighbor_x, neighbor_y, force);
  //  }
    
  //  force_vector.addVector(vector);
  //}
  
  void updatePosition() {
    float force_x = force_vector.getX();
    float force_y = force_vector.getY();
    float acceleration_x = force_x / mass;
    float acceleration_y = force_y / mass;
    
    x = x + (acceleration_x/2);
    y = y + (acceleration_y/2);
    
    boundPosition();
    
    force_vector.multiplyFloat(DAMPENING);
  }
  
  List<Connection> getConnections() {
    return connections;
  }
}