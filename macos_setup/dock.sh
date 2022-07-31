#!/bin/bash

# Enable auto hide.
defaults write com.apple.dock autohide -bool true

# Hide process indicators.
defaults write com.apple.dock show-process-indicators -bool false

# Set orientation.
defaults write com.apple.dock orientation -string left

# Don't show recent applications.
defaults write com.apple.dock show-recents -bool false

# Show only active applications.
defaults write com.apple.dock static-only -bool true

# Clear persistent applications.
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-others -array
defaults write com.apple.dock recent-apps -array

# Change Dock size.
defaults write com.apple.dock tilesize -float 44

# Lock Dock size.
defaults write com.apple.Dock size-immutable -bool true

# Restart Dock.app.
killall Dock
