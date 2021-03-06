include <deps/BOSL/constants.scad>
use <deps/BOSL/shapes.scad>
use <deps/BOSL/threading.scad>
$fn=64;
height = 20;
dot_radius = 5;
global_slop = PRINTER_SLOP;

module dot_1(internal=false, slop = global_slop) {
    smooth_height = height / 2;
    thread_height = height - smooth_height;
    
    thread_depth = 1;
    radius = dot_radius;
    
    translate([0, 0, thread_height * 1.5])
        cylinder(h=smooth_height, r=radius + (internal ? PRINTER_SLOP: 0), center=true);
    
    translate([0, 0, thread_height/2])
        trapezoidal_threaded_rod(d=(radius + thread_depth - (internal ? slop: 0)/2) * 2, l=thread_height, pitch=thread_depth * 2, thread_angle=15, internal = internal, slop=slop);
}

//dot_1();

module dot_2(internal=false, slop = global_slop) {
    stopper_height = 1;
    stopper_extra_radius = 1;
    stopper_slope_height = 1;
    
    added_slop = (internal ? slop: 0);
    
    translate([0, 0, height/2])
        cylinder(h=height, r=dot_radius + (internal ? slop: 0), center=true);
    
    translate([0, 0, stopper_height/2]) {
        cylinder(h=stopper_height, r=(dot_radius + stopper_extra_radius) + added_slop, center=true);
        
        translate([0, 0, stopper_height])
            cylinder(h = stopper_slope_height, r1 = (dot_radius + stopper_extra_radius) + added_slop, r2 = dot_radius + added_slop, center = true);
    }
}


sizes = [50, 25];
difference() {
    translate([0, 0, 0.001])
        rounded_prismoid(size1=sizes, size2=sizes, h=20-0.002, r=20);
    
    translate([-10, 0, 0])
        dot_1(internal=true, slop=0.5);
    translate([10, 0, 0])
        dot_2(internal=true);
}

translate([0, -20, 0]) {
    translate([-10, 0, 0])
        dot_1(internal=false);
    translate([10, 0, 0])
        dot_2(internal=false);
}