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
cutter_inner_z = 20;
cutter_inner_thickness = 5;
cutter_outer_z = 10;
cutter_outer_thickness = 2;
cutter_gap = 0.2;
cutter_blade_thickness = 0.4;
cutter_blade_flat_section = 10;
cutter_fn = 100;

module cutter(cut_radius) {
    cutter_inner(cut_radius);
    translate([cut_radius*2+10,0,0]) cutter_outer(cut_radius);
}

module cutter_inner(cut_radius) {
    difference() {
        cylinder(r=cut_radius-cutter_blade_thickness/2-cutter_outer_thickness-cutter_gap, h=cutter_inner_z, $fn=cutter_fn);
        cylinder(r=cut_radius-cutter_blade_thickness/2-cutter_outer_thickness-cutter_gap-cutter_inner_thickness, h=cutter_inner_z, $fn=cutter_fn);
    }
}

module cutter_outer(cut_radius) {
    difference() {
        hull() {
            cylinder(r=cut_radius-cutter_blade_thickness/2, h=cutter_outer_z, $fn=cutter_fn);
            translate([-cutter_blade_flat_section/2,cut_radius-cutter_blade_thickness/2-cutter_outer_thickness,0]) cube([cutter_blade_flat_section, cutter_outer_thickness, cutter_outer_z]);
        }
        cylinder(r=cut_radius-cutter_blade_thickness/2-cutter_outer_thickness, h=cutter_outer_z, $fn=cutter_fn);
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
render() {
    // life_token(); // 18 (townsfolk) + 5 (traveller)
    // character_token(); // 103
    // vote_token(); // 20
    // effect_token(); // 125
    // alignment_token(); // 22
    // pip_token(); // 34
    // info_tag(); // 12
    // shroud(); // 18
    cutter(character_token_r);
}