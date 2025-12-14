rows = 2;
columns = 5;
size = 15;
wall = 2;

case_height = 60;

case_width = rows * size + ((rows-1)+2)*wall;
case_lenght = columns * size + ((columns-1)+2)*wall;

// ========================
// Rounded rectangle module
// ========================
module rounded_rect(x, y, radius) {
    minkowski() {
        square([x - 2*radius, y - 2*radius], center = false);
        circle(r = radius, $fn = 64);
    }
}

// ========================
// Tweezers case
// ========================
module case() {
    // Corner radius
    corner_r = 2;

    difference() {
            // Outer shell (walls included)
            linear_extrude(height = case_height)
                rounded_rect(case_width, case_lenght, corner_r);
        
            translate([-corner_r + wall, -corner_r + wall, wall]) {
                for (y = [0 : columns-1]) {
                    for (x = [0 : rows-1]) {
                        translate([x*(size+wall), y*(size+wall), 0])
                            cube([size, size, case_height-wall]);
                    }
                }
            }
    }
}

// Draw the case
case();

