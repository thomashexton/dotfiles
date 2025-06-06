WORKDIR=$(pwd)

# Asks for the administrator password upfront
function request_sudo_privileges() {
  echo "Requesting sudo privileges..."
  sudo -v

  # Keep-alive: update existing `sudo` timestamp until `bootstrap` script has finished
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &
}


# Installs Homebrew on Apple Silicon Macs and sets up the environment
function install_homebrew() {
  local machine_arch=$(uname -m)
  if [[ ${machine_arch} == "arm64" ]]; then
    # Check if Homebrew is already installed
    if [[ -d "/opt/homebrew" ]]; then
      echo "Homebrew already installed..."
    else
      # Install Homebrew
      echo "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "${HOME}/.zprofile"
    fi

    # Set up Homebrew environment
    echo "Setting up Homebrew environment..."
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Use a simple version check instead of brew doctor
    if brew --version &>/dev/null; then
      echo "Homebrew is installed and functioning."
    else
      echo "Error: Homebrew installation appears to be broken."
      exit 1
    fi

    # Run brew doctor with a timeout, but don't halt execution
    echo "Running brew doctor check (with 10 second timeout)..."
    if command -v timeout &>/dev/null; then
      # Use timeout command if available
      if timeout 10 brew doctor; then
        echo "Homebrew installation is healthy."
      else
        echo "Warning: brew doctor found issues. Run 'brew doctor' manually to see details."
        echo "Continuing anyway..."
      fi
    else
      # Fallback method if timeout command isn't available
      echo "To check for Homebrew issues, run 'brew doctor' manually."
    fi
  else
    echo "To install Homebrew, this script requires a Mac using Apple Silicon."
    exit 1
  fi

  # Update Homebrew
  echo "Updating Homebrew..."
  brew update
}


# Installs packages and apps from Brewfile
function install_from_brewfile() {
  local BREWFILE=$1
  if [ ! -f "dependencies/$BREWFILE" ]; then
    echo "$BREWFILE not found in dependencies folder. Please check your files and try again."
    return 1
  fi
  echo "Installing packages and apps with Homebrew from $BREWFILE..."
  brew bundle --file="${WORKDIR}/dependencies/$BREWFILE" --no-upgrade
}


# Installs packages and apps from Brewfile
function install_homebrew_packages_and_apps() {
  echo "Tapping common repos and installing common packages..."
  install_from_brewfile "Brewfile"

  echo -n "Please enter 'h' for home or 'w' for work: "
  if read -t 5 -n 1 choice; then
    echo
    if [[ ${choice} =~ [HhWw] ]]; then
      if [[ ${choice} =~ [Hh] ]]; then
        install_from_brewfile "Brewfile_home"
      else
        install_from_brewfile "Brewfile_work"
      fi
    else
      echo "Invalid choice. Please enter either 'h' or 'w'."
    fi
  else
    echo
    echo "Timeout reached. You didn't choose a 'home' or 'work' Brewfile, so only common packages were installed."
  fi
}


function stow_configs() {
  local packages=(
    aerospace
    alacritty
    editorconfig
    fish
    gh
    ghostty
    git
    karabiner
    skhd
    stow
    zed
    zim
    zsh
  )

  echo "Stowing packages: ${packages[@]}"
  stow -t "${HOME}" "${packages[@]}" --no-folding --ignore='.*\.DS_Store'
  echo "Configs stowed."
}


function stow_secret_configs() {
  local icloud_stow_path="${HOME}/Library/Mobile Documents/com~apple~CloudDocs/stow"

  if [ ! -d "${icloud_stow_path}" ]; then
    echo "Error: iCloud Drive stow directory not found at ${icloud_stow_path}. Aborting."
    return 1
  fi

  local packages=(
    ssh
    git_canva
    zsh
  )

  echo "Stowing secret packages: ${packages[*]}"
  stow -t "${HOME}" -d "${icloud_stow_path}" "${packages[@]}" --no-folding --ignore='.*\.DS_Store'
  echo "Secret configs stowed."
}


function display_completion_message() {
  echo "Bootstrap complete."
}
