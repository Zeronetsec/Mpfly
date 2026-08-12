<!-- https://github.com/Zeronetsec/Mpfly -->

<div align="center">
    <img src="https://img.shields.io/badge/Mpfly-Version%200.1-blue?style=square&logo=ruby&logoColor=red&v=1" />
    <img src="https://img.shields.io/badge/Supported%20OS-Linux-blue?style=square&logo=linux&v=1" />
    <a href="LICENSE">
        <img src="https://img.shields.io/badge/License-MPL--2.0-blue?style=square&logo=github&v=1" />
    </a>
</div>

# Mpfly
Mpfly is a CLI music player that streams local audio and web URLs using JSON playlists with automatic fallbacks.

## Features
- Stream local and network audio via `mpv` using JMOD and FMOD playlists.
- Search tracks dynamically with interactive selection and temporary queues.
- Convert playlists (M3U to JSON) and manage shortcuts with `@alias`.
- Download and compress playlist media directly from streams.
- And more features.

## Disclaimer
Please read [.docs/disclaimer.md](.docs/disclaimer.md) before using this tool. </br>
Use this software at your own risk. </br>
The author is not responsible for any damage, data loss, or issues that may result from its use.

## Installation
Quick install:
```bash
git clone https://github.com/Zeronetsec/Mpfly
bash Mpfly/install.sh
```
For more detailed installation and uninstallation instructions, see [.docs/install_and_uninstall.md](.docs/install_and_uninstall.md).

## Usage Example
```bash
mpfly --play @myalias
mpfly --search @myalias caramelldansen --play selection
mpfly --alias --chval @myalias ~/my_new_playlist/
mpfly --convert myplaylist.m3u --to json --out mpfly_playlist.json
mpfly --download @myalias --compress auto --out download/
```
And more commands.

<!-- Copyright (c) 2026 Zeronetsec -->