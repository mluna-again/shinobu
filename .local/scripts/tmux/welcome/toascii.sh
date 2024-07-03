#! /usr/bin/env bash

[ -d images ] || mkdir images
[ -d ascii ] || mkdir ascii

offset="930x1180+1470+370"

file="$1"

ffmpeg -i "$file" -vf fps=1 images/out%d.png

for image in ./images/*; do
  bg=$(convert "$image" -format "%[pixel:p{0,0}]" info:)
  convert "$image" -fuzz 20% -transparent "$bg" "$image"
  convert "$image" -crop "$offset" "$image"

  ascii_file="$(sed -e 's|./images/||' -e 's|.png|.ascii|' <<< "$image")"
  chafa "$image" --size 60x60 --symbols ascii+half+digit > "./ascii/${ascii_file}"
done
