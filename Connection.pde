class Connection {
  Node neighbor;
  float default_edge;
  
  Connection(Node n, float edge_length) {
   neighbor = n;
   default_edge = (edge_length * .0000005);
   //TODO: figure out random start value stuff for when we make nodes
   //edge = new Spring(springlen, random value)
  }
  
  void display(float x, float y) {
    float x_neighbor = neighbor.getX();
    float y_neighbor = neighbor.getY();
    
    line(x, y, x_neighbor, y_neighbor);
  }
  
  float getNeighborX() {
    return neighbor.getX();
  }
  
  float getNeighborY() {
    return neighbor.getY();
  }
  
  float getDefaultEdge() {
    return default_edge;
  }
}