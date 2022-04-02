#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar --reload background &
polybar left &
echo "---" | tee -a /tmp/polybar1.log
polybar datetime &
polybar netstuff &
polybar volume &
polybar battnet &
polybar netspeed &

echo "Polybar launched..."
