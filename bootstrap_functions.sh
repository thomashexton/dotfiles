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
      echo "Run 'brew doctor' for diagnostics."
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
  if read -t 15 -n 1 choice; then
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
    # fish
    gh
    # ghostty
    git
    karabiner
    # skhd
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
    git_work
    zsh
  )

  echo "Stowing secret packages: ${packages[*]}"
  stow -t "${HOME}" -d "${icloud_stow_path}" "${packages[@]}" --no-folding --ignore='.*\.DS_Store'
  echo "Secret configs stowed."
  
  # Handle SSH config Include for work/personal config coexistence
  setup_ssh_config_include
}


function setup_ssh_config_include() {
  local ssh_config="${HOME}/.ssh/config"
  local personal_dir="${HOME}/.ssh/personal"
  
  # Only proceed if personal directory exists (was stowed successfully)
  if [[ ! -d "${personal_dir}" ]]; then
    echo "Personal SSH directory not found, skipping Include setup."
    return 0
  fi
  
  # Check if ~/.ssh/config exists
  if [[ ! -f "${ssh_config}" ]]; then
    # If config doesn't exist, create it with the Include block
    echo "Creating ~/.ssh/config with Include directive..."
    printf '## -- START PERSONAL -- ##\n' > "${ssh_config}"
    printf '## DO NOT EDIT: Added by the personal dotfiles script\n' >> "${ssh_config}"
    printf 'Include ~/.ssh/personal/*.conf\n' >> "${ssh_config}"
    printf '## -- END PERSONAL -- ##\n' >> "${ssh_config}"
    return 0
  fi
  
  # Check if personal block already exists
  if grep -q "## -- START PERSONAL -- ##" "${ssh_config}"; then
    echo "SSH config already includes personal config"
    return 0
  fi
  
  # Append Include block after any existing roo config blocks
  echo "Adding personal config Include to ~/.ssh/config..."
  
  # Create a temporary file with the new content
  local temp_config=$(mktemp)
  
  if grep -q "## -- END ROO -- ##" "${ssh_config}"; then
    # Insert after the roo block
    awk '/## -- END ROO -- ##/ {
      print
      print ""
      print "## -- START PERSONAL -- ##"
      print "## DO NOT EDIT: Added by the personal dotfiles script https://github.com/thomashexton/dotfiles#"
      print "Include ~/.ssh/personal/*.conf"
      print "## -- END PERSONAL -- ##"
      next
    }
    { print }' "${ssh_config}" > "${temp_config}"
    mv "${temp_config}" "${ssh_config}"
  else
    # Just append at the end
    printf '\n## -- START PERSONAL -- ##\n' >> "${ssh_config}"
    printf '## DO NOT EDIT: Added by the personal dotfiles script\n' >> "${ssh_config}"
    printf 'Include ~/.ssh/personal/*.conf\n' >> "${ssh_config}"
    printf '## -- END PERSONAL -- ##\n' >> "${ssh_config}"
  fi
  
  echo "SSH config Include setup complete."
}


function convert_git_remote_to_ssh() {
  local current_url
  current_url=$(git config --get remote.origin.url)

  if [[ $current_url == https://github.com/* ]]; then
    echo "Converting Git remote from HTTPS to SSH..."
    local repo_path
    repo_path=$(echo "$current_url" | sed -E 's|https://github.com/(.*)|\1|')
    git remote set-url origin "git@github.com:$repo_path"
    echo "Git remote URL updated to SSH."
  elif [[ $current_url == git@github.com:* ]]; then
    echo "Git remote is already using SSH."
  else
    echo "Warning: Git remote URL is not in the expected format. Skipping conversion."
  fi
}


function display_completion_message() {
  echo "Bootstrap complete."
}
