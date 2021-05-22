#!/bin/bash
# Note: openscad isn't on my $PATH, hence the symlink hack below. You may need to fix it on your system.

bits=(life_token character_token vote_token effect_token alignment_token pip_token info_tag shroud cutter_character_token cutter_life_token cutter_effect_token bits_box_base bits_box_lid clip)

for file in ${bits[@]}; do
    echo Exporting "$file"
    ./openscad -o "$file".stl bits.scad -D batch_export=true -D print_"$file"=true
done
