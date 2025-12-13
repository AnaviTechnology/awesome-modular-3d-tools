// USB Type A ports
usba = 3;
// USB Type C ports
usbc = 2;

// Margin
margin = 6;

// Corner radius
corner = 5;

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

    case_height = 14;

    case_width = 24.3;
    case_lenght = usba*(5+margin) + usbc*(2.5+margin);

    difference() {
        // Outer shell (walls included)
        translate([corner, corner, 0])
            linear_extrude(height = case_height)
                rounded_rect(case_width, case_lenght, corner);
        
        // USB Type A
        if (usba > 0) {
            translate([margin, margin/2, 2]) {
                for (a = [0 : usba-1]) {
                    translate([0, a*(5+margin), 0])
                        cube([12.3, 5, 12]);
                }
            }
        }

        // USB Type C
        if (usbc > 0) {
            posc = margin/2+usba*(5+margin);
            for (c = [0 : usbc-1]) {
                translate([margin+(12.5-8.5)/2, posc+c*(2.5+margin), 2])
                    cube([8.5, 2.5, 12]);
            }
        }
    }
}

stand();