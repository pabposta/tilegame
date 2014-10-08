class Menu {
  private ArrayList<Button> _buttons;
  private HashMap<Integer, Button> _previousHighlighted;
  private ArrayList<Label> _labels;
  
  public Menu() {
    _buttons = new ArrayList<Button>();
    _previousHighlighted = new HashMap<Integer, Button>();
    _labels = new ArrayList<Label>();
  }  
  
  public void click(int x, int y) {
    for (int i = 0; i < _buttons.size(); i++) {
      Button button = _buttons.get(i);
      if (button.isAt(x, y)) {
        // unhighlight the previously highlighted button of the group
        Integer buttonGroupId = new Integer(button.getButtonGroupId());
        if (_previousHighlighted.containsKey(buttonGroupId)) {
          _previousHighlighted.get(buttonGroupId).unHighlight();
        }
        // set the new button as previously highlighted
        _previousHighlighted.put(buttonGroupId, button);
        // pass the click to the button
        button.click();
        // buttons do not overlap, so we do not need to check the rest
        break;
      }
    }
  }
  
  public void draw() {
    for (int i = 0; i < _buttons.size(); i++) {
      _buttons.get(i).draw();
    }
    for (int i = 0; i < _labels.size(); i++) {
      _labels.get(i).draw();
    }
  }
 
  public void registerButton(Button button) {
    _buttons.add(button);
    // if the button is highlighted set it as previous highlighted
    if (button.isHighlighted()) {
      Integer buttonGroupId = new Integer(button.getButtonGroupId());
      _previousHighlighted.put(buttonGroupId, button);
    }
  }
  
  public void unRegisterButton(String label) {
    Button button = null;
    for (int i = 0; i < _buttons.size(); i++) {
      button = _buttons.get(i); 
      if (button.hasLabel(label)) {
        _buttons.remove(i);
        break;
      }
    } 
    // if it is highlighted, remove the previous highlight also 
    if (button != null && button.isHighlighted()) {
      Integer buttonGroupId = new Integer(button.getButtonGroupId());
      _previousHighlighted.remove(buttonGroupId);
    }
  }
  
  public void registerLabel(Label label) {
    _labels.add(label);
  }
}
