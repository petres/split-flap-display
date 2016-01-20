
// Left and Right Disk
diskHeight = 1.5;
diskRadius = 20;

// Disk Holes for Plates
holeRadius = 0.8;

// Margin of Holes and Stubbles
outerMargin = 2;

// Segment Count
segments = 10;

// Disk Stubbles
stubbleHeight = 3;
stubbleRadius = 0.6;
stubbleHoleAngle = 360/segments/3;



axisRadius = 2;

simpleAxisHole = true;
axisHolderRadius = 5;
axisHolderHeight = 8;
axisHeight = 40;



//$t = 10;
$fn = 100;

module disk(lower) {
    if(!simpleAxisHole)
        translate([0, 0, diskHeight])
            if (lower) {
                cylinder(h=axisHeight, r=axisRadius);
                translate([0, 0, axisHeight-axisHolderHeight+axisHolderHeight/2])
                    cube([axisHolderRadius*2,3,axisHolderHeight], center=true);
            } else {
                difference() {
                    cylinder(h=axisHolderHeight, r=axisHolderRadius);
                    cylinder(h=axisHeight, r=axisRadius);
                    translate([0, 0, axisHolderHeight/2+0.5])
                        cube([axisHolderRadius*2,3,axisHolderHeight+1], center=true);
                }
            }
    // Base Disk
    difference() {
        cylinder(h=diskHeight, r=diskRadius);
        for (i = [1:segments])
            rotate(a=360/segments*i, v=[0, 0, 1])
                translate([diskRadius-outerMargin, 0 ,-0.1])
                    cylinder(h=diskHeight+0.2, r=holeRadius);
        // Disk Holes for Plates
        if(simpleAxisHole)
            translate([0, 0, -0.1])
                cylinder(h=diskHeight+0.2, r=axisRadius);
    }
    // Disk Stubbles
    for (i = [1:segments])
        rotate(a=360/segments*i+stubbleHoleAngle, v=[0, 0, 1])
            translate([diskRadius-outerMargin, 0, diskHeight])
                cylinder(h=stubbleHeight, r=stubbleRadius);
}


plateTolerance = 2;
plateWidth = axisHeight - plateTolerance;
plateHeight = plateWidth;
plateThickness = 1;
plateStubbleOffset = 5.2;
//plateStubbleRadius = holeRadius -0.1; //-0.2
plateStubbleRadius = plateThickness;
plateStubbleLength = axisHeight + diskHeight*2 + 2;

module basePlate() {
    translate([0,-plateHeight/2 + plateStubbleOffset,0])
        cube([plateWidth, plateHeight, plateThickness], center = true);
    rotate(a=90,v=[0,1,0])
        translate([0,0,-plateStubbleLength/2])
            //cylinder(h = plateStubbleLength, r = plateStubbleRadius);
            translate([0,0,plateStubbleLength/2])
                cube([plateThickness,plateThickness,plateStubbleLength], center = true);
}



module plate(element, angle) 
    rotate(a=360/segments*element, v=[0, 0, 1])
        translate([diskRadius-outerMargin,0,plateWidth/2 + diskHeight + plateTolerance/2])
            rotate(a=angle,v=[0,0,1])
                rotate(a=90,v=[0,1,0])
                    basePlate();
 
             
//basePlate();

boxDeepth = axisHeight*1.8;
boxTolerance = 2;
boxThickness = 2;
boxHeight = plateHeight*2+20;

boxWidth = axisHeight + 2*diskHeight + boxTolerance + 2*boxThickness;

boxXcenter = 10;

frontHoleHeight = plateHeight*2;
frontHoleWidth = plateWidth + plateTolerance;
frontHoleOff = 2;


module box(left = true) {
    union(){
        if (left) {
            // LEFT WALL
            translate([boxXcenter, (boxWidth + boxThickness)/2, 0])
                cube([boxDeepth, boxThickness, boxHeight + boxThickness], center = true);
            // TOP 
            translate([boxXcenter, 0, boxHeight/2])
                cube([boxDeepth, boxWidth, boxThickness], center = true);
            // BOTTOM 
            translate([boxXcenter, 0, -boxHeight/2])
                cube([boxDeepth, boxWidth, boxThickness], center = true);
            // BACK 
            translate([(boxDeepth + boxThickness)/2 + boxXcenter, 0, 0])
                cube([boxThickness, boxWidth + 2*boxThickness, boxHeight + boxThickness], center = true);
            // FRONT 
            translate([-(boxDeepth + boxThickness)/2 + boxXcenter, 0, 0])
                difference() {
                    // WHOLE FRONT
                    cube([boxThickness, boxWidth + 2*boxThickness, boxHeight + boxThickness], center = true);
                    translate([0,0,frontHoleOff]) {
                        // MIDDLE WHOLE
                        cube([boxThickness+1, frontHoleWidth, frontHoleHeight], center = true);
                        // RIGHT AREA
                        translate([0,-(boxWidth + 2*boxThickness)/2 + (boxWidth + 2*boxThickness - frontHoleWidth)/4,0]) 
                            cube([boxThickness+1, (boxWidth + 2*boxThickness - frontHoleWidth)/2, frontHoleHeight], center = true); 
                    }
                }
        } else {
            union() {
                translate([boxXcenter, -(boxWidth + boxThickness)/2, 0])
                    cube([boxDeepth, boxThickness, boxHeight + boxThickness], center = true);
                translate([-(boxDeepth + boxThickness)/2 + boxXcenter, 0, 0])
                    translate([0,0,frontHoleOff])
                        translate([0,-(boxWidth + 2*boxThickness)/2 + (boxWidth + 2*boxThickness - frontHoleWidth)/4,0]) 
                            cube([boxThickness+1, (boxWidth + 2*boxThickness - frontHoleWidth)/2, frontHoleHeight], center = true);
            }
        }
    }
}


difference() {
    union() {
        %box(left=true);
        %box(left=false);
        
        // Split Flap
        rotate(a=-11,v=[0,1,0]) {
            rotate(a=90,v=[1,0,0]) 
                translate([0,0,-(diskHeight+axisHeight/2)]) {
                    // LOWERT PART
                    disk(lower = true);

                    // UPPER PART
                    translate([0,0,diskHeight*2 + axisHeight])
                        mirror([0,0,1]) {
                            disk(lower = false);
                        }
                    

                    plate(element = 0, angle = 25);
                    plate(element = 1, angle = 25);
                    plate(element = 2, angle = 25);
                    plate(element = 3, angle = 25);
                    plate(element = 4, angle = 25);
                    plate(element = 5, angle = 168);
                    plate(element = 6, angle = 121.5);
                    plate(element = 7, angle = 68);
                    plate(element = 8, angle = 42);
                    plate(element = 9, angle = 25);
                    
                }
        }
    }
    // AXIS
    if(simpleAxisHole)
        rotate(a=-11,v=[0,1,0])
            rotate(a=90,v=[1,0,0]) 
                translate([0, 0, -10])
                    translate([0,0,-(diskHeight+axisHeight/2)])
                        cylinder(h=diskHeight*2 + 20 + axisHeight, r=axisRadius);
}

