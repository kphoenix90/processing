/*
 *Kelsey Lee 13/9/65 Nr. 2, by Frieder Nake (born 1938, Germany)
 *trying to replicate  13/9/65 Nr. 2, by Frieder Nake (born 1938, Germany)
 *randomly selects widths of columns
 *randomly selects where to place horizontal lines, width of segments & incline/decline of those segments
 *will then chose whether the block created by the column/horizontal line barriers should contain 
 *straight lines, triangles/angles or nothing - if trianlges will choose whether to originate from top or bottom
 *when done, will randomly select number of circles, radius of circles and placement of circles
 *
 *  ***will draw it line by line so you can see process***
 */
 
int WIN_WIDTH = 600;

int COLS;
int CUBE_WIDTH_MIN = 30;
int CUBE_WIDTH_MAX = 80;

int[]colSegments = new int[int(WIN_WIDTH/CUBE_WIDTH_MIN)+1];

horizLine startHorizLine;
horizLine endHorizLine;
horizLine screenBottom;

vertLineHolder vertHolder;
vertLineSeg vertSeg;

int ctr;
int horizCtr;
int yHeight;
int circleCtr;
int numCircles;

String phase;
boolean moreVert;
boolean lastLine;

int CUBE_HEIGHT_START_MIN = 60;
int CUBE_HEIGHT_START_MAX = 100; //prior to sloping lines up or down

void setup(){
  size(WIN_WIDTH, WIN_WIDTH); //create window
  stroke(0);
  strokeWeight(1.5);
  smooth();
  background(255); 
  frameRate(40);
   yHeight =  0;
   lastLine = false;

   startHorizLine = new horizLine(0);
   startHorizLine.createTop();
   
   screenBottom = new horizLine(WIN_WIDTH);
   screenBottom.createBottom();

   //find column widths
   colSegments[0] = int(random(CUBE_WIDTH_MIN,CUBE_WIDTH_MAX)); //generates first cube width
   ctr=1;
   COLS=0;
   //randomly chose width of column until nearly at edge of screen, make sure last column is at least min cube width
   while ((colSegments[ctr-1]+CUBE_WIDTH_MIN) < WIN_WIDTH) {
     colSegments[ctr] = colSegments[ctr-1] + int(random(CUBE_WIDTH_MIN,CUBE_WIDTH_MAX)); 
     ctr++;
     COLS++; //number of columns
   }
   colSegments[ctr] = WIN_WIDTH;
   
   phase = "endHorizLineBegin";
//  print(COLS + "\n");
  circleCtr=-1; 
  numCircles = int(random(2,10));  
}

void draw() {
    if (phase == "endHorizLineBegin" ) {
        phase = "endHorizLineCreating";
        endHorizLine = new horizLine(yHeight); //draw the horizontal line
        if (lastLine ==false) {
           endHorizLine.createLine();
        }
        else {
          endHorizLine.createBottom();
        }
        line(endHorizLine.horizPts[endHorizLine.horizCtr][0], endHorizLine.horizPts[endHorizLine.horizCtr][1], endHorizLine.horizPts[endHorizLine.horizCtr][2], endHorizLine.horizPts[endHorizLine.horizCtr][3]);
  
        endHorizLine.horizCtr +=1;
    }
    else if (phase == "endHorizLineCreating") {
       line(endHorizLine.horizPts[endHorizLine.horizCtr][0], endHorizLine.horizPts[endHorizLine.horizCtr][1], endHorizLine.horizPts[endHorizLine.horizCtr][2], endHorizLine.horizPts[endHorizLine.horizCtr][3]);
        endHorizLine.horizCtr +=1;
        if (endHorizLine.horizCtr > endHorizLine.numPts) {
           phase="startVertSeg";
        }
    }  
    else if (phase == "startVertSeg") {
        vertHolder = new vertLineHolder(startHorizLine, endHorizLine);
        moreVert = vertHolder.drawLine();
        phase = "continueVertSeg"; 
    }
    else if (phase == "continueVertSeg") {
       moreVert = vertHolder.drawLine();
       if (moreVert == false) {
        // print("end vert seg\n");
         phase = "endVertSeg"; 
       }
    }
    else if (phase == "endVertSeg") {
       phase = "endHorizLineBegin";
       startHorizLine = endHorizLine; //now the bottom horizontal line is the starting horizontal line for the next iteration
       yHeight += int(random(int(WIN_WIDTH/10),int(WIN_WIDTH/8))); //choose starting height of the next line 
       if (lastLine == true) {
        phase = "circles"; 
       }
       if((yHeight+CUBE_HEIGHT_START_MAX+(CUBE_HEIGHT_START_MAX/5)) >= WIN_WIDTH) {
          lastLine = true;
       }
    }
    else if (phase == "circles") {
      boolean endOfCircles = makeCircles(); // draw circles
      if (endOfCircles == true) {
        phase="completed";
      }
  }
  
  if (phase == "completed"){
    noLoop();
  }
}



//make line equation from horizontal line of points and plug in known xVal to find the yVal
float findYVal(int xVal, int[][]horizLine) {
   int ctr = 0;
   boolean foundY = false;
   float yVal =0;
   
  //find which column this xVal is in
  while (foundY == false) {
    //if true, xVal is in this column
     if (xVal >=  horizLine[ctr][0] && xVal <= horizLine[ctr][2]) {  
       //line eq, plug in x 
       yVal = float(horizLine[ctr][3]-horizLine[ctr][1])/float(horizLine[ctr][2]-horizLine[ctr][0])*float(xVal-horizLine[ctr][2]) +horizLine[ctr][3];
       foundY=true;
      }
      else {
        ctr++; 
      }
  }
  return yVal;
}

/* 
 * structure that holds a whole row's worth of vertical line segments
 * keeps track of which segment is being drawn & which line in that segment is being drawn.
 * creates many vertLineSeg structures which contain the points of all vertical lines to be drawn
 */
class vertLineHolder{
  vertLineSeg[] segs = new vertLineSeg[COLS]; //holds vertical line segments
  horizLine startLine; 
  horizLine endLine;
  int col; //for total number of columns
  int currentCol; //used later to iterate through all columns
  int currentLine; //keeps track of which line in a segment is being drawn
  
  //constructor
  vertLineHolder(horizLine startHorizLine, horizLine endHorizLine){
      startLine = startHorizLine;
      endLine = endHorizLine;
      col = 0; 
      int vertLineStart = 0;
      currentCol = 0;
      
      //now create segments for whole row; randomize type of vertical lines for segment
      while (colSegments[col+1] < WIN_WIDTH) {
       // print("col: " +col);
         int vertLineEnd = colSegments[col];
        
         int pattern = int(random(0,8)); //0,1 -vert lines; 2,3 - triangles, 4-8 -empty makes it  5/8ths likely that nothing will be drawn
         //when creating vertLineSeg, call that constructor to choose lines
         if (pattern <= 1 ) { //lines are drawn straight
           segs[col] = new vertLineSeg(startHorizLine, endHorizLine, 1, vertLineStart, vertLineEnd);
         }
         else if (pattern == 2) { //angle
           segs[col] = new vertLineSeg(startHorizLine, endHorizLine, 2,vertLineStart, vertLineEnd);
         }
         else if (pattern == 3) { // angle
           segs[col] = new vertLineSeg(startHorizLine, endHorizLine, 3, vertLineStart, vertLineEnd);
         }
         else {
          segs[col] = null; // for when segment is blank
         }
         col+=1;
         vertLineStart = vertLineEnd;
      }
      currentLine = 0;
  }
  
  //now draw lines one at a time
  boolean drawLine() {
    //if there are no lines in this segment, don't do any drawing
    if (segs[currentCol] == null) {
     currentCol+=1; 
     currentLine=0;
   //  print("from if update col\n");
    }
    else {
      //print("drawing - currentCol " + currentCol + " , currentLine " + currentLine + "\n");
     line(segs[currentCol].segPts[currentLine][0], segs[currentCol].segPts[currentLine][1], segs[currentCol].segPts[currentLine][2], segs[currentCol].segPts[currentLine][3]);
      currentLine+=1;
      
      //if it's the last line in a segment, go to next segment & draw first line there
      if (currentLine > segs[currentCol].numLines-1) {
      //  print("from check to next col update col \n\n");
         currentLine=0;
         currentCol+=1; 
      }
    }
    
    //if now onto a column that exceeds the number of columns present, then must go to next row to draw
    if (currentCol >= COLS) {
   //   print("resetCol \n");
        currentCol = 0;
       return false; //meaning row is done being drawn
    }
    else {
      return true; //row is not done being drawn
    }
  }
}


//a single segment of vertical lines
class vertLineSeg {
  int numLines;
  int type; //type of lines
  int vertSeg;
  int vertStart; // value of starting x
  int vertEnd; // valiue of ending x
  float [][]segPts; // array of points for this segment
  int currentLine; //current line being drawn
  
  
   vertLineSeg(horizLine startHorizLine, horizLine endHorizLine, int t, int vertLineStart, int vertLineEnd) {
      type = t; // for straight or angled lines
      vertSeg = 0;
      vertStart = vertLineStart; // value of starting X
      vertEnd = vertLineEnd; //value of ending X
      
      currentLine =0; //current Line being created
      
      int lineCtr = 0; // the line being drawn
      numLines = int(random(1,(vertEnd-vertStart)/6)); //arbitrary 6 - total number of lines/angles for this seg,ent
      
      segPts = new float[(numLines*2)][4]; //array of points
      
   

      if (type == 1) { // straight lines
      //print(" lines: " + numLines + " | ");
       while (lineCtr < numLines) { //loop until all lines havbe been created - need starting x,y and ending x,y
          int startXVal = int(random(vertLineStart, vertLineEnd));
          if (startXVal> WIN_WIDTH) {
               startXVal=WIN_WIDTH;  //don't draw past end of screen
          }
          float yValStart = findYVal(startXVal, startHorizLine.horizPts);
          float yValEnd = 0;
      
          yValEnd = findYVal(startXVal, endHorizLine.horizPts);
          //store values
          segPts[lineCtr][0] = segPts[lineCtr][2] = startXVal;
          segPts[lineCtr][1] = yValStart;
          segPts[lineCtr][3] = yValEnd;
          lineCtr+=1; //increment to create next line
       }
        
      }
      else if (type==2) { //create angles starting from top
        numLines *=2;  // will need to store double the amount of lines b/c 2 lines for angle
     //   print(" lines: " + numLines + " | ");
        while ((lineCtr+2) < numLines) {
          int startXVal = int(random(vertLineStart, vertLineEnd));
          if (startXVal> WIN_WIDTH) {
               startXVal=WIN_WIDTH;  //don't draw past end of screen
          }
          float yValStart = findYVal(startXVal, startHorizLine.horizPts);
          float yValEnd = 0;
          //create both lines of angle
          for (int i=0; i<2; i++) {
               int endXVal = int(random(vertLineStart, vertLineEnd));
               if (endXVal> WIN_WIDTH) {
                   endXVal=WIN_WIDTH; 
               }    
                yValEnd = findYVal(endXVal, endHorizLine.horizPts);
              
                segPts[lineCtr][0] = startXVal;
                segPts[lineCtr][1] = yValStart;
                segPts[lineCtr][2] = endXVal;
                segPts[lineCtr][3] = yValEnd;
                lineCtr+=1;
          }
       }
      }
      else if (type == 3) { // create angles starting from bottom
        numLines *=2; 
     //   print(" lines: " + numLines + " | ");
        while ((lineCtr+2) < numLines) {
          int startXVal = int(random(vertLineStart, vertLineEnd));
          if (startXVal> WIN_WIDTH) {
               startXVal=WIN_WIDTH;  //don't draw past end of screen
          }
          float yValStart = findYVal(startXVal, endHorizLine.horizPts);
           float yValEnd = 0;
          for (int i=0; i<2; i++) {
               int endXVal = int(random(vertLineStart, vertLineEnd));
               if (endXVal> WIN_WIDTH) {
                   endXVal=WIN_WIDTH; 
               }    
               yValEnd = findYVal(endXVal, startHorizLine.horizPts); //ending yVals are on the top horizontal line
               
                segPts[lineCtr][0] = startXVal;
                segPts[lineCtr][1] = yValStart;
                segPts[lineCtr][2] = endXVal;
                segPts[lineCtr][3] = yValEnd;
                lineCtr+=1;
          }
        }
      }
 //  print( "\n");
 } 
}

//creates a horizontal line
class horizLine {
   int[][]horizPts = new int[10][4]; // stores points for horiz line
   int numPts;
   int minStartY; // starting Y
   int horizCtr; //number of horiz segments
   
   horizLine (int y){
      numPts = 0;
      minStartY = y;
      horizCtr=0;
   } 
   
   //line for top of screen
   void createTop() {
     horizPts[0][0] = horizPts[0][1] = horizPts[0][3] = 0;
     horizPts[0][2] = WIN_WIDTH;
   }
   
   //line for bottom of screen
   void createBottom() {
     horizPts[0][0]= 0;
     horizPts[0][1] = horizPts[0][2] = horizPts[0][3] = WIN_WIDTH;
   }
   
   // all other lines
   void createLine(){
     int remainingWidth = WIN_WIDTH;
      
      //starting coordinate
      int startX=0; 
      int startY = minStartY + int(random(CUBE_HEIGHT_START_MIN ,CUBE_HEIGHT_START_MAX));
      
      //line can slope up or down only w/in the following range - so as not to allow the horizontal lines to intersect with each other
      int minY = startY - ((startY-minStartY)/5); 
      int maxY = startY + ((startY-minStartY)/5);
      numPts = 0;
      while (remainingWidth > 0) {
        //find ending point for hte line segment
        int endX = startX + int(random(CUBE_HEIGHT_START_MIN ,CUBE_HEIGHT_START_MAX));
        //if chosen end X coordinate is past the end of the screen, reset to end of screen
        if (endX > WIN_WIDTH || (endX+CUBE_WIDTH_MIN)>WIN_WIDTH) {
          endX = WIN_WIDTH;
         }
         //will this segment of line slope up (0) or down (1)
         int sign = int(random(0,1));
         int endY;
         if (sign == 0 ) {
           endY = int(random(minY, maxY));
          }
          else {
            endY = -1*int(random(minY, maxY));
          }
          //store that line segment
          horizPts[numPts][0] = startX;
          horizPts[numPts][1] = startY;
          horizPts[numPts][2] = endX;
          horizPts[numPts][3] = endY;
          numPts+=1;
           
          remainingWidth = WIN_WIDTH - endX;
          ctr+=1;
          //end point from previous segment becomes the start of the next
          startX = endX;
          startY = endY;
        }
       }
       
       int[][] getLine() {
          return horizPts; 
       }
  
}


//draw circles, xVal of center will fall inside a column
boolean makeCircles() {
  fill(255, 0);
 
  //randomly choose number of circles
 
  if (circleCtr < numCircles) {
    //randomly choose radius
    int circleRadius = int(random(CUBE_WIDTH_MIN,200))/2;
    int cubeNum  = int(random(1,COLS));
    int xCoord= int(random(colSegments[cubeNum-1],colSegments[cubeNum]));
    ellipse(xCoord, int(random(circleRadius,WIN_WIDTH-circleRadius)), circleRadius, circleRadius);
    circleCtr++;
  } 
  else {
   return true; 
  }
  return false;
}
