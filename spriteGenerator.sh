#!/bin/bash

# Enable debugging
set -x

# Array mapping numeric folder names to direction names
declare -A directions=( [0]="SW" [1]="S" [2]="SE" [3]="E" [4]="NE" [5]="N" [6]="NW" [7]="W" )

# Base directory for folders, defaults to current directory if not provided
BASE_DIR="${1:-.}"

# Target resolution for each image
TARGET_WIDTH=409
TARGET_HEIGHT=230

# Final output resolution
FINAL_WIDTH=2048
FINAL_HEIGHT=2048

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
    
    # Temporary directory to store resized images
    TEMP_DIR="$BASE_DIR/temp"
    mkdir -p "$TEMP_DIR"

    # Resize images to fit within the target resolution while maintaining aspect ratio
    for image in "$folder"/*; do
      # Ensure image path is quoted
      magick "$image" -scale "${TARGET_WIDTH}x${TARGET_HEIGHT}" -quality 95 "$TEMP_DIR/$(basename "$image")"
    done
    
    # Create a montage (sprite sheet) from resized images
    # Use double quotes for path expansion to handle spaces
    magick montage "$TEMP_DIR/"*.png -tile 5x5 -geometry "${TARGET_WIDTH}x${TARGET_HEIGHT}+0+0" -background transparent -filter Catrom "$BASE_DIR/$OUTPUT_FILE"
    
    echo "Created $OUTPUT_FILE in $BASE_DIR"

    # Clean up temporary resized images
    rm -r "$TEMP_DIR"
  else
    echo "Skipping $folder, not a directory."
  fi
done

# Disable debugging
set +x