class Selector {
  private int _x;
  private int _y;
  private boolean _on;
  private color _color;
  private int _strokeWeight;
  
  public Selector(color c, int strokeWeight) {
    _on = false;
    _color = c;
    _strokeWeight = strokeWeight;
  }
  
  public void draw(int x, int y, int w, int h) {
    if (_on) {
      stroke(_color);
      strokeWeight(_strokeWeight);
      noFill();
      rect(x, y, w, h);
    }
  }
  
  public void toggle() {
    _on = !_on;
  }
  
  public void toggle(int x, int y) {
    _on = !_on;
    _x = x;
    _y = y;
  }
  
  public boolean isOn() {
    return _on;
  }
  
  public void setX(int x) {
    _x = x;
  }
  
  public int getX() {
    return _x;
  }
  
  public void setY(int y) {
    _y = y;
  }
  
  public int getY() {
    return _y;
  }
  
  public void setColor(color c) {
    _color = c;
  }
  
  public color getColor() {
    return _color;
  }
  
  public void setStrokeWidth(int strokeWeight) {
    _strokeWeight = strokeWeight;
  }
  
  public int getStrokeWidth() {
    return _strokeWeight;
  }
}
