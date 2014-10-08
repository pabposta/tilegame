class Tile {
  // position where tile should go
  private int _destinationX;
  private int _destinationY;
  // our tile image
  PImage _img;
  
  public Tile(PImage img, int x, int y, int w, int h) {
    // cut out the part of the image that we are interested in
    _img = img.get(x * w, y * h, w, h);
    // copy the parameters
    _destinationX = x;
    _destinationY = y;
  }
  
  public void draw(int x, int y, int w, int h) {
    image(_img, x, y, w, h);
  }
  
  public boolean isMisplaced(int x, int y) {
    return x != _destinationX || y != _destinationY;
  }
  
  public void setDestinationX(int x) {
    _destinationX = x;
  }  
  
  public int getDestinationX() {
    return _destinationX;
  }  
  
  public void setDestinationY(int y) {
    _destinationY = y;
  }

  public int getDestinationY() {
    return _destinationY;
  }
  
  public void setImage(PImage img) {
    _img = img;
  }
  
  public PImage getImage() {
    return _img;
  }
}
