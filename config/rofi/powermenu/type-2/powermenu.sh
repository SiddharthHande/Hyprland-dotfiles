#!/usr/bin/env bash
# Hyprland Power Menu (Rofi)
# Modernized by ChatGPT — Based on adi1090x’s original

# Theme & directory
dir="$HOME/.config/rofi/powermenu/type-2"
theme="style-1"

# System info
uptime="$(uptime -p | sed -e 's/up //g')"
host="$(hostname)"

# Icons (you can replace with Nerd Font or Material icons)
shutdown=''
reboot=''
lock=''
suspend=''
logout=''
yes=''
no=''


# Rofi Command Wrapper
rofi_cmd() {
	rofi -dmenu \
		-p "Uptime: $uptime" \
		-mesg "Uptime: $uptime" \
		-theme ${dir}/${theme}.rasi
}

# Confirmation Prompt
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme ${dir}/${theme}.rasi
}
# Confirm Exit
confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

# Run Rofi menu
run_rofi() {
    echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Selected Action
run_cmd() {
    selected="$(confirm_exit)"
    if [[ "$selected" == "$yes" ]]; then
        case "$1" in
            --shutdown) systemctl poweroff ;;
            --reboot) systemctl reboot ;;
            --suspend)
                playerctl pause
                amixer set Master mute
                systemctl suspend
                ;;
            --logout)
                hyprctl dispatch exit
                ;;
        esac
    else
        exit 0
    fi
}

# Main
chosen="$(run_rofi)"
case ${chosen} in
    "$shutdown") run_cmd --shutdown ;;
    "$reboot")   run_cmd --reboot ;;
    "$lock")
        if command -v hyprlock &>/dev/null; then
            hyprlock || notify-send "Hyprlock failed" "Check ~/.config/hypr/hyprlock.conf"
        elif command -v swaylock &>/dev/null; then
            swaylock
        else
            notify-send "No lockscreen found" "Install hyprlock or swaylock"
        fi
        ;;
    "$suspend") run_cmd --suspend ;;
    "$logout")  run_cmd --logout ;;
esac
