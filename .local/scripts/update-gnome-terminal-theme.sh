#!/bin/bash

profile_id=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')

# Get current GNOME theme
theme=$(gsettings get org.gnome.desktop.interface color-scheme)

if [[ "$theme" == "'prefer-dark'" ]]; then
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile_id/" use-theme-colors true
else
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile_id/" use-theme-colors false
fi

