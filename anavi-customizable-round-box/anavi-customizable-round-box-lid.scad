// ------------------ Parameters ------------------
outer_radius = 21;          // mm
wall_thickness = 1;         // mm
height = 5;                // mm

bottom_thickness = 1;       // mm (solid bottom)
top_clearance = 4;          // mm (no bars at top)

// smooth corners
$fn = 128;

module hollow_cylinder() {
    union() {
        difference() {
            // Outer shell
            cylinder(r = outer_radius, h = height);

            // Inner hollow (raised to leave solid bottom)
            translate([0, 0, bottom_thickness])
                cylinder(
                    r = outer_radius - wall_thickness,
                    h = height - bottom_thickness
                );
        }
        
        difference() {
            // Outer shell
            translate([0, 0, bottom_thickness])
                cylinder(r = outer_radius - 2*wall_thickness, h = height - bottom_thickness);

            // Inner hollow (raised to leave solid bottom)
            translate([0, 0, bottom_thickness])
                cylinder(
                    r = outer_radius - 2*wall_thickness - wall_thickness,
                    h = height - bottom_thickness
                );
        }      
    }
}

hollow_cylinder();