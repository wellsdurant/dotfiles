# Display an Apple icon on the active space
SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

for i in $(seq 1 10); do
    sid=$(($i))
    sketchybar -m                                              \
               --add item apple.logo.$sid left                 \
               --set apple.logo.$sid icon=$APPLE_ICN           \
                                  icon.font="$FONT:Heavy:16.0" \
                                  label.drawing=off            \
                                  icon.padding_left=6          \
                                  icon.padding_right=12        \
                                  associated_space=$sid        \
                                  display="active"
done
