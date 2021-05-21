/**
 * Load and Display 
 * 
 * Images can be loaded and displayed to the screen at their actual size
 * or any other size. 
 */

PImage img;  // Declare variable "a" of type PImage
float marginTop = 117;
float marginBottom = 70;
float marginLeft = 173;
float marginRight = 128;

void setup() {
  // 2560, 1800 // img size
  // 853, 600 // img size /3
  size(853, 600);
  //fullScreen();
  // The image file must be in the data folder of the current sketch 
  // to load successfully
  img = loadImage("LLC.jpg");  // Load the image into the program  
}

void draw() {
  // Displays the image at its actual size at point (0,0)
  //image(img, 0, 0);
  
  // Displays the image at point (0, height/2) at half of its size
  image(img, 0, 0, img.width/3, img.height/3);
  
  stroke(0);
  strokeWeight(4);
  float x = constrain(mouseX, marginLeft, width-marginRight);
  line(x, marginTop, x, height - marginBottom);

  println(mouseX);
}
