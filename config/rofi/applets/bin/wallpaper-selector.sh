#!/bin/bash

# Configuration
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper-thumbnails"
THUMBNAIL_SIZE="300x300"

source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# Check if swww is running, if not start it
if ! pgrep -x swww-daemon > /dev/null; then
    swww-daemon &
    sleep 1
fi

# Check if wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    rofi -e "Wallpaper directory not found: $WALLPAPER_DIR" -theme ${theme}
    exit 1
fi

# Create cache directory for thumbnails
mkdir -p "$CACHE_DIR"

# Find all image files
mapfile -t images < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.bmp" \) | sort)

# Check if any images were found
if [ ${#images[@]} -eq 0 ]; then
    rofi -e "No images found in $WALLPAPER_DIR"
    exit 1
fi

# Generate thumbnails and create rofi entries
entries=""
for img in "${images[@]}"; do
    filename=$(basename "$img")
    # Create a hash of the full path for unique cache names
    hash=$(echo -n "$img" | md5sum | cut -d' ' -f1)
    thumbnail="$CACHE_DIR/${hash}.png"
    
    # Generate thumbnail if it doesn't exist
    if [ ! -f "$thumbnail" ]; then
        convert "$img" -resize "$THUMBNAIL_SIZE" "$thumbnail" 2>/dev/null
    fi
    
    # Add entry with thumbnail path
    entries+="${filename}\x00icon\x1f${thumbnail}\n"
done

# Show rofi with image previews
selected=$(echo -e "$entries" | rofi -dmenu -i \
    -p "Select Wallpaper" \
    -theme-str 'window {width: 75%; height: 65%;}' \
    -theme-str 'listview {columns: 6; lines: 3;}' \
    -theme-str 'element {orientation: vertical; padding: 4px;}' \
    -theme-str 'element-icon {size: 220px;}' \
    -theme-str 'element-text {enabled: false;}' \
    -show-icons \
    -theme ${theme})

# Exit if no selection was made
if [ -z "$selected" ]; then
    exit 0
fi

# Find the full path of the selected image
selected_path=""
for img in "${images[@]}"; do
    if [ "$(basename "$img")" = "$selected" ]; then
        selected_path="$img"
        break
    fi
done

# Set wallpaper with swww
if [ -n "$selected_path" ]; then
    swww img "$selected_path" --transition-type fade --transition-duration 1
    notify-send "Wallpaper Changed" "Set to: $selected" -i "$selected_path"
fi
