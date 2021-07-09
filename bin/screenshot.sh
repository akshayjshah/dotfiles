#!/bin/bash
set -euo pipefail
set -x

TARGET="$(xdg-user-dir PICTURES)"/screenshots
NOTIFY=$(pidof mako || pidof dunst) || true
FOCUSED=$(swaymsg -t get_tree | jq '.. | ((.nodes? + .floating_nodes?) // empty) | .[] | select(.focused and .pid) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
OUTPUTS=$(swaymsg -t get_outputs | jq -r '.[] | select(.active) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
WINDOWS=$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')

notify() {
  # notify-send hangs if the daemon isn't running
  if [ "$NOTIFY" ]; then
    notify-send "$@"
  else
    echo NOTICE: notification daemon not active
    echo "$@"
  fi
}

read -r -d '' CHOICES <<EOF || true
region
focused
screen
select-window
select-output
EOF

CHOICE=$(echo "$CHOICES" | dmenu -i -p "What should we screenshot?")

mkdir -p "$TARGET"
FILENAME="$TARGET/$(date +'%Y-%m-%dT%H:%M:%S-screenshot.png')"

case "$CHOICE" in
"screen")
  grim "$FILENAME"
  ;;
"focused")
  grim -g "$(eval echo "$FOCUSED")" "$FILENAME"
  ;;
"select-window")
  echo "$WINDOWS" | slurp | grim -g - "$FILENAME"
  ;;
"select-output")
  echo "$OUTPUTS" | slurp | grim -g - "$FILENAME"
  ;;
"region")
  slurp | grim -g - "$FILENAME"
  ;;
*)
  grim -g "$(eval echo "$CHOICE")" "$FILENAME"
  ;;
esac

notify "Screenshot saved and copied to clipboard" -t 6000 -i "$FILENAME"
wl-copy <"$FILENAME"
feh "$FILENAME"
