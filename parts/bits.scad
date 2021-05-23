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

token_z = 1.5;
$fn=64;

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


// Bits box
// I originally started out with a design matching the bits boxes that come with the
// proper version of the game, with three square compartments large enough to hold
// the character tokens, and two smaller compartments at the end, all in one row.
// However this was too long to fit onto my print bed, so I went for a 2x2 arrangement
// of uniformly sized compartments.
// I added a hole cutout in the bottom of the bits box base to let air in. I found
// on earlier versions that it was hard to get the lid off due to the partial vacuum
// formed when lifting the lid.
bits_box_wt = 2; // Wall thickness
game_box_inside_x = 257;
bits_box_clearance_x = 5;
// bits_box_x = game_box_inside_x-bits_box_clearance_x;
bits_box_lid_clearance = 0.25;
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

// This is a clip to hold the two halves of the grimoire box together. Dog clips
// work well enough, but for maximum structural strength the very tops of the side
// edges of the grimoire should be pinched together. The pinch point of normal dog
// clips is some distance from the base of their throat.

clip_z = 25;
clip_length = 50;
clip_wt = 3;
// When tightly squashed the edges of my grimoire, made from a pandemic legacy season 0 box,
// measure 6.05mm in total.
clip_gap = 6.0;

module clip() {
    difference () {
        cube([clip_wt*2+clip_gap, clip_length, clip_z]);
        translate([clip_wt,0,clip_wt]) cube([clip_gap, clip_length, clip_z]);
        translate([0,0,clip_z]) rotate([0,45,0]) cube([(clip_wt*2+clip_gap)/sqrt(2), clip_length, (clip_wt*2+clip_gap)/sqrt(2)]);
    }
}

// You can safely ignore these, they're for exporting everything to STL in bulk.
batch_export = false;
print_life_token = false;
print_character_token = false;
print_vote_token = false;
print_effect_token = false;
print_alignment_token = false;
print_pip_token = false;
print_info_tag = false;
print_shroud = false;
print_cutter_character_token = false;
print_cutter_life_token = false;
print_cutter_effect_token = false;
print_bits_box_base = false;
print_bits_box_lid = false;
print_clip = false;

if (batch_export) {
    if (print_life_token) life_token();
    if (print_character_token) character_token();
    if (print_vote_token) vote_token();
    if (print_effect_token) effect_token();
    if (print_alignment_token) alignment_token();
    if (print_pip_token) pip_token();
    if (print_info_tag) info_tag();
    if (print_shroud) shroud();
    if (print_cutter_character_token) cutter(character_token_r);
    if (print_cutter_life_token) cutter(life_token_r);
    if (print_cutter_effect_token) cutter(effect_token_r);
    if (print_bits_box_base) bits_box_base();
    if (print_bits_box_lid) bits_box_lid();
    if (print_clip) rotate([90,0,0]) clip();
} else {
    render() {
        // life_token(); // 18 (townsfolk) + 5 (traveller)
        // character_token(); // 103
        // vote_token(); // 20
        effect_token(); // 125
        // alignment_token(); // 22
        // pip_token(); // 34
        // info_tag(); // 12
        // shroud(); // 18
        // cutter(character_token_r);
        // cutter(life_token_r);
        // cutter(effect_token_r);
        // bits_box_base(); // 4
        // bits_box_lid(); // 4
        // rotate([90,0,0]) clip();
    }
}