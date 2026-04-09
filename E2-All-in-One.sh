#!/bin/sh

# ============================================================
#           ENIGMA2 MANAGER - Karim
# ============================================================

# ----- Colors -----
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================================
# Function to read input (FIXED)
# ============================================================
get_input() {
    read choice < /dev/tty
    echo "$choice"
}

# ============================================================
# Function to install package via wget
# ============================================================
install_package() {
    local name="$1"
    local url="$2"
    echo ""
    echo "${GREEN}>>> Installing ${name}...${NC}"
    opkg update > /dev/null 2>&1
    opkg install wget > /dev/null 2>&1
    wget --no-check-certificate "${url}" -O - | /bin/sh
    echo "${GREEN}>>> ${name} installed successfully!${NC}"
}

# ============================================================
# Function to install package via opkg directly
# ============================================================
install_opkg() {
    local name="$1"
    local pkg="$2"
    echo ""
    echo "${GREEN}>>> Installing ${name}...${NC}"
    opkg update > /dev/null 2>&1
    opkg install "$pkg"
    echo "${GREEN}>>> ${name} installed successfully!${NC}"
}

# ============================================================
# Function to install .ipk file
# ============================================================
install_ipk() {
    local name="$1"
    local url="$2"
    echo ""
    echo "${GREEN}>>> Installing ${name}...${NC}"
    opkg update > /dev/null 2>&1
    opkg install wget > /dev/null 2>&1
    IPK_FILE="/tmp/${name}.ipk"
    wget --no-check-certificate -q "$url" -O "$IPK_FILE"
    if [ -f "$IPK_FILE" ]; then
        opkg install "$IPK_FILE"
        rm -f "$IPK_FILE"
        echo "${GREEN}>>> ${name} installed successfully!${NC}"
    else
        echo "${RED}>>> Failed to download ${name} package!${NC}"
    fi
}

# ============================================================
# Function to confirm installation (NO PROMPT - direct install)
# ============================================================
confirm_installation() {
    local items="$1"
    local count="$2"
    echo ""
    echo "${YELLOW}========================================${NC}"
    echo "${YELLOW}         Installation Summary           ${NC}"
    echo "${YELLOW}========================================${NC}"
    echo ""
    echo "${CYAN}Items to be installed:${NC}"
    echo -e "$items"
    echo ""
    echo "${YELLOW}Total: $count item(s)${NC}"
    echo ""
    echo "${GREEN}>>> Starting installation...${NC}"
    sleep 1
    return 0
}

# ============================================================
# Function to parse multiple choices (supports , - and spaces)
# ============================================================
parse_choices() {
    local input="$1"
    local result=""
    
    # First replace commas with spaces
    input=$(echo "$input" | tr ',' ' ' | tr -s ' ')
    
    # Process each part
    for part in $input; do
        if echo "$part" | grep -q '-'; then
            # Handle range like 1-4
            start=$(echo "$part" | cut -d'-' -f1)
            end=$(echo "$part" | cut -d'-' -f2)
            for i in $(seq $start $end); do
                result="$result $i"
            done
        else
            # Handle single number
            result="$result $part"
        fi
    done
    
    echo "$result"
}

# ============================================================
#                 PLUGINS & PANELS
# ============================================================
menu_plugins_panels() {
    while true; do
        clear
        echo "${CYAN}============================${NC}"
        echo "${CYAN}     PLUGINS & PANELS       ${NC}"
        echo "${CYAN}============================${NC}"
        echo ""
        echo "  1) AjPanel"
        echo "  2) Linuxsat Panel"
        echo "  3) EmilNabilPro"
        echo "  4) SimplySports"
        echo "  5) FuryBiss"
        echo "  6) RaedQuickSignal"
        echo "  7) ArabicPlayer"
        echo "  8) E2BissKeyEditor"
        echo "  9) Satelliweb"
        echo " 10) FootOnsat"
        echo ""
        echo "  Example: 1 or 1,2 or 1-10 or 1 3 5"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "${YELLOW}Choose: ${NC}"
        choice=$(get_input)

        [ "$choice" = "0" ] && { menu_main; return; }

        items="" ; count=0
        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) items="${items}  - AjPanel\n" ; count=$((count+1)) ;;
                2) items="${items}  - Linuxsat Panel\n" ; count=$((count+1)) ;;
                3) items="${items}  - EmilNabilPro\n" ; count=$((count+1)) ;;
                4) items="${items}  - SimplySports\n" ; count=$((count+1)) ;;
                5) items="${items}  - FuryBiss\n" ; count=$((count+1)) ;;
                6) items="${items}  - RaedQuickSignal\n" ; count=$((count+1)) ;;
                7) items="${items}  - ArabicPlayer\n" ; count=$((count+1)) ;;
                8) items="${items}  - E2BissKeyEditor\n" ; count=$((count+1)) ;;
                9) items="${items}  - Satelliweb\n" ; count=$((count+1)) ;;
               10) items="${items}  - FootOnsat\n" ; count=$((count+1)) ;;
                *) echo "${RED}Invalid option: $ch${NC}" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "${RED}No valid items selected!${NC}" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count"

        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) install_package "AjPanel" "https://raw.githubusercontent.com/biko-73/AjPanel/main/installer.sh" ;;
                2) install_package "Linuxsat Panel" "https://raw.githubusercontent.com/Belfagor2005/LinuxsatPanel/main/installer.sh" ;;
                3) install_package "EmilNabilPro" "https://raw.githubusercontent.com/emilnabil/download-plugins/refs/heads/main/EmilPanelPro/emilpanelpro.sh" ;;
                4)
                    echo ""
                    echo "${GREEN}>>> Installing SimplySports...${NC}"
                    opkg update > /dev/null 2>&1
                    opkg install wget unzip > /dev/null 2>&1
                    cd /usr/lib/enigma2/python/Plugins/Extensions && rm -rf SimplySports
                    wget --no-check-certificate https://github.com/Ahmed-Mohammed-Abbas/SimplySports/archive/refs/heads/main.zip -O SimplySports.zip
                    unzip SimplySports.zip
                    mv SimplySports-main SimplySports
                    rm SimplySports.zip
                    echo "${GREEN}>>> SimplySports installed successfully!${NC}"
                    echo ""
                    echo "${YELLOW}>>> Please restart Enigma2 manually from TOOLS menu to apply changes.${NC}"
                    ;;
                5) install_package "FuryBiss" "https://raw.githubusercontent.com/islam-2412/FuryBiss/main/fury/installer.sh" ;;
                6) install_package "RaedQuickSignal" "https://raw.githubusercontent.com/fairbird/RaedQuickSignal/main/installer_Version8.8.sh" ;;
                7) install_package "ArabicPlayer" "https://raw.githubusercontent.com/asdrere123-alt/ArabicPlayer/main/installer.sh?v=FINAL" ;;
                8) install_package "E2BissKeyEditor" "https://raw.githubusercontent.com/ismail9875/E2BissKeyEditor/refs/heads/main/installer.sh" ;;
                9) install_package "Satelliweb" "http://dreambox4u.com/dreamarabia/Satelliweb_e2/install_satelliweb.sh" ;;
               10) install_package "FootOnsat" "https://raw.githubusercontent.com/fairbird/FootOnsat/main/Download/install.sh" ;;
            esac
        done
        echo "\n${GREEN}Installation complete!!!${NC}"
        sleep 2
    done
}

# ============================================================
#                     ALL IMAGES
# ============================================================
menu_all_images() {
    while true; do
        clear
        echo "${CYAN}============================${NC}"
        echo "${CYAN}         ALL IMAGES         ${NC}"
        echo "${CYAN}============================${NC}"
        echo ""
        echo "  1) Fury"
        echo ""
        echo "  Example: 1 or 1,2 or 1-4 or 1 2 3"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "${YELLOW}Choose: ${NC}"
        choice=$(get_input)

        [ "$choice" = "0" ] && { menu_skins; return; }

        items="" ; count=0
        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) items="${items}  - Fury\n" ; count=$((count+1)) ;;
                *) echo "${RED}Invalid option: $ch${NC}" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "${RED}No valid items selected!${NC}" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count"

        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) install_package "Fury" "https://raw.githubusercontent.com/islam-2412/IPKS/refs/heads/main/fury/installer.sh" ;;
            esac
        done
        echo "\n${GREEN}Installation complete!!!${NC}"
        sleep 2
    done
}

# ============================================================
#                   OPENATV SKINS
# ============================================================
menu_openatv_skins() {
    while true; do
        clear
        echo "${CYAN}============================${NC}"
        echo "${CYAN}       OPENATV SKINS        ${NC}"
        echo "${CYAN}============================${NC}"
        echo ""
        echo "  1) MATRIX SKIN"
        echo ""
        echo "  Example: 1 or 1,2 or 1-4 or 1 2 3"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "${YELLOW}Choose: ${NC}"
        choice=$(get_input)

        [ "$choice" = "0" ] && { menu_skins; return; }

        items="" ; count=0
        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) items="${items}  - MATRIX SKIN\n" ; count=$((count+1)) ;;
                *) echo "${RED}Invalid option: $ch${NC}" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "${RED}No valid items selected!${NC}" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count"

        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) install_package "MATRIX SKIN" "https://raw.githubusercontent.com/islam-2412/SKINS/main/Matrix/installer.sh" ;;
            esac
        done
        echo "\n${GREEN}Installation complete!!!${NC}"
        sleep 2
    done
}

# ============================================================
#                     EGAMI SKINS
# ============================================================
menu_egami_skins() {
    while true; do
        clear
        echo "${CYAN}============================${NC}"
        echo "${CYAN}        EGAMI SKINS         ${NC}"
        echo "${CYAN}============================${NC}"
        echo ""
        echo "  1) Coming soon..."
        echo ""
        echo "  0) BACK"
        echo ""
        printf "${YELLOW}Choose: ${NC}"
        read choice < /dev/tty
        case $choice in
            0) menu_skins; return ;;
            *) echo "${RED}>>> Coming soon...${NC}" ; sleep 1 ;;
        esac
    done
}

# ============================================================
#                     OPENBH SKINS
# ============================================================
menu_openbh_skins() {
    while true; do
        clear
        echo "${CYAN}============================${NC}"
        echo "${CYAN}        OPENBH SKINS        ${NC}"
        echo "${CYAN}============================${NC}"
        echo ""
        echo "  1) Coming soon..."
        echo ""
        echo "  0) BACK"
        echo ""
        printf "${YELLOW}Choose: ${NC}"
        read choice < /dev/tty
        case $choice in
            0) menu_skins; return ;;
            *) echo "${RED}>>> Coming soon...${NC}" ; sleep 1 ;;
        esac
    done
}

# ============================================================
#                       SKINS
# ============================================================
menu_skins() {
    while true; do
        clear
        echo "${CYAN}============================${NC}"
        echo "${CYAN}           SKINS            ${NC}"
        echo "${CYAN}============================${NC}"
        echo ""
        echo "  1) OPENATV SKINS"
        echo "  2) ALL IMAGES"
        echo "  3) EGAMI SKINS"
        echo "  4) OPENBH SKINS"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "${YELLOW}Choose: ${NC}"
        read choice < /dev/tty
        case $choice in
            1) menu_openatv_skins ;;
            2) menu_all_images ;;
            3) menu_egami_skins ;;
            4) menu_openbh_skins ;;
            0) menu_main; return ;;
            *) echo "${RED}Invalid option!${NC}" ; sleep 1 ;;
        esac
    done
}

# ============================================================
#                       MEDIAS
# ============================================================
menu_medias() {
    while true; do
        clear
        echo "${CYAN}============================${NC}"
        echo "${CYAN}          MEDIAS            ${NC}"
        echo "${CYAN}============================${NC}"
        echo ""
        echo "  1) estalker"
        echo "  2) xclass"
        echo "  3) xtreamity"
        echo "  4) jedi maker xtream"
        echo "  5) BouquetMakerXtream"
        echo "  6) E2iPlayer"
        echo "  7) IPAudioPro"
        echo "  8) AISubtitles"
        echo ""
        echo "  Example: 1 or 1,3 or 1-8 or 1 3 5"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "${YELLOW}Choose: ${NC}"
        choice=$(get_input)

        [ "$choice" = "0" ] && { menu_main; return; }

        items="" ; count=0
        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) items="${items}  - estalker\n"            ; count=$((count+1)) ;;
                2) items="${items}  - xclass\n"             ; count=$((count+1)) ;;
                3) items="${items}  - xtreamity\n"          ; count=$((count+1)) ;;
                4) items="${items}  - jedi maker xtream\n"  ; count=$((count+1)) ;;
                5) items="${items}  - BouquetMakerXtream\n" ; count=$((count+1)) ;;
                6) items="${items}  - E2iPlayer\n"          ; count=$((count+1)) ;;
                7) items="${items}  - IPAudioPro\n"         ; count=$((count+1)) ;;
                8) items="${items}  - AISubtitles\n"        ; count=$((count+1)) ;;
                *) echo "${RED}Invalid option: $ch${NC}" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "${RED}No valid items selected!${NC}" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count"

        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) install_package "estalker"            "https://raw.githubusercontent.com/biko-73/estalky/main/installer.sh" ;;
                2) install_package "xclass"             "https://raw.githubusercontent.com/biko-73/xklass/main/installer.sh" ;;
                3) install_package "xtreamity"          "https://raw.githubusercontent.com/biko-73/xstreamity/main/installer.sh" ;;
                4) install_package "jedi maker xtream"  "https://raw.githubusercontent.com/jediepg/jedimakerxtream/main/installer.sh" ;;
                5) install_package "BouquetMakerXtream" "https://raw.githubusercontent.com/biko-73/BouquetMakerXtream/main/installer.sh" ;;
                6) install_package "E2iPlayer"          "https://raw.githubusercontent.com/biko-73/E2IPlayer/main/installer_E2.sh" ;;
                7) install_package "IPAudioPro"         "https://raw.githubusercontent.com/zKhadiri/IPAudioPro-Releases-/main/installer.sh" ;;
                8) install_ipk "AISubtitles" "https://github.com/milanello13/aisubtitles/releases/download/v2.0/enigma2-plugin-extensions-aisubtitles_v2.0_all.ipk" ;;
            esac
        done
        echo "\n${GREEN}Installation complete!!!${NC}"
        sleep 2
    done
}

# ============================================================
#                      SOFTCAM
# ============================================================
menu_softcam() {
    while true; do
        clear
        echo "${CYAN}============================${NC}"
        echo "${CYAN}         SOFTCAM            ${NC}"
        echo "${CYAN}============================${NC}"
        echo ""
        echo "  1) OSCam (MARKETTV1)"
        echo "  2) NCam"
        echo "  3) CCcam"
        echo "  4) OSCamicam_Kitte888"
        echo ""
        echo "  Example: 1 or 1,2 or 1-4 or 1 2 3"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "${YELLOW}Choose: ${NC}"
        choice=$(get_input)

        [ "$choice" = "0" ] && { menu_main; return; }

        items="" ; count=0
        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) items="${items}  - OSCam (MARKETTV1)\n"      ; count=$((count+1)) ;;
                2) items="${items}  - NCam\n"                   ; count=$((count+1)) ;;
                3) items="${items}  - CCcam\n"                  ; count=$((count+1)) ;;
                4) items="${items}  - OSCamicam_Kitte888\n"     ; count=$((count+1)) ;;
                *) echo "${RED}Invalid option: $ch${NC}" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "${RED}No valid items selected!${NC}" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count"

        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) install_package "OSCam (MARKETTV1)"   "https://raw.githubusercontent.com/MARKETTV1/softcams/refs/heads/main/oscam.sh" ;;
                2) install_package "NCam"                "https://raw.githubusercontent.com/biko-73/Ncam_EMU/main/installer.sh" ;;
                3) install_opkg    "CCcam"               "enigma2-plugin-softcams-cccam" ;;
                4) install_package "OSCamicam_Kitte888"  "https://raw.githubusercontent.com/biko-73/OSCamicam_Kitte888/main/installer.sh" ;;
            esac
        done
        echo "\n${GREEN}Installation complete!!!${NC}"
        sleep 2
    done
}

# ============================================================
#                        TOOLS
# ============================================================
menu_tools() {
    while true; do
        clear
        echo "${CYAN}============================${NC}"
        echo "${CYAN}           TOOLS            ${NC}"
        echo "${CYAN}============================${NC}"
        echo ""
        echo "  1) System Update (opkg update/upgrade)"
        echo "  2) Restart Enigma2"
        echo "  3) Install wget & curl"
        echo "  4) Add OpenATV Feed emu oscam"
        echo "  5) Check Python3 Version"
        echo "  6) Check IP & MAC Address"
        echo "  7) Factory Reset (⚠️ DANGER ⚠️)"
        echo ""
        echo "  Example: 1 or 1,2 or 1-7 or 1 2 3"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "${YELLOW}Choose: ${NC}"
        choice=$(get_input)

        [ "$choice" = "0" ] && { menu_main; return; }

        items="" ; count=0
        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) items="${items}  - System Update (opkg update/upgrade)\n" ; count=$((count+1)) ;;
                2) items="${items}  - Restart Enigma2\n"                      ; count=$((count+1)) ;;
                3) items="${items}  - Install wget & curl\n"                  ; count=$((count+1)) ;;
                4) items="${items}  - Add OpenATV Feed emu oscam\n"           ; count=$((count+1)) ;;
                5) items="${items}  - Check Python3 Version\n"                ; count=$((count+1)) ;;
                6) items="${items}  - Check IP & MAC Address\n"               ; count=$((count+1)) ;;
                7) items="${items}  - Factory Reset (⚠️ DANGER ⚠️)\n"         ; count=$((count+1)) ;;
                *) echo "${RED}Invalid option: $ch${NC}" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "${RED}No valid items selected!${NC}" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count"

        for ch in $(parse_choices "$choice"); do
            case $ch in
                1)
                    echo ""
                    echo "${GREEN}>>> Stopping Enigma2 (init 4)...${NC}"
                    init 4
                    sleep 2
                    echo "${GREEN}>>> Updating package lists (opkg update)...${NC}"
                    opkg update
                    echo "${GREEN}>>> Upgrading packages (opkg upgrade)...${NC}"
                    opkg upgrade
                    echo "${GREEN}>>> Restarting Enigma2 (init 3)...${NC}"
                    init 3
                    echo "${GREEN}>>> System update completed!${NC}"
                    ;;
                2)
                    echo ""
                    echo "${GREEN}>>> Restarting Enigma2...${NC}"
                    init 4 && sleep 2 && init 3
                    echo "${GREEN}>>> Enigma2 restarted!${NC}"
                    ;;
                3)
                    echo ""
                    echo "${GREEN}>>> Installing wget...${NC}"
                    opkg update
                    opkg install wget
                    echo "${GREEN}>>> wget installed successfully!${NC}"
                    echo ""
                    echo "${GREEN}>>> Installing curl...${NC}"
                    opkg install curl
                    echo "${GREEN}>>> curl installed successfully!${NC}"
                    ;;
                4)
                    echo ""
                    echo "${GREEN}>>> Adding OpenATV Feed emu oscam...${NC}"
                    wget -O - -q http://updates.mynonpublic.com/oea/feed | bash
                    echo "${GREEN}>>> OpenATV Feed emu oscam added successfully!${NC}"
                    ;;
                5)
                    echo ""
                    echo "${GREEN}>>> Checking Python3 version...${NC}"
                    echo ""
                    python3 --version
                    echo ""
                    echo "${GREEN}>>> Python3 version check completed!${NC}"
                    ;;
                6)
                    echo ""
                    echo "${GREEN}========================================${NC}"
                    echo "${GREEN}         Network Information            ${NC}"
                    echo "${GREEN}========================================${NC}"
                    echo ""
                    ip a | grep -E "inet |link/ether"
                    echo ""
                    echo "${GREEN}========================================${NC}"
                    echo "${GREEN}>>> IP & MAC Address check completed!${NC}"
                    ;;
                7)
                    echo ""
                    echo "${RED}═══════════════════════════════════════════════════════════════════════════════${NC}"
                    echo "${RED}╔═════════════════════════════════════════════════════════════════════════════╗${NC}"
                    echo "${RED}║                                                                             ║${NC}"
                    echo "${RED}║                         ⚠️  DANGER! ⚠️                                      ║${NC}"
                    echo "${RED}║                                                                             ║${NC}"
                    echo "${RED}║  This operation will DELETE:                                                ║${NC}"
                    echo "${RED}║  • All channels                                                             ║${NC}"
                    echo "${RED}║  • All bouquets                                                             ║${NC}"
                    echo "${RED}║  • All tuner settings                                                       ║${NC}"
                    echo "${RED}║  • All softcam settings                                                     ║${NC}"
                    echo "${RED}║  • All device settings                                                      ║${NC}"
                    echo "${RED}║                                                                             ║${NC}"
                    echo "${RED}║  🔴  This action CANNOT be undone!  🔴                                     ║${NC}"
                    echo "${RED}║                                                                             ║${NC}"
                    echo "${RED}║  The device will reboot automatically after reset                           ║${NC}"
                    echo "${RED}║                                                                             ║${NC}"
                    echo "${RED}╚═════════════════════════════════════════════════════════════════════════════╝${NC}"
                    echo "${RED}═══════════════════════════════════════════════════════════════════════════════${NC}"
                    echo ""
                    echo "${YELLOW}To confirm Factory Reset, type: ${RED}YES${NC}"
                    printf "${YELLOW}Confirm: ${NC}"
                    read confirm_reset < /dev/tty
                    if [ "$confirm_reset" = "YES" ]; then
                        echo ""
                        echo "${RED}>>> Starting Factory Reset...${NC}"
                        echo "${RED}>>> Stopping Enigma2 (init 4)...${NC}"
                        init 4
                        sleep 2
                        echo "${RED}>>> Deleting all settings (rm -rf /etc/enigma2/*)...${NC}"
                        rm -rf /etc/enigma2/*
                        echo "${RED}>>> Rebooting device...${NC}"
                        sleep 2
                        echo "${RED}>>> Rebooting now...${NC}"
                        reboot
                    else
                        echo ""
                        echo "${GREEN}>>> Factory Reset cancelled.${NC}"
                        sleep 2
                    fi
                    ;;
            esac
        done
        echo "\n${GREEN}Operation complete!!!${NC}"
        sleep 3
    done
}

# ============================================================
#                       BACKUPS
# ============================================================
menu_backups() {
    while true; do
        clear
        echo "${CYAN}============================${NC}"
        echo "${CYAN}          BACKUPS           ${NC}"
        echo "${CYAN}============================${NC}"
        echo ""
        echo "  1) Backup Tuner Settings"
        echo "  2) Restore Tuner Settings"
        echo "  3) Backup Full Image (Coming soon)"
        echo ""
        echo "  Example: 1 or 1,2 or 1-3 or 1 2"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "${YELLOW}Choose: ${NC}"
        choice=$(get_input)

        [ "$choice" = "0" ] && { menu_main; return; }

        items="" ; count=0
        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) items="${items}  - Backup Tuner Settings\n"          ; count=$((count+1)) ;;
                2) items="${items}  - Restore Tuner Settings\n"          ; count=$((count+1)) ;;
                3) items="${items}  - Backup Full Image (Coming soon)\n" ; count=$((count+1)) ;;
                *) echo "${RED}Invalid option: $ch${NC}" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "${RED}No valid items selected!${NC}" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count"

        for ch in $(parse_choices "$choice"); do
            case $ch in
                1)
                    echo ""
                    echo "${GREEN}>>> Creating backup of Tuner Settings...${NC}"
                    echo ""
                    
                    # Get image name
                    IMAGE_NAME=$(grep ^imageversion= /etc/image-version 2>/dev/null | cut -d= -f2 | tr -d ' ' || ( . /etc/issue 2>/dev/null && echo $DISTRO_NAME ) || echo "unknown")
                    
                    # Set backup filename
                    BACKUP_FILENAME="tuner_backup_${IMAGE_NAME}_$(date +%Y%m%d_%H%M%S).backup"
                    
                    # Determine backup location (prefer HDD, fallback to USB)
                    BACKUP_PATH=""
                    if [ -d "/media/hdd" ]; then
                        # Check HDD free space (need at least 10MB = 10240 KB)
                        HDD_SPACE=$(df /media/hdd 2>/dev/null | awk 'NR==2 {print $4}')
                        if [ -n "$HDD_SPACE" ] && [ "$HDD_SPACE" -gt 10240 ]; then
                            BACKUP_PATH="/media/hdd"
                            echo "${GREEN}>>> Using HDD for backup${NC}"
                        else
                            echo "${YELLOW}>>> HDD has insufficient space or not mounted, trying USB...${NC}"
                        fi
                    fi
                    
                    # If HDD not available, try USB
                    if [ -z "$BACKUP_PATH" ]; then
                        if [ -d "/media/usb" ]; then
                            USB_SPACE=$(df /media/usb 2>/dev/null | awk 'NR==2 {print $4}')
                            if [ -n "$USB_SPACE" ] && [ "$USB_SPACE" -gt 10240 ]; then
                                BACKUP_PATH="/media/usb"
                                echo "${GREEN}>>> Using USB for backup${NC}"
                            else
                                echo "${RED}>>> USB has insufficient space or not mounted${NC}"
                            fi
                        else
                            echo "${RED}>>> No USB storage found${NC}"
                        fi
                    fi
                    
                    # Create backup if storage is available
                    if [ -n "$BACKUP_PATH" ]; then
                        BACKUP_FILE="${BACKUP_PATH}/${BACKUP_FILENAME}"
                        grep "config.Nims." /etc/enigma2/settings > "$BACKUP_FILE"
                        
                        # Check if backup was successful
                        if [ -f "$BACKUP_FILE" ]; then
                            FILE_SIZE=$(ls -lh "$BACKUP_FILE" | awk '{print $5}')
                            LINE_COUNT=$(wc -l < "$BACKUP_FILE")
                            echo ""
                            echo "${GREEN}>>> Backup created successfully!${NC}"
                            echo "${GREEN}>>> Location: ${BACKUP_FILE}${NC}"
                            echo "${GREEN}>>> Size: ${FILE_SIZE}${NC}"
                            echo "${GREEN}>>> Tuner settings: ${LINE_COUNT} entries${NC}"
                        else
                            echo "${RED}>>> Backup failed!${NC}"
                        fi
                    else
                        echo ""
                        echo "${RED}>>> No suitable storage found (HDD or USB)${NC}"
                        echo "${RED}>>> Please check your storage devices${NC}"
                    fi
                    ;;
                2)
                    echo ""
                    echo "${GREEN}>>> Starting Tuner Restore Process...${NC}"
                    echo ""
                    
                    # Stop Enigma2
                    echo "${YELLOW}>>> Stopping Enigma2 (init 4)...${NC}"
                    init 4
                    sleep 2
                    
                    # Show old settings (first 5 lines)
                    echo "${YELLOW}>>> Old tuner settings (before restore):${NC}"
                    grep "config.Nims." /etc/enigma2/settings 2>/dev/null | head -n5
                    echo ""
                    
                    # Search for backup file
                    echo "${YELLOW}>>> Searching for backup file...${NC}"
                    BACKUP_FILE=$(ls /media/hdd/tuner_backup_*.backup 2>/dev/null | head -n1 || ls /media/usb/tuner_backup_*.backup 2>/dev/null | head -n1)
                    
                    if [ -f "$BACKUP_FILE" ]; then
                        echo "${GREEN}>>> Backup found: ${BACKUP_FILE}${NC}"
                        echo ""
                        
                        # Remove old tuner settings
                        echo "${YELLOW}>>> Removing old tuner settings...${NC}"
                        sed -i '/config.Nims./d' /etc/enigma2/settings
                        
                        # Restore new tuner settings
                        echo "${YELLOW}>>> Restoring new tuner settings...${NC}"
                        cat "$BACKUP_FILE" >> /etc/enigma2/settings
                        
                        # Show new settings (first 5 lines)
                        echo ""
                        echo "${YELLOW}>>> New tuner settings (after restore):${NC}"
                        grep "config.Nims." /etc/enigma2/settings 2>/dev/null | head -n5
                        echo ""
                        
                        echo "${GREEN}>>> Restored successfully from: ${BACKUP_FILE}${NC}"
                    else
                        echo "${RED}>>> Error: No backup file found in /media/hdd or /media/usb${NC}"
                    fi
                    
                    # Restart Enigma2
                    echo ""
                    echo "${GREEN}>>> Restarting Enigma2 (init 3)...${NC}"
                    init 3
                    echo "${GREEN}>>> Tuner Restore Process completed!${NC}"
                    ;;
                3)
                    echo ""
                    echo "${YELLOW}>>> Coming soon...${NC}"
                    ;;
            esac
        done
        echo "\n${GREEN}Operation complete!!!${NC}"
        sleep 3
    done
}

# ============================================================
#                   MAIN MENU
# ============================================================
menu_main() {
    while true; do
        clear
        echo "${CYAN}============================${NC}"
        echo "${CYAN}      Enigma2 Manager       ${NC}"
        echo "${CYAN}         by Karim           ${NC}"
        echo "${CYAN}============================${NC}"
        echo ""
        echo "  1) PLUGINS & PANELS"
        echo "  2) SKINS"
        echo "  3) MEDIAS"
        echo "  4) SOFTCAM"
        echo "  5) TOOLS"
        echo "  6) BACKUPS"
        echo ""
        echo "  0) EXIT"
        echo ""
        printf "${YELLOW}Choose: ${NC}"
        choice=$(get_input)
        case $choice in
            1) menu_plugins_panels ;;
            2) menu_skins ;;
            3) menu_medias ;;
            4) menu_softcam ;;
            5) menu_tools ;;
            6) menu_backups ;;
            0)
                clear
                echo "${CYAN}========================================${NC}"
                echo "${CYAN}      Enigma2 Manager - by Karim       ${NC}"
                echo "${CYAN}========================================${NC}"
                echo ""
                echo "${GREEN}      Thank you for using Enigma2 Manager${NC}"
                echo ""
                echo "${YELLOW}      Your device has been successfully managed!${NC}"
                echo "${YELLOW}              See you next time! 👋${NC}"
                echo ""
                echo "${CYAN}========================================${NC}"
                echo ""
                exit 0
                ;;
            *) echo "${RED}Invalid option!${NC}" ; sleep 1 ;;
        esac
    done
}

# ============================================================
#                      RUN SCRIPT
# ============================================================
menu_main
