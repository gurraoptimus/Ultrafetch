#!/bin/bash

# ==========================================
# Written by Gurraoptimus
# GitHub: https://github.com/gurraoptimus
# Website: https://gurraoptimus.se
# ==========================================

set -Eeuo pipefail

# ==========================================
# Welcome to Ultra Fetch!
# Modern Neofetch / Fastfetch Style
# ==========================================

# ===== VERSION =====
SCRIPT_VERSION="1.0"
# ===== ERROR HANDLER =====
error_handler() {
    local exit_code=$?
    local line_no=$1

    tput cnorm 2>/dev/null || true
    echo
    echo "X Error on line $line_no"
    echo "Exit code: $exit_code"
    exit "$exit_code"
}

trap 'error_handler $LINENO' ERR
trap 'tput cnorm 2>/dev/null || true; echo; exit' INT TERM

# ===== COLORS =====
RESET=$'\e[0m'
BOLD=$'\e[1m'

BLACK=$'\e[30m'
RED=$'\e[31m'
GREEN=$'\e[32m'
YELLOW=$'\e[33m'
BLUE=$'\e[34m'
MAGENTA=$'\e[35m'
CYAN=$'\e[36m'
WHITE=$'\e[97m'

# ===== DISTRO DETECTION =====
DISTRO=$(grep '^ID=' /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"')

# ===== ASCII LOGOS =====
case "$DISTRO" in


*)
ASCII='
 _____ _____ _____ _____ __    _____ 
|  _  | __  |   | |   __|  |  |     |
|     |    -| | | |   __|  |__|  |  |
|__|__|__|__|_|___|__|  |_____|_____|

'
;;
esac



# ===== SYSTEM INFO =====
USER_NAME=$(whoami)
HOST_NAME=$(hostname)

OS=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')

KERNEL=$(uname -r)

UPTIME=$(uptime -p 2>/dev/null | sed 's/up //' || echo "Unknown")

SHELL_NAME=$(basename "${SHELL:-unknown}")

TERM_NAME=${TERM:-unknown}


# ===== MEMORY =====
# Memory: human-readable (e.g., MiB/GiB)
RAM_USED=$(free -h | awk '/Mem:/ {print $3}')
RAM_TOTAL=$(free -h | awk '/Mem:/ {print $2}')

# ===== DISK =====
# Disk: human-readable (e.g., GiB)
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')

# ===== PACKAGE COUNT =====
PKGS=0

if command -v pacman >/dev/null 2>&1; then
    PKGS=$((PKGS + $(pacman -Qq | wc -l)))
fi

if command -v dpkg >/dev/null 2>&1; then
    PKGS=$((PKGS + $(dpkg -l | grep '^ii' | wc -l)))
fi

# ===== NETWORK =====
IP=$(hostname -I 2>/dev/null | awk '{print $1}' || echo "Unknown")

# ===== BATTERY =====
BATTERY="N/A"

if command -v acpi >/dev/null 2>&1; then
    BATTERY=$(acpi -b | awk -F', ' '{print $2}' || echo "N/A")
elif [[ -f /sys/class/power_supply/BAT0/capacity ]]; then
    BATTERY="$(cat /sys/class/power_supply/BAT0/capacity)%"
fi

# ===== WEATHER =====
export LANG=sv_SE.UTF-8
export LC_ALL=sv_SE.UTF-8
WEATHER=$(curl -fsS wttr.in/?format=1 2>/dev/null | sed -E 's/\x1b\[[0-9;]*m//g' || echo "Unavailable")


# ===== VERSION & SYSTEM UPDATE CHECK =====
# Set LINUX_VERSION to Linux OS version
LINUX_VERSION="$(uname -s) $(uname -r)"
SYSTEM_UPDATE="Unknown"
LAST_UPDATE_TIME="Unknown"

# Check for available system updates (Linux only)
if command -v apt >/dev/null 2>&1; then
    if command -v apt-get >/dev/null 2>&1; then
        # Ubuntu/Debian
        if [ "$(id -u)" -eq 0 ]; then
            apt update -qq > /dev/null 2>&1
        fi
        UPDATES=$(apt list --upgradeable 2>/dev/null | grep -v "Listing..." | wc -l)
        if [ "$UPDATES" -gt 0 ]; then
            SYSTEM_UPDATE="$UPDATES package(s) can be upgraded"
            echo
            read -p "Upgrade $UPDATES package(s) now? [y/N]: " RESP
            if [[ "$RESP" =~ ^[Yy]$ ]]; then
                sudo apt update && sudo apt upgrade
            fi
        else
            SYSTEM_UPDATE="System up to date"
        fi
        # Get last update time from /var/lib/apt/periodic/update-success-stamp or /var/lib/apt/periodic/update-success-stamp
        if [ -f /var/lib/apt/periodic/update-success-stamp ]; then
            LAST_UPDATE_TIME=$(date -r /var/lib/apt/periodic/update-success-stamp '+%Y-%m-%d %H:%M:%S')
        elif [ -f /var/lib/apt/periodic/update-stamp ]; then
            LAST_UPDATE_TIME=$(date -r /var/lib/apt/periodic/update-stamp '+%Y-%m-%d %H:%M:%S')
        fi
    fi
elif command -v pacman >/dev/null 2>&1; then
    # Arch Linux
    UPDATES=$(checkupdates 2>/dev/null | wc -l)
    if [ "$UPDATES" -gt 0 ]; then
        SYSTEM_UPDATE="$UPDATES package(s) can be upgraded"
    else
        SYSTEM_UPDATE="System up to date"
    fi
    # Get last update time from /var/lib/pacman/sync
    if [ -d /var/lib/pacman/sync ]; then
        LAST_UPDATE_TIME=$(ls -lt --time-style='+%Y-%m-%d %H:%M:%S' /var/lib/pacman/sync | awk 'NR==2 {print $6, $7}')
    fi
elif command -v dnf >/dev/null 2>&1; then
    # Fedora
    UPDATES=$(dnf check-update 2>/dev/null | grep -E '^[a-zA-Z0-9]' | wc -l)
    if [ "$UPDATES" -gt 0 ]; then
        SYSTEM_UPDATE="$UPDATES package(s) can be upgraded"
    else
        SYSTEM_UPDATE="System up to date"
    fi
    # Get last update time from /var/lib/dnf/history.sqlite
    if [ -f /var/lib/dnf/history.sqlite ]; then
        LAST_UPDATE_TIME=$(date -r /var/lib/dnf/history.sqlite '+%Y-%m-%d %H:%M:%S')
    fi
elif command -v zypper >/dev/null 2>&1; then
    # openSUSE
    UPDATES=$(zypper list-updates 2>/dev/null | grep -v '^Loading' | grep -v '^Repository' | grep -v '^$' | wc -l)
    if [ "$UPDATES" -gt 0 ]; then
        SYSTEM_UPDATE="$UPDATES package(s) can be upgraded"
    else
        SYSTEM_UPDATE="System up to date"
    fi
    # Get last update time from /var/cache/zypp/zypp-history
    if [ -f /var/cache/zypp/zypp-history ]; then
        LAST_UPDATE_TIME=$(date -r /var/cache/zypp/zypp-history '+%Y-%m-%d %H:%M:%S')
    fi
fi

# ===== SELF-UPDATE CHECK =====
# Download latest script and make it executable

read -p "Download latest from Github script? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -n "Downloading latest script from GitHub: "
    # Animated progress bar with growing bar and percent
    BAR_LENGTH=30
    PROGRESS=0
    # Start curl in background, redirect output
    curl -fSL https://raw.githubusercontent.com/gurraoptimus/Ultrafetch/main/ultrafetch.sh -o /tmp/ultrafetch.sh 2>/dev/null &
    CURL_PID=$!
    while kill -0 $CURL_PID 2>/dev/null; do
        PROGRESS=$(( (PROGRESS + 1) % (BAR_LENGTH + 1) ))
        FILLED=$(printf '%*s' "$PROGRESS" | tr ' ' '#')
        EMPTY=$(printf '%*s' "$((BAR_LENGTH - PROGRESS))" | tr ' ' '-')
        PERCENT=$(( (PROGRESS * 100) / BAR_LENGTH ))
        printf "\r[\e[32m%s\e[0m%s] %3d%%" "$FILLED" "$EMPTY" "$PERCENT"
        sleep 0.07
    done
    wait $CURL_PID
    CURL_STATUS=$?
    printf "\r[\e[32m%*s\e[0m] 100%%\n" "$BAR_LENGTH" | tr ' ' '#'
    if [ $CURL_STATUS -eq 0 ]; then
        echo "Download complete."
        chmod +x /tmp/ultrafetch.sh
        echo "Running the latest script..."
        exec /tmp/ultrafetch.sh
    else
        echo "Failed to download the latest script. Continuing with current version."
    fi
fi

# ===== UI =====
clear

# Get last modified time of this script
SCRIPT_LAST_MODIFIED="$(date -r "$0" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || echo "Unknown")"

# Split ASCII logo into lines
mapfile -t logo_lines <<< "$ASCII" 

# Print author info with clickable links (OSC 8 hyperlinks if supported)
AUTHOR_NAME="Gurraoptimus"
ENTERPRISE_NAME="Gurraoptimus Development"
GITHUB_URL="https://github.com/gurraoptimus"
WEBSITE_URL="https://gurraoptimus.se"
PROJECT_URL="https://github.com/gurraoptimus/Ultrafetch"
PROJECT_NAME="Ultra Fetch"
LICENSE="Apache License 2.0"

#======= enterprise ========

# OSC 8 hyperlink format: \e]8;;URL\aTEXT\e]8;;\a
OSC8_WEBSITE="\e]8;;$WEBSITE_URL\a$WEBSITE_URL\e]8;;\a"
OSC8_GITHUB="\e]8;;$GITHUB_URL\a$GITHUB_URL\e]8;;\a"
OSC8_PROJECT="\e]8;;$PROJECT_NAME\a$PROJECT_NAME\e]8;;\a"
OSC8_PROJECT="\e]8;;$PROJECT_URL\a$PROJECT_URL\e]8;;\a"
OSC8_ENTERPRISE="\e]8;;$ENTERPRISE_NAME\a$ENTERPRISE_NAME\e]8;;\a"
OSC8_LICENSE="\e]8;;https://www.apache.org/licenses/LICENSE-2.0\a$LICENSE\e]8;;\a"

printf "${BOLD}${CYAN}Written by %s${RESET}\n${WHITE}GitHub:${RESET} %b\n${CYAN}Website:${RESET} %b\n${GREEN}Project:${RESET} %b\n${YELLOW}License:${RESET} %b\n${MAGENTA}Enterprise:${RED} %b\n\n" "$AUTHOR_NAME" "$OSC8_GITHUB" "$OSC8_WEBSITE" "$OSC8_PROJECT" "$OSC8_LICENSE" "$OSC8_ENTERPRISE"

# Fastfetch-style info: label and value columns, modern color
SERVER_HOSTNAME="$(hostname)"
SERVER_PATH="$(pwd)"
info_labels=(
    "OS" "Kernel" "Uptime" "Shell" "Terminal" "Packages" "Memory" "Disk" "Battery" "Local IP (eth0)" "Weather"  "Sever Hostname" "Server Path" "Linux Version" "System Update" "Script Last Modified"
)
info_values=(
    "$OS" "$KERNEL" "$UPTIME" "$SHELL_NAME" "$TERM_NAME" "$PKGS" "$RAM_USED / $RAM_TOTAL" "$DISK_USED / $DISK_TOTAL" "$BATTERY" "$IP" "$WEATHER" "$SERVER_HOSTNAME" "$SERVER_PATH" "$LINUX_VERSION" "$SYSTEM_UPDATE" "$SCRIPT_LAST_MODIFIED"
)

# Header
printf "${BOLD}${WHITE}%s${RESET}${CYAN}@${RESET}${BOLD}${WHITE}%s${RESET} ${YELLOW}%s version${RESET}\n" "$USER_NAME" "$HOST_NAME" "$SCRIPT_VERSION"
printf "${BLUE}%0.s─" {1..44}; printf "${RESET}\n"

# Print logo and info side by side
max_logo=${#logo_lines[@]}
max_info=${#info_labels[@]}
max_lines=$(( max_logo > max_info ? max_logo : max_info ))

for ((i=0; i<max_lines; i++)); do
    # Print logo line if present, else print spaces
    if [[ -n "${logo_lines[i]:-}" ]]; then
        printf "%-38s" "${logo_lines[i]}"
    else
        printf "%-38s" ""
    fi
    # Print info label and value if present
    if [[ $i -lt $max_info ]]; then
        printf "${MAGENTA}%-14s${RESET} ${WHITE}%s${RESET}" "${info_labels[i]}:" "${info_values[i]}"
    fi
    echo
done

# Color blocks (like Fastfetch)
printf "\n"
for color in {0..7}; do
    echo -ne "\e[4${color}m   ${RESET}"
done
echo
for color in {8..15}; do
    echo -ne "\e[48;5;${color}m   ${RESET}"
done
echo -e "\n"
