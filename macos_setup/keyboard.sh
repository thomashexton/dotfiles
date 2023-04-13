#!/usr/bin/env bash

# System Preferences > Keyboard > "Key repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 5

# System Preferences > Keyboard > "Delay until repeat"
defaults write NSGlobalDomain InitialKeyRepeat -int 100

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# Disable automatic emoji substitution (i.e. use plain text smileys)
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false
