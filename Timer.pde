class Timer {
  int _start;
  int _stop;
  int _accumulated;
  
  public Timer() {
    _start = 0;
    _stop = 0;
    _accumulated = 0;
  }
  
  public void start() {
    _start = millis();
    _stop = 0; // indicate that we have not stopped
    _accumulated = 0;
  }
  
  public void stop() {
    if (_start != 0 && _stop == 0) {
      _stop = millis();
      _accumulated += _stop - _start;
    }
  }
  
  public void resume() {
    if (_stop != 0) {
      _start = millis();
      _stop = 0;
    }
  }
  
  public int getElapsedTime() {
    // we haven't started yet
    if (_start == 0) {
      return 0;
    }
    // we are currently running
    if (_stop == 0) {
      return _accumulated + millis() - _start;
    }
    // we have stopped
    return _accumulated;
  }
}
