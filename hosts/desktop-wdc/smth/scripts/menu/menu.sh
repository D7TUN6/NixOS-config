
SELECTIONS="Run Fuzzel\nRun Fastfetch\nEdit Config\nSleep\nRestart\nShut Down\nLock Screen\nLog Out\nExit"

CHOSEN=$(echo -e "$SELECTIONS" | fuzzel --dmenu --index --config /home/d7tun6/files/system/hosts/desktop/smth/scripts/menu/menu.ini)

case $CHOSEN in
    0) # App Launcher
        fuzzel ;;
    1) # About
        foot sh -c "fastfetch; read" ;;
    2) # Settings
        foot sh -c "/home/d7tun6/files/system/hosts/desktop/smth/scripts/config-editor/conf-editor.sh" ;;
    3) # Sleep
        systemctl suspend ;;
    4) # Restart
        systemctl reboot ;;
    5) # Shut Down
        systemctl poweroff ;;
    6) # Lock
        swaylock ;;
    7) # Log Out
        niri msg action quit ;;
    8) # Exit
        exit 0 ;;
esac
