// ========================
// Parameters
// ========================
corner_r = 5;    // PCB corner radius

wall_thickness = 2;  // Wall thickness
$fn = 64;              // smooth corners


// Case
case_width = 100;
case_length = 50;
case_height = 20;

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

open = false;

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
                             case_length,
                             corner_r);

            // Main hollow interior
            translate([wall_thickness, wall_thickness, border_height+0.5])
                linear_extrude(height = case_height-2)
                    rounded_rect(case_width-2*wall_thickness, case_length-2*wall_thickness, corner_r);
            
            border_top();
            
            border_bottom();
            
            // Open one of the sides
            if ( true == open) {
                translate([0, -corner_r, border_height+0.5])
                    cube([case_width-2*corner_r,wall_thickness+1,case_height-border_height-0.5]);
            }
            
            // Net
            if (true == net) {
                cube_size = 8;
                gap = 2;
                pitch = cube_size + gap;
                matrix_x  = (case_width - 2*corner_r) / pitch;
                matrix_y  = (case_length - 2*corner_r) / pitch;
                start_pos = gap/2;
                for (x = [0 : matrix_x-1]) {
                    for (y = [0 : matrix_y-1]) {
                        translate([start_pos+x * pitch, start_pos+y * pitch, 0])
                            cube(cube_size);
                    }
                }
            }
        }
    }
}

module border_top() {
    difference() {
        // Top hollow interior
        translate([0, 0, case_height-2])
            linear_extrude(height = border_height)
                rounded_rect(case_width, case_length, corner_r);
        translate([1, 1, case_height-2])
            linear_extrude(height = border_height)
                rounded_rect(case_width-2, case_length-2, corner_r);
        
    }
}

module border_bottom() {
    difference() {
        // Top hollow interior
        translate([1, 1, 0])
            linear_extrude(height = border_height)
                rounded_rect(case_width-2, case_length-2, corner_r);
        translate([2, 2, 0])
            linear_extrude(height = border_height)
                rounded_rect(case_width-4, case_length-4, corner_r);
        
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
                case_length - 2,
                wall_height
            ]);
    }
}