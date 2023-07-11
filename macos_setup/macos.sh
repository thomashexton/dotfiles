#!/usr/bin/env bash

# Close any open System Preferences panes, to prevent them from overriding settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

source "$(dirname "$0")/../bootstrap_functions.sh"
source "$(dirname "$0")/macos_functions.sh"

request_sudo_privileges
set_mac_name


################################################################################

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1


################################################################################
# Dock
################################################################################
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


################################################################################
# Finder
################################################################################
# Finder > Settings > General > Show these items on the desktop:
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false

# Finder > Settings > General > New Finder windows show:
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Finder > Settings > Advanced > Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder > Settings > Advanced > Show warning before changing an extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Finder > Settings > Advanced > Show warning before removing from iCloud Drive
defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false

# Finder > Settings > Advanced > Show warning before emptying the Bin
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Finder > Settings > Advanced > Remove items from the Bin after 30 days
defaults write com.apple.finder FXRemoveOldTrashItems -bool true

# Finder > Settings > Advanced > Keep folders on top > In windows when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Finder > Settings > Advanced > When performing a search
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

# Restart Finder.app
killall Finder


################################################################################
# Keyboard
################################################################################
# System Preferences > Keyboard > "Key repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 2

# System Preferences > Keyboard > "Delay until repeat"
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# Disable automatic emoji substitution (i.e. use plain text smileys)
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false


################################################################################
# Safari
################################################################################
# # Enable the Develop menu and the Web Inspector in Safari
# defaults write com.apple.Safari IncludeDevelopMenu -bool true
# defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Disable AutoFill
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# Enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# Update extensions automatically
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

echo "Done. Note that some of these changes require a logout/restart to take effect."
