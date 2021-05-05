# proxer - automatic proxy script
Minimal proxy connection script. Sets proxy depending on the WiFi it's connected to. WiFi can be identified using both SSID or BSSID. Read `~/.config/proxer/proxer.rc` or `$XDG_CONFIG_HOME/proxer/proxer.rc` for more information.
## Installation and Usage
Add the following line to your `.bashrc` or `.zshrc`.
```bash
source /path/to/proxer.bash
```
Or alternatively, run the following commands.
```bash
curl "https://raw.githubusercontent.com/ayan7744/proxer/master/proxer.bash" > ~/.local/bin/proxer
[ -f ~/.bashrc ] && echo "source ~/.local/bin/proxer" >> ~/.bashrc
[ -f ~/.zshrc ] && echo "source ~/.local/bin/proxer" >> ~/.zshrc
```
## Configuration
Read `~/.config/proxer/proxer.rc` or `$XDG_CONFIG_HOME/proxer/proxer.rc` for information.
