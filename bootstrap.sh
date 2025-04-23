#!/usr/bin/env bash

################################################################################
# Title: MacOS dotfiles bootstrap script
# Description: This script sets up a new MacOS system with the user's desired
#              configuration files, programs and tools. It does so by installing
#              Homebrew, installing packages and apps from Brewfiles, and  
#              using GNU stow to link configuration files to their appropriate
#              locations. The script supports both home and work environments
#              and can optionally skip Homebrew setup to only stow configs.
#
# Author: Thomas Hexton
# Date: April 2025
# Version: 2
# Usage: Run the script with ./bootstrap.sh OR ./bootstrap.sh --stow-only
#
# Notes:
#  - This script requires a Mac using Apple Silicon.
#  - This script should be run with administrator privileges unless using --stow-only.
#  - This script is opinionated and tailored to the author's preferences.
#
################################################################################

# Set XDG environment variables if they are not already set
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Log file for writing in the XDG cache directory
LOGFILE="${XDG_CACHE_HOME}/bootstrap.log"
# Ensure the directory exists
mkdir -p "${XDG_CACHE_HOME}"
# Output into the log file
echo "$(date): Starting bootstrap script..." | tee -a "${LOGFILE}"
exec > >(tee -a "${LOGFILE}") 2>&1

# This will cause the script to exit immediately if any command returns a non-zero exit status.
# It will also cause the script to exit if any unset variable is used,
# and will cause pipes to exit with a non-zero status if any command in the pipe fails.
set -euo pipefail

echo "Bootstrapping..."

# Import all the bootstrap functions
source "$(dirname "$0")/bootstrap_functions.sh"

# Check for stow-only flag
if [[ "${1-}" == "--stow-only" ]]; then
  echo "Running in stow-only mode. Skipping Homebrew setup."
  stow_configs
  stow_secret_configs || true
else
  # Normal full bootstrap process
  request_sudo_privileges
  install_homebrew
  install_homebrew_packages_and_apps
  stow_configs
  stow_secret_configs
fi

display_completion_message
