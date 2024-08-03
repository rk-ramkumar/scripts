#!/bin/bash

# Default output file name
OUTPUT_FILE="spritesheet.png"

# Check if an argument is given
if [ $# -ge 1 ]; then
  OUTPUT_FILE="$1"
fi

# Execute the magick montage command
magick montage * -geometry 128x128 -tile 8x8 -background transparent -filter Catrom "$OUTPUT_FILE"
