WORKDIR=$(pwd)
# REPO_NAME="dotfiles-m1"


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


# Installs Rosetta if not already installed and user agrees
function install_rosetta() {
  local rosetta_status=$(sysctl sysctl.proc_translated)
  if [[ ${rosetta_status} == "sysctl.proc_translated: 1" ]]; then
    echo "Rosetta is already installed."
  else
    echo -n "Rosetta is not installed. Do you want to install it now? (y/n): "
    if read -t 3 -n 1 install_rosetta; then
      echo
      if [[ ${install_rosetta} =~ [Yy] ]]; then
        softwareupdate --install-rosetta --agree-to-license
        echo "Rosetta has been installed."
      else
        echo "Rosetta has not been installed."
      fi
    else
      echo
      echo "Timeout reached. No input provided; Rosetta has not been installed."
    fi
  fi
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

    # Verify Homebrew installation
    brew doctor &>/dev/null
    local brew_success=$?
    if [[ $brew_success -eq 0 ]]; then
      echo "Homebrew installation is successful."
    else
      echo "Error: Homebrew installation is unsuccessful. Please fix the issues shown by 'brew doctor' and run this script again."
      exit 1
    fi

    install_rosetta
  else
    echo "To install Homebrew, this script requires a Mac using Apple Silicon."
    exit 1
  fi

  # Update Homebrew
  echo "Updating Homebrew..."
  brew update
}


# Installs packages and apps from Brewfile
function install_homebrew_packages_and_apps() {
  echo "Installing packages and apps with Homebrew..."
  brew bundle --file=dependencies/Brewfile --no-lock --no-upgrade
}


# Installs Oh My Zsh
function install_oh_my_zsh() {
  if [[ -d ${HOME}/.oh-my-zsh ]]; then
    # Use the inbuilt mechanism to update Oh My Zsh
    echo "Oh My Zsh already installed, updating..."
    (cd ${HOME}/.oh-my-zsh && git pull >/dev/null 2>&1)
  else
    echo "Installing Oh My Zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
  fi
}


# Installs additional zsh plugins not included with Oh My Zsh
function install_additional_zsh_plugins() {
  local plugins=("zsh-autosuggestions" "zsh-syntax-highlighting")

  for plugin in "${plugins[@]}"; do
    plugin_dir="${HOME}/.oh-my-zsh/custom/plugins/${plugin}"
    if [[ -d "${plugin_dir}" ]]; then
      echo "${plugin} already installed, updating..."
      (cd "${plugin_dir}" && git pull)
    else
      echo "Installing ${plugin}..."
      git clone --depth=1 "https://github.com/zsh-users/${plugin}" "${plugin_dir}"
    fi
  done
}


# Installs Powerlevel10k zsh theme
function install_powerlevel10k() {
  local powerlevel10k_dir="${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"

  echo "Installing Powerlevel10k zsh theme..."

  if [[ -d "${powerlevel10k_dir}" ]]; then
    echo "Powerlevel10k already installed, updating..."
    (cd "${powerlevel10k_dir}" && git pull >/dev/null 2>&1)
  else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${powerlevel10k_dir}"
  fi
}


function link_custom_configs() {
  # Prompt user if they use Mackup to backup secrets
  echo -n "Do you use Mackup to backup your secrets? (y/n): "
  if read -t 3 -n 1 use_mackup; then
    echo

    if [[ "${use_mackup}" =~ [Nn] ]]; then
      # Create custom .zsh file for secrets if not using Mackup
      touch custom/secret.zsh
    else
      echo "Script assumed you DO use Mackup, and did not create ~/custom/secret.zsh file."
    fi
  else
    echo
    echo "Timeout reached. No input provided; script assumed you DO use Mackup, and DID NOT create ~/custom/secret.zsh file."
  fi

  # Link custom .zsh files to Oh My Zsh custom folder
  for file in custom/*; do
    echo "Creating symbolic linking for ${file}"
    ln -sf "${WORKDIR}/${file}" "${HOME}/.oh-my-zsh/${file}"
  done

  # Link ssh config
  echo "Linking ssh config..."
  mkdir -p "${HOME}/.ssh"
  ln -sf "${WORKDIR}/ssh/config" "${HOME}/.ssh/config"

  # Link ${HOME} dotfiles
  # TODO: consider how to confirm to XDG file structure
  echo "Linking files to home directory..."
  for file in sym-links/*; do
    if [[ ! -d "${file}" ]]; then
      ln -sf "${WORKDIR}/${file}" "${HOME}/.${file#sym-links/}"
    else
      echo "Ignoring directory ${file}"
    fi
  done

  # Create this file to suppress error from z on first 'cd'
  touch "${HOME}/.z"
}


# Installs asdf version manager plugins
function install_asdf_plugins() {
  while read -r plugin _; do
    if asdf plugin-list | grep -q "^${plugin}$"; then
      echo "asdf plugin ${plugin} already added, updating..."
      asdf plugin update ${plugin} >/dev/null 2>&1
    else
      echo "Adding asdf plugin ${plugin}..."
      asdf plugin add ${plugin}
    fi
  done < sym-links/tool-versions
}


# Restores program configs with Mackup
function restore_configs_with_mackup() {
  echo "Linking Mackup config..."
  mkdir -p ${HOME}/.mackup

  for file in mackup/*; do
    ln -sf ${WORKDIR}/${file} ${HOME}/.${file}
  done
  echo "Restoring files with Mackup..."
  mackup restore -f
}


function display_completion_message() {
  if [[ -f ${HOME}/.p10k.zsh ]]; then
    echo "Bootstrap complete."
  else
    echo "Bootstrap complete, quit terminal and open iTerm to continue..."
  fi
}
