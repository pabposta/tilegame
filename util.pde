void strokeText(String message, int x, int y, int size, color foreground, color background, int alignX, int alignY, int strokeSize) 
{ 
  /*
  Idea taken from http://forum.processing.org/one/topic/text-outline.html
  */
  textSize(size);
  textAlign(alignX, alignY);
  fill(background);
  if (strokeSize != 0) {
    text(message, x - strokeSize, y);
    text(message, x, y - strokeSize);
    text(message, x + strokeSize, y);
    text(message, x, y + strokeSize);
  }
  fill(foreground);
  text(message, x, y); 
} 
