#!/usr/bin/env xonsh
#
# gametile.xsh
#
# This script takes a game window and makes sure that it's the size given as
# well as in the area provided.

import sys, time

if len(sys.argv) != 5:
    print("Usage: gametile.xsh x y width height")
    sys.exit(1)

# Area provided assumed to be both valid and reasonable.
game_x      = int(sys.argv[1])
game_y      = int(sys.argv[2])
game_width  = int(sys.argv[3])
game_height = int(sys.argv[4])

# Start by trying to autodetect a game. Some steam games have this set.
game_wid=$(boxdotool select -c --all --has-property STEAM_GAME).strip("\n")

if not game_wid:
    # Others will set a classname of "steam_app_xyz", so try that too.
    game_wid=$(boxdotool select -c --all --classname steam_app)

    if not game_wid:
        notify-send "Click on a game window to fix it."

        # Send xprop to find the window and tag it too.
        xprop -f STEAM_GAME 32x -set STEAM_GAME 1
        game_wid=$(boxdotool select -c --all --has-property STEAM_GAME)
    else:
        xprop -id @(game_wid) -f STEAM_GAME 32x -set STEAM_GAME 1

# Make sure the window isn't fullscreen, or it will ignore size requests.
![boxdotool \
    select \
        -c \
        --has-property \
            STEAM_GAME \
        windowstate \
            --remove \
                fullscreen]

# Some games (and windows) set WM_HINTS to specify attributes like where to
# place the window initially, a minimum size, a maximum size, and other goodies.
# Many window managers will prevent a user from resizing a window if the resize
# conflicts with the hints provided.
# Instead of trying to update the relevant parts of WM_HINTS, just get rid of
# them.
![xprop -id @(game_wid) -remove WM_HINTS]

# On the other hand, titlebar decorations are controlled by _MOTIF_WM_HINTS.
# A specific value must bet set to indicate that titlebar decorations are to
# be removed.
![boxdotool \
    select \
        -c \
        --has-property \
            STEAM_GAME \
    windowdecoration \
        none]

# Now that the motif hints are in place, resize the window. Since the motif
# hints clear all decorations, this size is the exact outgoing size.
# Finally, tag the window to make it easy to discover later.
![boxdotool \
    select \
        -c \
        --has-property \
            STEAM_GAME \
    windowmove \
        @(game_x) \
        @(game_y) \
    windowsize \
        @(game_width) \
        @(game_height) \
    set_window \
        --class \
            boxgame \
        --classname \
            boxgame ]
