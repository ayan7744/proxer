# proxer - automatic proxy script
<!--- ![built-with-love](https://img.shields.io/static/v1?label=Built%20with&message=%E2%9D%A4&color=red&style=for-the-badge) &nbsp; -->
![made-with-bash](https://img.shields.io/static/v1?label=Written%20in&message=bash&color=blue&style=for-the-badge) &nbsp;
![works-on-linux](https://img.shields.io/static/v1?label=Works%20on&message=Linux&color=green&style=for-the-badge)

Minimal proxy script for arch and arch based distributions. Sets or unsets a proxy depending on the connected WiFi. WiFis can be identified by both SSID or BSSID. Read `proxer.rc` for more information.
## Installation and Usage
Add the following line to your `.bashrc` or `.zshrc`.
```bash
source /path/to/proxer
```
Or alternatively, run the following commands.
```bash
curl "https://raw.githubusercontent.com/ayan7744/proxer/master/proxer" > ~/.local/bin/proxer
[ -f ~/.bashrc ] && echo "source ~/.local/bin/proxer" >> ~/.bashrc
[ -f ~/.zshrc ] && echo "source ~/.local/bin/proxer" >> ~/.zshrc
```
## Configuration
Read `~/.config/proxer/proxer.rc` or `$XDG_CONFIG_HOME/proxer/proxer.rc` for information.
## Dependencies
* NetworkManager
## Fish shell?
Coming soon...
