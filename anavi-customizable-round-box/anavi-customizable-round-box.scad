// ------------------ Parameters ------------------
outer_radius = 30;          // mm
wall_thickness = 1;         // mm
bar_thickness = 1;          // mm (radial)
bar_width = 1;              // mm (circumferential)
bar_gap = 1;                // mm
height = 20;                // mm

bottom_thickness = 1;       // mm (solid bottom)
top_clearance = 4;          // mm (no bars at top)

// smooth corners
$fn = 128;

// ------------------ Main ------------------
union() {
    hollow_cylinder();
    external_bars();
}

// ------------------ Hollow Cylinder ------------------
module hollow_cylinder() {
    difference() {
        // Outer shell
        cylinder(r = outer_radius, h = height);

        // Inner hollow (raised to leave solid bottom)
        translate([0, 0, bottom_thickness])
            cylinder(
                r = outer_radius - wall_thickness,
                h = height - bottom_thickness + 0.01
            );
    }
}

// ------------------ External Bars ------------------
module external_bars() {
    circumference = 2 * PI * outer_radius;
    bar_pitch = bar_width + bar_gap;
    bar_count = floor(circumference / bar_pitch);

    for (i = [0 : bar_count - 1]) {
        angle = i * 360 / bar_count;
        rotate([0, 0, angle])
            translate([outer_radius, -bar_width/2, 0])
                cube([
                    bar_thickness,
                    bar_width,
                    height - top_clearance
                ]);
    }
}