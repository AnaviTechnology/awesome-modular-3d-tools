//Laptop size


// ThinkPad X1 Yoga Gen 7
laptop_length = 315;
laptop_width = 17.5;
laptop_height = 223;


// ThinkPad T14 Gen 1 to Gen 4 and T490
/*
laptop_length = 329;
laptop_width = 20;
laptop_height = 227;
*/

// Dock size

// ThinkPad Universal Thunderbolt 4 Dock and
// ThinkPad Universal Thunderbolt 3 Dock 40AC
dock_length = 80;
dock_width = 31;
dock_height = 10;


// ThinkPad USB-C Dock 40A9
/*
dock_length = 80;
dock_width = 34;
dock_height = 10;
*/

// Power adapter
adapter_width = 35;

// Margin and corner radius
margin = 4;
dock_case_lenght = dock_length+2*margin;
dock_case_width = dock_width+2*margin;
dock_case_heigth = dock_height+margin/2;

laptop_case_lenght = laptop_length*0.5;
laptop_case_width = laptop_width+2*margin;
laptop_case_heigth = laptop_height*0.25+margin/2;

// increase for smoother corners
segments = 64;


// ========================
// Rounded rectangle module
// ========================
module rounded_rect(x, y, radius) {
    minkowski() {
        square([x - 2*radius, y - 2*radius], center = false);
        circle(r = radius, $fn = segments);
    }
}

module laptop() {
    difference() {
            // Outer shell (walls included)  
            translate([0, 0, 0])
                cube([laptop_case_lenght, laptop_case_width, laptop_case_heigth]);

            translate([0, margin, margin/2])
                cube([laptop_length, laptop_width, laptop_height]);
        
            // Vents
            vents_side_margin = 20;
            vents_width = laptop_case_lenght - 2*vents_side_margin;
            translate([vents_side_margin, laptop_width+margin, laptop_case_heigth/4])
            {
                vent_width = 1;
                vent_margin = 2;
                vents = (vents_width/(vent_width+vent_margin))-1;
                for (v = [0 : vents]) {
                    translate([v*(vent_width+vent_margin), 0, margin/2])
                        cube([vent_width, margin, laptop_case_heigth/2]);
                }
           }
    }
}

module dock() {
    difference() {
            // Outer shell (walls included)
            translate([margin, margin, 0])
                linear_extrude(height = dock_case_heigth)
                    rounded_rect(dock_case_lenght, dock_case_width, margin);

            translate([margin, margin, dock_case_heigth-dock_height])
                cube([dock_length, dock_width, dock_height]);
    }
}

module base() {
    difference() {
        base_width = dock_width+laptop_width+adapter_width+4*margin;
        translate([margin, margin, 0])
            linear_extrude(height = margin*2)
                rounded_rect(laptop_case_lenght, base_width, margin);
        
        translate([0, 0, margin/2])
            cube([laptop_case_lenght, base_width-margin, margin*2]);
    }
}

base();

translate([0, dock_case_width-margin, 0])
    laptop();

translate([(laptop_case_lenght-dock_case_lenght)/2, 0, 0])
    dock();
