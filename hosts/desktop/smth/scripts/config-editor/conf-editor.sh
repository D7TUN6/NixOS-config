#!/usr/bin/env bash

export NCURSES_NO_UTF8_ACS=1

BASE_DIR="/home/d7tun6/files/system/hosts/desktop"
FLAKE_DIR="/home/d7tun6/files/system"
EDITOR="hx"

if ! command -v dialog &> /dev/null; then
    echo "install dialog pls"
    exit 1
fi

edit_subdir() {
    local subdir=$1
    local title=$2
    local recursive=$3
    local target_path="$BASE_DIR/$subdir"

    if [ ! -d "$target_path" ]; then
        dialog --title " error " --msgbox "directory not found:\n$target_path" 0 0
        return
    fi

    while true; do
        local options=()
        if [ "$recursive" == "true" ]; then
            while read -r line; do
                options+=("$line" "")
            done < <(find "$target_path" -type f -not -path '*/.*' | sed "s|$target_path/||" | sort)
        else
            local files=($(find "$target_path" -maxdepth 1 \( -name "*.nix" -o -name "*.nix.disabled" \) -exec basename {} \; 2>/dev/null | sort))
            for f in "${files[@]}"; do
                local status="[edit]"
                [[ "$f" == *.disabled ]] && status="[disabled]"
                options+=("$f" "$status")
            done
        fi
        
        options+=("+ NEW FILE" "create new module")

        exec 3>&1
        file_choice=$(dialog --clear \
            --title " $title " \
            --extra-button --extra-label "disable/enable" \
            --help-button --help-label "delete" \
            --ok-label "edit" \
            --cancel-label "back" \
            --menu "select module (tab to switch buttons):" 0 0 0 \
            "${options[@]}" 2>&1 1>&3)
        exit_code=$?
        exec 3>&-

        if [ $exit_code -eq 1 ] || [ $exit_code -eq 255 ]; then
            break
        fi

        clean_choice="${file_choice#HELP }"

        case $exit_code in
            3) # disable/enable
                if [[ -n "$clean_choice" && "$clean_choice" != "+ NEW FILE" ]]; then
                    local current_path="$target_path/$clean_choice"
                    if [[ "$clean_choice" == *.disabled ]]; then
                        mv "$current_path" "${current_path%.disabled}"
                    else
                        mv "$current_path" "${current_path}.disabled"
                    fi
                fi
                ;;
            2) # delete
                if [[ -n "$clean_choice" && "$clean_choice" != "+ NEW FILE" ]]; then
                    # Теперь здесь точно не будет слова HELP в тексте
                    dialog --title " confirm delete " \
                        --yesno "are you sure you want to delete module:\n\n$clean_choice?" 0 0
                    if [ $? -eq 0 ]; then
                        rm "$target_path/$clean_choice"
                    fi
                fi
                ;;
            0) # edit
                if [ "$clean_choice" == "+ NEW FILE" ]; then
                    local new_filename
                    new_filename=$(dialog --title "create" --inputbox "enter filename:" 0 0 --stdout)
                    if [ -n "$new_filename" ]; then
                        local full_path="$target_path/$new_filename"
                        mkdir -p "$(dirname "$full_path")"
                        if [[ "$new_filename" == *.nix ]]; then
                            echo -e "{\n  config,\n  pkgs,\n  lib,\n  inputs,\n  outputs,\n  ...\n}: {\n\n}" > "$full_path"
                        else
                            touch "$full_path"
                        fi
                        $EDITOR "$full_path"
                    fi
                elif [ -n "$clean_choice" ]; then
                    $EDITOR "$target_path/$clean_choice"
                fi
                ;;
        esac
    done
}

while true; do
    main_choice=$(dialog --clear \
        --backtitle "nixos config editor" \
        --title " nixos config editor " \
        --cancel-label "exit" \
        --menu "main menu:" 0 0 0 \
        "1" "system modules" \
        "2" "home-manager modules" \
        "3" "containers" \
        "4" "smth" \
        "5" "entrypoints" \
        "A" "alejandra format" \
        "R" "rebuild switch" \
        "H" "rebuild home-manager" \
        "U" "update flake.lock" \
        "G" "garbage collect" \
        "O" "optimize nix-store" \
        "V" "verify nix-store" --stdout)

    if [ $? -ne 0 ] || [ -z "$main_choice" ]; then
        clear; break
    fi

    case $main_choice in
        1) edit_subdir "modules/system" "system" "false" ;;
        2) edit_subdir "modules/home-manager" "home-manager" "false" ;;
        3) edit_subdir "modules/containers" "containers" "false" ;;
        4) edit_subdir "smth" "smth" "true" ;;
        5) 
            sub_main=$(dialog --clear --title "root configs" \
                --menu "files:" 0 0 0 \
                "flake.nix" "flake" \
                "home.nix" "home-manager" \
                "configuration.nix" "nixos" --stdout)
            [[ -z "$sub_main" ]] && continue
            [[ "$sub_main" == "flake.nix" ]] && $EDITOR "$FLAKE_DIR/flake.nix" || $EDITOR "$BASE_DIR/$sub_main"
            ;;
        A)
            clear
            echo "running alejandra format on $FLAKE_DIR..."
            alejandra "$FLAKE_DIR"
            read -p "done. press enter..."
            ;;
        R)
            clear; cd "$FLAKE_DIR" || exit
            run0 nixos-rebuild switch --flake ".#desktop"
            read -p "press enter to return..."
            ;;
        H)
            clear; cd "$FLAKE_DIR" || exit
            home-manager switch --flake "$FLAKE_DIR#d7tun6"
            read -p "press enter to return..."
            ;;
        U)
            clear; cd "$FLAKE_DIR" || exit
            run0 nix flake update
            read -p "press enter to return..."
            ;;
        G)
            clear; sudo nix-collect-garbage -d
            read -p "done. press enter..."
            ;;
        O)
            clear
            run0 nix-store --optimize
            read -p "done. press enter..."
            ;;
        V)
            clear
            run0 nix-store --verify --check-contents --repair
            read -p "done. press enter..."
            ;;
    esac
done
