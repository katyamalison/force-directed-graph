import java.util.Arrays;

color BACKGROUND = #f09b9b;
String DATA = "data2.csv";
Graph graph;
Button button;
Button plus;
Button minus;


List<Node> makeGraph(String [] data) {
  int num_nodes = Integer.parseInt(data[0]);
  int num_edges = Integer.parseInt(data[num_nodes + 1]);
  
  String [] node_data = splitData(data, 1, num_nodes);
  String [] edge_data = splitData(data, num_nodes + 2, num_edges);
  
  List <Node> nodes = new ArrayList <Node>();
  
  createNodes(node_data, nodes);
  
  connectNodes(edge_data, nodes);
  
  for(int i = 0; i < nodes.size(); i++) {
    println(nodes.get(i).getId());
  }
  
  return nodes;
}

void createNodes(String [] node_data, List <Node> nodes) {
  for (int i = 0; i < node_data.length; i++) {
    String [] temp = node_data[i].split(",");
    int id = Integer.parseInt(temp[0]);
    int mass = Integer.parseInt(temp[1]);
    
    nodes.add(new Node(id, mass));
  }

}

void connectNodes(String [] edge_data, List <Node> nodes) {
  for (int i = 0; i < edge_data.length; i++) {
    String [] conn_data = edge_data[i].split(",");
    int id_1 = Integer.parseInt(conn_data[0]);
    int id_2 = Integer.parseInt(conn_data[1]);
    float edge_len = Integer.parseInt(conn_data[2]);
    
    Node node_one = null;
    Node node_two = null; 
    for (int j = 0; j < nodes.size(); j ++) {
      println("for loop iteration " + j);
      if(nodes.get(j).getId() == id_1) {
        node_one = nodes.get(j);
      }
      else if(nodes.get(j).getId() == id_2) {
        node_two = nodes.get(j);
      }
      //println("for loop iteration " + j);
    }
    
    if (node_one != null && node_two != null) {
      println("adding node " + node_one.getId() + " and node " + node_two.getId());
      node_one.addConnection(node_two, edge_len);
      node_two.addConnection(node_one, edge_len);
    }
  }
}

String [] splitData(String [] data, int start, int len) {
  return Arrays.copyOfRange(data, start, start + len);
}

void mousePressed() {
  graph.lockNodes();

}

void mouseClicked() {
  if(button.clickedOn()) {
    button.changeLabel();
    graph.changeMode();
  }
  if(plus.clickedOn() && graph.getMode()) {
    graph.incrementDegree();
    graph.updateBacon();
  }
  if(minus.clickedOn() && graph.getMode()) {
    if(graph.degree > 0)
      graph.decrementDegree();
    graph.updateBacon();
  }
}

void mouseDragged() {
  graph.moveNodes();
}

void mouseReleased() {
  graph.unlockNodes();
}

void mouseMoved() {
  graph.highlightNodes();
}

void setup() {
  size(1100, 1000);
  surface.setResizable(true);
  
  String[] data = loadStrings(DATA);
  
  graph = new Graph(makeGraph(data));
  button = new Button(10, 10, 150, 30, "Kevin Bacon Mode");
  plus = new Button(10, 50, 30, 30, "+");
  minus = new Button(130, 50, 30, 30, "-");
}

int getFontSize() {
  return 70;
}

void draw() {
  background(BACKGROUND);
  graph.update();
  graph.display();
  button.render();
  if (graph.getMode()) {
    fill(#ffffff);
    textSize(30);
    text(graph.getDegree(), 75, 75);
    plus.render();
    minus.render();
  }
  if (graph.getDegree() > 6) {
    fill(#ffffff);
    textSize(getFontSize());
    text("No one is more than 6", 50, 300);
  }
}