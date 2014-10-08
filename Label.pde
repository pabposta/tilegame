class Label {
  
  private String _text;
  private int _x;
  private int _y;
  private int _fontSize;
  private color _primaryColor;
  private color _secondaryColor;
  
  public Label(String text, int x, int y, int fontSize, color primaryColor, color secondaryColor) {
    _text = text;
    _x = x;
    _y = y;
    _fontSize = fontSize;
    _primaryColor = primaryColor;
    _secondaryColor = secondaryColor;
  }
  
  public void draw() {
    strokeText(_text, _x, _y, _fontSize, _primaryColor, _secondaryColor, CENTER, CENTER, 2);
  }
}
