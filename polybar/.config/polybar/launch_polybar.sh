if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload i3 2>/tmp/polybar.log&
  done
else
  polybar --reload i3 &
fi
