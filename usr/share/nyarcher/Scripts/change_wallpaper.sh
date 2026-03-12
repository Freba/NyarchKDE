#!/bin/bash

# Get color_last property from kde-material-you-colors config
color_last=$(grep "^color_last=" ~/.config/kde-material-you-colors/config.conf | cut -d'=' -f2)

# Check if color_last was found
if [ -n "$color_last" ]; then
    # Get GTK color scheme preference to determine dark/light mode
    gtk_color_scheme=$(gsettings get org.gnome.desktop.interface color-scheme)

    # Determine the argument to pass to adwmu (light or dark)
    if [ "$gtk_color_scheme" = "'default'" ]; then
        # If default, check the explicit dark theme preference
        prefer_dark=$(gsettings get org.gnome.desktop.interface gtk-application-prefer-dark-theme)
        if [ "$prefer_dark" = "true" ]; then
            adwmu_scheme="dark"
        else
            adwmu_scheme="light"
        fi
    elif [ "$gtk_color_scheme" = "'prefer-dark'" ]; then
        adwmu_scheme="dark"
    elif [ "$gtk_color_scheme" = "'prefer-light'" ]; then
        adwmu_scheme="light"
    else
        # Fallback to light if something unexpected happens
        adwmu_scheme="light"
    fi

    # Run adwmu with the color and the detected scheme
    adwmu -c "$color_last" "$adwmu_scheme" -a
else
    echo "Error: color_last property not found in config file"
    exit 1
fi
