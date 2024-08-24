#!/bin/bash

# Enable debugging
set -x

# Array mapping numeric folder names to direction names
declare -A directions=( [0]="SW" [1]="S" [2]="SE" [3]="E" [4]="NE" [5]="N" [6]="NW" [7]="W" )

# Base directory for folders, defaults to current directory if not provided
BASE_DIR="${1:-.}"

# Loop through all directories in the base directory
for folder in "$BASE_DIR"/*; do
  # Check if the folder exists and is a directory
  if [ -d "$folder" ]; then
    folder_name=$(basename "$folder")
    
    # Check if the folder name is a number and map it to the direction
    if [[ $folder_name =~ ^[0-7]$ ]]; then
      OUTPUT_FILE="${directions[$folder_name]}.png"
    else
      OUTPUT_FILE="${folder_name}.png"
    fi
    
    # Create a montage (sprite sheet) from resized images
    # Use double quotes for path expansion to handle spaces
    magick montage "$folder"/* -tile 5x5 -background transparent -filter Catrom "$BASE_DIR/$OUTPUT_FILE"
    
    echo "Created $OUTPUT_FILE in $BASE_DIR"

  else
    echo "Skipping $folder, not a directory."
  fi
done

# Disable debugging
set +x