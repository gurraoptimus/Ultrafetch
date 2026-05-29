# Ultra Fetch Linux Guide (Short)

## 1) Download and run from `/tmp`

```bash
curl -fSL https://raw.githubusercontent.com/gurraoptimus/Ultrafetch/main/ultrafetch.sh -o /tmp/ultrafetch.sh
chmod +x /tmp/ultrafetch.sh
/tmp/ultrafetch.sh
```

## 2) Add `/tmp/ultrafetch.sh` to `.bashrc`

```bash
echo 'alias ultrafetch="/tmp/ultrafetch.sh"' >> ~/.bashrc
source ~/.bashrc
```

## 3) Run with shortcut

```bash
ultrafetch
```

Note: `/tmp` can be cleared after reboot. Re-download if needed.
