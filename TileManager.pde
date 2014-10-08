import java.util.Arrays;

class TileManager {
  private int _xTiles;
  private int _yTiles;
  private String[] _levelFiles;
  private Tile[][] _tiles;
  private boolean _imageIsWide;
  
  public TileManager(int xTiles, int yTiles, String path, String prefix) {
    // copy parameters
    _xTiles = xTiles;
    _yTiles = yTiles;
    // create the tile matrix
    _tiles = new Tile[xTiles][yTiles];
    // read the list of level files
    getLevelFiles(path, prefix);
  }
  
  public void newLevel(int level) {
    // read the new level image from disk
    PImage img = loadImage(_levelFiles[level - 1]); // levels start counting at 1, but java arrays start counting at 0 (so we have a - 1)
    
    // if the image is wider than it is high, rotate it 90 degrees
    if (img.width > img.height) {
      // buffer for the new image
      PImage tmp = createImage(img.height, img.width, RGB);
      // load pixel array from image
      img.loadPixels();
      // copy the pixels one by one, swapping rows with columns, so that the picture is rotated to the right 90 degrees
      for (int i = 0; i < img.width; i++) {
        for (int j = 0; j < img.height; j++) {
          tmp.pixels[i * img.height + img.height - j - 1] = img.pixels[j * img.width + i];
        }
      }
      // update tmp image with copied pixel array
      tmp.updatePixels();
      // set tmp image as new img
      img = tmp;
      // set wide flag
      _imageIsWide = true;
    }
    else {
      // set wide flag to false
      _imageIsWide = false;
    }
    
    // divide the image into tiles
    int tileWidthInImage = img.width / _xTiles;
    int tileHeightInImage = img.height / _yTiles;
    for (int x = 0; x < _xTiles; x++) { 
      for (int y = 0; y < _yTiles; y++) {
        _tiles[x][y] = new Tile(img, x, y, tileWidthInImage, tileHeightInImage);
      }
    }
    
    // shuffle the image tiles with (modified) Fisher-Yates algorithm. a tile cannot be in its original spot 
    for (int x = _xTiles - 1; x >= 0; x--) {
      for (int y = _yTiles - 1; y >= 0; y--) {
        int i = int(random(x * _yTiles + y));
        int xSwap = i / _yTiles;
        int ySwap = i % _yTiles;
        
        // swap
        tileSwap(x, y, xSwap, ySwap);
      }
    }
  }
  
  public Tile getTileAt(int x, int y) {
    return _tiles[x][y];
  }
  
  public boolean noTilesMisplaced() {
    for (int x = 0; x < _xTiles; x++) { 
      for (int y = 0; y < _yTiles; y++) {
        // if just one is misplaced, we can return false
        if (_tiles[x][y].isMisplaced(x, y)) {
          return false;
        }
      }
    }
    // if we got here, no tiles are misplaced
    return true;
  }
  
  public void tileSwap (int x1, int y1, int x2, int y2) {
    // swap the tiles inside the array
    Tile tmp = _tiles[x1][y1];
    _tiles[x1][y1] = _tiles[x2][y2];
    _tiles[x2][y2] = tmp;
  }
  
  public int getNumberOfLevels() {
    return _levelFiles.length;
  }
  
  public boolean levelIsWide() {
    return _imageIsWide;
  }
  
  public int getXTiles() {
    return _xTiles;
  }
  
  public int getYTiles() {
    return _yTiles;
  }
  
  private void getLevelFiles(String path, final String prefix) {
    _levelFiles = new String[] {
      "level01.jpg",
      "level02.jpg",
      "level03.jpg",
      "level04.jpg",
      "level05.jpg",
      "level06.jpg",
      "level07.jpg",
      "level08.jpg",
      "level09.jpg",
      "level10.jpg"
    };
  }
}
