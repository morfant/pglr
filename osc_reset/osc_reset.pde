/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
final String DEST_ADDR = "localhost";
// String const DEST_ADDR = "192.168.0.4";


void setup() {
  size(400, 400);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 2000);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  // myRemoteLocation = new NetAddress("192.168.0.4", 12000);
  myRemoteLocation = new NetAddress(DEST_ADDR, 12000);
}


void draw() {
  background(0);  

  if (keyPressed) {
    fill(0);
    if (key == 'r' || key == 'R') {
      sendResetMsg("r");
      println("r");
    } else if (key == 'd' || key == 'D') {
      sendResetMsg("d");
      println("d");
    } else if (key == 'f' || key == 'F') {
      sendResetMsg("f");
      println("f");
    } else if (key == 'j' || key == 'J') {
      sendResetMsg("j");
      println("j");
    } else if (key == 'k' || key == 'K') {
      sendResetMsg("k");
      println("k");
    } else if (key == 'b' || key == 'B') {
      sendResetMsg("b");
    } else if (key == 'w' || key == 'W') {
      sendResetMsg("w");
    }

    else if (key == '1') { sendResetMsg("1"); }
    else if (key == '2') { sendResetMsg("2"); }
    else if (key == '3') { sendResetMsg("3"); }

  } else {
    fill(255);
  }
  rect(25, 25, 50, 50);
}


void sendMsg(int i) {
  OscMessage myMessage = new OscMessage("/toConsole");

  myMessage.add(i); /* add an int to the osc message */

  oscP5.send(myMessage, myRemoteLocation);
}



void sendResetMsg(String str) {
  OscMessage myMessage = new OscMessage("/toConsole");

  myMessage.add(str); /* add an int to the osc message */

  oscP5.send(myMessage, myRemoteLocation);
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}
