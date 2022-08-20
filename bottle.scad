use <lib/threads/threads.scad>;
$fn = 50;
cell_width = 42;

bottle_body_height = 33;
bottle_corner_radius = 3;

cell_bottom_width = 37;
cell_bottom_height = 3;
cell_bottom_offset = 2; 
cell_bottom_corner_radius = 2;

neck_diameter = 36;
neck_thread_outer_diameter = 38;
neck_thread_tooth_height = (neck_thread_outer_diameter - neck_diameter)/2;
neck_height = 8;
neck_offset = 8;
neck_threads = 3;
neck_threads_pitch = 9;

thread_cut = 2;

module rbox(width, depth, height, r) {
    minkowski() {
        cylinder(r=r, h=0.01);
        translate([-width/2+r, -depth/2+r, 0])
            cube([width-r*2, depth-r*2, height]);
    }
}



translate([0, 0, bottle_body_height + neck_offset]) {
    intersection() {
        for(i=[1:neck_threads])
            rotate(360/neck_threads * (i-1), [0, 0, 1])
                ScrewThread(
                    outer_diam=neck_thread_outer_diameter,
                    height=neck_height,
                    pitch=neck_threads_pitch,
                    tooth_angle=30, tolerance=0.4, tip_height=0, tooth_height=neck_thread_tooth_height, tip_min_fract=0);
        translate([0,0,0])
            minkowski() {
                cylinder(h=thread_cut, d1=thread_cut, d2=0.01);
                cylinder(h=neck_height-thread_cut*2, d=neck_thread_outer_diameter-thread_cut*2+0.8);
                cylinder(h=thread_cut, d1=0.01, d2=thread_cut);
            }
    }
    //cylinder(d=neck_diameter, h=neck_height);
}

    
hull() {
    translate([0, 0, bottle_body_height])
        cylinder(d=neck_diameter, h=neck_offset);

    
    rbox(cell_width, cell_width, bottle_body_height, bottle_corner_radius);

    translate([0, 0, -cell_bottom_offset])
        rbox(cell_bottom_width, cell_bottom_width, cell_bottom_offset, cell_bottom_corner_radius);
}    
translate([0, 0, -cell_bottom_height-cell_bottom_offset])
    rbox(cell_bottom_width, cell_bottom_width, cell_bottom_height, cell_bottom_corner_radius);
