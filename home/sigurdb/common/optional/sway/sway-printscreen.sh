#!/usr/bin/env bash
arg="${1}"
dir="${HOME}/Pictures"
[[ -d "${dir}" ]] || mkdir -p "${dir}"
file="$(date +'%Y%m%d_%H%M%S')_Screenshot.png"
windowName="$(swaymsg -t get_tree | jq -r '.. | select(.focused?) | .app_id')"
IMG="${dir}/${file}"

case "${arg}" in
  screen|Screen|screens|Screens)
    grim "${IMG}"
    ;;
  selection|Selection)
    IMG="${IMG//Screenshot/Selection}"
    grim -g "$(slurp)" "${IMG}"
    [[ "${?}" -ge "1" ]] && exit 1
    ;;
  window|Window)
    IMG="${IMG//Screenshot/$windowName}"
    grim -g "$(swaymsg -t get_tree | jq -r '.. | select(.focused?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')" "${IMG}"
    ;;
  *)
    notify-send --app-name="ERROR" "Pass screen, selection or window as the argument to this script"
    exit 1
esac

wl-copy < "${IMG}"
notify-send -i "${IMG}" \
  --app-name="Screenshot copied to clipboard" \
  "And saved to ${IMG}"
