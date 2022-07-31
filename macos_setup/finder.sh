#!/bin/bash

# Don't show external, removable and network media on Desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# Search on current folder.
defaults write com.apple.finder FXDefaultSearchScope -string SCcf

# Remove Trash items after 30 days.
defaults write com.apple.finder FXRemoveOldTrashItems -bool true

# Show all file extensions.
defaults write -g AppleShowAllExtensions -bool true

# Restart Finder.app.
killall Finder
