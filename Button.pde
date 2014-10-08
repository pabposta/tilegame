class Button {
  private int _xLeft;
  private int _xCenter;
  private int _xRight;
  private int _yTop;
  private int _yCenter;
  private int _yBottom;
  private color _primaryColor;
  private color _secondaryColor;
  private String _label;
  private int _fontSize;
  private int _buttonGroupId;
  private Callback _callback;
  private boolean _highlighted;
  
  public Button(int x, int y, int w, int h, color primaryColor, color secondaryColor, String label, int fontSize, boolean highlighted, int buttonGroupId, Callback callback) {
    _xLeft = int(x - w * 0.5);
    _xCenter = x;
    _xRight = int(x + w * 0.5);
    _yTop = int(y - h * 0.5);
    _yCenter = y;
    _yBottom = int(y + h * 0.5);
    _primaryColor = primaryColor;
    _secondaryColor = secondaryColor;
    _label = label;
    _fontSize = fontSize;
    _buttonGroupId = buttonGroupId;
    _callback = callback;
    _highlighted = highlighted;
  }
  
  public boolean isAt(int x, int y) {
    return x >= _xLeft && x <= _xRight && y >= _yTop && y <= _yBottom;
  };
  
  public void draw() {
    if (_highlighted) {
      // draw highlighted buttons with inverted colors and slighltly larger
      int extraSize = int(_fontSize * 0.4);
      strokeText(_label, _xCenter, _yCenter - int(extraSize * 0.175), _fontSize + extraSize, _secondaryColor, _primaryColor, CENTER, CENTER, 2);
    }
    else {
      strokeText(_label, _xCenter, _yCenter, _fontSize, _primaryColor, _secondaryColor, CENTER, CENTER, 2);
    }
  }
  
  public void click() {
    _highlighted = true;
    if (_callback != null) {
      _callback.run();
    }
  }
  
  public void unHighlight() {
    _highlighted = false;
  }
  
  public boolean isHighlighted() {
    return _highlighted;
  }
  
  public int getButtonGroupId() {
    return _buttonGroupId;
  }
  
  public boolean hasLabel(String label) {
    return _label == label;
  }
  
  public void moveBy(int x, int y) {
    _xLeft += x;
    _xCenter += x;
    _xRight += x;
    _yTop += y;
    _yCenter += y;
    _yBottom += y;
  }
}
