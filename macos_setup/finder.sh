#!/usr/bin/env bash

# Don't show external, removable and network media on Desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# Remove Trash items after 30 days.
defaults write com.apple.finder FXRemoveOldTrashItems -bool true

# Set last open folder as the default location for new Finder windows
# defaults write com.apple.finder NewWindowTarget -string "PfLo"

# Set user home as the default location for new Finder windows
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Finder > Preferences > Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder > Preferences > Show warning before changing an extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Finder > Preferences > Show warning before removing from iCloud Drive
defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false

# Finder > Preferences > Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Finder > Preferences > When performing a search
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Finder > View > As List
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`, `Nlsv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Finder > View > Show Path Bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder > View > Show Status Bar
defaults write com.apple.finder ShowStatusBar -bool true

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Restart Finder.app
killall Finder
