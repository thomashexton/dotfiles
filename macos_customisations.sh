#!/bin/bash

echo "Starting macOS Customizations Script..."

# Hack to fix Aerospace from rendering tiny window icons
defaults write com.apple.dock expose-group-apps -bool true && killall Dock
defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer

# ======================================
# 1. Adjust Key Repeat Rate and Delay
# ======================================
echo "Setting fast key repeat rate and short delay..."
defaults write NSGlobalDomain KeyRepeat -int 4 # Faster key repeat rate
defaults write NSGlobalDomain InitialKeyRepeat -int 16 # Shorter delay before repeat starts
defaults write -g ApplePressAndHoldEnabled -bool false

# ======================================
# 2. Show Hidden Files and File Extensions
# ======================================
echo "Enabling hidden files and file extensions in Finder..."
defaults write com.apple.finder AppleShowAllFiles -bool true # Show hidden files
defaults write NSGlobalDomain AppleShowAllExtensions -bool true # Show all file extensions

# ======================================
# 3. Set Finder Preferences
# ======================================
echo "Customizing Finder settings..."
defaults write com.apple.finder NewWindowTarget -string "PfHm" # Default to Home folder
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" # Use List View

# ======================================
# 4. Speed Up Dock Animations
# ======================================
echo "Speeding up Dock animations..."
defaults write com.apple.dock autohide -bool true # Auto-hide Dock
defaults write com.apple.dock autohide-time-modifier -float 1.0 # Faster hide/show
defaults write com.apple.dock autohide-delay -float 0.025 # Shorten the delay before the Dock appears
defaults write com.apple.dock launchanim -bool false # Disable launch animation
killall Dock # Restart Dock to apply changes

# ======================================
# 5. Disable Screenshot Thumbnails and Change Save Location
# ======================================
echo "Customizing screenshot behavior..."
mkdir -p ~/Screenshots # Create Screenshots directory
defaults write com.apple.screencapture location -string "~/Screenshots" # Save to ~/Screenshots
defaults write com.apple.screencapture show-thumbnail -bool false # Disable thumbnails
killall SystemUIServer # Apply changes to System UI

# ======================================
# 6. Reduce Transparency
# ======================================
echo "Reducing system transparency for performance boost..."
defaults write com.apple.universalaccess reduceTransparency -bool true

# ======================================
# 7. Speed Up Mission Control Animations
# ======================================
echo "Speeding up Mission Control animations..."
defaults write com.apple.dock expose-animation-duration -float 0.1

# ======================================
# 8. Prevent Photos App from Auto-Opening
# ======================================
echo "Preventing Photos app from opening automatically..."
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# ======================================
# 9. Disable Auto-Correct
# ======================================
echo "Disabling auto-correct..."
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# ======================================
# 10. Require Password Immediately After Sleep
# ======================================
echo "Enabling immediate password requirement after sleep/screensaver..."
defaults write com.apple.screensaver askForPassword -int 1 # Require password
defaults write com.apple.screensaver askForPasswordDelay -int 0 # No delay


defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

defaults write com.apple.LaunchServices LSQuarantine -bool false


defaults write com.apple.loginwindow TALLogoutSavesState -bool false

echo "macOS customizations applied! Some changes may require a restart to take effect."
