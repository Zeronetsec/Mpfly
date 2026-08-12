<!-- https://github.com/Zeronetsec/Mpfly -->

# Installation
`install.sh` optional options (can be used together):
- `--home=<path>`
- └── override `$HOME` value.
- `--backup`
- └── create a backup of the existing source installation before replacing it.

### Usage
```bash
git clone https://github.com/Zeronetsec/Mpfly
bash Mpfly/install.sh <option>
```

# Uninstallation
`uninstall.sh` optional options (can be used together):
- `--home=<path>`
- └── override `$HOME` value.
- `--remove-backup`
- └── remove all backup found.
- `--no-remove-config`
- └── no remove `~/.mpfly`.

### Usage
```bash
export prefix="${PREFIX:-/usr}"
bash $prefix/opt/mpfly/uninstall.sh <option>
```

<!-- Copyright (c) 2026 Zeronetsec -->