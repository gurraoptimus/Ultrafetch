# Contributing to Ultra Fetch

Thanks for helping improve Ultra Fetch.

## Linux setup

Clone and run from the repository root:

```bash
git clone https://github.com/gurraoptimus/ultrafetch.git
cd ultrafetch
chmod +x ultrafetch.sh
./ultrafetch.sh
```

## Test the temporary updater build in /tmp

The script can download a new version and run it from `/tmp/ultrafetch.sh`.
To test this manually:

```bash
curl -fSL https://raw.githubusercontent.com/gurraoptimus/Ultrafetch/main/ultrafetch.sh -o /tmp/ultrafetch.sh
chmod +x /tmp/ultrafetch.sh
/tmp/ultrafetch.sh
```

## Add a bash shortcut in .bashrc

If you are on Linux and use bash, add this alias to your `~/.bashrc`:

```bash
alias ultrafetch="$HOME/ultrafetch/ultrafetch.sh"
```

Then reload bash:

```bash
source ~/.bashrc
ultrafetch
```

## Before you open a pull request

- Keep shell scripts POSIX-friendly where possible.
- Run the script on a Linux machine and verify output formatting.
- If your change affects update behavior, test both local execution and `/tmp/ultrafetch.sh` flow.
- Update README.md when user-facing behavior changes.

## Pull request checklist

- Describe what changed and why.
- Include terminal output or screenshots for visible output changes.
- Keep changes focused and avoid unrelated edits.

Thank you for contributing.
