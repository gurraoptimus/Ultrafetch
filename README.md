
# 🚀 Ultra Fetch

```
 ╔═══════════════════════════════╗
 ║    ULTRA FETCH v1.0           ║
 ║  System Info Made Beautiful   ║
 ╚═══════════════════════════════╝
```

Modern terminal system info script inspired by Neofetch and Fastfetch.

## Overview

Ultra Fetch is a Bash script that displays system details in a colorful, compact layout.

It shows:

- OS and kernel
- Uptime
- Shell and terminal
- Package count
- Memory and disk usage
- Battery status
- Local IP address
- Weather (`wttr.in`)
- System update status

## Features

- Styled output with ANSI colors
- Side-by-side ASCII logo and info table
- OSC 8 clickable links (in supported terminals)
- Distro-aware package/update checks
- Error handling with line number and exit code

## Requirements

- Linux
- Bash 4+
- Core tools: `grep`, `awk`, `sed`, `df`, `free`, `hostname`, `uname`
- Optional:
  - `curl` for weather
  - `acpi` for battery percentage
  - Package tools (`apt`, `pacman`, `dnf`, `zypper`) for update checks

## Installation

```bash
chmod +x ultrafetch.sh
./ultrafetch.sh
```

## Notes

- Weather uses locale `sv_SE.UTF-8`.
- On Debian/Ubuntu, the script may prompt for upgrade.
- Update checks depend on available package manager tools.

## Author

- Gurraoptimus
- GitHub: [gurraoptimus](https://github.com/gurraoptimus)
- Website: [gurraoptimus.se](https://gurraoptimus.se)
- Project: [ultra-fetch](https://github.com/gurraoptimus/ultra-fetch)

## License

Apache License 2.0