# dotfiles

My personal dotfiles for macOS on Apple Silicon.

## Quick Options

- Full setup: `./bootstrap.sh`
- Stow only (skip Homebrew): `./bootstrap.sh --stow-only`

## Notes

- Designed for Apple Silicon Macs
- Idempotent: can be run multiple times safely
- Uses GNU stow for symlink management
- Secret configurations stored in iCloud Drive
- Supports home/work environment configurations

## Before Setup

### Prerequisites

- You need to have `git` installed on your machine:

  ```sh
  xcode-select --install
  ```

## Setup

To set up your environment with these dotfiles, execute the following commands:

```sh
git clone https://github.com/thomashexton/dotfiles.git ~/dotfiles
cd ~/dotfiles  # Important: The bootstrap script needs to run from the dotfiles directory
./bootstrap.sh
```

The bootstrap script will:
1. Install Homebrew if not already installed
2. Install essential packages including GNU stow for dotfile management
3. Prompt you to choose between home or work configuration
4. Stow configuration files to their appropriate locations
5. Set up additional secret configurations from iCloud (if available)

## Post-Setup Configuration

### Git Identity

Set your Git identity:

```sh
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

Note: Consider using your [GitHub-provided no-reply address](https://help.github.com/en/github/setting-up-and-managing-your-github-user-account/setting-your-commit-email-address#setting-your-commit-email-address-on-github).

### Secure Configurations

- **SSH Keys**: [Generate new SSH keys](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) or restore from backup
- **Secret Files**: Place in `~/Library/Mobile Documents/com~apple~CloudDocs/stow/` for automatic linking

### Additional Setup

- **Fish Shell**: Run `fisher update` to install Fish plugins if using the Fish configuration
