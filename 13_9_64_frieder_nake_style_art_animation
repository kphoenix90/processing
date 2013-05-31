/*
 *Kelsey Lee 13/9/65 Nr. 2, by Frieder Nake (born 1938, Germany)
 *trying to replicate  13/9/65 Nr. 2, by Frieder Nake (born 1938, Germany)
 *randomly selects widths of columns
 *randomly selects where to place horizontal lines, width of segments & incline/decline of those segments
 *will thenchose whether the block created by the column/horizontal line barriers should contain 
 *straight lines, triangles/angles or nothing - if trinalges will choose whether to originate from top or bottom
 *when done, will randomly select number of circles, radius of circles and placement of circles
 */
 
int WIN_WIDTH = 600;

int COLS;
int CUBE_WIDTH_MIN = 30;
int CUBE_WIDTH_MAX = 80;
int[]colSegments = new int[int(WIN_WIDTH/CUBE_WIDTH_MIN)+1];
horizLine startHorizLine;
horizLine endHorizLine;
horizLine screenBottom;
int ctr;
int horizCtr;
int yHeight;
int circleCtr;
int numCircles;
String phase;

int CUBE_HEIGHT_START_MIN = 60;
int CUBE_HEIGHT_START_MAX = 100; //prior to sloping lines up or down

void setup(){
  size(WIN_WIDTH, WIN_WIDTH); //create window
  stroke(0);
  strokeWeight(1.5);
  smooth();
  background(255); 
  frameRate(3);
   yHeight =  0;

   startHorizLine = new horizLine(0);
   startHorizLine.createTop();
   
   screenBottom = new horizLine(WIN_WIDTH);
   screenBottom.createBottom();

   //find column widths
   colSegments[0] = int(random(CUBE_WIDTH_MIN,CUBE_WIDTH_MAX)); //generates first cube width
   ctr=1;
   
   //randomly chose width of column until nearly at edge of screen, make sure last column is at least min cube width
   while ((colSegments[ctr-1]+CUBE_WIDTH_MIN) < WIN_WIDTH) {
     colSegments[ctr] = colSegments[ctr-1] + int(random(CUBE_WIDTH_MIN,CUBE_WIDTH_MAX)); 
     ctr++;
     COLS++; //number of columns
   }
   colSegments[ctr] = WIN_WIDTH;
  
  circleCtr=-1; 
  numCircles = int(random(2,10)); 
 // horizLineStart = false;
  phase = "endHorizLineBegin";
  
}

void draw() {

    if (phase == "endHorizLineBegin" ) {
      phase = "endHorizLineCreating";
      endHorizLine = new horizLine(yHeight); //draw the horizontal line
      endHorizLine.createLine();
      line(endHorizLine.horizPts[endHorizLine.horizCtr][0], endHorizLine.horizPts[endHorizLine.horizCtr][1], endHorizLine.horizPts[endHorizLine.horizCtr][2], endHorizLine.horizPts[endHorizLine.horizCtr][3]);

      endHorizLine.horizCtr +=1;
    }
    else if (phase == "endHorizLineCreating") {
       line(endHorizLine.horizPts[endHorizLine.horizCtr][0], endHorizLine.horizPts[endHorizLine.horizCtr][1], endHorizLine.horizPts[endHorizLine.horizCtr][2], endHorizLine.horizPts[endHorizLine.horizCtr][3]);
        endHorizLine.horizCtr +=1;
        if (endHorizLine.horizCtr > endHorizLine.numPts) {
           phase="endHorizLineComplete"; 
        }
    }  
    else if (phase == "endHorizLineComplete") {
      phase = "startVertSeg";
    }
    else if (phase == "startVertSeg") {
      
     phase = "continueVertSeg"; 
    }
    else if (phase == "continueVertSeg") {
     
     phase = "endVertSeg"; 
    }
    else if (phase == "endVertSeg") {
     phase = "endHorizLineBegin";
     startHorizLine = endHorizLine; //now the bottom horizontal line is the starting horizontal line for the next iteration
  //   horizLineStart = false;
     yHeight += int(random(int(WIN_WIDTH/10),int(WIN_WIDTH/8))); //choose starting height of the next line 
     if((yHeight+CUBE_HEIGHT_START_MAX+(CUBE_HEIGHT_START_MAX/5)) <= WIN_WIDTH ) {
        phase = "circles"; 
     }
    }
    else if (phase == "circles") {
      phase = "completed";
    }
  /*  }
 /*   else {
      makeVert(startHorizLine, endHorizLine);  //figure out how the segments are illustrated
      startHorizLine = endHorizLine; //now the bottom horizontal line is the starting horizontal line for the next iteration
      horizLineStart = false;
      yHeight += int(random(int(WIN_WIDTH/10),int(WIN_WIDTH/8))); //choose starting height of the next line
    }
  }
  else if (circleCtr == -1) {
    circleCtr = 0;
    makeVert(startHorizLine, screenBottom); //finish off by connecting horizontal line to screen bottom
  }
  else if (circleCtr < numCircles){
    makeCircles(); // draw circles
  }*/
  if (phase == "completed"){
    noLoop();
  }

// }
}





//draw circles, xVal of center will fall inside a column
void makeCircles() {
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
}



class horizLine {
   int[][]horizPts = new int[10][4];
   boolean started;
   boolean finished;
   int numPts;
   int minStartY;
   int horizCtr;
   
   horizLine (int y){
      started = false;
      finished = false;
      numPts = 0;
      minStartY = y;
      horizCtr=0;
      
   } 
   void createTop() {
     horizPts[0][0] = horizPts[0][1] = horizPts[0][3] = 0;
     horizPts[0][2] = WIN_WIDTH;
   }
   
   void createInitHoriz() {
     
   }
   
   void createBottom() {
     horizPts[0][0]= 0;
     horizPts[0][1] = horizPts[0][2] = horizPts[0][3] = WIN_WIDTH;
   }
   
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
      //draw the line
   //   line(linePts[ctr][0],linePts[ctr][1],linePts[ctr][2],linePts[ctr][3]);
       
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



class vertLine {
  vertLine(int[][]startHorizLine, int[][]endHorizLine){
    
  }
  
  
}
