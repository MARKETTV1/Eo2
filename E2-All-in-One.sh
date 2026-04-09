#!/bin/sh

# ============================================================
#           ENIGMA2 MANAGER - MARKETTV1 (NO COLORS)
# ============================================================

# ----- No Colors -----
RED=''
GREEN=''
YELLOW=''
BLUE=''
CYAN=''
NC=''

# ============================================================
# Function to install package via wget
# ============================================================
install_package() {
    local name="$1"
    local url="$2"
    echo ""
    echo ">>> Installing ${name}..."
    opkg update > /dev/null 2>&1
    opkg install wget > /dev/null 2>&1
    wget --no-check-certificate "${url}" -O - | /bin/sh
    echo ">>> ${name} installed successfully!"
}

# ============================================================
# Function to install package via opkg directly
# ============================================================
install_opkg() {
    local name="$1"
    local pkg="$2"
    echo ""
    echo ">>> Installing ${name}..."
    opkg update > /dev/null 2>&1
    opkg install "$pkg"
    echo ">>> ${name} installed successfully!"
}

# ============================================================
# Function to confirm installation
# ============================================================
confirm_installation() {
    local items="$1"
    local count="$2"
    echo ""
    echo "========================================"
    echo "         Installation Summary"
    echo "========================================"
    echo ""
    echo "Items to be installed:"
    echo -e "$items"
    echo ""
    echo "Total: $count item(s)"
    echo ""
    printf "Proceed with installation? (y/n): "
    read confirm
    case $confirm in
        y|Y|yes|YES) return 0 ;;
        *)
            echo ">>> Cancelled."
            sleep 1
            return 1
            ;;
    esac
}

# ============================================================
# Function to parse multiple choices
# ============================================================
parse_choices() {
    echo "$1" | tr ',' ' '
}

# ============================================================
#                 PLUGINS & PANELS
# ============================================================
menu_plugins_panels() {
    while true; do
        clear
        echo "============================"
        echo "     PLUGINS & PANELS"
        echo "============================"
        echo ""
        echo "  1) AjPanel"
        echo "  2) Linuxsat Panel"
        echo "  3) EmilNabilPro"
        echo "  4) SimplySports"
        echo ""
        echo "  Example: 1 or 1,2 or 1,2,3,4"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "Choose: "
        read choice

        [ "$choice" = "0" ] && { menu_main; return; }

        items="" ; count=0
        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) items="${items}  - AjPanel\n" ; count=$((count+1)) ;;
                2) items="${items}  - Linuxsat Panel\n" ; count=$((count+1)) ;;
                3) items="${items}  - EmilNabilPro\n" ; count=$((count+1)) ;;
                4) items="${items}  - SimplySports\n" ; count=$((count+1)) ;;
                *) echo "Invalid option: $ch" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "No valid items selected!" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count" || continue

        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) install_package "AjPanel" "https://raw.githubusercontent.com/biko-73/AjPanel/main/installer.sh" ;;
                2) install_package "Linuxsat Panel" "https://raw.githubusercontent.com/Belfagor2005/LinuxsatPanel/main/installer.sh" ;;
                3) install_package "EmilNabilPro" "https://raw.githubusercontent.com/emilnabil/download-plugins/refs/heads/main/EmilPanelPro/emilpanelpro.sh" ;;
                4)
                    echo ""
                    echo ">>> Installing SimplySports..."
                    opkg update > /dev/null 2>&1
                    opkg install wget unzip > /dev/null 2>&1
                    cd /usr/lib/enigma2/python/Plugins/Extensions && rm -rf SimplySports
                    wget --no-check-certificate https://github.com/Ahmed-Mohammed-Abbas/SimplySports/archive/refs/heads/main.zip -O SimplySports.zip
                    unzip SimplySports.zip
                    mv SimplySports-main SimplySports
                    rm SimplySports.zip
                    echo ">>> SimplySports installed successfully!"
                    echo ""
                    echo ">>> Please restart Enigma2 manually from TOOLS menu to apply changes."
                    ;;
            esac
        done
        printf "\nOperation complete! Press Enter..."
        read dummy
    done
}

# ============================================================
#                     ALL IMAGES
# ============================================================
menu_all_images() {
    while true; do
        clear
        echo "============================"
        echo "         ALL IMAGES"
        echo "============================"
        echo ""
        echo "  1) Fury"
        echo ""
        echo "  Example: 1 or 1,2"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "Choose: "
        read choice

        [ "$choice" = "0" ] && { menu_skins; return; }

        items="" ; count=0
        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) items="${items}  - Fury\n" ; count=$((count+1)) ;;
                *) echo "Invalid option: $ch" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "No valid items selected!" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count" || continue

        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) install_package "Fury" "https://raw.githubusercontent.com/islam-2412/IPKS/refs/heads/main/fury/installer.sh" ;;
            esac
        done
        printf "\nInstallation complete! Press Enter..."
        read dummy
    done
}

# ============================================================
#                   OPENATV SKINS
# ============================================================
menu_openatv_skins() {
    while true; do
        clear
        echo "============================"
        echo "       OPENATV SKINS"
        echo "============================"
        echo ""
        echo "  1) MATRIX SKIN"
        echo ""
        echo "  Example: 1 or 1,2"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "Choose: "
        read choice

        [ "$choice" = "0" ] && { menu_skins; return; }

        items="" ; count=0
        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) items="${items}  - MATRIX SKIN\n" ; count=$((count+1)) ;;
                *) echo "Invalid option: $ch" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "No valid items selected!" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count" || continue

        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) install_package "MATRIX SKIN" "https://raw.githubusercontent.com/islam-2412/SKINS/main/Matrix/installer.sh" ;;
            esac
        done
        printf "\nInstallation complete! Press Enter..."
        read dummy
    done
}

# ============================================================
#                     EGAMI SKINS
# ============================================================
menu_egami_skins() {
    while true; do
        clear
        echo "============================"
        echo "        EGAMI SKINS"
        echo "============================"
        echo ""
        echo "  1) Coming soon..."
        echo ""
        echo "  0) BACK"
        echo ""
        printf "Choose: "
        read choice
        case $choice in
            0) menu_skins; return ;;
            *) echo ">>> Coming soon..." ; sleep 1 ;;
        esac
    done
}

# ============================================================
#                     OPENBH SKINS
# ============================================================
menu_openbh_skins() {
    while true; do
        clear
        echo "============================"
        echo "        OPENBH SKINS"
        echo "============================"
        echo ""
        echo "  1) Coming soon..."
        echo ""
        echo "  0) BACK"
        echo ""
        printf "Choose: "
        read choice
        case $choice in
            0) menu_skins; return ;;
            *) echo ">>> Coming soon..." ; sleep 1 ;;
        esac
    done
}

# ============================================================
#                       SKINS
# ============================================================
menu_skins() {
    while true; do
        clear
        echo "============================"
        echo "           SKINS"
        echo "============================"
        echo ""
        echo "  1) OPENATV SKINS"
        echo "  2) ALL IMAGES"
        echo "  3) EGAMI SKINS"
        echo "  4) OPENBH SKINS"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "Choose: "
        read choice
        case $choice in
            1) menu_openatv_skins ;;
            2) menu_all_images ;;
            3) menu_egami_skins ;;
            4) menu_openbh_skins ;;
            0) menu_main; return ;;
            *) echo "Invalid option!" ; sleep 1 ;;
        esac
    done
}

# ============================================================
#                       MEDIAS
# ============================================================
menu_medias() {
    while true; do
        clear
        echo "============================"
        echo "          MEDIAS"
        echo "============================"
        echo ""
        echo "  1) estalky"
        echo "  2) xclass"
        echo "  3) xtreamity"
        echo "  4) jedi maker xtream"
        echo "  5) BouquetMakerXtream"
        echo ""
        echo "  Example: 1 or 1,3 or 1,2,3"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "Choose: "
        read choice

        [ "$choice" = "0" ] && { menu_main; return; }

        items="" ; count=0
        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) items="${items}  - estalky\n"            ; count=$((count+1)) ;;
                2) items="${items}  - xclass\n"             ; count=$((count+1)) ;;
                3) items="${items}  - xtreamity\n"          ; count=$((count+1)) ;;
                4) items="${items}  - jedi maker xtream\n"  ; count=$((count+1)) ;;
                5) items="${items}  - BouquetMakerXtream\n" ; count=$((count+1)) ;;
                *) echo "Invalid option: $ch" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "No valid items selected!" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count" || continue

        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) install_package "estalky"            "https://raw.githubusercontent.com/biko-73/estalky/main/installer.sh" ;;
                2) install_package "xclass"             "https://raw.githubusercontent.com/biko-73/xklass/main/installer.sh" ;;
                3) install_package "xtreamity"          "https://raw.githubusercontent.com/biko-73/xstreamity/main/installer.sh" ;;
                4) install_package "jedi maker xtream"  "https://raw.githubusercontent.com/jediepg/jedimakerxtream/main/installer.sh" ;;
                5) install_package "BouquetMakerXtream" "https://raw.githubusercontent.com/biko-73/BouquetMakerXtream/main/installer.sh" ;;
            esac
        done
        printf "\nInstallation complete! Press Enter..."
        read dummy
    done
}

# ============================================================
#                      SOFTCAM
# ============================================================
menu_softcam() {
    while true; do
        clear
        echo "============================"
        echo "         SOFTCAM"
        echo "============================"
        echo ""
        echo "  1) OSCam (MARKETTV1)"
        echo "  2) NCam"
        echo "  3) CCcam"
        echo "  4) OSCamicam_Kitte888"
        echo ""
        echo "  Example: 1 or 1,2 or 1,2,3"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "Choose: "
        read choice

        [ "$choice" = "0" ] && { menu_main; return; }

        items="" ; count=0
        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) items="${items}  - OSCam (MARKETTV1)\n"      ; count=$((count+1)) ;;
                2) items="${items}  - NCam\n"                   ; count=$((count+1)) ;;
                3) items="${items}  - CCcam\n"                  ; count=$((count+1)) ;;
                4) items="${items}  - OSCamicam_Kitte888\n"     ; count=$((count+1)) ;;
                *) echo "Invalid option: $ch" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "No valid items selected!" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count" || continue

        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) install_package "OSCam (MARKETTV1)"   "https://raw.githubusercontent.com/MARKETTV1/softcams/refs/heads/main/oscam.sh" ;;
                2) install_package "NCam"                "https://raw.githubusercontent.com/biko-73/Ncam_EMU/main/installer.sh" ;;
                3) install_opkg    "CCcam"               "enigma2-plugin-softcams-cccam" ;;
                4) install_package "OSCamicam_Kitte888"  "https://raw.githubusercontent.com/biko-73/OSCamicam_Kitte888/main/installer.sh" ;;
            esac
        done
        printf "\nInstallation complete! Press Enter..."
        read dummy
    done
}

# ============================================================
#                        TOOLS
# ============================================================
menu_tools() {
    while true; do
        clear
        echo "============================"
        echo "           TOOLS"
        echo "============================"
        echo ""
        echo "  1) System Update (opkg update/upgrade)"
        echo "  2) Restart Enigma2"
        echo "  3) Install wget & curl"
        echo "  4) Add OpenATV Feed emu oscam"
        echo ""
        echo "  Example: 1 or 1,2 or 1,2,3,4"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "Choose: "
        read choice

        [ "$choice" = "0" ] && { menu_main; return; }

        items="" ; count=0
        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) items="${items}  - System Update (opkg update/upgrade)\n" ; count=$((count+1)) ;;
                2) items="${items}  - Restart Enigma2\n"                      ; count=$((count+1)) ;;
                3) items="${items}  - Install wget & curl\n"                  ; count=$((count+1)) ;;
                4) items="${items}  - Add OpenATV Feed emu oscam\n"           ; count=$((count+1)) ;;
                *) echo "Invalid option: $ch" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "No valid items selected!" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count" || continue

        for ch in $(parse_choices "$choice"); do
            case $ch in
                1)
                    echo ""
                    echo ">>> Stopping Enigma2 (init 4)..."
                    init 4
                    sleep 2
                    echo ">>> Updating package lists (opkg update)..."
                    opkg update
                    echo ">>> Upgrading packages (opkg upgrade)..."
                    opkg upgrade
                    echo ">>> Restarting Enigma2 (init 3)..."
                    init 3
                    echo ">>> System update completed!"
                    ;;
                2)
                    echo ""
                    echo ">>> Restarting Enigma2..."
                    init 4 && sleep 2 && init 3
                    echo ">>> Enigma2 restarted!"
                    ;;
                3)
                    echo ""
                    echo ">>> Installing wget..."
                    opkg update
                    opkg install wget
                    echo ">>> wget installed successfully!"
                    echo ""
                    echo ">>> Installing curl..."
                    opkg install curl
                    echo ">>> curl installed successfully!"
                    ;;
                4)
                    echo ""
                    echo ">>> Adding OpenATV Feed emu oscam..."
                    wget -O - -q http://updates.mynonpublic.com/oea/feed | bash
                    echo ">>> OpenATV Feed emu oscam added successfully!"
                    ;;
            esac
        done
        printf "\nOperation complete! Press Enter..."
        read dummy
    done
}

# ============================================================
#                   MAIN MENU
# ============================================================
menu_main() {
    while true; do
        clear
        echo "============================"
        echo "      Enigma2 Manager"
        echo "       by MARKETTV1"
        echo "============================"
        echo ""
        echo "  1) PLUGINS & PANELS"
        echo "  2) SKINS"
        echo "  3) MEDIAS"
        echo "  4) SOFTCAM"
        echo "  5) TOOLS"
        echo ""
        echo "  0) EXIT"
        echo ""
        printf "Choose: "
        read choice
        case $choice in
            1) menu_plugins_panels ;;
            2) menu_skins ;;
            3) menu_medias ;;
            4) menu_softcam ;;
            5) menu_tools ;;
            0)
                clear
                echo "Goodbye! 👋"
                echo ""
                exit 0
                ;;
            *) echo "Invalid option!" ; sleep 1 ;;
        esac
    done
}

# ============================================================
#                      RUN SCRIPT
# ============================================================
menu_main
