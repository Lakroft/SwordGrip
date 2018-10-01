//!OpenSCAD

//Все размеры в см.

module screwHoles(H, holeH, nutD, screwD) {
    union() {
        cylinder (r=nutD/2, h=H - holeH, $fn=6);
        translate([0, 0, H - holeH])
            cylinder (r=screwD/2, h=holeH);
    }
}

module ellipse(h, t, w) {
    scale ([w/t, 1, 1])
        cylinder (r=t/2, h=h);
}

module gripWall (L, W, H) {
        rotate([0, 90 , 0])
            ellipse(L, W, H);
}

module gripWallHalf(L, W, H) {
    difference () {
        gripWall(L, W, H);
        translate ([0, -W/2, 0])
			cube ([L, W, H/2]);
    }
}

module batteryBlock(batBlL, batBlW, batBlH, batBlIntend) {
    translate ([batBlIntend, 0, 0])
            rotate([0, 90 , 0])
                ellipse(batBlL, 
                    batBlW, 
                    batBlH);
}

// Может пригодиться в дальнейшем как подставка для кнопки или батарейного блока
module bladeHolder(gripW, gripH, holderW, holderL) {
    intersection() {
        translate([0, -holderW/2, -gripH/2])
            cube ([holderL, holderW, 
                gripH/2]);
        rotate([0, 90 , 0])
            ellipse(holderL, gripW, gripH);
    }
}

module gripBase(GRIP_LENGTH, GRIP_WIDTH, GRIP_HEIGTH,
    HOLDER_WIDTH, HOLDER_LENGTH,
    BLADE_WIDTH, BLADE_THICKNESS,
	BATTERY_BLOCK_LENGTH, BATTERY_BLOCK_WIDTH, 
	BATTERY_BLOCK_HEIGTH, BATTERY_BLOCK_INTEND,
    WALL_WIDTH, SCREW_POINTS, NUT_D, SCREW_D) {
    difference() {        
		gripWallHalf(GRIP_LENGTH, GRIP_WIDTH, GRIP_HEIGTH);
		
		// Отверстия для соединения половинок
        for (screwPoint = SCREW_POINTS) {
            translate([screwPoint, 0, -GRIP_HEIGTH/2])
                screwHoles(GRIP_HEIGTH/2, 
                    WALL_WIDTH + BLADE_THICKNESS/2, NUT_D, SCREW_D);
        }
		
		// Держатель лезвия
        translate([0, -BLADE_WIDTH/2, -BLADE_THICKNESS])
            cube ([HOLDER_LENGTH, BLADE_WIDTH, BLADE_THICKNESS]);
			
		// Отсек для батареек
		batteryBlock(BATTERY_BLOCK_LENGTH, BATTERY_BLOCK_WIDTH, 
		BATTERY_BLOCK_HEIGTH, BATTERY_BLOCK_INTEND);
		
		// Отверстие для кнопки
    }
	
}

GRIP_LENGTH = 20;
GRIP_WIDTH = 3.5;
GRIP_HEIGTH = 2.5;
WALL_WIDTH = 0.3;
BLADE_THICKNESS = 0.9;
BLADE_WIDTH = 2;
HOLDER_WIDTH = BLADE_WIDTH;
HOLDER_LENGTH = GRIP_LENGTH/2;
BATTERY_BLOCK_LENGTH = GRIP_LENGTH - HOLDER_LENGTH - WALL_WIDTH;
BATTERY_BLOCK_WIDTH = GRIP_WIDTH - 2 * WALL_WIDTH;
BATTERY_BLOCK_HEIGTH = GRIP_HEIGTH - 2 * WALL_WIDTH;
BATTERY_BLOCK_INTEND = HOLDER_LENGTH;
NUT_D = 1.18; // Внешний диаметр М6 гайки
SCREW_D = 0.6; // Диаметр резьбы болта М6
SCREW_INTEND = 4;
SCREW_POINTS = [(HOLDER_LENGTH - SCREW_INTEND)/3 + SCREW_INTEND,
                2*(HOLDER_LENGTH - SCREW_INTEND)/3 + SCREW_INTEND];
$fn=180;

gripBase(GRIP_LENGTH, GRIP_WIDTH, GRIP_HEIGTH,
    HOLDER_WIDTH, HOLDER_LENGTH,
    BLADE_WIDTH, BLADE_THICKNESS,
	BATTERY_BLOCK_LENGTH, BATTERY_BLOCK_WIDTH, 
	BATTERY_BLOCK_HEIGTH, BATTERY_BLOCK_INTEND,
    WALL_WIDTH, SCREW_POINTS, NUT_D, SCREW_D);
