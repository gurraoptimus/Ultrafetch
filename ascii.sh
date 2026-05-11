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
RAM_USED=$(free -h | awk '/Mem:/ {print $3}')
RAM_TOTAL=$(free -h | awk '/Mem:/ {print $2}')

# ===== DISK =====
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
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
WEATHER=$(curl -fsS wttr.in/?format=1 2>/dev/null | sed -E 's/\x1b\[[0-9;]*m//g' || echo "Unavailable")

# ===== UI =====
clear

# Split ASCII logo into lines
mapfile -t logo_lines <<< "$ASCII" 

# Print author info with clickable links (OSC 8 hyperlinks if supported)
AUTHOR_NAME="Gurraoptimus"
GITHUB_URL="https://github.com/gurraoptimus"
WEBSITE_URL="https://gurraoptimus.se"
PROJECT_URL="https://github.com/gurraoptimus/ultra-fetch"
PROJECT_NAME="Ultra Fetch"
LICENSE="Apache License 2.0"

# OSC 8 hyperlink format: \e]8;;URL\aTEXT\e]8;;\a
OSC8_GITHUB="\e]8;;$GITHUB_URL\a$GITHUB_URL\e]8;;\a"
OSC8_WEBSITE="\e]8;;$WEBSITE_URL\a$WEBSITE_URL\e]8;;\a"
OSC8_PROJECT="\e]8;;$PROJECT_NAME\a$PROJECT_NAME\e]8;;\a"

printf "${BOLD}${CYAN}Written by %s${RESET}\nGitHub: %b\nWebsite: %b\nProject: %b\n\n" "$AUTHOR_NAME" "$OSC8_GITHUB" "$OSC8_WEBSITE" "$OSC8_PROJECT"

# Fastfetch-style info: label and value columns, modern color
SERVER_HOSTNAME="tailscale.taild60d34.ts.net"
SERVER_PATH="$(pwd)"
info_labels=(
    "OS" "Kernel" "Uptime" "Shell" "Terminal" "Packages" "Memory" "Disk" "Battery" "IP" "Weather" "Server Hostname" "Server Path"
)
info_values=(
    "$OS" "$KERNEL" "$UPTIME" "$SHELL_NAME" "$TERM_NAME" "$PKGS" "$RAM_USED / $RAM_TOTAL" "$DISK_USED / $DISK_TOTAL" "$BATTERY" "$IP" "$WEATHER" "$SERVER_HOSTNAME" "$SERVER_PATH"
)

# Header
printf "${BOLD}${WHITE}%s${RESET}${CYAN}@${RESET}${BOLD}${WHITE}%s${RESET}\n" "$USER_NAME" "$HOST_NAME"
printf "${BLUE}%0.s─" {1..44}; printf "${RESET}\n"

# Print logo and info side by side
max_logo=${#logo_lines[@]}
max_info=${#info_labels[@]}
max_lines=$(( max_logo > max_info ? max_logo : max_info ))

for ((i=0; i<max_lines; i++)); do
    printf "%-38b" "${logo_lines[i]:-}"
    if [[ $i -lt $max_info ]]; then
        printf "${MAGENTA}%-9s${RESET} ${WHITE}%s${RESET}" "${info_labels[i]}:" "${info_values[i]}"
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