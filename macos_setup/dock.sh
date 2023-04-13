#!/usr/bin/env bash

# System Preferences > Dock > "Position on screen"
defaults write com.apple.dock orientation -string left

# System Preferences > Dock > Size:
defaults write com.apple.dock tilesize -int 64

# System Preferences > Dock > Magnification:
defaults write com.apple.dock magnification -bool false

# System Preferences > Dock > Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# System Preferences > Dock > Automatically hide and show the Dock (duration)
defaults write com.apple.dock autohide-time-modifier -int 0

# System Preferences > Dock > Automatically hide and show the Dock (delay)
defaults write com.apple.dock autohide-delay -int 0

# System Preferences > Dock > Show indicators for open applications
defaults write com.apple.dock show-process-indicators -bool true

# System Preferences > Dock > Minimize windows using: Scale effect
defaults write com.apple.dock mineffect -string "scale"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# System Preferences > Dock > "Show recent applications in Dock"
defaults write com.apple.dock show-recents -bool false

# System Preferences > Mission Control > Automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Restart Dock.app
killall Dock
