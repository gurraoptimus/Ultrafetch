<div align="center">

# 🚀 Ultra Fetch

**A blazingly fast system information display tool**

Inspired by [Neofetch](https://github.com/dylanaraps/neofetch) and [Fastfetch](https://github.com/fastfetch-cli/fastfetch)

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)
[![GitHub](https://img.shields.io/badge/GitHub-gurraoptimus-black?logo=github)](https://github.com/gurraoptimus)

</div>

---

## ✨ Features

- ⚡ **Ultra-fast** system information retrieval
- 🎨 **Beautiful colored terminal output** with modern styling
- 🖼️ **ASCII art logos** displayed side-by-side with system info
- 📊 **Comprehensive system details**: OS, Kernel, Uptime, Shell, Terminal, Packages
- 💾 **Resource monitoring**: Memory, Disk, Battery status
- 🌍 **Network & Weather**: Local IP address and weather conditions
- 📦 **Update checking**: APT, Pacman, DNF, and Zypper package managers


## 🆕 More Features & Updates

- 🔄 **Self-update prompt**: Option to download and run the latest script version directly from GitHub, with an animated progress bar.
- 🌦️ **Live weather info**: Fetches and displays current weather for your location.
- 🔋 **Battery status**: Supports both ACPI and sysfs battery info for laptops.
- 🖥️ **Terminal & shell detection**: Shows your current terminal and shell.
- 🧑‍💻 **User & host display**: Shows the current user and hostname in the header.
- 🕒 **Last script modification time**: Displays when the script was last updated on your system.
- 🖼️ **Modern, colored output**: Uses bold and colorized labels for a clean, modern look.
- 🟩 **Animated color blocks**: Fastfetch-style color bars for visual flair.
- 🛡️ **Robust error handling**: Script exits gracefully and restores cursor on error or interruption.
- 🏷️ **Clickable hyperlinks**: OSC 8 hyperlinks for GitHub, website, and license (if supported by your terminal).

## Installation

```bash
git clone https://github.com/gurraoptimus/ultrafetch.git
cd ultrafetch
chmod +x ultrafetch.sh
```

## Usage

```bash
./ultrafetch.sh
```

## Example Output

```text
user@host 1.0 version
────────────────────────────────────────────
<ascii logo>   OS: Ubuntu 24.04 LTS
               Kernel: 6.x.x
               Uptime: 2 hours
               Memory: 3.1Gi / 15.5Gi
```

## Project

- Repository: [Ultra Fetch](https://github.com/gurraoptimus/ultra-fetch)

## License

[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)