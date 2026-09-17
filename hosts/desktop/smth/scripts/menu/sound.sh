SELECTIONS="Mute/Unmute\n+5\n-5\nPavucontrol\nHelvum\nEasyEffects\nExit"

while true; do
    CHOSEN=$(echo -e "$SELECTIONS" | fuzzel --dmenu --index --config /home/d7tun6/files/system/hosts/desktop/smth/scripts/menu/sound.ini)

    if [ -z "$CHOSEN" ]; then
        exit 0
    fi

    case $CHOSEN in
        0) # Toggle Mute/Unmute
            pamixer -t & exit ;;
        1) # + 5
            pamixer -i 5 ;;
        2) # - 5
            pamixer -d 5 ;; 
        3) # Pavucontrol
            pavucontrol & exit ;;
        4) # Helvum
            helvum & exit ;;
        5) # EasyEffects
            easyeffects & exit ;;
        6) # Exit
            exit 0 ;;
    esac
done
