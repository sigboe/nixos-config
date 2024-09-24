#!/usr/bin/env bash

shopt -s nullglob globstar

typeit=0
if [[ $1 == "--type" ]]; then
	typeit=1
	shift
fi

focusedwindow="$(xdotool getwindowfocus -f)"
[[ -d "${HOME}/.work-password-store" ]] && prefix=${PASSWORD_STORE_DIR-~/.work-password-store}
[[ -d "${HOME}/.local/share/work-password-store" ]] && prefix=${PASSWORD_STORE_DIR-~/.local/share/work-password-store}
[[ -n "${prefix}" ]] || { echo "workpass not found" ; exit 1 ; } 
password_files=( "$prefix"/**/*.gpg )
password_files=( "${password_files[@]#"$prefix"/}" )
password_files=( "${password_files[@]%.gpg}" )

password=$(printf '%s\n' "${password_files[@]}" | dmenu -i "$@")

[[ -n $password ]] || exit

if [[ $typeit -eq 0 ]]; then
	PASSWORD_STORE_DIR="${prefix}" pass show -c "$password" 2>/dev/null
else
	xdotool mousemove --sync --window "$focusedwindow" 50 50
	PASSWORD_STORE_DIR="${prefix}" pass show "$password" 2>/dev/null | { IFS= read -r pass; printf %s "$pass"; } | xdotool type --clearmodifiers --delay 30 --file -
fi
