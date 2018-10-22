/**
 * Measures how far away a given pixel on the canvas is from the camera. White is closer. 
 * However, it seems to be bit relative, so it's best used to measure changes between frames and not as an absolute measurement.
 *
 * @param PImage map – greyscale map image from Kinect generated using kinect.depthImage() from SimpleOpenNI 
 * @param float x – x coordinate on the canvas to measure on the image 
 * @param float y – y coordinate on the canvas to measure on the image
 * @return float – Returns a number between 0 and 255
 */
float getDepth(PImage map, float x, float y) {
  // Translate the given coordinates to map the canvas onto the map image. 
  float mx, my;
  mx = map(x, 0, width, 0, map.width);
  my = map(y, 0, height, 0, map.height);
  
  // Translate the map coordinates into an approximate pixels, since pixels in PImages are in a 1-dimensional array.
  int index = floor(mx);
  index += floor(my) * map.width;
  index = constrain(index, 0, map.pixels.length - 1);
  
  // Return the brightness (0-255) of the pixel
  return brightness(map.pixels[index]);
}
