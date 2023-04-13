#!/usr/bin/env bash

# System Preferences > Desktop & Dock > Dock > Size:
defaults write com.apple.dock tilesize -int 64

# System Preferences > Desktop & Dock > Dock > Magnification:
defaults write com.apple.dock magnification -bool false

# System Preferences > Desktop & Dock > Dock > Position on screen:
defaults write com.apple.dock orientation -string left

# System Preferences > Desktop & Dock > Dock > Minimise windows using:
defaults write com.apple.dock mineffect -string "scale"

# System Preferences > Desktop & Dock > Dock > Minimise windows into application icon:
defaults write com.apple.dock minimize-to-application -bool true

# System Preferences > Desktop & Dock > Dock > Automatically hide and show the Dock:
defaults write com.apple.dock autohide -bool true

# System Preferences > Desktop & Dock > Dock > Automatically hide and show the Dock (duration)
defaults write com.apple.dock autohide-time-modifier -int 0

# System Preferences > Desktop & Dock > Dock > Automatically hide and show the Dock (delay)
defaults write com.apple.dock autohide-delay -int 0

# System Preferences > Desktop & Dock > Dock > Animate opening applications:
defaults write com.apple.dock launchanim -bool false

# System Preferences > Desktop & Dock > Dock > Show indicators for open applications:
defaults write com.apple.dock show-process-indicators -bool true

# System Preferences > Desktop & Dock > Dock > Show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# System Preferences > Desktop & Dock > Mission Control > Automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Restart Dock.app
killall Dock
