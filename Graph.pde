class Graph {
  List <Node> nodes;
  float tot_forces;
  boolean dynam_eq;
  boolean kevin_mode;
  
  Graph(List<Node> n) {
    nodes = n;
    tot_forces = 0;
    dynam_eq = false;
    kevin_mode = false;
    
  }
  
  void update() {
    if(!dynam_eq) {
      tot_forces = 0;
      for (int i = 0; i < nodes.size(); i++) {
        if (!(nodes.get(i).isLocked())) {
          tot_forces += nodes.get(i).calcHookeVector();
        }
      }
      
      for (int i = 0; i < nodes.size(); i++) {
        Node curr_node = nodes.get(i);
        for (int j = 0; j < nodes.size(); j++){
          if ((j != i) && (!(nodes.get(i).isLocked()))) {
            curr_node.calcCoulombVector(nodes.get(j));
          }
        }
        tot_forces += curr_node.getNetForce();
      }
      
      for (int i = 0; i < nodes.size(); i++) {
        if (!(nodes.get(i).isLocked())) {
          nodes.get(i).updatePosition();
        }
      }
      if(tot_forces < 7.5)
        dynam_eq = true;
    }
    //println("mode: " + kevin_mode);
    //println("total forces = " + tot_forces);
  }
  
  void changeMode() {
    kevin_mode = !kevin_mode;
  }
  
  void lockNodes() {
    if(dynam_eq)
      dynam_eq = false;
    for (int i = 0; i < nodes.size(); i++) {
      nodes.get(i).lock();
    }
  }
  
  void unlockNodes() {
    if(dynam_eq)
      dynam_eq = false;
    for (int i = 0; i < nodes.size(); i++) {
      nodes.get(i).unlock();
    }  
  }
  
  void moveNodes() {
    if(dynam_eq)
      dynam_eq = false;
    for (int i = 0; i < nodes.size(); i++) {
      if (nodes.get(i).isLocked()) {
        nodes.get(i).move();
      }
    }
  }
  
  void highlightNodes() {
    for (int i = 0; i < nodes.size(); i++) {
        nodes.get(i).highlight();
    }   
  }
  
  Node getKevin() {
    Node kevin = nodes.get(0);
    
    for (int i = 1; i < nodes.size(); i++) {
      if (nodes.get(i).getMass() > kevin.getMass()) {
        kevin = nodes.get(i);
      }
    }
    return kevin;
  }
  
  void KevinBacon() {
    Node kevin = getKevin();
    
  }
  
  void display() {
    for (int i = 0; i < nodes.size(); i++) {
      nodes.get(i).display_connections();
    }
    
    for (int i = 0; i < nodes.size(); i++) {
      nodes.get(i).display_nodes();
    }
    
    for (int i = 0; i < nodes.size(); i++) {
      if (nodes.get(i).inside() && !nodes.get(i).isLocked()) {
        nodes.get(i).displayData();
      }
    }
  }
}