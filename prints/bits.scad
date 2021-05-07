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
    shroud(); // 18
}