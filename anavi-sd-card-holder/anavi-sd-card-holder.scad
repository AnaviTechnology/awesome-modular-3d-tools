rows = 5;
columns = 1;

// Margin between the SD card and the end of the holder
bezel = 2;

// Distance between SD cards
spacing = 4;


// ========================
// Rounded rectangle module
// ========================
module rounded_rect(x, y, radius) {
    minkowski() {
        square([x - 2*radius, y - 2*radius], center = false);
        circle(r = radius, $fn = 64);
    }
}

// ===============================
// Stand for USB stick and devices
// ===============================
module stand() {

    // Corner radius
    corner = 2;

    case_height = 14;

    card_lenght = 24.2;
    card_width = 2.3;

    case_width = columns*card_lenght+(columns-1)*spacing+2*bezel;
    case_lenght =rows*card_width+(rows-1)*spacing+2*bezel;

    difference() {
        // Outer shell (walls included)
        translate([corner, corner, 0])
            linear_extrude(height = case_height)
                rounded_rect(case_width, case_lenght, corner);

        translate([bezel, bezel, 2]) {
            for (y = [0 : columns-1]) {
                for (x = [0 : rows-1]) {
                    translate([y*(card_lenght+spacing), x*(card_width+spacing), 0])
                        cube([card_lenght, card_width, 12]);
                }
            }
        }
    }
}

stand();