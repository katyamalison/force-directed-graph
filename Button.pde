String KEVIN_MODE = "Kevin Bacon Mode";
String NORMAL_MODE = "Normal Mode";

public class Button {
  int Width;
  int Height;
  int centerX;
  int centerY;
  String label;
  color backgroundColor;
  
  public Button(int x, int y, int w, int h, String t) {
    Width = w;
    Height = h;
    centerX = x;
    centerY = y;
    label = t;
    backgroundColor = #ffffff;
  }
  
  public void changeLabel() {
    if (label == KEVIN_MODE) {
      label = NORMAL_MODE;
    } else {
      label = KEVIN_MODE;
    }
  }
  
  public void setLabel(String l) {
    label = l;
  }
  
  public void setWidth(int w) {
    Width = w;
  }
  
  public void setHeight(int h) {
    Height = h;
  }
  
  boolean clickedOn(){
    if ((mouseX < (centerX + Width ) && (mouseX > centerX)) &&
        (mouseY < (centerY + Height) && (mouseY > centerY))) {
          return true;
        } else {
          return false;
        }
  }
  
  void render() {
    fill(backgroundColor);
    rect(centerX, centerY, Width, Height);
    fill(0);
    textSize(14);
    textAlign(LEFT);
    //textAlign(CENTER,CENTER);
    text(label, centerX + 10, centerY + 20);
  }
}