#!/usr/bin/env bash

i3status -c $HOME/.config/i3blocks/i3status.conf | while IFS= read -r line; do
    PARTS=($line)

    CHARGE="${PARTS[1]}"
    CHARGE="${CHARGE%\%*}"

    STATE=""
    [[ "${PARTS[0]}" = "BAT" ]] && {
        STATE="${PARTS[2]}"
        [[ -z "${STATE}" ]] && STATE="??:??:00"

        STATE="${STATE:0:-3}"
        STATE=" (${STATE})"
    }

    LEVEL=$(( (CHARGE - 1) / 20 ))
    ICON="f$(( 244 - LEVEL ))"

    echo -e "  \u${ICON}  ${CHARGE}${STATE} "

    [[ "${LEVEL}" = "0" ]] && {
        [[ -z "${STATE}" ]] || i3-msg "fullscreen disable"
    }
done
