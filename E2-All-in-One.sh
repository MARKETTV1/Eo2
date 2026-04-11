#!/bin/sh

# ============================================================
#          - ENIGMA2 MANAGER - (Karim Abu Rida)
# ============================================================

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
# Function to install .ipk file
# ============================================================
install_ipk() {
    local name="$1"
    local url="$2"
    echo ""
    echo ">>> Installing ${name}..."
    opkg update > /dev/null 2>&1
    opkg install wget > /dev/null 2>&1
    IPK_FILE="/tmp/${name}.ipk"
    wget --no-check-certificate -q "$url" -O "$IPK_FILE"
    if [ -f "$IPK_FILE" ]; then
        opkg install "$IPK_FILE"
        rm -f "$IPK_FILE"
        echo ">>> ${name} installed successfully!"
    else
        echo ">>> Failed to download ${name} package!"
    fi
}

# ============================================================
# Function to confirm installation (NO PROMPT - direct install)
# ============================================================
confirm_installation() {
    local items="$1"
    local count="$2"
    echo ""
    echo "========================================"
    echo "         Installation Summary           "
    echo "========================================"
    echo ""
    echo "Items to be installed:"
    echo -e "$items"
    echo ""
    echo "Total: $count item(s)"
    echo ""
    echo ">>> Starting installation..."
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
        echo "============================"
        echo "     PLUGINS & PANELS       "
        echo "============================"
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
        echo " 11) NewVirtualkeyboard"
        echo " 12) MyTranslator"
		echo " 13) MagicPanelGold"
        echo ""
        echo "  Example: 1 or 1,2 or 1-13 or 1 3 5"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "Choose: "
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
               11) items="${items}  - NewVirtualkeyboard\n" ; count=$((count+1)) ;;
               12) items="${items}  - MyTranslator\n" ; count=$((count+1)) ;;
			   13) items="${items}  - MagicPanelGold\n" ; count=$((count+1)) ;;
                *) echo "Invalid option: $ch" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "No valid items selected!" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count"

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
                5) install_package "FuryBiss" "https://raw.githubusercontent.com/islam-2412/FuryBiss/main/fury/installer.sh" ;;
                6) install_package "RaedQuickSignal" "https://raw.githubusercontent.com/fairbird/RaedQuickSignal/main/installer_Version8.8.sh" ;;
                7) install_package "ArabicPlayer" "https://raw.githubusercontent.com/asdrere123-alt/ArabicPlayer/main/installer.sh?v=FINAL" ;;
                8) install_package "E2BissKeyEditor" "https://raw.githubusercontent.com/ismail9875/E2BissKeyEditor/refs/heads/main/installer.sh" ;;
                9) install_package "Satelliweb" "http://dreambox4u.com/dreamarabia/Satelliweb_e2/install_satelliweb.sh" ;;
               10) install_package "FootOnsat" "https://raw.githubusercontent.com/fairbird/FootOnsat/main/Download/install.sh" ;;
               11) install_package "NewVirtualkeyboard" "https://raw.githubusercontent.com/fairbird/NewVirtualKeyBoard/main/installer.sh" ;;
			   12) install_package "MyTranslator" "https://raw.githubusercontent.com/islam-2412/mytrans/main/fury/installer.sh" ;;
			   13) install_package "MagicPanelGold" "https://raw.githubusercontent.com/Ham-ahmed/G/refs/heads/main/MagicPanelGold-v9_install.sh" ;;
            esac
        done
        echo ""
        echo "Installation complete!!!"
        sleep 2
    done
}

# ============================================================
#                     ALL IMAGES
# ============================================================
menu_all_images() {
    while true; do
        clear
        echo "============================"
        echo "         ALL IMAGES         "
        echo "============================"
        echo ""
        echo "  1) Fury"
        echo ""
        echo "  Example: 1 or 1,2 or 1-4 or 1 2 3"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "Choose: "
        choice=$(get_input)

        [ "$choice" = "0" ] && { menu_skins; return; }

        items="" ; count=0
        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) items="${items}  - Fury\n" ; count=$((count+1)) ;;
                *) echo "Invalid option: $ch" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "No valid items selected!" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count"

        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) install_package "Fury" "https://raw.githubusercontent.com/islam-2412/IPKS/refs/heads/main/fury/installer.sh" ;;
            esac
        done
        echo ""
        echo "Installation complete!!!"
        sleep 2
    done
}

# ============================================================
#                   OPENATV SKINS
# ============================================================
menu_openatv_skins() {
    while true; do
        clear
        echo "============================"
        echo "       OPENATV SKINS        "
        echo "============================"
        echo ""
        echo "  1) MATRIX SKIN"
        echo ""
        echo "  Example: 1 or 1,2 or 1-4 or 1 2 3"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "Choose: "
        choice=$(get_input)

        [ "$choice" = "0" ] && { menu_skins; return; }

        items="" ; count=0
        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) items="${items}  - MATRIX SKIN\n" ; count=$((count+1)) ;;
                *) echo "Invalid option: $ch" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "No valid items selected!" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count"

        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) install_package "MATRIX SKIN" "https://raw.githubusercontent.com/islam-2412/SKINS/main/Matrix/installer.sh" ;;
            esac
        done
        echo ""
        echo "Installation complete!!!"
        sleep 2
    done
}

# ============================================================
#                     EGAMI SKINS
# ============================================================
menu_egami_skins() {
    while true; do
        clear
        echo "============================"
        echo "        EGAMI SKINS         "
        echo "============================"
        echo ""
        echo "  1) Coming soon..."
        echo ""
        echo "  0) BACK"
        echo ""
        printf "Choose: "
        read choice < /dev/tty
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
        echo "        OPENBH SKINS        "
        echo "============================"
        echo ""
        echo "  1) Coming soon..."
        echo ""
        echo "  0) BACK"
        echo ""
        printf "Choose: "
        read choice < /dev/tty
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
        echo "           SKINS            "
        echo "============================"
        echo ""
        echo "  1) OPENATV SKINS"
        echo "  2) ALL IMAGES"
        echo "  3) EGAMI SKINS"
        echo "  4) OPENBH SKINS"
        echo "  5) OTHER SKINS"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "Choose: "
        read choice < /dev/tty
        case $choice in
            1) menu_openatv_skins ;;
            2) menu_all_images ;;
            3) menu_egami_skins ;;
            4) menu_openbh_skins ;;
            5) menu_other_skins ;;
            0) menu_main; return ;;
            *) echo "Invalid option!" ; sleep 1 ;;
        esac
    done
}

# ============================================================
#                     OTHER SKINS
# ============================================================
menu_other_skins() {
    while true; do
        clear
        echo "============================"
        echo "        OTHER SKINS         "
        echo "============================"
        echo ""
        echo "  1) Maxy-FHD by MNASR"
        echo "  2) XDREAMY"
        echo "  3) eam_Nitro-by_BoHlal"
        echo "  4) premium-fhd-black"
        echo "  5) premium-fhd-blue"
        echo "  6) premium-fhd-magenta"
        echo ""
        echo "  Example: 1 or 1,2 or 1-6 or 1 2 3"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "Choose: "
        choice=$(get_input)

        [ "$choice" = "0" ] && { menu_skins; return; }

        items="" ; count=0
        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) items="${items}  - Maxy-FHD by MNASR\n" ; count=$((count+1)) ;;
                2) items="${items}  - XDREAMY\n"           ; count=$((count+1)) ;;
                3) items="${items}  - eam_Nitro-by_BoHlal\n" ; count=$((count+1)) ;;
                4) items="${items}  - premium-fhd-black\n" ; count=$((count+1)) ;;
                5) items="${items}  - premium-fhd-blue\n"  ; count=$((count+1)) ;;
                6) items="${items}  - premium-fhd-magenta\n" ; count=$((count+1)) ;;
                *) echo "Invalid option: $ch" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "No valid items selected!" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count"

        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) install_package "Maxy-FHD by MNASR" "https://raw.githubusercontent.com/popking159/skins/refs/heads/main/maxyatv/installer.sh" ;;
                2) install_package "XDREAMY" "https://raw.githubusercontent.com/Insprion80/Skins/main/xDreamy/installer.sh" ;;
                3) install_package "eam_Nitro-by_BoHlal" "https://raw.githubusercontent.com/biko-73/TeamNitro/main/script/installerB.sh" ;;
                4) install_package "premium-fhd-black" "https://gitlab.com/hmeng80/skin-all/-/raw/main/premium-fhd/premium-fhd-black.sh" ;;
                5) install_package "premium-fhd-blue" "https://gitlab.com/hmeng80/skin-all/-/raw/main/premium-fhd/premium-fhd-blue.sh" ;;
                6) install_package "premium-fhd-magenta" "https://gitlab.com/hmeng80/skin-all/-/raw/main/premium-fhd/premium-fhd-_magenta.sh" ;;
            esac
        done
        echo ""
        echo "Installation complete!!!"
        sleep 2
    done
}

# ============================================================
#                       MEDIAS
# ============================================================
menu_medias() {
    while true; do
        clear
        echo "============================"
        echo "          MEDIAS            "
        echo "============================"
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
        printf "Choose: "
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
                *) echo "Invalid option: $ch" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "No valid items selected!" ; sleep 1 ; continue; }

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
        echo ""
        echo "Installation complete!!!"
        sleep 2
    done
}

# ============================================================
#                      SOFTCAM
# ============================================================
menu_softcam() {
    while true; do
        clear
        echo "============================"
        echo "         SOFTCAM            "
        echo "============================"
        echo ""
        echo "  1) OSCam 11946 (compiled by levi5)"
        echo "  2) NCam (Latest version)"
        echo "  3) Add OpenATV Feed (SoftCAM)"
        echo "  4) OSCamicam_Kitte888"
        echo ""
        echo "  Example: 1 or 1,2 or 1-4 or 1 2 3"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "Choose: "
        choice=$(get_input)

        [ "$choice" = "0" ] && { menu_main; return; }

        items="" ; count=0
        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) items="${items}  - OSCam 11946 (compiled by levi5)\n" ; count=$((count+1)) ;;
                2) items="${items}  - NCam (Latest version)\n"           ; count=$((count+1)) ;;
                3) items="${items}  - Add OpenATV Feed (SoftCAM)\n"      ; count=$((count+1)) ;;
                4) items="${items}  - OSCamicam_Kitte888\n"              ; count=$((count+1)) ;;
                *) echo "Invalid option: $ch" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "No valid items selected!" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count"

        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) install_package "OSCam 11946 (compiled by levi5)" "https://raw.githubusercontent.com/MARKETTV1/softcams/refs/heads/main/OScam_Final%20version.sh" ;;
                2) install_package "NCam (Latest version)" "https://raw.githubusercontent.com/biko-73/Ncam_EMU/main/installer.sh" ;;
                3)
                    echo ""
                    echo ">>> Adding OpenATV Feed (SoftCAM)..."
                    echo ""
                    wget -O - -q http://updates.mynonpublic.com/oea/feed | bash
                    echo ""
                    echo ">>> OpenATV Feed (SoftCAM) added successfully!"
                    ;;
                4) install_package "OSCamicam_Kitte888"  "https://raw.githubusercontent.com/biko-73/OSCamicam_Kitte888/main/installer.sh" ;;
            esac
        done
        echo ""
        echo "Installation complete!!!"
        sleep 2
    done
}

# ============================================================
#                        TOOLS
# ============================================================
menu_tools() {
    while true; do
        clear
        echo "============================"
        echo "           TOOLS            "
        echo "============================"
        echo ""
        echo "  1) System Update (opkg update/upgrade)"
        echo "  2) Restart Enigma2"
        echo "  3) Install wget & curl"
        echo "  4) Add OpenATV Feed emu oscam"
        echo "  5) Check Python3 Version"
        echo "  6) Check IP & MAC Address"
        echo "  7) Factory Reset (!!! DANGER !!!)"
		echo "  8) Factory Reset (!!! DANGER !!!)"
        echo ""
        echo "  Example: 1 or 1,2 or 1-7 or 1 2 3"

        echo ""
        echo "  0) BACK"
        echo ""
        printf "Choose: "
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
                7) items="${items}  - Factory Reset (DANGER)\n"               ; count=$((count+1)) ;;
                8) items="${items}  - fix_players.sh \n"                      ; count=$((count+1)) ;;
                *) echo "Invalid option: $ch" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "No valid items selected!" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count"

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
                5)
                    echo ""
                    echo ">>> Checking Python3 version..."
                    echo ""
                    python3 --version
                    echo ""
                    echo ">>> Python3 version check completed!"
                    echo ""
                    echo ">>> Waiting 20 seconds before returning to menu..."
                    sleep 20
                    ;;
                6)
                    echo ""
                    echo "========================================"
                    echo "         Network Information            "
                    echo "========================================"
                    echo ""
                    ip a | grep -E "inet |link/ether"
                    echo ""
                    echo "========================================"
                    echo ">>> IP & MAC Address check completed!"
                    echo ""
                    echo ">>> Waiting 20 seconds before returning to menu..."
                    sleep 20
                    ;;
                7)
                    echo ""
                    echo "================================================"
                    echo "           !!! DANGER - FACTORY RESET !!!        "
                    echo "================================================"
                    echo "  This will DELETE:                              "
                    echo "  - All channels and bouquets                    "
                    echo "  - All tuner settings                           "
                    echo "  - All softcam settings                         "
                    echo "  - All device settings                          "
                    echo "                                                 "
                    echo "  This action CANNOT be undone!                  "
                    echo "  The device will REBOOT completely!             "
                    echo "================================================"
                    echo ""
                    printf "To confirm Factory Reset, type: YES: "
                    read confirm_reset < /dev/tty
                    if [ "$confirm_reset" = "YES" ]; then
                        echo ""
                        echo ">>> Starting Factory Reset..."
                        echo ">>> Stopping Enigma2 (init 4)..."
                        init 4
                        sleep 5
                        echo ">>> Deleting all settings (rm -f /etc/enigma2/*)..."
                        rm -f /etc/enigma2/*
                        echo ">>> Rebooting device..."
                        sleep 2
                        echo ">>> Rebooting now..."
                        reboot
                    else
                        echo ""
                        echo ">>> Factory Reset cancelled."
                        sleep 2
                    fi
                    ;;
                8)
                    echo ""
                    echo ">>> Install or reinstall PLAYERS "
                    wget -O - -q http://updates.mynonpublic.com/oea/feed | bash
                    echo ">>> ALL PLAYERS FIXED successfully!"
                    ;;
            esac
        done
        echo ""
        echo "Operation complete!!!"
        sleep 3
    done
}

# ============================================================
#                       BACKUPS
# ============================================================
menu_backups() {
    while true; do
        clear
        echo "============================"
        echo "          BACKUPS           "
        echo "============================"
        echo ""
        echo "  1) Backup Tuner Settings"
        echo "  2) Restore Tuner Settings"
        echo "  3) Backup Full Image (Coming soon)"
        echo ""
        echo "  Example: 1 or 1,2 or 1-3 or 1 2"
        echo ""
        echo "  0) BACK"
        echo ""
        printf "Choose: "
        choice=$(get_input)

        [ "$choice" = "0" ] && { menu_main; return; }

        items="" ; count=0
        for ch in $(parse_choices "$choice"); do
            case $ch in
                1) items="${items}  - Backup Tuner Settings\n"          ; count=$((count+1)) ;;
                2) items="${items}  - Restore Tuner Settings\n"          ; count=$((count+1)) ;;
                3) items="${items}  - Backup Full Image (Coming soon)\n" ; count=$((count+1)) ;;
                *) echo "Invalid option: $ch" ; sleep 1 ;;
            esac
        done

        [ $count -eq 0 ] && { echo "No valid items selected!" ; sleep 1 ; continue; }

        confirm_installation "$items" "$count"

        for ch in $(parse_choices "$choice"); do
            case $ch in
                1)
                    echo ""
                    echo ">>> Creating backup of Tuner Settings..."
                    echo ""
                    
                    IMAGE_NAME=$(grep ^imageversion= /etc/image-version 2>/dev/null | cut -d= -f2 | tr -d ' ' || ( . /etc/issue 2>/dev/null && echo $DISTRO_NAME ) || echo "unknown")
                    BACKUP_FILENAME="tuner_backup_${IMAGE_NAME}_$(date +%Y%m%d_%H%M%S).backup"
                    BACKUP_PATH=""

                    if [ -d "/media/hdd" ]; then
                        HDD_SPACE=$(df /media/hdd 2>/dev/null | awk 'NR==2 {print $4}')
                        if [ -n "$HDD_SPACE" ] && [ "$HDD_SPACE" -gt 10240 ]; then
                            BACKUP_PATH="/media/hdd"
                            echo ">>> Using HDD for backup"
                        else
                            echo ">>> HDD has insufficient space or not mounted, trying USB..."
                        fi
                    fi
                    
                    if [ -z "$BACKUP_PATH" ]; then
                        if [ -d "/media/usb" ]; then
                            USB_SPACE=$(df /media/usb 2>/dev/null | awk 'NR==2 {print $4}')
                            if [ -n "$USB_SPACE" ] && [ "$USB_SPACE" -gt 10240 ]; then
                                BACKUP_PATH="/media/usb"
                                echo ">>> Using USB for backup"
                            else
                                echo ">>> USB has insufficient space or not mounted"
                            fi
                        else
                            echo ">>> No USB storage found"
                        fi
                    fi
                    
                    if [ -n "$BACKUP_PATH" ]; then
                        BACKUP_FILE="${BACKUP_PATH}/${BACKUP_FILENAME}"
                        grep "config.Nims." /etc/enigma2/settings > "$BACKUP_FILE"
                        if [ -f "$BACKUP_FILE" ]; then
                            FILE_SIZE=$(ls -lh "$BACKUP_FILE" | awk '{print $5}')
                            LINE_COUNT=$(wc -l < "$BACKUP_FILE")
                            echo ""
                            echo ">>> Backup created successfully!"
                            echo ">>> Location: ${BACKUP_FILE}"
                            echo ">>> Size: ${FILE_SIZE}"
                            echo ">>> Tuner settings: ${LINE_COUNT} entries"
                        else
                            echo ">>> Backup failed!"
                        fi
                    else
                        echo ""
                        echo ">>> No suitable storage found (HDD or USB)"
                        echo ">>> Please check your storage devices"
                    fi
                    ;;
                2)
                    echo ""
                    echo ">>> Starting Tuner Restore Process..."
                    echo ""
                    
                    echo ">>> Stopping Enigma2 (init 4)..."
                    init 4
                    sleep 2
                    
                    echo ">>> Old tuner settings (before restore):"
                    grep "config.Nims." /etc/enigma2/settings 2>/dev/null | head -n5
                    echo ""
                    
                    echo ">>> Searching for backup file..."
                    BACKUP_FILE=$(ls /media/hdd/tuner_backup_*.backup 2>/dev/null | head -n1 || ls /media/usb/tuner_backup_*.backup 2>/dev/null | head -n1)
                    
                    if [ -f "$BACKUP_FILE" ]; then
                        echo ">>> Backup found: ${BACKUP_FILE}"
                        echo ""
                        
                        echo ">>> Removing old tuner settings..."
                        sed -i '/config.Nims./d' /etc/enigma2/settings
                        
                        echo ">>> Restoring new tuner settings..."
                        cat "$BACKUP_FILE" >> /etc/enigma2/settings
                        
                        echo ""
                        echo ">>> New tuner settings (after restore):"
                        grep "config.Nims." /etc/enigma2/settings 2>/dev/null | head -n5
                        echo ""
                        
                        echo ">>> Restored successfully from: ${BACKUP_FILE}"
                    else
                        echo ">>> Error: No backup file found in /media/hdd or /media/usb"
                    fi
                    
                    echo ""
                    echo ">>> Restarting Enigma2 (init 3)..."
                    init 3
                    echo ">>> Tuner Restore Process completed!"
                    ;;
                3)
                    echo ""
                    echo ">>> Coming soon..."
                    ;;
            esac
        done
        echo ""
        echo "Operation complete!!!"
        sleep 3
    done
}

# ============================================================
#                   MAIN MENU
# ============================================================
menu_main() {
    while true; do
        clear
        echo "============================"
        echo "      Enigma2 Manager       "
        echo "         by Karim           "
        echo "============================"
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
        printf "Choose: "
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
                echo "==================================================="
                echo "            Enigma2 Manager - by Karim             "
                echo "==================================================="
                echo ""
                echo "      Thank you for using Enigma2 Manager          "
                echo ""
                echo "      Your device has been successfully managed!   "
                echo "              See you next time! 👋"
                echo ""
                echo "===================================================="
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
