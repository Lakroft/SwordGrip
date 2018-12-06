//!OpenSCAD

//*************** ПЕРЕМЕННЫЕ ***************************************************
//Все размеры в см.
GRIP_LENGTH = 20;
GRIP_WIDTH = 3.5;
GRIP_HEIGTH = 2.5;
WALL_WIDTH = 0.3;
BLADE_THICKNESS = 0.9 + 0.2; //Значение + запас
BLADE_WIDTH = 2 + 0.3; //Значение + запас
HOLDER_WIDTH = BLADE_WIDTH;
HOLDER_LENGTH = GRIP_LENGTH/2;

BUTTON_LENGTH = 0.5;
BUTTON_WIDTH = 0.8;
BUTTON_HEIGTH = 0.7;
BUTTON_WINDOW_LENGTH = WALL_WIDTH;
BUTTON_WINDOW_WIDTH = 0.3;
BUTTON_WINDOW_INTEND = 0.08;
BUTTON_WINDOW_HEIGTH = BUTTON_HEIGTH - BUTTON_WINDOW_INTEND;
BUTTON_REST_LENGTH = 0.5;
BUTTON_REST_WIDTH = 0.3;
BUTTON_REST_HEIGTH = BUTTON_HEIGTH;
BUTTON_SHELF_LENGTH = WALL_WIDTH + BUTTON_LENGTH + BUTTON_REST_LENGTH;
LEG_EXTRA_SPACE = 0.1;

BATTERY_BLOCK_LENGTH = GRIP_LENGTH - HOLDER_LENGTH - BUTTON_SHELF_LENGTH;
BATTERY_BLOCK_WIDTH = GRIP_WIDTH - 2 * WALL_WIDTH;
BATTERY_BLOCK_HEIGTH = GRIP_HEIGTH - 2 * WALL_WIDTH;
BATTERY_BLOCK_INTEND = HOLDER_LENGTH;
NUT_D = 1.13; // Внешний диаметр гайки. Должно подходить для М5
NUT_D_M3 = 0.7; // Диаметр гайки М3
SCREW_D = 0.6; // Диаметр резьбы болта. Идеально для М5
SCREW_D_M3 = 0.32; // Диаметр резьбы болта М3
SCREW_POINT_M3_X = GRIP_LENGTH - BUTTON_SHELF_LENGTH/2;
SCREW_POINT_M3_Y = (GRIP_WIDTH-BUTTON_WIDTH)/4 + BUTTON_WIDTH/2;
SCREW_INTEND = 2;
SCREW_POINTS = [(HOLDER_LENGTH - SCREW_INTEND)/3 + SCREW_INTEND,
                2*(HOLDER_LENGTH - SCREW_INTEND)/3 + SCREW_INTEND];
$fn=180;


//********************* MAIN ***************************************************

translate([0, GRIP_WIDTH, 0])
	gripBase();
	

translate([0, -GRIP_WIDTH, 0])
	gripBaseWithButton();
		

//*************** МОДУЛИ ***************************************************
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

module buttonHoleNew(butL, butW, butH,
	butWinL, butWinW, butWinH, butWinInt,
	butRestL, butRestW, butRestH, legExtraSpace) {
	
	// Координаты от середины кнопки.
	legWidth = (butW - butRestW)/2;
	union() {
		// Вырезы для ножек кнопки. 
		// Между ними сформируется стопор для тела кнопки.
		for(legsHoleY = [butRestW/2, -legWidth - butRestW/2 - legExtraSpace]) {
			translate([-0.1, legsHoleY, 0])
				cube([butRestL + 0.1, legWidth + legExtraSpace, butRestH + 0.1]);
		}
		// "Тело" кнопки
		translate([butRestL, -butW/2, 0])
			cube([butL, butW, butH + 0.1]);
		// "Окошко" для нажимной части кнопки
		translate([butRestL + butL, (butW - butWinW)/2 - butW/2, butWinInt])
			cube([butWinL + 0.1, butWinW, butWinH + 0.1]);
	}
}

module gripBase() {
    difference() {
		gripWallHalf(GRIP_LENGTH, GRIP_WIDTH, GRIP_HEIGTH);

		// Отверстия для соединения половинок
    for (screwPoint = SCREW_POINTS) {
        translate([screwPoint, 0, -GRIP_HEIGTH/2])
            screwHoles(GRIP_HEIGTH/2,
                WALL_WIDTH + BLADE_THICKNESS/2, NUT_D, SCREW_D);
    }
	
	// Отверстие для соединения в задней части
	translate([SCREW_POINT_M3_X, SCREW_POINT_M3_Y, -GRIP_HEIGTH/2])
		screwHoles(GRIP_HEIGTH/2, WALL_WIDTH, NUT_D_M3, SCREW_D_M3);
	translate([SCREW_POINT_M3_X, -SCREW_POINT_M3_Y, -GRIP_HEIGTH/2])
		screwHoles(GRIP_HEIGTH/2, WALL_WIDTH, NUT_D_M3, SCREW_D_M3);

		// Держатель лезвия
    translate([0, -BLADE_WIDTH/2, -BLADE_THICKNESS/2])
        cube ([HOLDER_LENGTH, BLADE_WIDTH, BLADE_THICKNESS/2]);

		// Отсек для батареек
		batteryBlock(BATTERY_BLOCK_LENGTH, BATTERY_BLOCK_WIDTH,
		BATTERY_BLOCK_HEIGTH, BATTERY_BLOCK_INTEND);
    }
}

module gripBaseWithButton() {
	difference() {
		gripBase();
		
		translate([GRIP_LENGTH - BUTTON_SHELF_LENGTH, 
			0, -BUTTON_HEIGTH])
			buttonHoleNew(BUTTON_LENGTH, BUTTON_WIDTH, BUTTON_HEIGTH,
				BUTTON_WINDOW_LENGTH, BUTTON_WINDOW_WIDTH, BUTTON_WINDOW_HEIGTH,
				BUTTON_WINDOW_INTEND,
				BUTTON_REST_LENGTH, BUTTON_REST_WIDTH, BUTTON_REST_HEIGTH, LEG_EXTRA_SPACE);
	}
}
