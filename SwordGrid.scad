//!OpenSCAD

//Все размеры в см.

module screwHoles(H, holeH, nutD, screwD) {
    union() {
        cylinder (r=nutD/2, h=H - holeH, $fn=6);
        translate([0, 0, H - holeH])
            cylinder (r=screwD/2, h=holeH, $fn=180);
    }
}

module elips(h, t, w) {
    scale ([w/t, 1, 1])
        cylinder (r=t/2, h=h, $fn=180);
}

module gripWall (L, W, H, WW) {
    difference() {
        rotate([0, 90 , 0])
            elips(L, W, H);
        translate ([WW, 0, 0])
            rotate([0, 90 , 0])
                elips(L - 2 * WW, 
                    W - 2 * WW, 
                    H - 2 * WW);
    }
}

module gripWallHalf(L, W, H, WW) {
    difference () {
        gripWall(L, W, H,
            WW);
        translate ([0, -W/2, 0])
        cube ([L, W, H/2]);
    }
}

module bladeHolder(gripW, gripH, holderW, holderL) {
    intersection() {
        translate([0, -holderW/2, -gripH/2])
            cube ([holderL, holderW, 
                gripH/2]);
        rotate([0, 90 , 0])
            elips(holderL, gripW, gripH);
    }
}

module gripBase(GRIP_LENGTH, GRIP_WIDTH, GRIP_HEIGTH,
    HOLDER_WIDTH, HOLDER_LENGTH,
    BLADE_WIDTH, BLADE_THICKNESS,
    WALL_WIDTH, SCREW_POINTS, NUT_D, SCREW_D) {
    difference() {
        union() {
            gripWallHalf(GRIP_LENGTH, GRIP_WIDTH, GRIP_HEIGTH,
                WALL_WIDTH);
                
            bladeHolder(GRIP_WIDTH, GRIP_HEIGTH, HOLDER_WIDTH, 
                HOLDER_LENGTH);
        }
        for (screwPoint = SCREW_POINTS) {
            translate([screwPoint, 0, -GRIP_HEIGTH/2])
                screwHoles(GRIP_HEIGTH/2, 
                    WALL_WIDTH + BLADE_THICKNESS/2, NUT_D, SCREW_D);
        }
        translate([0, -BLADE_WIDTH/2, -BLADE_THICKNESS])
            cube ([HOLDER_LENGTH, BLADE_WIDTH, BLADE_THICKNESS]);
    }
}

GRIP_LENGTH = 20;
GRIP_WIDTH = 3.5;
GRIP_HEIGTH = 2.5;
WALL_WIDTH = 0.3;
BLADE_THICKNESS = 0.3;
BLADE_WIDTH = 2;
HOLDER_WIDTH = BLADE_WIDTH;
HOLDER_LENGTH = GRIP_LENGTH/2;
NUT_D = 1.18; //Внешний диаметр М6 гайки
SCREW_D = 0.6; //Диаметр резьбы болта М6
SCREW_INTEND = 4;
SCREW_POINTS = [(HOLDER_LENGTH - SCREW_INTEND)/3 + SCREW_INTEND,
                2*(HOLDER_LENGTH - SCREW_INTEND)/3 + SCREW_INTEND];

gripBase(GRIP_LENGTH, GRIP_WIDTH, GRIP_HEIGTH,
    HOLDER_WIDTH, HOLDER_LENGTH,
    BLADE_WIDTH, BLADE_THICKNESS,
    WALL_WIDTH, SCREW_POINTS, NUT_D, SCREW_D);
