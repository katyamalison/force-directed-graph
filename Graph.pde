class Graph {
  List <Node> nodes;
  float tot_forces;
  boolean dynam_eq;
  boolean kevin_mode;
  Node center;
  Node kevin;
  int degree;
  
  Graph(List<Node> n) {
    nodes = n;
    tot_forces = 0;
    dynam_eq = false;
    kevin_mode = false;
    center = new Node(width / 2, height / 2, 0);
    degree = 0;
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
        //curr_node.calcCoulombVector(center);
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
    
    if(kevin_mode) {
      for(int i = 0; i < nodes.size(); i ++) {
       nodes.get(i).visited = false; 
      }
      find_connections(degree, getKevin());
      getKevin().baconColor();
      getKevin().connected = true;
    }
    else {
      for(int i = 0; i < nodes.size(); i++) {
       nodes.get(i).setNormColor();
       nodes.get(i).connected = false;
      }
    }
    
  }
  
  void incrementDegree() {
    degree += 1;
//    println(degree);
  }
  
  void decrementDegree() {
    degree -= 1;
//    println(degree);
  }
  
  void lockNodes() {
    if(dynam_eq)
      dynam_eq = false;
    for (int i = 0; i < nodes.size(); i++) {
      nodes.get(i).lock();
    }
  }
  
  boolean getMode() {
    return kevin_mode;
  }
  
  int getDegree() {
    return degree;
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
  
  
  void display() {
    
    for (int i = 0; i < nodes.size(); i++) {
      nodes.get(i).display_connections();
    }
    
    for (int i = 0; i < nodes.size(); i++) {
      nodes.get(i).display_nodes();
     if (nodes.get(i) == kevin && kevin_mode) {
       nodes.get(i).displayKevin();
      }
    }
    
    for (int i = 0; i < nodes.size(); i++) {
      if (nodes.get(i).inside() && !nodes.get(i).isLocked()) {
        nodes.get(i).displayData();
      }
    }
  }
  
  void find_connections(int curr_degree, Node curr_node) {
    List <Connection> connections;
    
    if(curr_degree == 0) {
      if(!curr_node.isVisited())
        curr_node.baconHighlight();
      curr_node.connected = true;
    }
    else if(curr_node.isVisited()) {
     return; 
    }
    else {
      curr_node.visited();
      connections = curr_node.getConnections();
      for(int i = 0; i < connections.size(); i++) {
        find_connections(curr_degree - 1, connections.get(i).getNeighbor());
      }
    }

    
  }
  void updateBacon() {
    kevin = getKevin();
    if(kevin_mode) {
      for(int i = 0; i < nodes.size(); i ++) {
       nodes.get(i).setNormColor();
       nodes.get(i).connected = false;
       nodes.get(i).visited = false; 
      }
      find_connections(degree, kevin);
      getKevin().baconColor();
      getKevin().connected = true;
    }
  }
}