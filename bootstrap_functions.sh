WORKDIR=$(pwd)
DOTFILES_STATE_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/dotfiles-bootstrap"
DOTFILES_PROFILE_FILE="${DOTFILES_STATE_DIR}/profile"
mkdir -p "${DOTFILES_STATE_DIR}"

# Helpers for persisting the machine profile (home/work)
function set_bootstrap_profile() {
  local profile=$1
  printf "%s\n" "${profile}" > "${DOTFILES_PROFILE_FILE}"
}

function get_bootstrap_profile() {
  if [[ -f "${DOTFILES_PROFILE_FILE}" ]]; then
    tr -d '\n' < "${DOTFILES_PROFILE_FILE}"
  fi
}

function current_profile() {
  if [[ "${WORK:-}" == "true" ]]; then
    echo "work"
    return
  fi

  local saved_profile
  saved_profile=$(get_bootstrap_profile)
  if [[ "${saved_profile}" == "work" || "${saved_profile}" == "home" ]]; then
    echo "${saved_profile}"
  fi
}

function is_work_machine() {
  [[ "$(current_profile)" == "work" ]]
}

function ensure_profile_choice() {
  if [[ "${WORK:-}" == "true" ]]; then
    echo "WORK=true detected; using work profile for this run."
    return 0
  fi

  local saved_profile
  saved_profile=$(get_bootstrap_profile)
  if [[ "${saved_profile}" == "home" || "${saved_profile}" == "work" ]]; then
    echo "Using stored profile '${saved_profile}'."
    echo "Remove ${DOTFILES_PROFILE_FILE} to re-prompt."
    return 0
  fi

  while true; do
    read -n 1 -p "Please enter 'h' for home or 'w' for work: " choice
    echo
    if [[ ${choice} =~ [Hh] ]]; then
      set_bootstrap_profile "home"
      echo "Saved 'home' profile for future runs."
      break
    elif [[ ${choice} =~ [Ww] ]]; then
      set_bootstrap_profile "work"
      echo "Saved 'work' profile for future runs."
      break
    else
      echo "Invalid choice. Please enter either 'h' or 'w'."
    fi
  done
}

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

  local profile_choice
  profile_choice=$(current_profile)
  if [[ -z "${profile_choice}" ]]; then
    echo "Error: no profile selected. Run ensure_profile_choice first." >&2
    exit 1
  fi

  if [[ "${profile_choice}" == "home" ]]; then
    install_from_brewfile "Brewfile_home"
  elif [[ "${profile_choice}" == "work" ]]; then
    install_from_brewfile "Brewfile_work"
  fi
}


function stow_configs() {
  local packages=(
    amp
    aerospace
    alacritty
    claude
    codex
    editorconfig
    # fish
    gh
    git
    kanata
    stow
    tmux
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
  local profile_choice
  profile_choice=$(current_profile)

  if [ ! -d "${icloud_stow_path}" ]; then
    echo "Error: iCloud Drive stow directory not found at ${icloud_stow_path}. Aborting."
    return 1
  fi

  if [[ -z "${profile_choice}" ]]; then
    echo "Error: no profile selected. Run ensure_profile_choice first." >&2
    return 1
  fi

  local profile_stow_path="${icloud_stow_path}/${profile_choice}"
  if [ ! -d "${profile_stow_path}" ]; then
    echo "Error: profile-scoped iCloud Drive stow directory not found at ${profile_stow_path}."
    return 1
  fi

  local packages=(
    ssh
    zsh
  )
  local existing_packages=()

  for package in "${packages[@]}"; do
    if [[ -d "${profile_stow_path}/${package}" ]]; then
      existing_packages+=("${package}")
    fi
  done

  if [[ ${#existing_packages[@]} -eq 0 ]]; then
    echo "No secret packages found for profile '${profile_choice}' in ${profile_stow_path}."
  else
    echo "Stowing secret packages for profile '${profile_choice}': ${existing_packages[*]}"
    if ! stow -t "${HOME}" -d "${profile_stow_path}" "${existing_packages[@]}" --no-folding \
      --ignore='.*\.DS_Store' \
      --ignore='.*_include\.conf$'; then
      echo "Error: stowing secret packages failed for profile '${profile_choice}'." >&2
      return 1
    fi
    echo "Secret configs stowed."
  fi

  # Handle SSH config Include for work/personal config coexistence
  setup_ssh_config_include "${profile_stow_path}"
}


function setup_ssh_config_include() {
  local profile_stow_path="${1:?profile stow path required}"
  local ssh_config="${HOME}/.ssh/config"
  local include_dir="${profile_stow_path}/ssh/.ssh"
  local begin_mark="## -- START THOMAS -- ##"
  local end_mark="## -- END THOMAS -- ##"
  local temp_config
  temp_config=$(mktemp)
  local temp_block
  temp_block=$(mktemp)
  local include_files=()
  local include_file

  if [[ -d "${include_dir}" ]]; then
    while IFS= read -r include_file; do
      include_files+=("${include_file}")
    done < <(find "${include_dir}" -maxdepth 1 -type f -name '*_include.conf' | sort)
  fi

  if [[ -f "${ssh_config}" ]]; then
    # Remove any legacy personal block or previous dotfiles block before inserting.
    awk -v begin="${begin_mark}" -v end="${end_mark}" '
      $0 == begin { in_block = 1; next }
      $0 == end { in_block = 0; next }
      $0 == "## -- START PERSONAL -- ##" { in_block = 1; next }
      $0 == "## -- END PERSONAL -- ##" { in_block = 0; next }
      !in_block { print }
    ' "${ssh_config}" > "${temp_config}"
  else
    : > "${temp_config}"
  fi

  if [[ ${#include_files[@]} -eq 0 ]]; then
    cat "${temp_config}" > "${ssh_config}"
    rm -f "${temp_config}" "${temp_block}"
    echo "No SSH include snippets found in ${include_dir}; managed SSH include block removed."
    return 0
  fi

  {
    printf '%s\n' "${begin_mark}"
    for include_file in "${include_files[@]}"; do
      cat "${include_file}"
    done
    printf '%s\n' "${end_mark}"
  } > "${temp_block}"

  cat "${temp_block}" > "${ssh_config}"
  if [[ -s "${temp_config}" ]]; then
    printf '\n' >> "${ssh_config}"
    cat "${temp_config}" >> "${ssh_config}"
  fi

  rm -f "${temp_config}" "${temp_block}"

  echo "SSH config include block updated from ${include_dir}."
}


function setup_amp_config() {
  local script="${WORKDIR}/amp/setup-amp.sh"
  if [[ -f "${script}" ]]; then
    echo "Merging Amp settings overrides..."
    bash "${script}"
  else
    echo "Amp setup script not found. Skipping."
  fi
}


function setup_claude_config() {
  local script="${WORKDIR}/claude/setup-claude.sh"
  if [[ -f "${script}" ]]; then
    echo "Merging Claude CLI settings overrides..."
    bash "${script}"
  else
    echo "Claude setup script not found. Skipping."
  fi
}


function setup_codex_config() {
  local script="${WORKDIR}/codex/setup-codex.sh"
  if [[ -f "${script}" ]]; then
    echo "Merging Codex CLI settings overrides..."
    bash "${script}"
  else
    echo "Codex setup script not found. Skipping."
  fi
}


function setup_kanata() {
  local config_path="${XDG_CONFIG_HOME}/kanata/kanata.kbd"
  local driver_app="/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app"
  local kanata_bin
  kanata_bin=$(command -v kanata || true)

  if [[ ! -f "${config_path}" ]]; then
    echo "kanata config not found at ${config_path}. Skipping."
    return 0
  fi

  if [[ -z "${kanata_bin}" ]]; then
    echo "kanata is not installed yet. Skipping launch daemon setup."
    return 0
  fi

  if [[ ! -d "${driver_app}" ]]; then
    echo "Karabiner VirtualHID driver is not installed. Install karabiner-elements first."
    return 0
  fi

  if ! sudo -n true >/dev/null 2>&1; then
    echo "kanata config is stowed, but sudo is unavailable so launch daemon setup was skipped."
    echo "Run this manually once sudo is available:"
    echo "  sudo \"${kanata_bin}\" --cfg \"${config_path}\""
    return 0
  fi

  local label="com.thomashexton.kanata"
  local plist_path="/Library/LaunchDaemons/${label}.plist"
  local stdout_path="${XDG_CACHE_HOME}/kanata.stdout.log"
  local stderr_path="${XDG_CACHE_HOME}/kanata.stderr.log"

  echo "Installing kanata launch daemon..."

  sudo tee "${plist_path}" >/dev/null <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>${label}</string>
    <key>KeepAlive</key>
    <true/>
    <key>ProgramArguments</key>
    <array>
      <string>${kanata_bin}</string>
      <string>--cfg</string>
      <string>${config_path}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardErrorPath</key>
    <string>${stderr_path}</string>
    <key>StandardOutPath</key>
    <string>${stdout_path}</string>
    <key>WorkingDirectory</key>
    <string>${HOME}</string>
  </dict>
</plist>
EOF

  sudo chown root:wheel "${plist_path}"
  sudo chmod 644 "${plist_path}"
  sudo launchctl bootout "system/${label}" >/dev/null 2>&1 || true
  sudo launchctl bootstrap system "${plist_path}"
  sudo launchctl enable "system/${label}"
  sudo launchctl kickstart -k "system/${label}"
  echo "kanata launch daemon installed."
}


function install_tmux_plugin_manager() {
  if [[ -d "${HOME}/.tmux/plugins/tpm" ]]; then
    echo "TPM already installed."
  else
    echo "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
  fi
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
