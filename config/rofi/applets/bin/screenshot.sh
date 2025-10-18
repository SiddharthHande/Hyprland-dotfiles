#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Screenshot

# Import Current Theme
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# Theme Elements
prompt='Screenshot'
mesg="DIR: `xdg-user-dir PICTURES`/Screenshots"

if [[ "$theme" == *'type-1'* ]]; then
  list_col='1'
  list_row='5'
  win_width='400px'
elif [[ "$theme" == *'type-3'* ]]; then
  list_col='1'
  list_row='5'
  win_width='120px'
elif [[ "$theme" == *'type-5'* ]]; then
  list_col='1'
  list_row='5'
  win_width='520px'
elif [[ ( "$theme" == *'type-2'* ) || ( "$theme" == *'type-4'* ) ]]; then
  list_col='5'
  list_row='1'
  win_width='670px'
fi

# Options
layout=`cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2`
if [[ "$layout" == 'NO' ]]; then
  option_1=" Capture Desktop"
  option_2=" Capture Area"
  option_3=" Capture Window"
  option_4=" Capture in 5s"
  option_5=" Capture in 10s"
else
  option_1=""
  option_2=""
  option_3=""
  option_4=""
  option_5=""
fi

# Rofi CMD
rofi_cmd() {
  rofi -theme-str "window {width: $win_width;}" \
    -theme-str "listview {columns: $list_col; lines: $list_row;}" \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -dmenu \
    -p "$prompt" \
    -mesg "$mesg" \
    -markup-rows \
    -theme ${theme}
  }

# Pass variables to rofi dmenu
run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Screenshot
time=`date +%Y-%m-%d-%H-%M-%S`
geometry=`xrandr | grep 'current' | head -n1 | cut -d',' -f2 | tr -d '[:blank:],current'`
dir="`xdg-user-dir PICTURES`/Screenshots"
file="Screenshot_${time}_${geometry}.png"

if [[ ! -d "$dir" ]]; then
  mkdir -p "$dir"
fi

notify_view() {
  local file_path="${dir}/${file}"
  local action_id="default"

  (

    action="$(dunstify --action="${action_id},Click to view actions" \
      --timeout=0 \
      -i "$filename" \
      "Screenshot" "Saved & Copied.")"

    action="$(echo "$action" | tr -d '[:space:]')"

    if [[ "$action" == "default" ]]; then
      # Show image in background
      feh --geometry 700x500 "$file_path" &
      local feh_pid=$!

      local options="📂\n🗑️\n✏️\n📋"

      local choice="$(echo -e "$options" | rofi -dmenu -p "Screenshot Action" \
        -theme-str "window {width: 400px;}" \
        -theme "$theme" \
        -theme-str "listview {columns: 4; lines: 1;}")"

        # Kill the preview
        kill $feh_pid 2>/dev/null

        case "$choice" in
          "📂")
            nautilus --select "$file_path" ;;
          "🗑️")
            rm "$file_path" ;;
          "✏️")
            setsid --fork pinta "$file_path" ;;
          "📋")
            wl-copy --type image/png < "$file_path" ;;
        esac
    fi
    ) &

    disown
  }

# Countdown function
countdown () {
  for sec in $(seq "$1" -1 1); do
    dunstify -t 1000 --replace=699 "Taking shot in : $sec"
    sleep 1
  done
}

# Screenshot functions
shotnow () {
  hyprshot --mode output --raw > ~/Pictures/Screenshots/"$file" 
  notify_view
}

shot5 () {
  countdown 5
  sleep 1 && hyprshot --mode output --raw >  ~/Pictures/Screenshots/"$file"
  notify_view
}

shot10 () {
  countdown 10
  sleep 1 && hyprshot --mode output --raw >  ~/Pictures/Screenshots/"$file"
  notify_view
}

shotwin () {
  hyprshot --mode window --raw >  ~/Pictures/Screenshots/"$file"
  notify_view
}

shotarea () {
  hyprshot --mode region --raw >  ~/Pictures/Screenshots/"$file"
  notify_view
}

# Execute Command
run_cmd() {
  case "$1" in
    --opt1) shotnow ;;
    --opt2) shotarea ;;
    --opt3) shotwin ;;
    --opt4) shot5 ;;
    --opt5) shot10 ;;
  esac
}

chosen="$(run_rofi)"
case ${chosen} in
  $option_1) run_cmd --opt1 ;;
  $option_2) run_cmd --opt2 ;;
  $option_3) run_cmd --opt3 ;;
  $option_4) run_cmd --opt4 ;;
  $option_5) run_cmd --opt5 ;;
esac
