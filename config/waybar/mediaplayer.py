#!/usr/bin/env python3
import json
import subprocess

def run(cmd):
    try:
        return subprocess.check_output(cmd, stderr=subprocess.DEVNULL).decode().strip()
    except subprocess.CalledProcessError:
        return ""

def get_icon(player_name, status):
    player_icons = {
        "spotify": "",
        "youtube": "󰗃",
        "firefox": "󰈹",
        "chromium": "󰊯",
        "vlc": "󰕼",
        "mpd": "󰝚",
    }
    state_icons = {
        "Playing": "󰐊",
        "Paused": "󰏤",
        "Stopped": "󰓛"
    }
    player_icon = next(
        (icon for name, icon in player_icons.items() if name in player_name.lower()),
        "󰎈"
    )
    state_icon = state_icons.get(status, "")
    return f"{player_icon} {state_icon}"

def main():
    status = run(["playerctl", "status"]) or "Stopped"

    if status == "Stopped":
        print(json.dumps({"text": ""}, ensure_ascii=False))
        return

    artist = run(["playerctl", "metadata", "artist"])
    title = run(["playerctl", "metadata", "title"])
    player_name = run(["playerctl", "metadata", "player-name"])

    text = f"{artist} - {title}" if artist and title else title or "No media"

    output = {
        "text": f"{get_icon(player_name, status)} {text}",
        "tooltip": f"{player_name}\n{artist} - {title}\n\nClick: Play/Pause\nScroll: Next/Previous",
        "class": player_name.lower(),
        "alt": status
    }

    # ✅ Only print JSON, no extra whitespace
    print(json.dumps(output, ensure_ascii=False))

if __name__ == "__main__":
    main()
