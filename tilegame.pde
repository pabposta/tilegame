// look for comments JAVA-ANDROID to see which parts to switch 

// constants
int screenWidth = 320;
int screenHeight = 480;
final int EASY = 0;
final int MEDIUM = 1;
final int HARD = 2;
final color SELECTOR_COLOR = color(246, 181, 6);
final color MENU_COLOR_FG1 = color(246, 181, 6);
final color MENU_COLOR_FG2 = color(34, 161, 212);
final color MENU_COLOR_BG1 = color(255, 255, 255);
final int SELECT_STROKE_WEIGHT = 4;
final int MIN_WAIT = 2000; // minimum amount of time that needs to pass before we can go to the next level. this avoid accidentally clicking on the screen and missing the congratulations message

// objects
Menu menu;
TileManager tileManager = null;
GameManager gameManager = null;
Selector selector = null;
PImage tileOverlay = null;
Timer delayTimer = null;
Button playButton = null;
Button resumeButton = null;

// other variables
int xTiles;
int yTiles;
int tileWidthOnScreen;
int tileHeightOnScreen;
int fontSize;
int fontSizeSmall;
int startingLevel;

void setup() {
  // manage screen
  // JAVA-ANDROID
  //size(screenWidth, screenHeight);
  orientation(PORTRAIT);
  
  // define font size
  fontSize = round(height * 0.05);
  fontSizeSmall = round(height * 0.04);
  
  // menu
  menu = buildMenu();
  
  // create game manager
  gameManager = new GameManager();
}

// JAVA-ANDROID
/*void keyPressed() {
  if (key == ESC) {
    if (!gameManager.inMenu()) {
      backToMenu();
      // avoid quitting application by not passing back key to base class
      key = 0;
    }
  }
}*/

// JAVA-ANDROID
boolean surfaceKeyDown(int code, android.view.KeyEvent event) {
  if (event.getKeyCode() == android.view.KeyEvent.KEYCODE_BACK) {
    if (!gameManager.inMenu()) {
      backToMenu();
      // avoid quitting application
      return true;
    }
    else {
      // move the task to stack, so we can recover it
      moveTaskToBack(true);
      return true;
    } 
  }
  return super.surfaceKeyDown(code, event);
}

// JAVA-ANDROID
boolean surfaceKeyUp(int code, android.view.KeyEvent event) {
  return super.surfaceKeyDown(code, event);
}

// JAVA-ANDROID
void onPause() {
  super.onPause();
  if (gameManager != null) {
    gameManager.stopTimer();
  }
}

// JAVA-ANDROID
void onResume() {
  super.onResume();
  if (gameManager != null && !gameManager.inMenu()) {
    gameManager.resumeTimer();
  }
}

void backToMenu() {
  // open the menu
  gameManager.goToMenu();
  // add a resume button, if it does not exist yet and move the play button down a notch
  if (resumeButton == null) {
    resumeButton = new Button(int(width * 0.5), int(height * 0.111), int(9 * fontSize * 0.6), int(fontSize * 1.5), MENU_COLOR_FG1, MENU_COLOR_BG1, "Continuar", fontSize, false, 3, new Callback() {
      public void run() {
        // resume the game
        gameManager.resume();
      }
    });
    menu.registerButton(resumeButton);
    playButton.moveBy(0, int(0.055 * height));
  }
  // unhighlight the play and resume buttons
  playButton.unHighlight();
  resumeButton.unHighlight();
}

void mousePressed() {
  // do different stuff, depending on what state we are in
  // in the menu
  if (gameManager.inMenu()) {
    menu.click(mouseX, mouseY);
  }
  // we won
  else if (gameManager.won()) {
    if (delayTimer.getElapsedTime() > MIN_WAIT) {
      delayTimer.stop();
      gameManager.nextLevel();
    }
  }
  // we are playing
  else {
    // convert screen coordinates to tile coordinates
    int x = mouseX / tileWidthOnScreen;
    int y = mouseY / tileHeightOnScreen;
  
    // ignore clicks on correctly places tiles
    if (!tileManager.getTileAt(x, y).isMisplaced(x, y)) {
      return;
    }
    // two cases: a tile is already selected and we swap, or it is not and we just select it
    if (selector.isOn()) {
      // swap
      tileManager.tileSwap(x, y, selector.getX(), selector.getY());
    }
    // toggle in any case. this will unhighlight a selector after a swap and highlight a selector in the case it was off
    selector.toggle(x, y);
    // if we won, start delay timer
    if (gameManager.won()) {
      delayTimer.start();
    }
  }
}

void draw() {
  // clear buffer
  background(0);
  
  // depending on mode draw either menu or game screen
  // menu
  if (gameManager.inMenu()) {
    menu.draw();
  }
  // game screen
  else {
    // draw the tiles
    for (int x = 0; x < tileManager.getXTiles(); x++) { 
      for (int y = 0; y < tileManager.getYTiles(); y++) {
        int screenX = tileWidthOnScreen * x;
        int screenY = tileHeightOnScreen * y;
        tileManager.getTileAt(x, y).draw(screenX, screenY, tileWidthOnScreen, tileHeightOnScreen);
        if (tileManager.getTileAt(x, y).isMisplaced(x, y)) {
          image(tileOverlay, screenX, screenY, tileWidthOnScreen, tileHeightOnScreen);
        }
      }
    }
    // draw the highlight box around a tile if it has been selected
    if (selector.isOn()) {
      selector.draw(tileWidthOnScreen * selector.getX(), tileHeightOnScreen * selector.getY(), tileWidthOnScreen, tileHeightOnScreen);
    }
    // if we won, display a congratulations message
    if (gameManager.won()) {
      // get level time
      int ms = gameManager.getElapsedTime();
      int s = (ms / 1000) % 60;
      int m = ms / 60000;
      String elapsedTime = nf(m, 2) + ":" + nf(s, 2);
      // display level ended text.
      // display text depends on image orientation, as it is follows the orientation.
      // variables we need
      float rotation;
      int x, y, yStep, yStepSmall;
      // horizontal image 
      if (tileManager.levelIsWide()) {
        rotation = PI / 2.0;
        x = round(height * 0.5);
        y = -round(width * 0.85);
        yStep = round(width * 0.2);
        yStepSmall = round(width * 0.1);
      }
      // vertical image
      else {
        rotation = 0.0f;
        x = round(width * 0.5);
        y = round(height * 0.25);
        yStep = round(height * 0.15);
        yStepSmall = round(height * 0.05);
      }
      // draw the text
      pushMatrix();
      rotate(rotation);
      strokeText("Parabéns bonitinha", x, y, fontSize, color(246, 181, 6), color(0, 0, 0), CENTER, CENTER, 2);
      y += yStep;
      strokeText("Ganhou!", x, y, fontSize, color(34, 161, 212), color(0, 0, 0), CENTER, CENTER, 2);
      y += yStep;
      strokeText("Seu tempo", x, y, fontSizeSmall, color(245, 12, 63), color(0, 0, 0), CENTER, CENTER, 2);
      y += yStepSmall;
      strokeText(elapsedTime, x, y, fontSizeSmall, color(255, 255, 255), color(0, 0, 0), CENTER, CENTER, 2);
      y += yStep;
      strokeText("Próximo nível", x, y, fontSize, color(30, 179, 21), color(0, 0, 0), CENTER, CENTER, 2);
      popMatrix();
    }
  }
}

public void play() {
  // tile manager
  tileManager = new TileManager(xTiles, yTiles, dataPath(""), "level");
  gameManager.setTileManager(tileManager);
     
  // gui objects
  tileWidthOnScreen = width / xTiles;
  tileHeightOnScreen = height / yTiles;
  selector = new Selector(SELECTOR_COLOR, SELECT_STROKE_WEIGHT);
  tileOverlay = loadImage("button.png");
  delayTimer = new Timer();
  
  // start game
  gameManager.setLevel(startingLevel);  
  gameManager.play();
}

public void setDifficulty(int level) {
  if (level == EASY) {
    xTiles = 4;
    yTiles = 6;
  }
  else if (level == MEDIUM) {
    xTiles = 5;
    yTiles = 7;
  }
  else if (level == HARD) {
    xTiles = 6;
    yTiles = 9;
  }
}

public void setLevel(int level) {
  startingLevel = level;
}

Menu buildMenu() {
  menu = new Menu();
  // play button
  playButton = new Button(int(width * 0.5), int(height * 0.167), int(5 * fontSize * 0.75), int(fontSize * 1.5), MENU_COLOR_FG1, MENU_COLOR_BG1, "Iniciar", fontSize, false, 0, new Callback() {
    public void run() {
      play();
    }
  });
  menu.registerButton(playButton);
  // level buttons
  menu.registerLabel(new Label("Nível", int(width * 0.5), int(height * 0.333), fontSize, MENU_COLOR_FG1, MENU_COLOR_BG1));
  menu.registerButton(new Button(int(width * 0.167), int(height * 0.458), fontSizeSmall, int(fontSizeSmall * 1.5), MENU_COLOR_FG2, MENU_COLOR_BG1, "1", fontSizeSmall, true, 1, new Callback(){
    public void run() {
      setLevel(1);
    }
  }));
  menu.registerButton(new Button(int(width * 0.333), int(height * 0.458), fontSizeSmall, int(fontSizeSmall * 1.5), MENU_COLOR_FG2, MENU_COLOR_BG1, "2", fontSizeSmall, false, 1, new Callback(){
    public void run() {
      setLevel(2);
    }
  }));
  menu.registerButton(new Button(int(width * 0.5), int(height * 0.458), fontSizeSmall, int(fontSizeSmall * 1.5), MENU_COLOR_FG2, MENU_COLOR_BG1, "3", fontSizeSmall, false, 1, new Callback(){
    public void run() {
      setLevel(3);
    }
  }));
  menu.registerButton(new Button(int(width * 0.667), int(height * 0.458), fontSizeSmall, int(fontSizeSmall * 1.5), MENU_COLOR_FG2, MENU_COLOR_BG1, "4", fontSizeSmall, false, 1, new Callback(){
    public void run() {
      setLevel(4);
    }
  }));
  menu.registerButton(new Button(int(width * 0.833), int(height * 0.458), fontSizeSmall, int(fontSizeSmall * 1.5), MENU_COLOR_FG2, MENU_COLOR_BG1, "5", fontSizeSmall, false, 1, new Callback(){
    public void run() {
      setLevel(5);
    }
  }));
  menu.registerButton(new Button(int(width * 0.167), int(height * 0.542), fontSizeSmall, int(fontSizeSmall * 1.5), MENU_COLOR_FG2, MENU_COLOR_BG1, "6", fontSizeSmall, false, 1, new Callback(){
    public void run() {
      setLevel(6);
    }
  }));
  menu.registerButton(new Button(int(width * 0.333), int(height * 0.542), fontSizeSmall, int(fontSizeSmall * 1.5), MENU_COLOR_FG2, MENU_COLOR_BG1, "7", fontSizeSmall, false, 1, new Callback(){
    public void run() {
      setLevel(7);
    }
  }));
  menu.registerButton(new Button(int(width * 0.5), int(height * 0.542), fontSizeSmall, int(fontSizeSmall * 1.5), MENU_COLOR_FG2, MENU_COLOR_BG1, "8", fontSizeSmall, false, 1, new Callback(){
    public void run() {
      setLevel(8);
    }
  }));
  menu.registerButton(new Button(int(width * 0.667), int(height * 0.542), fontSizeSmall, int(fontSizeSmall * 1.5), MENU_COLOR_FG2, MENU_COLOR_BG1, "9", fontSizeSmall, false, 1, new Callback(){
    public void run() {
      setLevel(9);
    }
  }));
  menu.registerButton(new Button(int(width * 0.833), int(height * 0.542), int(1.5 * fontSizeSmall), int(fontSizeSmall * 1.5), MENU_COLOR_FG2, MENU_COLOR_BG1, "10", fontSizeSmall, false, 1, new Callback(){
    public void run() {
      setLevel(10);
    }
  }));
  // set level to match highlighted button
  setLevel(1);
  // difficulty buttons
  menu.registerLabel(new Label("Dificuldade", int(width * 0.5), int(height * 0.667), fontSize, MENU_COLOR_FG1, MENU_COLOR_BG1));
  menu.registerButton(new Button(int(width * 0.2), int(height * 0.792), int(5 * fontSizeSmall * 0.6), int(fontSizeSmall * 1.5), MENU_COLOR_FG2, MENU_COLOR_BG1, "Fácil", fontSizeSmall, false, 2, new Callback() {
    public void run() {
      setDifficulty(EASY);
    }
  }));
  menu.registerButton(new Button(int(width * 0.5), int(height * 0.792), int(5 * fontSizeSmall * 0.6), int(fontSizeSmall * 1.5), MENU_COLOR_FG2, MENU_COLOR_BG1, "Média", fontSizeSmall, true, 2, new Callback() {
    public void run() {
      setDifficulty(MEDIUM);
    }
  }));
  menu.registerButton(new Button(int(width * 0.8), int(height * 0.792), int(5 * fontSizeSmall * 0.6), int(fontSizeSmall * 1.5), MENU_COLOR_FG2, MENU_COLOR_BG1, "Difícil", fontSizeSmall, false, 2, new Callback() {
    public void run() {
      setDifficulty(HARD);
    }
  }));
  // set the difficulty to match highlighted button
  setDifficulty(MEDIUM);
  // return our shiny new menu
  return menu;
}

