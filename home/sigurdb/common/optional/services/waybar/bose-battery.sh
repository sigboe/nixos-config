#!/usr/bin/env dash

if ! command -v bose-connect-app-linux > /dev/null 2> /dev/null; then exit; fi
MAC="$(bluetoothctl devices |grep -m 1 Bose|awk '{print $2}')"
if ! bluetoothctl info "${MAC}" | grep -q "Connected: yes"; then exit; fi

percent="$(bose-connect-app-linux -b "${MAC}")"

case $percent in
  [0-2][0-9]) color="#dc322f" ;;
  [7-9][0-9]|100) color="#859900" ;;
esac

echo "<span color='#268bd2'>󰋎</span> <span color=\"${color}\">${percent}%</span>"
