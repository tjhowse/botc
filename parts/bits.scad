life_token_r = 40/2;
character_token_r = 47/2;
vote_token_r = 25/2;
effect_token_r = 25/2;
pip_token_r = 12/2;
alignment_token_r = 15/2;

shroud_x = 20;
shroud_y = 36;
shroud_notch_y = 8.5;

info_tag_x = 47;
info_tag_y = 58;
info_tag_corner_r = 3.5;
info_tag_offset_x = info_tag_x-info_tag_corner_r*2;
info_tag_offset_y = info_tag_y-info_tag_corner_r*2;

token_z = 2;
$fn=32;

// This is a tool for cutting nice circles out of paper for gluing onto the printed tokens.
// Print both parts. Glue a section of craft knife blade to the flat portion of the outer ring.
// Position the thicker inner ring exactly over the centre of the circle you want to cut.
// Lower the outer ring over the inner ring. Firmly hold the inner ring in place as you rotate
// the outer ring around to make the cut.
// Tweak the cutter_gap variable until your outer ring fits snugly over the inner ring with
// minimum wiggle room.

// I've found that it's good to make the circle pieces slightly smaller than the tokens to
// protect the edges of the paper.
cutter_tweak = 0.25;
cutter_inner_z = 30;
cutter_inner_thickness = 5;
cutter_outer_z = 15;
cutter_outer_thickness = 2;
cutter_gap = 0.1; // You may need to change this number based on how much clearance you need.
cutter_blade_thickness = 0.4;
cutter_blade_flat_section_x = 10;
cutter_fn = 100;
cutter_blade_x = 4.8;

module cutter(cut_radius) {
    cutter_inner(cut_radius-cutter_tweak);
    translate([cut_radius*2+10,0,0]) cutter_outer(cut_radius-cutter_tweak);
}

module cutter_inner(cut_radius) {
    difference() {
        cylinder(r=cut_radius-cutter_blade_thickness/2-cutter_outer_thickness-cutter_gap, h=cutter_inner_z, $fn=cutter_fn);
        cylinder(r=cut_radius-cutter_blade_thickness/2-cutter_outer_thickness-cutter_gap-cutter_inner_thickness, h=cutter_inner_z, $fn=cutter_fn);
    }
}

module cutter_blade_groove() {
    wt = (cutter_blade_flat_section_x - cutter_blade_x)/2;
    translate([-wt/2-cutter_blade_x/2,cutter_blade_thickness,cutter_outer_z/2]) cube([wt,cutter_blade_thickness*2,cutter_outer_z], center=true);
    translate([wt/2+cutter_blade_x/2,cutter_blade_thickness,cutter_outer_z/2]) cube([wt,cutter_blade_thickness*2,cutter_outer_z], center=true);
}

module cutter_outer(cut_radius, blade_grooves=false) {
    difference() {
        hull() {
            cylinder(r=cut_radius-cutter_blade_thickness/2, h=cutter_outer_z, $fn=cutter_fn);
            for (i = [0:360/3:360]) {
                rotate([0,0,i]) translate([-cutter_blade_flat_section_x/2,cut_radius-cutter_blade_thickness/2-cutter_outer_thickness,0]) cube([cutter_blade_flat_section_x, cutter_outer_thickness, cutter_outer_z]);
            }
        }
        cylinder(r=cut_radius-cutter_blade_thickness/2-cutter_outer_thickness, h=cutter_outer_z, $fn=cutter_fn);
        echo(cut_radius-cutter_blade_thickness/2-cutter_outer_thickness);
    }
    if (blade_grooves) {
        for (i = [0:360/3:360]) {
            rotate([0,0,i]) translate([0,cut_radius-cutter_blade_thickness/2,0]) cutter_blade_groove();
        }
    }
}

module token(radius) {
    cylinder(r=radius,h=token_z);
}

module life_token() {
    token(life_token_r);
}

module character_token() {
    token(character_token_r);
}

module vote_token() {
    token(vote_token_r);
}

module effect_token() {
    token(effect_token_r);
}

module alignment_token() {
    token(alignment_token_r);
}

module pip_token() {
    token(pip_token_r);
}

module info_tag() {
    hull() {
        cylinder(r=info_tag_corner_r, h = token_z);
        translate([info_tag_offset_x, info_tag_offset_y, 0]) cylinder(r=info_tag_corner_r, h = token_z);
        translate([0, info_tag_offset_y, 0]) cylinder(r=info_tag_corner_r, h = token_z);
        translate([info_tag_offset_x, 0, 0]) cylinder(r=info_tag_corner_r, h = token_z);
    }
}

module shroud() {
    difference() {
        cube([shroud_x, shroud_y, token_z*2]);
        translate([shroud_x/2,0,0]) scale([shroud_x/2,shroud_notch_y,1]) rotate([0,0,45]) cube([sqrt(2), sqrt(2), 100], center=true);
        translate([shroud_x/2,shroud_y/4,token_z]) character_token();
    }
}

bits_box_wt = 2; // Wall thickness
game_box_inside_x = 257;
bits_box_clearance_x = 5;
// bits_box_x = game_box_inside_x-bits_box_clearance_x;
bits_box_lid_clearance = 0.35;
bits_box_bits_clearance = 0.5; // How much space around the character tokens?
// bits_box_y = character_token_r*2+bits_box_wt*2+2*bits_box_bits_clearance;
bits_box_compartment_xy = character_token_r*2+bits_box_bits_clearance*2;
bits_box_x = 2*bits_box_compartment_xy+bits_box_wt*3;
bits_box_y = bits_box_x;
bits_box_z = 35;
bits_box_lid_z = 20;
bits_box_vent_hole_r = 5; // The lid seals onto the base too well. Needs a breather hole.

module bits_box_base_cutout() {
    cube([bits_box_compartment_xy, bits_box_compartment_xy, bits_box_z-bits_box_wt]);
    // translate([bits_box_compartment_xy/2, bits_box_compartment_xy/2,-bits_box_wt]) cylinder(r=bits_box_vent_hole_r, h = bits_box_wt);
}

module bits_box_base() {
    difference() {
        cube([bits_box_x, bits_box_y, bits_box_z]);
        translate([bits_box_wt,bits_box_wt,bits_box_wt]) bits_box_base_cutout();
        translate([bits_box_wt*2+bits_box_compartment_xy,bits_box_wt,bits_box_wt]) bits_box_base_cutout();
        translate([bits_box_wt,bits_box_wt*2+bits_box_compartment_xy,bits_box_wt]) bits_box_base_cutout();
        translate([bits_box_wt*2+bits_box_compartment_xy,bits_box_wt*2+bits_box_compartment_xy,bits_box_wt]) bits_box_base_cutout();
        translate([bits_box_x/2, bits_box_y/2, 0]) sphere(r=bits_box_vent_hole_r);
    }
}

module bits_box_lid() {
    difference() {
        cube([bits_box_x+bits_box_lid_clearance+2*bits_box_wt, bits_box_y+bits_box_lid_clearance+2*bits_box_wt, bits_box_lid_z+bits_box_wt]);
        translate([bits_box_wt,bits_box_wt,bits_box_wt]) cube([bits_box_x+bits_box_lid_clearance, bits_box_y+bits_box_lid_clearance, bits_box_z]);
    }
}

render() {
    // life_token(); // 18 (townsfolk) + 5 (traveller)
    // character_token(); // 103
    // vote_token(); // 20
    // effect_token(); // 125
    // alignment_token(); // 22
    // pip_token(); // 34
    // info_tag(); // 12
    // shroud(); // 18
    // cutter(character_token_r);
    // cutter(life_token_r);
    cutter(effect_token_r);
    // bits_box_base(); // 4
    // bits_box_lid(); // 4
}