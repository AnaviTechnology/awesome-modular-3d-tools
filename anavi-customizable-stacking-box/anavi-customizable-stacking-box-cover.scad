// ========================
// Parameters
// ========================
corner_r = 5;    // PCB corner radius

wall_thickness = 2;  // Wall thickness
$fn = 64;              // smooth corners


// Case
case_width = 160;
case_lenght = 120;
case_height = 2.5;

border_height = 2;

// Outer cylinder
outer_r = 3;
outer_h = 4;

// Inner hole
hole_r = 3;
hole_h = 2;

// USB-C connector
usbc_l = 10;
usbc_h = 5;

// LED
led_r = 5;

// increase for smoother cone ($fn)
segments = 64;

net = false;

// ========================
// Case Top Module
// ========================
module case_top() {

    // Translate so inner PCB pocket starts at (0,0)
    translate([corner_r, corner_r, 0]) {
        difference() {
            
            // Outer shell (walls included)
            linear_extrude(height = case_height)
                rounded_rect(case_width,
                             case_lenght,
                             corner_r);
            
            border_bottom();
        }
    }
}

module border_bottom() {
    difference() {
        // Top hollow interior
        translate([1, 1, 0])
            linear_extrude(height = border_height)
                rounded_rect(case_width-2, case_lenght-2, corner_r);
        translate([2, 2, 0])
            linear_extrude(height = border_height)
                rounded_rect(case_width-4, case_lenght-4, corner_r);
        
    }
}

// ========================
// Rounded rectangle module
// ========================
module rounded_rect(x, y, radius) {
    minkowski() {
        square([x - 2*radius, y - 2*radius], center = false);
        circle(r = radius, $fn = $fn);
    }
}

// Helper functions
function sum_first(arr, n) =
    n == 0 ? 0 : arr[n - 1] + sum_first(arr, n - 1);

// ========================
// Top case
// ========================

case_top();

// -------------------- PARAMETERS --------------------
ratios = [1];   // must sum to 1

availableSpace = case_width-2*wall_thickness;             // total X space
//wall_thickness = 3;               // x
//case_length = 100;                // y
//case_height = 50;                 // z

wall_height = case_height - 2 - 2.5;

echo("Total: ");
echo(availableSpace);

// -------------------- WALL GENERATION --------------------
if (1 < len(ratios)) {
    for (i = [0 : len(ratios) - 2]) {   // no wall for last element

        space = ratios[i] * availableSpace;

        // cumulative space before this element
        x_cursor = sum_first(
            [for (j = [0 : len(ratios) - 1]) ratios[j] * availableSpace],
            i
        ) + len(ratios)-1 * wall_thickness;

        wall_pos = x_cursor + space - wall_thickness / 2;

        echo("i =", i);
        echo("space =", space);
        echo("x_cursor =", x_cursor);
        echo("wall_pos =", wall_pos);

        translate([
            wall_pos,
            0,
            2.5
        ])
            cube([
                wall_thickness,
                case_lenght - 2,
                wall_height
            ]);
    }
}