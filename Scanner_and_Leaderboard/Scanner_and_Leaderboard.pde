int canrun=0;
int canleaderboard=0;
long tstamp;
String[] leaderboardhttp;
String lastleader="";
int cannotify = 0;

// Number of rows in leaderboard table
int rowcount;

//This waypoint is unique so set it to a number
int thiswaypoint = 1;

//Set the framerate
int framerate = 20;

// Set up a variable to default to use the scanner
boolean scannermode = true;

//Use the F5 key to toggle pausing the application
boolean paused = false;

//Set up the link to the serial port for the card reader
import processing.serial.*;
Serial myport;

//Import the sound library
import ddf.minim.*;

Minim minim;

AudioSample running;

//Store the username, password and runner name as varibles
String usernamefield = "";
String hidepasswordfield = "";
String passwordfield = "";
String runnernamefield = "";
String username = "";
String password = "";
String runnername = "";
String liverunnername = "";

//Import Java libraries to calculate the time
import java.util.*;
import java.text.*;

//Variables used by the card reader
int havearduino = 0; // assume there is no arduino
String id;
String newid = "-- -- -- --";  //my id number
String previd = "";
String lastreading = "";
String thisreading = "";
//end of variables used by the card reader

//Store the current time as a string
String currenttime;

//Store the run start and finish times as strings
String starttime;
String finishtime;

//Store the cfurrent date as a string
String date;

//Store the duration of the run as a string
String duration;
String start;
String liveduration = "";

//Linefeed in ASCII
int lf = 10;

//Textbox focus
int focus = 1;

//Begin run
int goheight = -200;

int liveopacity = 0;
int livecounter = 999;

int welcomeposy = 0;
// Set the welcome counter to 0 to trigger the notifiction
int welcomecounter = 999;
String welcomerunnername = "";

int finishposy = 0;
// Set the finish counter to 0 to trigger the notification
int finishcounter = 999;

// Set the waypoint number when the program runs
boolean setwaypoint = false;

PFont proximanovaregular;
PFont proximanovabold;
PFont dinregular;
PFont rooneysans;
PFont rooneysansbold;

PImage logo;
PImage photo;

float usernameposx = 105;
float usernamesizex = 457;
float passwordposx = 105;
float passwordsizex = 457;
float runnernameposx = 105;
float runnernamesizex = 457;

// Leaderboard variables

Table leaderboard;

String leaderboardinitial;

int durationshown;

//String[] leaderboardhttp;

String fastest = ""; 
String lastfastest = "";

String firstrunner;

boolean notified = false;

boolean endnotification = false;

// New fastest runner notification
// Offset each position by 720 to transform it off the screen
int notifyposy = 720;

void setup() {

  fullScreen();

  //size(1920, 1080);
  leaderboardhttp = loadStrings("http://localhost:8888/processing/dump.php");

  leaderboardinitial = join(leaderboardhttp, "");
  //store last leader board as textstring 

  tstamp = millis();

  //Load in the sound files
  minim = new Minim(this);
  running = minim.loadSample("running.wav");
  running.trigger();

  // The leaderboard is displayed in a table format
  leaderboard = new Table();
  //leaderboard.addColumn("position"); //1st, 2nd, 3rd [...]
  leaderboard.addColumn("runnername"); // The runnername
  leaderboard.addColumn("duration"); // The duration of that run
  leaderboard.addColumn("durationindex"); // The duration of the run in hhmmss format sorts the table in ascending order, won't be displayed.
  leaderboard.setColumnType("durationindex", Table.INT); // Set the column type to integer

  // Load in the logo
  logo = loadImage("logo.png");

  // Load in the photo
  photo = loadImage("DSC_0052.jpg");

  //create the link to the card reader
  println(Serial.list());
  String arduino = "a";
  for (int lop=0; lop<Serial.list().length; lop=lop+1) {
    if (Serial.list()[lop].indexOf("cu.wchusbserial")>-1) {
      println("Found arduino:"+lop);
      arduino=Serial.list()[lop];
      havearduino=1; // we do have an arduino
    }
  }

  if (havearduino==1) {
    myport=new Serial(this, arduino, 9600);
    myport.bufferUntil(lf);
  }

  //end create the link to the card reader

  //frameRate(framerate);
  background(#E84D2A);

  proximanovaregular = createFont("proximanova-regular.otf", 22);
  proximanovabold = createFont("proximanova-bold.otf", 60);
  dinregular = createFont("din-regular.otf", 22);
  rooneysans = createFont("rooneysans-regular.ttf", 26);
  rooneysansbold = createFont("rooneysans-bold.ttf", 26);
}

void serialEvent(Serial myport) { 

  thisreading = myport.readString();
}

void keyPressed() {

  char k=key;
  println(keyCode);
  int clearuser=0;

  if ((canrun==0) && (k=='1' || k=='2')) {
    canrun=1;
    clearuser=1;

    // Set the waypoint number

    if ((setwaypoint == false) && (key == '1')) {
      thiswaypoint = 1;
      setwaypoint=true;
    }

    if ((setwaypoint == false) && (key == '2')) {
      thiswaypoint = 2;
      setwaypoint=true;
    }
  }

  //Pause the program
  if (keyCode == 116 && paused == false) {
    println("pausing");
    paused = true;
    noLoop();

    noStroke();
    fill(#E84D2A);
    rect(0, height/3-2, width, height);

    fill(#F3F3F3);
    textFont(proximanovabold);
    textSize(30);
    text("Paused"+"\n"+"Press any key to resume Runner's High", 1314, 651);
  }
  //Resume the program
  else {
    paused = false;
    loop();
  }

  if (focus==1) {
    if ((key >= 'A' && key <= 'z') || (key >= '0' && key <='9') || keyCode==32) {
      usernamefield += k;
    } else if ((keyCode==BACKSPACE) && (usernamefield.length()>0)) {
      usernamefield=usernamefield.substring(0, usernamefield.length()-1);
    }
  }
  if (focus==2) {
    if ((key >= 'A' && key <= 'z') || (key >= '0' && key <='9') || keyCode==32) {
      passwordfield += k;
      hidepasswordfield += "*";
    } else if ((keyCode==BACKSPACE) && (passwordfield.length()>0)) {
      passwordfield=passwordfield.substring(0, passwordfield.length()-1);
      hidepasswordfield=hidepasswordfield.substring(0, hidepasswordfield.length()-1);
    }
  }
  if (focus==3) {
    if ((k >= 'A' && k <= 'z') || keyCode==32) {
      runnernamefield += k;
    } else if ((keyCode==BACKSPACE) && (runnernamefield.length()>0)) {
      runnernamefield=runnernamefield.substring(0, runnernamefield.length()-1);
    }
  }
  //The user can use the ENTER key to register, if they fill all three text fields
  if (!(usernamefield.equals("")) && !(passwordfield.equals("")) && !(runnernamefield.equals("")) && keyCode==10) {
    Submit();
  }

  if (clearuser==1) {
    usernamefield="";
    // usernamefieldcursor=0;
    username="";
  }
}

void mousePressed() {

  if ((mouseX > 82 && mouseX < 585) && (mouseY > 578 && mouseY < 678)) {
    focus=1;
  }
  if ((mouseX > 82 && mouseX < 585) && (mouseY > 683 && mouseY < 788)) {
    focus=2;
  }
  if ((mouseX > 82 && mouseX < 585) && (mouseY > 788 && mouseY < 888)) {
    focus=3;
  }
  if ((mouseX > 200 && mouseX < 467) && (mouseY > 893 && mouseY < 998)) {
    Submit();
  }
  if ((mouseX > 1320 && mouseX < 1690) && (mouseY > 250 && mouseY < 350)) {
    if (scannermode == true) {
      scannermode = false;
      canrun=1;
      canleaderboard=1;
    } else {
      scannermode = true;
      canrun=1;
      canleaderboard=0;
    }
  }
}

void draw() {

  frameRate(framerate);
  //println(framerate);
  background(#E84D2A);
  image(photo, 0, 0);
  hint(ENABLE_STROKE_PURE);

  image(logo, 82, 82);

  if (canrun==1) {

    if (scannermode == true) {

      stroke(#F2F4F4);
      strokeWeight(2);
      fill(#E84D2A);
      rect(1320, 250, 370, 100);

      if (canleaderboard==0 && canrun==1) {
        fill(#F2F4F4);
        textFont(rooneysans);
        textSize(60);
        text("Leaderboard", 1340, 290);
      }

      String leadinghour = "";
      String leadingminute = "";
      String leadingsecond = "";

      if (hour() < 10) {
        leadinghour = "0";
      }
      if (minute() < 10) {
        leadingminute = "0";
      }
      if (second() < 10) {
        leadingsecond = "0";
      }

      currenttime = leadinghour+hour()+":"+leadingminute+minute()+":"+leadingsecond+second();

      // Show the registration form only on the first terminal
      if (thiswaypoint == 1) {

        fill(#F2F4F4);
        rect(82, 540, 503, 50);

        // Registration instructions
        fill(#E84D2A);
        textFont(rooneysans);
        textSize(18);
        textAlign(LEFT, LEFT);
        text("Fill the registration form before using for the first time.", 110, 570);

        // Username box
        fill(#F2F4F4);
        noStroke();
        rect(82, 578, 503, 105);

        // Username text
        clip(105, 578, 457, 100);
        fill(#1D1D1B);
        textFont(rooneysans);
        textSize(60);
        textAlign(LEFT, LEFT);
        text(usernamefield, usernameposx, 578 + textAscent() - 50, usernamesizex, 100);
        noClip();

        Float usernamecursorx = 105 + textWidth(usernamefield);

        if ((usernamefield == null) || (usernamefield.equals(""))) {
          fill(#1D1D1D, 50);
          textFont(rooneysans);
          textSize(60);
          text("Username:", 105, 578 + textAscent() + 12);
        }

        // If the username doesn't fit in the box
        if (textWidth(usernamefield) > 457) {
          usernameposx = 105 - (textWidth(usernamefield) - 457);
          usernamesizex = textWidth(usernamefield); 
          usernamecursorx = 562.0;
        } else {
          usernameposx = 105;
        }

        // Username cursor line
        if (focus == 1) {
          stroke(#1D1D1D);
          strokeWeight(2);
        } else {
          noStroke();
        }

        line(usernamecursorx, 596, usernamecursorx, 663);

        // Password Box
        fill(#F2F4F4);
        noStroke();
        rect(82, 683, 503, 105);

        // Password text
        clip(105, 683, 457, 100);
        fill(#1D1D1B);
        textFont(rooneysans);
        textSize(60);
        text(hidepasswordfield, passwordposx, 683 + textAscent() - 35, passwordsizex, 100);
        noClip();

        Float passwordcursorx = 110 + textWidth(hidepasswordfield);

        if ((passwordfield == null) || (passwordfield.equals(""))) {
          fill(#1D1D1D, 50);
          textFont(rooneysans);
          textSize(60);
          text("Password:", 105, 683 + textAscent() + 12);
        }

        // If the password doesn't fit in the box
        if (textWidth(hidepasswordfield) > 457) {
          passwordposx = 105 - (textWidth(hidepasswordfield) - 457);
          passwordsizex = textWidth(hidepasswordfield); 
          passwordcursorx = 562.0;
        } else {
          passwordposx = 105;
        }

        // Password cursor line
        if (focus == 2) {
          stroke(#1D1D1D);
          strokeWeight(2);
        } else {
          noStroke();
        }

        line(passwordcursorx, 701 + textAscent() - 60, passwordcursorx, 768);

        // Runnername box
        fill(#F2F4F4);
        noStroke();
        rect(82, 788, 503, 105);

        // Runnername text
        clip(105, 788, 457, 100);
        fill(#1D1D1B);
        textFont(rooneysans);
        textSize(60);
        text(runnernamefield, runnernameposx, 788 + textAscent() - 50, runnernamesizex, 100);
        noClip();

        Float runnernamecursorx = 105 + textWidth(runnernamefield);

        if ((runnernamefield == null) || (runnernamefield.equals(""))) {
          fill(#1D1D1D, 50);
          textFont(rooneysans);
          textSize(60);
          text("Your name:", 105, 788 + textAscent() + 12);
        }

        // If the runnername doesn't fit in the box
        if (textWidth(runnernamefield) > 457) {
          runnernameposx = 105 - (textWidth(runnernamefield) - 457);
          runnernamesizex = textWidth(runnernamefield); 
          runnernamecursorx = 562.0;
        } else {
          runnernameposx = 105;
        }

        // Runnername cursor line
        if (focus == 3) {
          stroke(#1D1D1D);
          strokeWeight(2);
        } else {
          noStroke();
        }

        line(runnernamecursorx, 800, runnernamecursorx, 867);

        if ((mouseX > 200 && mouseX < 467) && (mouseY > 893 && mouseY < 998)) {
          cursor(HAND);
        } else if ((mouseX > 82 && mouseX < 585) && (mouseY > 578 && mouseY < 678) || (mouseX > 82 && mouseX < 585) && (mouseY > 683 && mouseY < 788) || (mouseX > 82 && mouseX < 585) && (mouseY > 788 && mouseY < 888)) {
          cursor(TEXT);
        } else {
          cursor(ARROW);
        }

        stroke(#F2F4F4);
        strokeWeight(2);
        fill(#E84D2A);
        rect(200, 893, 267, 105);

        fill(#F2F2F2);
        textFont(rooneysans);
        textSize(60);
        text("Register", 227, 960);
      }

      stroke(255);
      strokeWeight(2);
      //line(width/3, height/3, width/3, height);
      //line(0, height/3, width, height/3);

      fill(#F2F2F2);
      textFont(rooneysans);
      textSize(40);
      text("Time", 1314, 401, 256, 52);

      fill(#F2F2F2);
      textFont(dinregular);
      textSize(110);
      textAlign(LEFT, CENTER);
      text(currenttime, 1314, 453, 512, 105);

      fill(#F2F2F2);
      textFont(rooneysans);
      textSize(40);
      text("Waypoint", 1314, 599, 256, 52);

      fill(#F2F2F2);
      textFont(proximanovabold);
      textSize(110);
      textAlign(LEFT, CENTER);
      text(str(thiswaypoint), 1314, 651, 512, 105);

      /*
      if (livecounter < 150) {
       
       liveDuration();
       liveRunInfo();
       }
       */

      if (welcomecounter < 150) {

        welcome();
      }

      if (finishcounter < 150) {

        finish();
      }
    }

    if (canleaderboard == 1 && canrun == 1) {

      stroke(#F2F4F4);
      strokeWeight(2);
      fill(#E84D2A);
      rect(1320, 250, 370, 100);

      fill(#F2F4F4);
      textFont(rooneysans);
      textSize(60);
      text("Back", 1560, 320);
    }

    if (thisreading.equals(lastreading)==false) {

      println(thisreading);

      scannermode = true;

      canleaderboard = 0;

      lastreading=thisreading;

      int stpos6=thisreading.indexOf("UID:");

      newid=thisreading.substring(stpos6+5);
      //thisreading="";
      println("**newid="+newid+"**");

      //Start removal of spaces in card ID
      String pair1=newid.substring(0, 2);
      String pair2=newid.substring(3, 5);
      String pair3=newid.substring(6, 8);
      String pair4=newid.substring(9, 11);

      id=pair1+pair2+pair3+pair4;
      println(id);
      //End removal of spaces in card ID

      //Newly registered runners who entered text into all three fields and this must be the first terminal.
      //The user text fields are not displayed in the GUI so new users can only start runs from the first terminal.
      if (!username.equals("") && !password.equals("") && !runnername.equals("") && thiswaypoint == 1) {
        println(username+password+runnername);

        newUser();
      }
      //Existing users who scanned a card at the terminal
      else {

        println("Go to checkCardID()");

        //Check if the card ID is already in the database, if it is then run existingUser()
        checkCardID();
      }

      lastreading = thisreading;
    } else {

      if (canleaderboard==1)  leaderboard();
    }

    if ((setwaypoint = false) && !((thiswaypoint == 1) || (thiswaypoint == 2))) {

      println("pausing");
      noLoop();

      noStroke();
      fill(#E84D2A);
      rect(0, height/3-2, width, height);

      fill(#F3F3F3);
      textFont(proximanovabold);
      textSize(30);
      text("Type either 1 or 2 to set this waypoint number.", 640, 651);
    }
  }//end of canrun==1;
}

void Submit() {

  println("the following text was submitted :");
  //Replace any spaces in the runnername with underscores
  //Replace any spaces in the username with underscores
  for (int i = 0; i < usernamefield.length(); i++) {
    usernamefield = usernamefield.replaceAll(" ", "_");
  }
  //Replace any spaces in the password with underscores
  for (int i = 0; i < passwordfield.length(); i++) {
    passwordfield = passwordfield.replaceAll(" ", "_");
  }
  for (int i = 0; i < runnernamefield.length(); i++) {
    runnernamefield = runnernamefield.replaceAll(" ", "_");
  }

  username = usernamefield;
  password = passwordfield;
  runnername = runnernamefield;
  println("Name = " + runnername);
  println("Username = " + username);
  println("Password = " + password);

  println("Reset the namefield, usernamefield and passwordfield");
  usernamefield = "";
  hidepasswordfield = "";
  passwordfield = "";
  runnernamefield = "";
}

void newUser() {

  //if (!(username.equals("")) && !(password.equals("")) && !(runnername.equals(""))) {
  //Store the current day, date and month as a string called 'today'
  Date date = new Date();
  SimpleDateFormat daydate = new SimpleDateFormat ("EEEE_dd");
  SimpleDateFormat month = new SimpleDateFormat ("MMMMM");
  //Get today's ordinal and store it in the string 'ordinal'
  String[] ordinals = { "", "st", "nd", "rd", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th", "th", "st" };
  int day = day();
  String ordinal = ordinals[day];
  String today = daydate.format(date)+ordinal+"_"+month.format(date);
  println(today);

  //Store the current time as a string called 'starttime'
  //starttime=year()+":"+month()+":"+day()+":"+hour()+":"+minute()+":"+second();
  starttime=hour()+":"+minute()+":"+second();

  String[] createData = loadStrings("http://localhost:8888/processing/createData.php?username="+username+"&password="+password+"&runnername="+runnername+"&cid="+id+"&date="+today+"&tstamp1="+starttime+"&terminalid="+thiswaypoint);
  println("http://localhost:8888/processing/createData.php?username="+username+"&password="+password+"&runnername="+runnername+"&cid="+id+"&date="+today+"&tstamp1="+starttime+"&terminalid="+thiswaypoint);
  println(createData);

  println("A new user has been registered and their run has begun");

  //Play the running sound
  running.trigger();

  //Welcome the new runner as they begin their first run
  welcomecounter = 0;
  welcomeposy = 0;

  //Store the submitted runnername as a string to welcome the new runner
  welcomerunnername = runnername;

  //Replace all the underscores with spaces
  for (int i = 0; i < welcomerunnername.length(); i++) {
    welcomerunnername = welcomerunnername.replaceAll("_", " ");
  }

  username = "";
  password = "";
  runnername = "";
  //} else {
  //println("didn't create a new user because runner details weren't entered");
  //}
}

void welcome() {

  difference();

  //Replace all the underscores with spaces
  for (int i = 0; i < duration.length(); i++) {
    duration = duration.replaceAll("_", " ");
  }

  if ((welcomecounter <= 120) && (welcomeposy <= 255)) {
    welcomeposy += 10;
    println("starting to welcome the new user, welcomeposy is up to: "+welcomeposy);
  }
  if ((welcomecounter > 120) && (welcomeposy >= 0)) {
    //stop the animation for 20 seconds
    //delay(20000);
    welcomeposy += -10;
    println("starting to hide the new user welcome, welcomeposy is down to: "+welcomeposy);
  }

  //The screen will light up in a red colour
  noStroke();
  fill(#E84D2A, welcomeposy);
  rect(0, 0, width, height);

  //A welcome message to greet the new user
  fill(#F2F2F2, welcomeposy);
  textFont(rooneysans);
  textSize(120);
  textAlign(CENTER, LEFT);
  textLeading(textAscent() * 1.1);
  text("Hi, "+welcomerunnername+"\n Get going!\n"+duration, width/2, height/2.5);

  welcomecounter += 1;
  println("the welcomecounter is at"+welcomecounter);
}

void finish() {

  difference();

  //Replace all the underscores with spaces
  for (int i = 0; i < duration.length(); i++) {
    duration = duration.replaceAll("_", " ");
  }

  if ((finishcounter <= 120) && (finishposy <= 255)) {
    finishposy += 10;
    println("starting to show the welcome message, finishposy is up to: "+finishposy);
  }
  if ((finishcounter > 120) && (finishposy >= 0)) {
    //stop the animation for 20 seconds
    //delay(20000);
    finishposy += -10;
    println("starting to hide the finish message, finishposy is down to: "+finishposy);
  }

  //The screen will light up in a red colour
  noStroke();
  fill(#E84D2A, finishposy);
  rect(0, 0, width, height);

  //frozentime = 

  //A welcome message to greet the new user
  fill(#F2F2F2, finishposy);
  textFont(rooneysans);
  textSize(120);
  textAlign(CENTER, LEFT);
  textLeading(textAscent() * 1.1);
  text("Hi, "+liverunnername+"\n You have finished a run!\n"+duration, width/2, height/2.5);

  finishcounter += 1;
  println("the finishcounter is at"+finishcounter);
}

void checkCardID() {

  println(id);

  String[] checkCardID = loadStrings("http://localhost:8888/processing/checkCardID.php?cid="+id);
  String checkingCardID = join(checkCardID, "");
  //String checkingCardID = "0";

  println(checkingCardID);

  //The card ID does exist in the database
  if (checkingCardID.equals("1")==true) {

    //If this is the beginning of a new run then set the start time to the current time
    if (thiswaypoint == 1) {
      start = hour()+":"+minute()+":"+second();
    }
    //If this is not the first terminal then retrieve the start time from the database
    else {
      String[] starttime = loadStrings("http://localhost:8888/processing/terminalTime.php?cid="+id+"&terminalid=1");
      //Store the 'starttime' parameter as the string 'start'
      start = join(starttime, "");
    }

    //Retrieve the runnername associated with the card ID
    String[] checkrunnername = loadStrings("http://localhost:8888/processing/runnername.php?cid="+id);
    liverunnername = join(checkrunnername, "");
    //Replace all the underscores with spaces
    for (int i = 0; i < liverunnername.length(); i++) {
      liverunnername = liverunnername.replaceAll("_", " ");
    }
    println("the name of the current runner is: "+liverunnername);
    println("The card exists so try to make run data");
    existingUser();
    return;
  }
  //The card ID doesn't exist in the database
  if (checkingCardID.equals("0")==true) {
    //The card doesn't exist
    println("No such card ID exists in the database, you should type in your details");
    return;
  }
  //Don't know if the card ID does exist in the database
  else {
    println("Don't know if the card ID does exists in the database.");
  }
}

void liveDuration() {

  println(start);

  //If the card ID doesn't have a start time then don't calculate the run duration
  if ((start == null) || (start.indexOf(":")==-1)) {
    println("There is no start time to be parsed");
  } 
  //If the card ID does have a start time then calculate the run duration
  else {
    //Create a string array with the first swipe and split the date fields
    String[] st1=start.split(":");

    int hr1=int(st1[0]);
    int min1=int(st1[1]);
    int sec1=int(st1[2]);

    //Create a string array with the current time and split the date fields
    currenttime=hour()+":"+minute()+":"+second();
    String[] ft1=currenttime.split(":");
    int hr2=int(ft1[0]);
    int min2=int(ft1[1]);
    int sec2=int(ft1[2]);

    String livedifference="";
    String daylabel="";
    String hourlabel="";
    String minutelabel="";
    String secondlabel="";

    //Create a string for the start swipe
    //String input=yr1+"-"+mnth1+"-"+dy1+"-"+hr1+"-"+min1+"-"+sec1;
    String input=hr1+"-"+min1+"-"+sec1;

    //Set the date format for the start swipe
    //SimpleDateFormat st2 = new SimpleDateFormat ("yyyy-M-dd-h-m-s");
    SimpleDateFormat st2 = new SimpleDateFormat ("h-m-s");

    //Create a string for the finish swipe
    //String input2=yr2+"-"+mnth2+"-"+dy2+"-"+hr2+"-"+min2+"-"+sec2;
    String input2=hr2+"-"+min2+"-"+sec2;

    //Set the date format for the finish swipe 
    //SimpleDateFormat ft2 = new SimpleDateFormat ("yyyy-M-dd-h-m-s");
    SimpleDateFormat ft2 = new SimpleDateFormat ("h-m-s");

    println(input);
    println(input2);  

    //Parse the first swipe date
    Date t1=new Date();
    try {
      t1 = st2.parse(input); 
      println(t1);
    }
    catch (ParseException e) { 
      println("Unparseable using " + st2);
    }

    //Parse the second swipe date
    Date t2=new Date();
    try {
      t2 = ft2.parse(input2); 
      println(t2);
    }
    catch (ParseException e) { 
      println("Unparseable using " + ft2);
    }

    println(t2.getTime());
    println(t1.getTime());

    long diff = t2.getTime() - t1.getTime();
    long diffSeconds = (diff / 1000) % 60;
    long diffMinutes = (diff / (60 * 1000)) % 60;
    long diffHours = (diff / (60 * 60 * 1000)) % 24;
    int diffDays = (int) (diff / (1000 * 60 * 60 * 24));

    //Pluralise the time labels or not
    if (diffDays == (1)) {
      daylabel=" day";
    } else {
      daylabel=" days";
    }

    if (diffHours == (1)) {
      hourlabel=" hour";
    } else {
      hourlabel=" hours";
    }

    if (diffMinutes == (1)) {
      minutelabel=" minute";
    } else {
      minutelabel=" minutes";
    }

    if (diffSeconds == (1)) {
      secondlabel=" second";
    } else {
      secondlabel=" seconds";
    }
    //End pluralise

    livedifference=diffDays+daylabel+", "+diffHours+hourlabel+", "+diffMinutes+minutelabel+" and "+diffSeconds+secondlabel;
    //If days aren't needed then strip them
    if (diffDays<(1)) {
      livedifference=diffHours+hourlabel+", "+diffMinutes+minutelabel+" and "+diffSeconds+secondlabel;
    }
    //If days and hours aren't needed then strip them
    if (diffDays < (1) & diffHours < (1)) {
      livedifference=diffMinutes+minutelabel+" and "+diffSeconds+secondlabel;
    }
    //If days and minutes aren't needed then strip them
    if (diffDays < (1) & diffMinutes < (1)) {
      livedifference=diffHours+hourlabel+" and "+diffSeconds+secondlabel;
    }
    //If days, hours and minutes aren't needed then strip them
    if (diffDays < (1) & diffHours < (1) & diffMinutes < (1)) {
      livedifference=diffSeconds+secondlabel;
    }
    //If days and seconds aren't needed then strip them
    if (diffDays<(1) & diffSeconds < (1)) {
      livedifference=diffHours+hourlabel+" and "+diffMinutes+minutelabel;
    }
    //If days, minutes and seconds aren't needed then strip them
    if (diffDays<(1) & diffMinutes < (1) & diffSeconds < (1)) {
      livedifference=diffHours+hourlabel;
    }
    //If days, hours and seconds aren't needed then strip them
    if (diffDays<(1) & diffHours < (1) & diffSeconds < (1)) {
      livedifference=diffMinutes+minutelabel;
    }

    println(livedifference);

    liveduration = livedifference;
  }
}

/*
//Add the runner name and their time to draw and hide it after 5 seconds
 void liveRunInfo() {
 
 if ((livecounter <= 120) && (liveopacity <= 255)) {
 liveopacity += 10;
 println("starting to show the live run info, liveopacity is up to: "+liveopacity);
 }
 if ((livecounter > 120) && (liveopacity >= 0)) {
 liveopacity += -10;
 println("starting to hide the live run info, liveopacity is down to: "+liveopacity);
 }
 fill(#E84D2A, liveopacity);
 textFont(proximanovabold);
 textSize(60);
 textAlign(LEFT, LEFT);
 text("Hi, "+liverunnername, (width/2) + 100, 650);
 
 fill(#E84D2A, liveopacity);
 textFont(rooneysans);
 textSize(40);
 textAlign(LEFT, LEFT);
 text("You", (width/2) + 100, 750);
 
 fill(#E84D2A, liveopacity);
 textFont(dinregular);
 textSize(60);
 textAlign(LEFT, LEFT);
 text(liveduration, (width/2) + 100, 900);
 
 noStroke();
 fill(#F2F2F2);
 rect(width/2, height/3, width, height);
 
 livecounter += 1;
 
 println("the livecounter is at"+livecounter);
 } */

void existingUser() {

  //Store the current day, date and month as a string called 'today'
  Date date = new Date();
  SimpleDateFormat daydate = new SimpleDateFormat ("EEEE_dd");
  SimpleDateFormat month = new SimpleDateFormat ("MMMMM");
  //Get today's ordinal and store it in the string 'ordinal'
  String[] ordinals = { "", "st", "nd", "rd", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th", "th", "st" };
  int day = day();
  String ordinal = ordinals[day];
  String today = daydate.format(date)+ordinal+"_"+month.format(date);
  println(today);

  //Store the current time as a string called 'currenttime'
  //currenttime=year()+":"+month()+":"+day()+":"+hour()+":"+minute()+":"+second();
  currenttime=hour()+":"+minute()+":"+second();
  println(currenttime);

  //Download which terminal the card was at last and store it as the string array 'terminal'
  String[] terminal = loadStrings("http://localhost:8888/processing/terminalID.php?cid="+id);

  println(terminal);

  //Store the 'terminal' parameter as the string 'previousterminal' so that the IF statements can compare it to strings
  String previousterminal = join(terminal, "");

  println("The card was last at terminal number: "+previousterminal);

  //If this is the first terminal then start a new run
  if (thiswaypoint == 1) {

    String[] createData = loadStrings("http://localhost:8888/processing/createData.php?cid="+id+"&date="+today+"&tstamp1="+currenttime+"&terminalid="+thiswaypoint);

    println("http://localhost:8888/processing/createData.php?cid="+id+"&tstamp1="+currenttime+"&terminalid="+thiswaypoint);

    println("This is the first terminal so start a new run");

    println(createData);

    //Play the running sound
    running.trigger();

    //Don't show the live run info to existing users when they start a new run
    livecounter = 999;
    liveopacity = 0;

    //Welcome the existing runner as they begin a new run,
    welcomecounter = 0;
    welcomeposy = 0;

    //Retrieve the runnername associated with the card ID
    String[] checkrunnername = loadStrings("http://localhost:8888/processing/runnername.php?cid="+id);
    //Store the submitted runnername as as string to welcome the new runner
    welcomerunnername = join(checkrunnername, "");

    //Replace all the underscores with spaces
    for (int i = 0; i < welcomerunnername.length(); i++) {
      welcomerunnername = welcomerunnername.replaceAll("_", " ");
    }

    //Break out of the existingUser() function
    return;
  }

  //The runner is finishing at waypoint 2
  if ((previousterminal.equals("1")==true) && (thiswaypoint == 2)) {

    difference();

    String[] updateData = loadStrings("http://localhost:8888/processing/updateData.php?cid="+id+"&tstamp2="+currenttime+"&duration="+duration+"&terminalid="+thiswaypoint);

    println("An existing runner has finished their run");

    println(updateData);

    //Play the running sound
    running.trigger();

    //Don't show the live run info because the runner has finished
    //livecounter = 0;
    //liveopacity = 0;

    //Welcome back the runner as their run has finished
    finishposy = 0;
    finishcounter = 0;

    if (canleaderboard==1)   leaderboard();

    //Break out of the existingUser() function
    return;
  }
  /*
  //The runner is arriving at terminal 3
   if ((previousterminal.equals("2")==true) && (thiswaypoint == 3)) {
   
   difference();
   
   String[] updateData = loadStrings("http://localhost:8888/processing/updateData.php?cid="+id+"&tstamp3="+currenttime+"&duration="+duration+"&terminalid="+thiswaypoint);
   
   println("An existing runner has continued their run towards terminal number 4");
   
   println(updateData);
   
   //Play the running sound
   running.trigger();
   
   //Reset the timing of the live info animation for the current runner
   livecounter = 0;
   liveopacity = 0;
   
   //Break out of the existingUser() function
   return;
   }
   //The runner is finishing a run at terminal 4
   if ((previousterminal.equals("3")==true) && (thiswaypoint == 4)) {
   
   difference();
   
   String[] updateData = loadStrings("http://localhost:8888/processing/updateData.php?cid="+id+"&tstamp4="+finishtime+"&duration="+duration+"&terminalid="+thiswaypoint);
   
   println("An existing runner has finished their run");
   
   println(updateData);
   
   //Play the running sound
   running.trigger();
   
   //Break out of the existingUser() function
   return;
   }
   */

  println("Error trying to send run data for the current terminal.");
}

void updateLeaderboard() {

  // Retrieve the database dump
  leaderboardhttp = loadStrings("http://localhost:8888/processing/dump.php");

  String leaderboarddump = join(leaderboardhttp, "");

  if (leaderboardinitial.equals(leaderboarddump) == false) {
    cannotify = 1;

    //convert to thisleaderboard ... a big wadge of text
    //if !bigwadeoftext is .equals(firstleaderboard) candisplay=1;
    //String[] leaderboardhttp = loadStrings("dump.html");
  }
}

void leaderboard() {

  //if (firstrun == 0) {
  //Wait 10 seconds
  //delay(10000);

  framerate = 60;

  noStroke();
  fill(#F1F1F1);
  rect(0, 360, width, 720);

  if (millis() - tstamp > 5 * 1000) {
    thread("updateLeaderboard");
    tstamp = millis();
  }

  // Retrieve the database dump
  //String[] leaderboard = loadStrings("http://localhost:8888/processing/dump.php");

  String rawleaderboard = join(leaderboardhttp, "");

  //println("Retrieved the leaderboard dump from the server");

  //Replace all underscores with spaces
  for (int i = 0; i < rawleaderboard.length(); i++) { 
    rawleaderboard = rawleaderboard.replaceAll("_", " ");
  }

  //printArray(leaderboard);

  //Split the string leaderboard on double asterisks
  String[] rawdata = split(rawleaderboard, "**");
  //println("Outside the for loop");
  //printArray(rawdata);

  // Remove the empty first draw in the array 
  rawdata = subset(rawdata, 1);
  //printArray(rawdata);

  //Prepare the formatted duration
  String finaltime="";

  for (int lop=0; lop<rawdata.length; lop++) {

    String item=rawdata[lop];

    // Strip line break and horizonal line HTML tags
    for (int lop2 = 0; lop2 < item.length(); lop2++) {
      item = item.replaceAll("<br><hr>", "");
    }

    finaltime = "";

    //FIRST DEAL WITH HOURS
    String finalhours="00"; 

    if (item.indexOf(" hour")>-1) { //if hours is in the string then we have more than zero hours and need to find out how manyt we have
      int stpos=item.indexOf(" hour")-2; //start at the beginning of the line
      int enpos=item.indexOf(" hour"); //seek where ' hour' occurs
      String hourstring=item.substring(stpos, enpos); //pull out the number as a string ... start of the string to the occurrence of ' hours'
      //println("This is the unprocessed hour: "+hourstring);
      //if the hour string contains the space before the hour number then get rid of it
      if (hourstring.contains(" ")) {
        stpos=stpos+1;
        hourstring="0"+item.substring(stpos, enpos);
        //println("A space was found; remove it");
      }

      finalhours = hourstring;
    }

    if (finalhours.indexOf('|')>-1) finalhours=finalhours.substring(1);

    //println("This is the processed hour:"+finalhours);
    //SECONDS DEAL WITH MINUTES
    String finalminutes="00"; 

    if (item.indexOf(" minute")>-1) { //if hours is in the string then we have more than zero hours and need to find out how manyt we have
      int stpos=item.indexOf(" minute")-2; //start at the beginning of the line
      int enpos=item.indexOf(" minute"); //seek where ' hour' occurs
      String minutestring=item.substring(stpos, enpos); //pull out the number as a string ... start of the string to the occurrence of ' hours'
      //println("This is the unprocessed hour: "+hourstring);
      //if the minute string contains the space before the minute number then get rid of it
      if (minutestring.contains(" ")) {
        stpos=stpos+1;
        minutestring="0"+item.substring(stpos, enpos);
      }

      finalminutes = minutestring;
      //println("This is the processed hour: "+finalhours);
    }

    if (finalminutes.indexOf('|')>-1) finalminutes=finalminutes.substring(1);
    //println("This is the processed minutes: "+finalminutes);
    //THIRD DEAL WITH seconds
    String finalseconds="00"; 

    if (item.indexOf(" second")>-1) { //if hours is in the string then we have more than zero hours and need to find out how manyt we have
      int stpos=item.indexOf(" second")-2; //start at the beginning of the line
      int enpos=item.indexOf(" second"); //seek where ' hour' occurs
      String secondstring=item.substring(stpos, enpos); //pull out the number as a string ... start of the string to the occurrence of ' hours'
      //println("This is the unprocessed hour: "+hourstring);
      //if the minute string contains the space before the minute number then get rid of it
      if (secondstring.contains(" ")) {
        stpos=stpos+1;
        secondstring="0"+item.substring(stpos, enpos);
      }

      finalseconds = secondstring;
    }

    if (finalseconds.indexOf('|')>-1) finalseconds=finalseconds.substring(1);

    finaltime=finalhours+""+finalminutes+""+finalseconds+"";

    //finaltime=finaltime.replaceAll("|", "");

    // Remove leading zeros
    int finaltimeint = int(finaltime);

    String entry = item+finaltimeint;
    //println(entry);

    // Split the entry into the runner name and the duration
    String[] splitentry = split(item, "|");
    runnername = splitentry[0];
    duration = splitentry[1];

    // Convert the int lop to a string 
    //String position = String.valueOf(lop);

    //Set up the new row function for the for loop
    TableRow newRow = leaderboard.addRow();

    // Create a new row for the runnername column and fill it with the runnername variable
    newRow.setString("runnername", runnername);

    // Create a new row for the duration column and fill it with the duration variable
    newRow.setString("duration", duration);

    // Create a new row for the durationindex column and fill it with the finaltime variable. Set this column to contain integers to enable sorting. 
    newRow.setInt("durationindex", finaltimeint);
    //newRow.setString("durationindex", "Hi");
  }

  // Find out how many rows are in the leaderboard table
  rowcount = leaderboard.getRowCount();
  //println(rowcount);

  // Sort the table in ascending order of duration; the fastest runner is at the top
  leaderboard.sort("durationindex");

  if (rowcount > 0) {

    fastest = leaderboard.getString(0, "runnername");
  }

  String runnername;
  String duration;

  String firstrunner = "";
  String firstduration = "";

  if (rowcount > 0) {

    // Get the fastest runner now that the table's sorted
    firstrunner = leaderboard.getString(0, "runnername");
    firstduration = leaderboard.getString(0, "duration");

    //Replace all underscores with spaces
    for (int i = 0; i < firstrunner.length(); i++) { 
      firstrunner = firstrunner.replaceAll("\\*\\*", "");
    }

    //Draw the first position in the leaderboard
    textAlign(LEFT, BASELINE);  
    textFont(rooneysansbold);
    textSize(80);
    fill(#E94D2A);
    //Draw the position number of this runner
    text("1st", 87, 505);
    //Get the fastest runner
    textFont(proximanovaregular);
    textSize(40);
    text(firstrunner, 291, 505);
    // Get the fastest runner duration
    textSize(40);
    textAlign(CENTER);
    text(firstduration, width/2, 505);
  }

  if (rowcount > 1) {

    // Get the second runner
    String secondrunner = leaderboard.getString(1, "runnername");
    String secondduration = leaderboard.getString(1, "duration");

    //Replace all underscores with spaces
    for (int i = 0; i < secondrunner.length(); i++) { 
      secondrunner = secondrunner.replaceAll("\\*\\*", "");
    }

    textFont(rooneysansbold);
    textSize(30);
    textAlign(LEFT);
    fill(#E94D2A);
    //Draw the position number of this runner
    text("2nd", 87, 600);
    //Get the second runnername
    textFont(proximanovaregular);
    textSize(20);
    text(secondrunner, 160, 600);
    // Get the second runner duration
    textSize(20);
    textAlign(RIGHT);
    text(secondduration, 640, 600);
  }

  if (rowcount > 2) {

    // Get the third runner
    String thirdrunner = leaderboard.getString(2, "runnername");
    String thirdduration = leaderboard.getString(2, "duration");

    //Replace all underscores with spaces
    for (int i = 0; i < thirdrunner.length(); i++) { 
      thirdrunner = thirdrunner.replaceAll("\\*\\*", "");
    }

    //Draw the third position in the leaderboard
    fill(#E94D2A);
    textFont(rooneysansbold);
    textSize(30);
    textAlign(LEFT);
    //Draw the position number of this runner
    text("3rd", 1277, 600);
    //Get the third runnername
    textFont(proximanovaregular);
    textSize(20);
    text(thirdrunner, 1350, 600);
    // Get the third runner duration
    textSize(20);
    textAlign(RIGHT);
    text(thirdduration, 1834, 600);
  }

  if (rowcount > 3) {

    // Get the fourth runner
    String fourthrunner = leaderboard.getString(3, "runnername");
    String fourthduration = leaderboard.getString(3, "duration");

    //Replace all underscores with spaces
    for (int i = 0; i < fourthrunner.length(); i++) { 
      fourthrunner = fourthrunner.replaceAll("\\*\\*", "");
    }

    //Draw the fourth position in the leaderboard
    textFont(rooneysansbold);
    textSize(30);
    textAlign(LEFT); 
    fill(#E94D2A);
    //Draw the position number of this runner
    text("4th", 87, 692);
    //Get the fourth runnername
    textFont(proximanovaregular);
    textSize(20);
    text(fourthrunner, 160, 692);
    // Get the second runner duration
    textSize(20);
    textAlign(RIGHT);
    text(fourthduration, 640, 692);
  }

  if (rowcount > 4) {

    // Get the fifth runner
    String fifthrunner = leaderboard.getString(4, "runnername");
    String fifthduration = leaderboard.getString(4, "duration");

    //Replace all underscores with spaces
    for (int i = 0; i < fifthrunner.length(); i++) { 
      fifthrunner = fifthrunner.replaceAll("\\*\\*", "");
    }

    //Draw the fifth position in the leaderboard
    fill(#E94D2A);
    textFont(rooneysansbold);
    textSize(30);
    textAlign(LEFT);
    //Draw the position number of this runner
    text("5th", 1277, 692);
    //Get the fifth runnername
    textFont(proximanovaregular);
    textSize(20);
    text(fifthrunner, 1350, 692);
    // Get the third runner duration
    textSize(20);
    textAlign(RIGHT);
    text(fifthduration, 1834, 692);
  }

  if (rowcount > 5) {

    // Get the sixth runner

    String sixthrunner = leaderboard.getString(5, "runnername");
    String sixthduration = leaderboard.getString(5, "duration");

    //Replace all underscores with spaces
    for (int i = 0; i < sixthrunner.length(); i++) { 
      sixthrunner = sixthrunner.replaceAll("\\*\\*", "");
    }

    //Draw the sixth position in the leaderboard
    textFont(rooneysansbold);
    textSize(30);
    textAlign(LEFT); 
    fill(#E94D2A);
    //Draw the position number of this runner
    text("6th", 87, 786);
    //Get the sixth runnername
    textFont(proximanovaregular);
    textSize(20);
    text(sixthrunner, 160, 786);
    // Get the second runner duration
    textSize(20);
    textAlign(RIGHT);
    text(sixthduration, 640, 786);
  }

  if (rowcount > 6) {

    // Get the seventh runner
    String seventhrunner = leaderboard.getString(6, "runnername");
    String seventhduration = leaderboard.getString(6, "duration");

    //Replace all underscores with spaces
    for (int i = 0; i < seventhrunner.length(); i++) { 
      seventhrunner = seventhrunner.replaceAll("\\*\\*", "");
    }

    //Draw the seventh position in the leaderboard
    fill(#E94D2A);
    textFont(rooneysansbold);
    textSize(30);
    textAlign(LEFT);
    //Draw the position number of this runner
    text("7th", 1277, 786);
    //Get the seventh runnername
    textFont(proximanovaregular);
    textSize(20);
    text(seventhrunner, 1350, 786);
    // Get the seventh runner duration
    textSize(20);
    textAlign(RIGHT);
    text(seventhduration, 1834, 786);
  }

  if (rowcount > 7) {

    // Get the eighth runner
    String eighthrunner = leaderboard.getString(7, "runnername");
    String eighthduration = leaderboard.getString(7, "duration");

    //Replace all underscores with spaces
    for (int i = 0; i < eighthrunner.length(); i++) { 
      eighthrunner = eighthrunner.replaceAll("\\*\\*", "");
    }

    //Draw the eighth position in the leaderboard
    textFont(rooneysansbold);
    textSize(30);
    textAlign(LEFT); 
    fill(#E94D2A);
    //Draw the position number of this runner
    text("8th", 87, 878);
    //Get the sixth runnername
    textFont(proximanovaregular);
    textSize(20);
    text(eighthrunner, 160, 878);
    // Get the second runner duration
    textSize(20);
    textAlign(RIGHT);
    text(eighthduration, 640, 878);
  }

  if (rowcount > 8) {

    // Get the ninth runner
    String ninthrunner = leaderboard.getString(8, "runnername");
    String ninthduration = leaderboard.getString(8, "duration");

    //Replace all underscores with spaces
    for (int i = 0; i < ninthrunner.length(); i++) { 
      ninthrunner = ninthrunner.replaceAll("\\*\\*", "");
    }

    //Draw the ninth position in the leaderboard
    fill(#E94D2A);
    textFont(rooneysansbold);
    textSize(30);
    textAlign(LEFT);
    //Draw the position number of this runner
    text("9th", 1277, 878);
    //Get the ninth runnername
    textFont(proximanovaregular);
    textSize(20);
    text(ninthrunner, 1350, 878);
    // Get the ninth runner duration
    textSize(20);
    textAlign(RIGHT);
    text(ninthduration, 1834, 878);
  }

  if (rowcount > 9) {

    // Get the tenth runner
    String tenthrunner = leaderboard.getString(9, "runnername");
    String tenthduration = leaderboard.getString(9, "duration");

    //Replace all underscores with spaces
    for (int i = 0; i < tenthrunner.length(); i++) { 
      tenthrunner = tenthrunner.replaceAll("\\*\\*", "");
    }

    //Draw the tenth position in the leaderboard
    textFont(rooneysansbold);
    textSize(30);
    textAlign(LEFT); 
    fill(#E94D2A);
    //Draw the position number of this runner
    text("10th", 87, 973);
    //Get the sixth runnername
    textFont(proximanovaregular);
    textSize(20);
    text(tenthrunner, 160, 973);
    // Get the tenth runner duration
    textSize(20);
    textAlign(RIGHT);
    text(tenthduration, 640, 973);
  }

  // Display a message when there's a new first place runner.
  if (fastest.equals(lastfastest) == false && cannotify == 1) {

    framerate = 60;

    // Draw a rectangle
    noStroke();
    fill(#E84D2A);
    rect(0, notifyposy + 360, width, 720);

    // Draw runnername
    fill(#F3F3F3);
    textFont(rooneysansbold);
    textSize(60);
    textAlign(RIGHT);
    text(firstrunner, 1840, notifyposy + 500);

    // Draw the new record sentence body copy
    fill(#F3F3F3);
    textFont(proximanovaregular);
    textSize(30);
    text("has set a new lap record of:", 1840, notifyposy + 550);

    // Draw the fastest lap time
    fill(#F3F3F3);
    textFont(rooneysans);
    textSize(40);
    text(firstduration, 1840, notifyposy + 600);

    // Draw the old record body copy
    fill(#F3F3F3);
    textFont(proximanovaregular);
    textSize(30);
    text("Demolishing the previous record set by "+lastfastest+"!", 1840, notifyposy + 650);

    endnotification = false;

    // Move the notification up and increase the framerate for smooth motion
    if (notifyposy > 0 && notified == false) {
      //println(framerate);
      notifyposy -= 5;
    }

    // Hold the notification for 10 seconds
    else if (notified == false) {
      notified = true;
      delay(10000);
    }

    // Move the notification down
    if (notified == true) {
      //println(framerate);
      notifyposy += 5;
      // End the notification when it's gone down off the screen
      if (notifyposy >= 720) {
        endnotification = true;
      }
    }

    // Reset the notification for the next fastest runner
    if (endnotification == true) {
      // Get the first row entry and store it as lastfastest
      lastfastest = leaderboard.getString(0, "runnername");
      notified = false;
      notifyposy = 720;
      //framerate = 1;
    }

    //println("the last fastest is: "+lastfastest);
  }

  // Clear the table for the next update
  leaderboard.clearRows();
}

//Find the time difference
void difference() {

  //Download the card ID start time and store it as the string array 'sttime'
  String[] sttime = loadStrings("http://localhost:8888/processing/terminalTime.php?cid="+id+"&terminalid=1");

  //Store the 'sttime' parameter as the string 'starttime'
  starttime = join(sttime, "");
  println(starttime);

  if (starttime.indexOf(":")==-1) {
    println("There is no start time to be parsed");
  } else {
    //Create a string array with the first swipe and split the date fields
    String[] st1=starttime.split(":");

    //int yr1=int(st1[0]);
    //int mnth1=int(st1[1]);
    //int dy1=int(st1[2]);
    int hr1=int(st1[0]);
    int min1=int(st1[1]);
    int sec1=int(st1[2]);

    //Store the current time as a string called 'finishtime'
    //finishtime=year()+":"+month()+":"+day()+":"+hour()+":"+minute()+":"+second();
    finishtime=hour()+":"+minute()+":"+second();

    //Create a string array with the second swipe and split the date fields
    String[] ft1=finishtime.split(":");
    //int yr2=int(ft1[0]);
    //int mnth2=int(ft1[1]);
    //int dy2=int(ft1[2]);
    int hr2=int(ft1[0]);
    int min2=int(ft1[1]);
    int sec2=int(ft1[2]);

    String difference="";
    String daylabel="";
    String hourlabel="";
    String minutelabel="";
    String secondlabel="";

    //Store the current time as a string called 'finishtime'
    //finishtime=year()+":"+month()+":"+day()+":"+hour()+":"+minute()+":"+second();

    Date datedate = new Date();
    SimpleDateFormat date = new SimpleDateFormat ("EEE-dd-MMMMM");
    println(date.format(datedate));

    println(datedate);

    String currentdate=day()+":"+minute()+":"+second();

    //Create a string for the start swipe
    //String input=yr1+"-"+mnth1+"-"+dy1+"-"+hr1+"-"+min1+"-"+sec1;
    String input=hr1+"-"+min1+"-"+sec1;

    //Set the date format for the start swipe
    //SimpleDateFormat st2 = new SimpleDateFormat ("yyyy-M-dd-h-m-s");
    SimpleDateFormat st2 = new SimpleDateFormat ("h-m-s");

    //Create a string for the finish swipe
    //String input2=yr2+"-"+mnth2+"-"+dy2+"-"+hr2+"-"+min2+"-"+sec2;
    String input2=hr2+"-"+min2+"-"+sec2;

    //Set the date format for the finish swipe 
    //SimpleDateFormat ft2 = new SimpleDateFormat ("yyyy-M-dd-h-m-s");
    SimpleDateFormat ft2 = new SimpleDateFormat ("h-m-s");

    println(input);
    println(input2);  

    //Parse the first swipe date
    Date t1=new Date();
    try {
      t1 = st2.parse(input); 
      println(t1);
    }
    catch (ParseException e) { 
      println("Unparseable using " + st2);
    }

    //Parse the second swipe date
    Date t2=new Date();
    try {
      t2 = ft2.parse(input2); 
      println(t2);
    }
    catch (ParseException e) { 
      println("Unparseable using " + ft2);
    }

    println(t2.getTime());
    println(t1.getTime());

    long diff = t2.getTime() - t1.getTime();
    long diffSeconds = (diff / 1000) % 60;
    long diffMinutes = (diff / (60 * 1000)) % 60;
    long diffHours = (diff / (60 * 60 * 1000)) % 24;
    int diffDays = (int) (diff / (1000 * 60 * 60 * 24));

    //Pluralise the time labels or not
    if (diffDays == (1)) {
      daylabel="_day";
    } else {
      daylabel="_days";
    }

    if (diffHours == (1)) {
      hourlabel="_hour";
    } else {
      hourlabel="_hours";
    }

    if (diffMinutes == (1)) {
      minutelabel="_minute";
    } else {
      minutelabel="_minutes";
    }

    if (diffSeconds == (1)) {
      secondlabel="_second";
    } else {
      secondlabel="_seconds";
    }
    //End pluralise


    difference=diffDays+daylabel+",_"+diffHours+hourlabel+",_"+diffMinutes+minutelabel+"_and_"+diffSeconds+secondlabel;
    //If days aren't needed then strip them
    if (diffDays<(1)) {
      difference=diffHours+hourlabel+",_"+diffMinutes+minutelabel+"_and_"+diffSeconds+secondlabel;
    }
    //If days and hours aren't needed then strip them
    if (diffDays < (1) & diffHours < (1)) {
      difference=diffMinutes+minutelabel+"_and_"+diffSeconds+secondlabel;
    }
    //If days and minutes aren't needed then strip them
    if (diffDays < (1) & diffMinutes < (1)) {
      difference=diffHours+hourlabel+"_and_"+diffSeconds+secondlabel;
    }
    //If days, hours and minutes aren't needed then strip them
    if (diffDays < (1) & diffHours < (1) & diffMinutes < (1)) {
      difference=diffSeconds+secondlabel;
    }
    //If days and seconds aren't needed then strip them
    if (diffDays<(1) & diffSeconds < (1)) {
      difference=diffHours+hourlabel+"_and_"+diffMinutes+minutelabel;
    }
    //If days, minutes and seconds aren't needed then strip them
    if (diffDays<(1) & diffMinutes < (1) & diffSeconds < (1)) {
      difference=diffHours+hourlabel;
    }
    //If days, hours and seconds aren't needed then strip them
    if (diffDays<(1) & diffHours < (1) & diffSeconds < (1)) {
      difference=diffMinutes+minutelabel;
    }

    println(difference);

    duration=difference;
  }//end of protective if
}
