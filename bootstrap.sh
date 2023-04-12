#!/usr/bin/env bash

################################################################################
# Title: MacOS dotfiles bootstrap script
# Description: This script sets up a new MacOS system with the user's desired
#              configuration files, programs and tools. It does so by installing
#              Homebrew, checking for Rosetta 2 (if applicable), installing
#              packages and apps from a Brewfile, installing Oh My Zsh, the
#              Powerlevel10k zsh theme, additional zsh plugins and linking
#              custom configuration files. It also adds asdf version manager
#              plugins and restores configs with mackup.
#
# Author: Thomas Hexton
# Date: April 2023
# Version: 1
# Usage: Run the script with ./bootstrap.sh
#
# Notes:
#  - This script requires a Mac using Intel CPU or Apple Silicon.
#  - This script should be run with administrator privileges.
#  - This script is opinionated and tailored to the author's preferences.
#
################################################################################

# Open log file for writing and append current date/time
LOGFILE="${HOME}/.bootstrap.log"
echo "$(date): Starting bootstrap script..." | tee -a "${LOGFILE}"
exec > >(tee -a "${LOGFILE}") 2>&1

# This will cause the script to exit immediately if any command returns a non-zero exit status.
# It will also cause the script to exit if any unset variable is used,
# and will cause pipes to exit with a non-zero status if any command in the pipe fails.
set -euo pipefail

echo "Bootstrapping..."

# Import all the bootstrap functions
source bootstrap_functions.sh

# Main script execution starts here
request_sudo_privileges
install_homebrew
install_homebrew_packages_and_apps
install_oh_my_zsh
install_additional_zsh_plugins
install_powerlevel10k
link_custom_configs
install_asdf_plugins
restore_configs_with_mackup
display_completion_message
