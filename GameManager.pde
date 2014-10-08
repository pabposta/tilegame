class GameManager {
  private final int MENU = 0;
  private final int PLAYING = 1;
  private final int WON = 2;
  
  private int _level;
  private TileManager _tileManager;
  private int _state;
  private Timer _timer;
    
  public GameManager() {
    // create the timer
    _timer = new Timer();
    // init level to 1
    _level = 1;
    // start in menu mode
    _state = MENU;
  }
  
  public void setTileManager(TileManager tileManager) {
    _tileManager = tileManager;
  } 
  
  public boolean inMenu() {
    return _state == MENU;
  } 
  
  public void goToMenu() {
    _state = MENU;
    _timer.stop();
  }
  
  public boolean won() {
    // quickly check if the state already is won
    if (_state == WON) {
      return true;
    }
    // if we are not playing, we cannot possibly win
    if (_state != PLAYING) {
      return false;
    }
    // check if all tiles are in the correct place
    if (_tileManager.noTilesMisplaced()) {
      // stop timer
      _timer.stop();
      // set state to won
      _state = WON;
      // return true
      return true;
    }
    // otherwise return false
    return false;
  }
  
  public void play() {
    // tell tile manager to create the next tile
    _tileManager.newLevel(_level);
    // set state to playing
    _state = PLAYING;
    // start timer
    _timer.start();
  }
  
  public void resume() {
    // set state to playing
    _state = PLAYING;
    // resume timer
    _timer.resume();
  }
  
  public void stopTimer() {
    _timer.stop();
  }
  
  public void resumeTimer() {
    _timer.resume();
  }
  
  
  public void setLevel(int level) {
    _level = level;
    if (_level > _tileManager.getNumberOfLevels()) {
      _level = _tileManager.getNumberOfLevels();
    }
  }
  
  public void nextLevel() {
    // advance one level in a circular fashion
    _level++;
    if (_level > _tileManager.getNumberOfLevels()) {
      _level = 1;
    }
    // start playing
    play();
  }
  
  public int getElapsedTime() {
    return _timer.getElapsedTime();
  }
}
