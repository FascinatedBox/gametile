gametile
========

### Overview

This is a simple script that I use to adjust a game window before I play the
game. This script does the following:

* Sets `STEAM_GAME` atom to 1 on a game window.

* Removes fullscreen state, if present.

* Removes `WM_HINTS`, allowing the game window to be resized.

* Sets `_MOTIF_WM_HINTS` to no decorations.

* Position and size the window according to parameters provided.

### Usage

`gametile.xsh x y width height`

The script will attempt to autodetect an existing game window. If it cannot do
so, it will prompt the user to click on a window and fix that window.

### Requirements

* Linux + X11. This script will not work with Wayland.

* Xonsh (Scripting language)

* boxdotool, my xdotool fork :)

* xprop (if you're using X11, you probably have this already).
