#!/bin/bash

bits=(life_token character_token vote_token effect_token alignment_token pip_token info_tag shroud cutter_character_token cutter_life_token cutter_effect_token cutter_pip_token cutter_alignment_token bits_box_base bits_box_lid clip)

for file in ${bits[@]}; do
    echo Exporting "$file"
    openscad -o "$file".stl bits.scad -D batch_export=true -D print_"$file"=true
done
