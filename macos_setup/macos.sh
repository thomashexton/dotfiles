#!/usr/bin/env bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

source "$(dirname "$0")/../bootstrap_functions.sh"

request_sudo_privileges

################################################################################
# General UI/UX                                                                #
################################################################################

function set_mac_name() {
  printf "Please enter the desired name for your Mac: "
  read mac_name

  if [[ -z "${mac_name}" ]]; then
    echo "No input provided. No changes were made."
    exit 0
  fi

  sanitized_mac_name=$(echo -n "${mac_name}" | tr -dc '[:alnum:][:space:]' | tr '[:upper:]' '[:lower:]' | tr '[:space:]' '-')
  sanitized_mac_netbios_name=$(echo -n "${mac_name}" | tr -dc '[:alnum:]' | tr '[:lower:]' '[:upper:]' | cut -c 1-15)

  echo "You are about to set the following names:"
  echo "ComputerName: ${mac_name}"
  echo "HostName: ${sanitized_mac_name}"
  echo "LocalHostName: ${sanitized_mac_name}"
  echo "PlistHostName: ${sanitized_mac_name}"
  echo "NetBIOSName: ${sanitized_mac_netbios_name}"

  echo "Do you want to proceed? (y/n): "
  read -n 1 confirmation

  if [[ "${confirmation}" =~ [Nn] ]]; then
    echo
    echo "Operation cancelled. No changes were made."
    exit 0
  fi

  if sudo scutil --set ComputerName "${mac_name}" &&
     sudo scutil --set HostName "${sanitized_mac_name}" &&
     sudo scutil --set LocalHostName "${sanitized_mac_name}" &&
     sudo defaults write /Library/Preferences/SystemConfiguration/preferences.plist PlistHostName -string "${sanitized_mac_name}"; then
     sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "${sanitized_mac_netbios_name}" &&
     echo
     echo "Successfully set names."
  else
    echo "An error occurred. Some names might not have been updated."
    exit 1
  fi
}

set_mac_name

source "$(dirname "$0")/dock.sh"
source "$(dirname "$0")/finder.sh"
source "$(dirname "$0")/keyboard.sh"

###############################################################################
# System Preferences > Appearance > Appearance
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

# System Preferences > Appearance > Click in the scrollbar to: Jump to the spot that's clicked
defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool true

# System Preferences > General > Sidebar icon size: Large
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 3

# # Expand save panel by default
# defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
# # defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true # not a default key in MacOS

# # Expand print panel by default
# defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
# # defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true # not a default key in MacOS

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# # Automatically quit printer app once the print jobs complete
# defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable machine sleep while charging
sudo pmset -c sleep 0

# Set machine sleep to 5 minutes on battery
sudo pmset -b sleep 5

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# Allow the App Store to reboot machine on macOS updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

###############################################################################
# Safari                                                                      #
###############################################################################

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool true

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Disable AutoFill
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# Enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# Update extensions automatically
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

echo "Done. Note that some of these changes require a logout/restart to take effect."
