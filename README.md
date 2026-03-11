# waybar-mpd-module

>  Custom MPD module for Waybar featuring scrolling song titles
and a favorite playlist toggle.

## Demo

https://github.com/user-attachments/assets/52496d02-1559-4dd2-b8b1-d76a8c81f162



---

## Overview

This project provides a custom MPD module for Waybar written in Bash.

Unlike the default Waybar MPD module, this implementation supports a
marquee-style scrolling animation for long song titles and includes a
playlist favorite system using a clickable heart icon.

The module uses `mpc idle` to react to MPD events, which keeps CPU usage
extremely low while still updating instantly when the track changes.


## Features
- Smooth marquee scrolling for long song titles
- Favorite playlist toggle via clickable heart icon
- Event-driven updates using `mpc idle` (very low CPU usage)
- Modular Bash scripts for easy customization
- Simple integration with Waybar

## Scripts
There are 3 scripts that would give you the complete experience.

### **MPD marquee animation** (`mpd-waybar.sh`):
When a user clicks on the custom module that was configured for waybar, the toggle action for `mpc` has been executed.
The script listens to events via a background process, therefore there is basically close to none usage for the CPU.
The script also has an infinite while loop for the marquee animation, till the music stops.
The script is being executed once at the waybar config.

### **Add The Current Song To Playlist** :
#### Changing the heart status when clicked (`is_in_playlist.sh`):
Similarlly to how the `mpd-heart-toggle.sh` works, we wait till a user action has been made.
We check if the current playing or paused song is in the playlist that you hardcode into this script.
The script is being executed once in the waybar config.
Depending on the status:
Full Heart = Found
Empty Heart = Not Found
#### Do the action of adding or removing the song (`mpd-heart-toggle.sh`):
When clicking on the heart, we execute this script via the waybar config and get the current playing or paused song.
We then remove or add the song to the hardcoded playlist at the playlist's position.



## Installation

### Requirements
- `mpc` – https://www.musicpd.org/clients/mpc/
- `mpd` – https://www.musicpd.org/
- `bash`
- Nerd Fonts (required for icons)

Place the scripts inside your Waybar configuration directory.

### Folder structure:
```
~/.config/waybar
├── config.jsonc
├── style.css
└── scripts
    ├── mpd-waybar.sh
    ├── is_in_playlist.sh
    └── mpd-heart-toggle.sh
```

Make sure the scripts are executable:
```
chmod +x ~/.config/waybar/scripts/*.sh
```

For more examples check out my dotfiles repository.

## Configuration
1. Add the custom modules to your waybar config file:
```
"custom/mpd": {
	        "exec": "$HOME/.config/waybar/scripts/mpd-waybar.sh",
		"tail": true,
		"markup": false,
		"align": 0,
		"max-length": 30,
		"return-type": "text",
		"format": "{} |",
  		"on-scroll-up": "mpc next",
		"on-scroll-down": "mpc prev",
		"on-click": "mpc toggle"
	},
	"custom/is_in_playlist": {
		"exec": "$HOME/.config/waybar/scripts/is_in_playlist.sh",
		"format": "{}",
		"on-click": "$HOME/.config/waybar/scripts/mpd-heart-toggle.sh"
	}
```
2. You can edit the size of the module via:
- Config file - `max-length`
- `mpd-waybar.sh` -
  - WIDTH - size of the scrolling viewport.
  - MODULE_WIDTH - This pads the output so Waybar doesn't resize the module constantly.
3. Change to your playlist:
For both the scripts `is_in_playlist.sh` and `mpd-heart-toggle.sh` change the `PLAYLIST_NAME=<YOUR PLAYLIST NAME>`.

## License
MIT
